# Verification Is Identification (System)

A finite structure exists. It is not nothing: there is a distinction. Equality on finite trees is decidable by structural recursion. A terminating comparison reads finite data, while a finite candidate space additionally requires a uniform representation bound. If exactly one candidate in that space passes, verification is identification.

The paper studies one loop, 26 properties and five central theorems (compilation, safety, identifiability, finite extensional presentation, completeness). Their representation, finite-domain, control-flow and memory premises are stated separately. The existence of a finite structure alone does not establish an append-only cache. The inner pipeline uses finite encodings, fixed features and a fixed protocol. Its type constructions express the corresponding relations under Law §0′ without a runtime solver.

## §0. Derivation

**Postulate.** A finite structure exists.

1. A finite structure exists. *[postulate]*
2. A finite structure is not nothing. *[from 1: if structure = nothing, "a finite structure exists" = "nothing exists" = no postulate. The reading is self-refuting.]*
3. Structure ≠ nothing → a distinction exists between them. *[from 2: "not" IS the distinction.]*
4. Structural equality of finite ordered binary-tree encodings is decidable. *[representation premise + structural induction]* A leaf differs from a constructed pair. Two pairs agree exactly when their respective children agree. Recursion terminates because each descent enters a smaller finite tree. Applying this test to another domain requires a supplied encoding with the intended equality semantics. Steps 1–3 alone do not establish that encoding or its recoverable constructors (EiF EF2–EF4). The encoding and its implemented reader can both belong to the same closed reality.

> Argues: ``EqualityDecidable`` needs ``StructuresFinite``.
5. The test halts. *[from 4: decidable ⊂ halting.]*
6. A halting test examines finite data. *[from 1 + 5: finite structure → finite data.]*
7. Finite data of bounded size is in a finite space F. *[from 1 + 6: the structure has finite size n over its finite set of distinct components. All structures over those components up to size n form a finite set by combinatorics.]*

> Argues: ``StructuresFinite`` needs ``HasSigma``.
> Argues: ``StructuresFinite`` needs ``/Notation/Pair``.
8. S = {y ∈ F : COMPARE(y, target) = EQUAL} is computable. *[from 4 + 7: structural equality is decidable (step 4) + finite space (step 7) = enumerate F and check each.]*
9. The structure is representable in F. *[from 1 + 7: it is finite (step 1) and F contains all finite structures up to its size (step 7) → it is in F.]* Under an encoding whose test recognizes it, it passes and enters S.

The bound in steps 7–9 belongs to the chosen encoding. A finite target has some size, but an executable search needs a sufficient bound it can obtain. Finiteness of each possible target does not supply one common bound over all targets. Existence Is Finite EF5–EF6 separates these quantifiers.

10. |S| is computable. *[from 8: counting a computed finite set.]*
11. If |S| = 1 and the intended target's encoding y\* belongs to S, a passing representation equals y\*. *[from 9 + 10: y\* ∈ S, |S| = 1, S = {y\*}. Any y passing = y\*.]* Identifying the encoded target does not make its representation literally the physical thing it represents.

**Step 11: if |S| = 1, verification is identification.**

**On the alternatives to |S| = 1.** If |S| > 1, multiple representations pass. Identifying the complete candidate needs further justified distinctions, while a coarser question can already have one answer (U2c). If |S| = 0, none passes: the candidate family or test may need revision. Failure of the singleton check alone does not distinguish these cases.

**On search.** The derivation has no word on how y is found. Whether you find a passing representation is the search's question. Whether a passing representation is y* is step 11's, and search is not among its premises.

**On encoding.** Under the declared finite-tree representation and a sufficient bound, F contains the target's encoding. Its passing the test is a further premise. A singleton S identifies its one member within the model. Identifying that member with the intended target additionally requires that the target belongs to S. A misspecified candidate family can have one survivor and still exclude the target (CS1–CS3).

**On uniqueness.** Identifying the complete candidate requires |S|=1. For a specified question q, a nonempty S needs only |q(S)|=1. The claims about a primitive (§2.5) and an equality-classification instruction (§5.21) concern the chosen representation and operation vocabulary. They have different premises. The former claim that I3 uniquely forces every information axis to align is replaced by the specific order-compatibility argument in §5.25.

**U1 (A projection fixpoint does not count candidates).** The Swift protocol `Unique: Monotone, Null` entails Left=Right=T and T.Left=T. Its constraints contain no candidate membership relation or counting rule. They do not identify its nominal carrier with Never, and do not constrain T.Right. The existing `EqualSidesWitness` in Checks/ClosedInformation.swift also conforms to Unique while remaining a different type from Never. The generic `UniqueWithResidual<A>` in the same checks satisfies the relation while retaining arbitrary A at its common side's Right address. Its recursive nominal side is not a finite tree of EiF's constructor grammar. These examples establish the scope of the open Swift protocol, not a counterexample to a singleton theorem with an explicit set interpretation.

`SolutionSet=Never` can therefore name a chosen coordinate but does not by itself show that one candidate survived. Conversely, absence of a Unique conformance proves neither |S|=0 nor |S|>1. `IdentityCollapse` identifies its Left, Right and SolutionSet axes, without supplying membership or target adequacy. ExactlyOneSurvives and SystemCrystallizes need those separate links to interpret their coordinates as R4.

**U2 (Identify a singleton through its declared support).** The finite coverage grammar of Verdict §6b already records candidate leaves and joins without dropping a branch. Its support itself can identify its sole distinct member. CandidateLeaf<X> conforms to SingleCandidateSupport with Member=X. CandidateFork<L,R> conforms conditionally when both children conform and their Member types agree. It then carries that common member. CheckedCoverage compares the certificate's support with an independently declared support tree. DeclaredSingleCandidate derives equality between their Member coordinates from that coverage equality.

*Proof.* A leaf records exactly X. A fork has one distinct member exactly when each nonempty child has one and those members agree. Structural induction therefore proves both soundness and completeness of the supplied conformances on the finite leaf/fork grammar. Coverage equality transfers the common member between the declaration and the actual certificate support. No identity-reading law or integer count is needed for this support test. The declaration must actually describe the intended survivor domain. A proof over a smaller declaration does not establish uniqueness in a larger one. QED

The open SingleCandidateSupport protocol names the Member coordinate. The constructor conformances establish its singleton interpretation, which cannot be assumed for arbitrary unrelated conformers. The declaration, its coverage and the finite support grammar remain explicit.

Identity readings provide a compatible specialization of the existing verdict mechanism. CoveredIdentity<X,S,E> abbreviates CoveredLeaf<IdentityReading<X,S,E>>. Such leaves answer with their candidate, so agreement propagates candidate identity through CoveredJoin and CoveredGroup. IdentityVerdictIdentifiesSources<C> checks the local implication from agreeing answers to agreeing sources when each actual reading returns its source. Its generic premises do not include equality of those two sources. For coarser readings, agreement answers only the chosen question: the existing VisibleVerdict has different source beams. ThreeBeamsCovered verifies complete agreement on the visible question while its candidate support correctly fails the singleton test. Verdict's question-specific results already establish this distinction.

Two repeated leaves carrying X give two occurrences but one distinct candidate. Their support tree does not collapse to one leaf as a type. Similarly CandidateLeaf<Never> records one candidate type, despite Never having no runtime values. Distinct-candidate cardinality, support occurrence count and runtime inhabitance require their own interpretations. No integer runtime is needed for the supported singleton proof.

**U2a (Identification from actual membership paths).** SelectCandidateLeaf<X> selects X from CandidateLeaf<X>. SelectCandidateLeft<P,R> embeds a child's path in the left branch of CandidateFork<P.Left,R>, retaining P.Right as its selected candidate. SelectCandidateRight<L,P> does the same on the right. A finite expression in these constructors gives an actual leaf occurrence in its source support. It does not imply that the support has only one distinct candidate.

*Proof.* At a leaf the selected candidate is X. At either fork step the child path selects a member of that child, which is a member of the parent. Every leaf occurrence has such a finite path by descent through its address. On a singleton support, induction also derives that the selected candidate equals the support's Member. The base is X=X. For a left step, the induction hypothesis gives P.Right=P.Left.Member, and the parent's common member is P.Left.Member. For a right step, the hypothesis gives P.Right=P.Left.Member and the singleton fork equates that member with the left child's member. These are the conditional SingletonCandidateSelection conformances. They require the unselected sibling to have the same sole member, so membership in a mixed support cannot establish uniqueness. QED

IdentifyCoveredCandidates<C,P,T> binds both path sources to the actual independently checked declaration C.Right and derives P.Right=T.Right. Its inputs contain no equality premise between those selected candidates. Two members of the same singleton agree even without coverage. Coverage additionally ties this domain to the certificate's actual candidate support. In the supplied finite coverage grammar, each support leaf records a source of an actual leaf reading. Group nodes add no candidate. Thus a selected support member is also a source represented by the certificate, even when its reading gives a coarser answer.

This supplies Theorem 2's membership-to-identity step for the supported grammar. It does not infer that an arbitrary PASS label is membership, or that a declaration includes an intended physical target. The declaration must describe the survivor domain, and an intended target must have a membership path or a separate adequacy argument. Uniform identity readings can establish a singleton but are unnecessary when the support supplies it. The shared name Unique cannot replace these links. As in U2, arbitrary conformances outside the finite constructor grammar do not establish the path interpretation.

**U2b (Uniqueness from equations without a candidate census).** The existing Coloring example uses two machines with A.Opposite=B and B.Opposite=A. Fix the first of four tasks to A and require each subsequent assignment to be the previous assignment's opposite. Then every assignment satisfying these equations is (A,B,A,B).

*Proof.* Substitute the pin in the first edge equation to obtain B for the second task. Substitution in the next two equations gives A and B. Thus the three chain edges force the entire assignment. The fourth edge from the last task back to the first is satisfied since B.Opposite=A. The first part gives at most one assignment, while the constructed tasks and this closing check give existence of a valid four-cycle assignment. QED

PinnedScheduleIsForced<A,B,C,D> checks the first part for arbitrary task types with the pin and the three edge equations. Its two sides are their actual ScheduleAssignment coordinates and the coordinates of the existing T0–T3 construction. No complete assignment equality is supplied as a premise. ClosingConflict checks the remaining edge separately. A closing edge can instead reject the forced assignment, as when closing a three-task chain with assignments (A,B,A). Uniqueness from a connected chain does not itself establish that additional constraints are satisfiable.

This proof needs no enumeration of all schedules and no SolutionSet=Never choice. Equality concerns assigned machine coordinates, not nominal task wrapper types. Removing the pin admits the exchanged (B,A,B,A) assignment too. Exactly two unpinned assignments additionally uses the declared two-machine domain: the open Machine protocol permits other opposite maps. U2b gives a direct uniqueness proof where equations force every coordinate. U2–U2a remain useful for finite supports whose members are supplied through a coverage construction.

**U2c (Constraint determination is relative to the question).** Fix a candidate carrier F, constraints C and the compatible set S={s∈F : every constraint in C is satisfied}. For a question q:F→A, an answer a is forced precisely when S is nonempty and q(s)=a for every s∈S. Equivalently, q(S)={a}. A concrete member establishes existence. To establish determination, compare any two compatible candidates and derive agreement of their q-readings. This proof need not enumerate F or construct a preferred candidate.

*Proof.* If every compatible candidate answers a and at least one exists, the image is exactly {a}. Conversely, a singleton image means that all compatible candidates give that answer. Nonemptiness excludes a vacuous answer certified only because the constraints contradict one another. This is Verdict VC15's question factorization applied to one constraint fiber. U2b supplies a source-bound static example for complete assignment coordinates. The existing covered visible readings supply a case where the answer is unique and the candidates differ. QED

The corresponding impossibility test uses two candidates under the same givens: C(s), C(t) and q(s)≠q(t) must have no joint solution. Together with one compatible witness, that refusal establishes the unique answer. A generic static proof can derive q(s)=q(t) from the actual constraint relations without enumerating either candidate space. The two copies must share the question and all fixed source parameters.

Constraint layout makes the distinction concrete. In real line coordinates, require x_B−x_A=d and x_C−x_B=e. Every solution is (u,u+d,u+d+e), with u free. The question x_C−x_A has the unique answer d+e. Pinning x_A to zero chooses a coordinate representative and is unnecessary for that question. A position relative to an additional actual reference asks for another retained relation. No outside origin is supplied by the three constraints.

There are three different changes during refinement. Deriving a consequence already entailed by C preserves S exactly, even if it removes candidates from an incomplete working approximation to S. Adding a new source-supported condition can reduce S. Adding a preference or a default changes the selection contract. Only the second adds a new restriction on the described target. In VI's search loop, rejecting a trial against an already fixed condition exposes an incompatibility that was present in that condition, rather than changing the target.

In design, a newly chosen requirement can legitimately define the object to be made. In discovery, a restriction on what is already given needs a source-supported fact or a derivation from retained relations. Adding enough arbitrary conditions to leave one candidate would establish a specified design, not identify the given reality. The author, evidence and instruments can all be internal to that reality. The distinction concerns what supports each constraint.

In [Apple's Auto Layout guide, *Anatomy of a Constraint*](https://developer.apple.com/library/archive/documentation/UserExperience/Conceptual/AutolayoutPG/AnatomyofaConstraint.html), constraints relate attributes through equations and inequalities, and priorities and intrinsic content sizes contribute further conditions or preferences. The document distinguishes equality from assignment. [Its ambiguity guide](https://developer.apple.com/library/archive/documentation/UserExperience/Conceptual/AutolayoutPG/AmbiguousLayouts.html) also states that the engine can display one of several valid solutions. A rendered result alone is therefore not a uniqueness certificate. [Badros, Borning and Stuckey, §1.1](https://constraints.cs.washington.edu/solvers/cassowary-tochi.pdf), distinguish satisfaction of required constraints from comparison of preferred solutions. Their hierarchy can have several equally preferred solutions.

For example, widths a,b≥0 with a+b=10 admit many layouts. Adding a=b forces a=b=5. Choosing the minimum a instead gives a=0,b=10, once that objective is part of the task. The equal-width layout also uniquely minimizes a²+b², since a²+b²=50+2(a−5)². Agreement with one objective's result does not establish that the sum constraint alone forced it. Conversely, the minimum of a+b is 10 at every compatible layout, so a unique optimal value need not identify one minimizer.

Equal sharing can also follow from a stated symmetry obligation. If exchanging the two roles preserves the complete input, including priorities and references, a deterministic equivariant layout rule must return a=b by VI1a. The sum then forces both widths to 5. Symmetry of the compatible set alone does not require each member to be symmetric: (0,10) and (10,0) are both admitted. The single-valued equivariant rule is the additional obligation in that derivation.

The same distinction applies to behavior. A relation R(x,y) constrains two jointly compatible forms. It gives a function in the x-to-y direction exactly when each admitted x has one compatible y. Relations among several occurrences can constrain whole histories, without prescribing the order in which a checker solves the equations. The histories need not be unique, reversible or physically realizable solely because their syntax is relational. Seam SG4 gives a concrete case where one boundary direction fails to be a function and another is unitary. Seam §3 shows why a default chosen before a later contact can erase an otherwise valid joint solution.

IiS25 supplies a finite physical-model instance: nine specified zero-error output-ray constraints and one success probability determine the complete successful quantum operation. Internal implementations and failure outputs can still differ. Those constraints also forbid success above one half for the stated balanced program. Thus an exact answer and an execution limit follow from the same contacts. The calibrated preparation and common quantum map remain premises. IiS26 then shows why the one-use success number alone cannot replace the program's relations when asking about a future joint use.

The verification question is whether a candidate passes. The identification question is which candidate it is. When exactly one candidate passes, the two predicates agree. Finite enumeration and a decidable fixed test make this collapse computable. An append-only comparison cache can avoid repeated work, but is not necessary for that result (GC4). Changing the verifier or candidate space changes the stated problem. Removing a cache alone need not change its answer or decidability. Order independence applies to a traversal with fixed candidates, tests and the required coverage, not to arbitrary interventions.

## §1. The Loop

The system operates as a cycle between two participants:

```
AGENT ──> ENCODING ──> VERIFY ──> PASS: solution identified (Theorem 2)
  ↑                        │
  └── REJECT(where, why) ──┘
```

The agent proposes, and the system certifies relative to the supplied encoding. Theorem 2 gives correctness under R4 and PASS with the stated algorithm and representation. An encoding must make the intended task representable and its check adequate. Theorem 4 constructs an identifying presentation from a complete finite function graph; it does not acquire that graph from an unknown source or supply its execution in every program grammar. Retaining a comparison cache additionally requires its update law (GC2) and a compatible reading of stored records (GC3).

1. **AGENT** provides an encoding: how to represent the task as finite binary trees. Finite F, decidable verification and adequacy for the intended task remain required grounds. Providing the encoding alone does not establish those grounds. The inner system certifies under them; §§1a–1b state the additional obligation on the agent's transformation.
2. **SYSTEM** runs the inner pipeline (§2–§4): encode → extract → compile → execute.
3. **SYSTEM** returns one of:
   - **PASS(f\*)**: solution identified. f' = f\* by Theorem 2 (§5).
   - **REJECT(basis, position P)**: value at P not in input basis. Agent: change encoding or extend basis.
   - **REJECT(compile, example k)**: rule fails on example k. Agent: add features or change representation.
   - **MISMATCH**: rule compiles but fails on test. Agent: add training examples or change features.
4. **AGENT** reads the diagnostic and constructs a revised encoding, preserving or re-establishing the source/question connection required by §1b, then re-enters at step 1. A deliberate requirement revision states a new task rather than silently counting as completion of the old one.

**Inner half** (steps 2–3): total on its admitted finite inputs with the supplied enumerations and terminating primitive checks. Every path halts at a definite terminal state. If PASS: output = f*. If REJECT: no output. The proofs and the scope of these premises are in §5.

**Outer half** (steps 1, 4): the agent's domain. Completion must be scoped:
- PASS settles the represented task under its stated grounds. Completion of the original task additionally requires the source/question transfer of §1b; without it, application remains conditional.
- Agent exhausts grammar → REJECT. No encoding in the grammar produces PASS.

**Diagnostics.** Each REJECT names a structural address: not "failed" but "failed HERE, because THIS." The agent reads the address, finds where the system's information is insufficient, and modifies exactly that.

Sections §2–§5 describe the inner half: the author defines the building blocks in §2 (what the agent provides), the workspace in §3 (what the system constructs), the pipeline in §4, and proves the guarantees in §5. The following section locates the missing application obligation at its boundary.

## §1a. Working with content before identifying it

Unknown content can already participate in a constructed relation. An action can use that relation without first identifying its contents. A relation written about a proposed source and a relation supplied by that source are different grounds. The first supports a conditional construction. Applying it to the second requires the corresponding source relation, not a repeated name or a successful example. The source, construction and reader may all be parts of one system; this does not remove their application obligations.

**U3 (structural transport needs no leaf identification).** Fix finite product shapes built from opaque sorts. Admit precisely these typed operations:

```
id_T : T → T
left : T × U → T                 right : T × U → U
⟨P,Q⟩ : T → U × V               when P : T → U and Q : T → V
Q ∘ P : T → V                   when P : T → U and Q : U → V
```

There are no leaf constants, leaf tests or other primitive operations in this fragment. Every finite operation P:T→U determines a sort-preserving map from the leaf occurrences of U to those of T. Each output leaf is the corresponding input leaf under every interpretation of the opaque sorts.

*Proof.* Identity retains each address. A projection prefixes its output addresses with the selected input side. Pairing combines its two child address maps on the disjoint output branches. Composition composes the address maps. Induction on the finite construction proves the claim. In particular, for any family h of maps between interpretations of the opaque sorts,

```
P_new ∘ h_T = h_U ∘ P_old.
```

Both sides select the same input occurrence and apply the same map to its content. No comparison of the contents enters the construction. QED

This supplies the interpretation law assumed in Matter M65 for this specified grammar. M65 classifies the resulting uniform operations under additional recovery requirements. U3 does not classify every operation on unknown content: additional supplied content relations can support other actions. A symbolic pairing can select one input twice, and a projection can omit inputs. Their logical meaning supplies no physical copying, erasure or complete-source recovery. Nor does the address theorem certify execution time or all possible observations of an implementation.

The existing `EqualityContactCut<X>` gives a stronger example than routing alone. All four forms belong to the supplied X=((L1,L2),(R1,R2)). Its premises are the three addressed relations

```
L1.Right = L2.Left
R1.Right = R2.Left
L1.Right = R2.Left.
```

The complementary relation R1.Right=L2.Left follows by symmetry and transitivity. The constructor computes the two complementary recombinations from X's fields; it does not ask the caller to provide that fourth equality. No field's content is identified. The result derives a new usable relation among still-unknown fields. The three source equalities remain its premises; their physical establishment is not derived by this constructor. This example uses equality contacts specifically, rather than treating every admission relation as equality (LQ13–LQ16).

**Applying a conditional result requires its argument.** Law's derivation witness already requires a generic constructor whose caller supplies only the premises and whose body supplies the conclusion. For a precise minimal proof fragment, take atomic propositions, product and function types, and terms generated only by typed variables, pairing, projections, abstraction and application. Typing uses the corresponding introduction and elimination rules; there are no primitive inhabitants of atomic propositions. Named definitions must expand to terms in this grammar.

If Γ,b:B ⊢ t:Q, abstraction gives Γ ⊢ (λb.t):B→Q. Applying this construction requires Γ ⊢ u:B. Substitution then gives Γ ⊢ t[u/b]:Q. Substitution preserves typing by induction on t: the variable case substitutes the supplied argument or retains another variable; pairing, projection and application inherit the induction hypotheses; abstraction first renames its bound variable to avoid capture. Naming or packaging λb.t creates no argument of type B. This is a property of the stated proof grammar. Q may also have an independent proof which does not use B; such a proof need not retain B.

Atomic propositions can address the source relations needed by a task. Their meaning and binding to that source remain further obligations. Adding a free constructor for a claimed source fact, or treating an unchecked declaration as its proof, would extend this grammar and invalidate the claimed exclusion. This fragment specifies a restriction on proof construction, not a theorem that arbitrary Swift conformances or the complete current VI pipeline enforce it. It also does not make a syntactic source address into a physical witness.

**What must enter the outer loop.** A proposed representation change must carry its construction and the still-required grounds with it. If an encoding makes the requested conclusion follow only under B, the result is a construction requiring B. Renaming that result, compiling it, or passing its inner check must not turn it into an established conclusion about the source. This is the same application obligation as for the generic witnesses, now imposed on the agent's own modeling step. CS3 already exhibits the error when the actual law is outside the assumed family.

For an action on unknown content, present one admissible program P and derive its required effect for every case compatible with the retained grounds. Separate programs which would work after learning each hidden case do not supply that P. A bare existence proof for P does not supply an executable construction either. U2c's unique answer alone does not provide a way to obtain it. One constructed program may branch on permitted actual records; it need not be one fixed word.

In a composition, the next construction must receive the actual residual produced by the preceding construction together with its applicable relations. The same source name, equal displayed answers or independently possible remainders cannot substitute for that joint derivation. Thus retaining an unknown need not mean acquiring its value: the composition retains the relation which makes the next action applicable. Certifying that an implementation acquires no other information additionally needs its complete admitted reading interface; U3 alone makes no such claim.

This section connects existing structural witnesses to a proposed requirement on the outer loop. It does not report an implementation of that requirement. For a research step to resolve an earlier obstacle, it must show which former open ground was actually constructed, which requirements remain open, and that the requested conclusion still concerns the same source and task. A useful conditional theorem can leave the obstacle open without being invalid.

## §1b. Apply VI to the modeling step itself

The agent's choice of representation is another proposed transformation. Its result must remain connected to the source and question it claims to serve. The meta-level applies Law's existing derivation-witness requirement to that transformation. It supplies no additional authority to the agent or judge.

The following distinctions concern what a construction does. They are not trust labels attached to its output, and one construction may combine them.

| Move | Required connection | Scope of the result |
| --- | --- | --- |
| Derive a consequence | The conclusion follows from the addressed premises. | The same grounds support another claim. |
| Change the description | The new description transports the required questions and applicable operations. | A claim or use survives that particular change of representation. |
| Act on the source | The actual source–residual relation establishes the next premises. | The result can support the declared continuation. |
| Revise the requirement | The new requirement is connected to its source of revision; any retained obligations are transported. | The new task is stated. Fulfillment of the old task needs its own derivation. |

**U4 (a sufficient rule for transporting an addressed claim).** Let X and Y be two declared description domains, with a relation T⊆X×Y. They need not describe every distinction of the physical whole. Let B(x) and B′(y) be the grounds of the two descriptions, Q(x) the original claim, and Q′(y) the claim proved in the second description. Keep these meanings fixed throughout the following derivations:

All free variables in the premises below are universally quantified over their declared domains.

```
B(x)                         ⇒ ∃y T(x,y)       (coverage)
B(x) ∧ T(x,y)                ⇒ B′(y)          (premise transfer)
B′(y)                        ⇒ Q′(y)          (inner proof)
B(x) ∧ T(x,y) ∧ Q′(y)        ⇒ Q(x)           (return to the original claim).
```

Together these give B(x)⇒Q(x).

*Proof.* Assume B(x). Coverage gives a related y. Premise transfer establishes B′(y), the inner proof gives Q′(y), and the return derivation gives Q(x). The final claim does not depend on which such y was used, so existential elimination discharges that witness. Uniqueness of x or y is not required. To apply the result at a particular source, its B(x) is still required. QED

Coverage prevents obtaining a source claim solely from universal implications over an empty transfer fiber. This is a sufficient rule for the presented route, not a necessary form of every proof of Q. A separate derivation may avoid this route or discharge some of its grounds.

A logical existence proof can suffice for this conclusion without a procedure which obtains y. To claim an executable translation, also supply that procedure or a justified witness extraction. At the constructive level, a constructor taking x and its B-ground and returning y together with T(x,y) can be composed with the three subsequent witnesses. A formal constructor does not by itself establish the operations or source relation of a physical implementation. U3 separately provides a content-independent fragment; U4 alone does not certify that a particular translator acquires no hidden content.

**Composition retains the intermediate occurrence.** Two transfers compose through T₀₁(x,y) and T₁₂(y,z) with the same intermediate witness y. The second construction must apply to the actual output of the first, on the scope for which continued execution is claimed. Separate nonempty relations do not supply this. For distinct p,q, T₀₁={(a,p)} and T₁₂={(q,b)} have no composite witness at all. Equal displayed readings of p and q would not identify them. All four roles can be internal to one whole; the mismatch remains.

**A whole-source construction can change the local representation without identifying its contents.** In the canonical pair fragment of §1a, take the source ((a,b),c). Its old local pair is (a,b), and the required reading selects a. The permutation ((a,b),c)↦((c,a),b) retains each field once and is reversed by ((c,a),b)↦((a,b),c). Selecting the right field of the new local pair (c,a) returns the original a. This equality is derived from the constructor; it is not another constraint requested on a,b,c.

When b and c can vary independently while a is held fixed, with at least two possibilities for each, neither local pair determines the other: varying c preserves (a,b), and varying b preserves (c,a). Thus the preserved reading needs no invertible translation between these local views. Its translation uses the actual whole, including the participating context. A later request for b needs its retained address in the residual; the new pair alone does not answer it. This is a structural application of U3 and U4, not two physical measurements or a derivation of why the source should prefer to preserve a. Additional admission restrictions on an implementation must permit the proposed permutation.

**The strength of the transported question must be retained.** U4 transports the specified claim in one direction. Calling two descriptions equivalent requires the corresponding stronger result. For a binary reading, both answers must transport, or an appropriate equivalence must be derived. Operational refusal, unavailable action, divergence and unresolved knowledge are not automatically logical negation. Include them in the relation when the promised continuation depends on them (VC46–VC47).

**The metarule has the same obligation as its uses.** The displayed proof establishes a conditional consequence from its four premises under the stated inference rules. It does not derive their applicability to an actual source, the adequacy of an arbitrary encoding, or soundness of the entire executing judge. A name for T or a `true` field cannot replace a derivation of its required relations. In the closed fragment of §1a, an unapplied construction requiring B remains a construction requiring B. Giving it another name does not supply its argument.

This rule locates several already established checks. `EqualityContactCut` derives the complementary contact from the same source fields (U3's example). CS3 rejects importing a singleton answer from a family that excludes the actual source. Liquid LQ8a distinguishes agreement with a changed target from an answer about the original one. Liquid §6h keeps a condition extracted from a supplied relation separate from the origin of that relation or a motive to maintain it. None of these checks is replaced by a general label of validity.

For each claimed advance, identify the former open ground actually derived or constructed, the requirements still open, and the relation keeping the result attached to the requested source and question. A conditional theorem can be useful without closing its application. This section strengthens the specification of the outer loop; automatic enforcement over all modeling and physical application is not an implemented guarantee of the present system.

## §1c. Construct a continuation from the source relation

U3 normalizes a structural operation to its source addresses. In this fragment, that normalization can construct a continuation, rather than only check a continuation chosen in advance. The fragment admits unknown, even infinite, leaf carriers. Its finite objects are product shapes, operation expressions and addressed source relations, not a table of possible payload states.

Fix a finite source shape T and a finite set E of equalities between same-sort leaf occurrences of T. Write i ~E j for the equivalence relation generated by E. For each interpretation of the opaque sorts by nonempty sets, X_E consists of **all** fillings of T satisfying E. Universality below ranges over these interpretations and fillings. A narrower preparation can have further useful relations; none is silently imported into X_E. Equal addresses, source-supplied equalities and an accidental equality of observed values are distinct grounds.

An independently specified question need not come from an external observer. It can select a target already carried by this same source. Independence here means that the required relation is not chosen to match the candidate's produced output. The origin of that internal target is a separate question; its address and its relation to the required result are part of this task.

**U5 (constructive structural continuation).** Let P:T→U and Q:T→V be U3 operations with source-address maps p and q. There is a structural R:U→V satisfying R(P(x))=Q(x) on X_E under every interpretation if and only if

```
for every leaf v of V, some leaf u of U satisfies p(u) ~E q(v).
```

*Construction.* For each requested v, choose such a u and an equality path from p(u) to q(v) using E. Project u from U and assemble the resulting leaves in V's shape. This is a term of U3. Each output equality follows from the addressed source path; the caller supplies neither Q(x)'s value nor the final R(P(x))=Q(x) equation. Duplicate suitable addresses can yield different terms with the same effect on the actual image P(X_E).

*Necessity.* If a requested class is absent from p, interpret its sort by a set with two distinct elements. Choose two fillings constant on every E-class, agreeing on all classes except the absent one. They have the same P-image and different Q-images. No function of that image alone can return both. This rules out even a nonstructural decoder in that interpretation, so in particular rules out a universal structural R. It does not rule out a decoder on a narrower source domain or for a special singleton carrier. QED

The construction uses equivalence closure and projection paths, with no payload comparison and no enumeration of candidate programs. A certificate contains the selected output addresses and their E-paths. Checking it only checks those paths and the assembled term. For a refusal, a sort-respecting partition of the source leaves that contains every E-edge and separates the missing requested leaf from every same-sort P-leaf certifies the obstruction. Such a partition can be checked without repeating the construction's search for a decoder.

**U6 (the least residual is relative to what remains).** Let M select one source leaf from every Q-required E-class not represented in P. Then Q factors structurally through the same-source joint view ⟨P,M⟩. Every other adequate structural residual D contains each missing class, and M factors through D. Consequently the number of missing classes is the exact minimum number of additional leaves in this grammar. It is not a lower bound in bits or physical memory units. If no class is missing, P alone suffices: no new opaque constant or payload is introduced to represent the absence of an extra residual.

There is a stronger conclusion with a different meaning of minimality. Allow arbitrary deterministic residual views D and decoders, on a fixed source interpretation. Define

```
D₁ ≼_P D₂  iff  D₁(x) = f(P(x),D₂(x)) on X_E for some f.
```

The function need only be defined on the joint image actually reached. This is a preorder of **relative** information; it is not a comparison of D₁ and D₂ in isolation. M is least among residuals from which Q can be recovered jointly with P. Equivalently, ⟨P,M⟩ and ⟨P,Q⟩ factor through each other, and ⟨P,Q⟩ factors through every adequate ⟨P,D⟩.

*Proof.* U5 constructs Q from ⟨P,M⟩. Each selected leaf of M is also a leaf of Q up to an E-path, so M=m∘Q. If Q=d∘⟨P,D⟩, then M=m∘d∘⟨P,D⟩. Retaining P on both sides gives the joint factorizations. For structural D, U5 forces each missing class to occur in D, giving the stronger standalone structural factorization and exact leaf bound. QED

A least adequate residual in the **absolute** information order need not exist. On all bit pairs (a,b), retain P=a and request Q=b. Both D₁=b and D₂=a XOR b are adequate jointly with a. If C factors through each separately, C=f(b)=g(a XOR b); the two arguments vary independently, so C is constant. Then (a,C) cannot recover b. Hence there is no least adequate standalone residual in this example, although there is a least joint information class. XOR here supplies a counterexample in a larger, fixed bit interpretation; it is not an added operation of U3's opaque grammar.

Every joint view above uses the same x. Independently sampled marginals do not supply it. Constructing M also requires its source fields to remain available, or to be retained as part of P's actual action. U6 cannot restore an omitted independent field from P alone. The logical product constructor does not establish physical copying or an acquisition interface.

**U7 (finite construction for all permitted structural continuations).** Let G be a finite family of U3 endomorphisms g:T→T. First require every g to preserve X_E. With source-address map σ_g, this is equivalent, universally over the declared interpretations, to

```
i ~E j  implies  σ_g(i) ~E σ_g(j).
```

It suffices to check the generating E-edges. Only then does g induce the class map γ_g([i])=[σ_g(i)]. Notice the direction: γ_(g∘h)=γ_h∘γ_g. These maps pull questions back to their source fields.

Start with the E-classes selected by Q. Close this set S under all γ_g. This terminates after at most the number of source classes have been added. Keep, for each added class, a witness consisting of a finite word w in G and a leaf v of Q whose pullback selects that class. The empty word is included. Let V_S select one representative of every class in the resulting S.

For each supplied g construct its image action by

```
(g_S(z))_c = z_(γ_g(c))         for c in S.
```

Projections, pairing and the recorded E-paths derive V_S∘g=g_S∘V_S on X_E. Q also factors through V_S. Induction on words now supplies every requested Q(w(x)), including the present Q(x), without any new access to the omitted source classes.

This view is least in information among **all** views sufficient for these questions, beyond structural selections alone. Indeed, suppose H has decoders d_w with d_w(H(x))=Q(w(x)) for every finite word w. For each c in S, use its witness (w_c,v_c) and set

```
F(h)_c = projection_(v_c)(d_(w_c)(h)).
```

Then F(H(x))=V_S(x). Its domain is the actual H-image; totality on unrelated values is not required. Existence of these d_w proves informational minimality. An executable F additionally requires the finitely used decoder constructions. The closure algorithm itself constructs all image actions and the Q-decoder directly in U3. QED

The finite certificate comprises the chosen classes, their reachable-word witnesses, the closure edges, and their source equality paths. Reachability prevents gratuitously retaining unrelated classes; closure prevents silently dropping a later question. This is a constructive specialization of VC15's operational quotient, not a claim that the general quotient was absent. Finite source addresses replace potentially infinite enumeration of payloads. Partial actions, refusal and state-dependent availability require additional grounds; U7 is stated for total structural actions.

**A fixed question and a transported question have different requirements.** For g(a,b,c)=(c,a,b), the fixed first-coordinate question after every power of g needs a,b,c. After one g, however, the second-coordinate question returns the original a. Following that original field asks a different family of questions. The updated reading path must itself be supplied by the actual action or another established control relation. It is not a free hidden clock or an unrecorded choice of decoder. For a noninvertible action, the original field may have no remaining output occurrence at all; U5 detects that case.

**U8 (a hidden action needs a common induced action).** U7 supplies an image action for each supplied g. It does not establish that an unknown choice of g can be executed on the retained view without access to that choice. Let H be a nonempty family of E-preserving structural actions, and let S be a nonempty set of E-classes. Universally over the preceding interpretations, one common action k satisfying

```
V_S(g(x)) = k(V_S(x))          for every g in H and every x in X_E
```

exists exactly when every γ_g maps S into S and all restrictions γ_g|S coincide. In particular, allowing an arbitrary deterministic k does not remove either condition.

*Proof.* Closure gives an input coordinate for every output coordinate. Agreement gives the same selection independently of the hidden g, constructing k. If closure fails, vary the missing source class while holding V_S fixed. If agreement fails, choose one filling that distinguishes the two selected classes of the same sort. Applying the two actions to that same filling gives different required outputs with the very same input to k. Both contradictions use an interpretation with two available values of the relevant sort. A singleton interpretation alone would not support these necessities. QED

Adding more source fields cannot repair the second contradiction: it already uses the same complete source x. A source-correlated action requires analysis of its actual joint relation instead of the full H×X_E domain used here. More generally, on R⊆H×X_E a common decoder exists on the realized V_S-image exactly when any two R-admitted cases with equal V_S-inputs have equal required V_S-outputs. The source–action dependence must not be replaced by separate lists of possible sources and actions.

Established relations between repeated actions can suffice at the end of a block even when no common intermediate image action exists. For a nonempty family J of permitted finite words, apply U8 to their composite source maps. On two independent same-sort fields, a hidden fixed H chosen from identity and exchange has no common one-step image action on the full pair. The two joint words (identity,identity) and (exchange,exchange) nevertheless both induce identity. Independent choices would also permit exchange as the total action and would destroy this conclusion. No hidden choice was learned in the correlated case. The result concerns the end of that block; questions asked at intermediate cuts require their own conditions. An execution interface supporting these related repetitions remains necessary: the list of words does not itself construct that interface.

**U9 (derive the changed source relation, instead of assuming it persists).** For a structural P:T→U, define E_P on U's same-sort leaves by

```
u ~_(E_P) v  iff  p(u) ~E p(v).
```

For every interpretation by nonempty sorts,

```
P(X_E) = X_(E_P).
```

*Proof.* Every output filling satisfies the displayed relations. Conversely, an E_P-valid filling assigns a consistent value to each source E-class represented by p. Assign that value to the class, and fill each unrepresented source class with any member of its nonempty sort. The resulting E-valid source maps to the given output. There are finitely many classes. This is an existence argument for the exact image; it does not provide access to an unknown omitted field or a physical preparation of the chosen source. QED

For (a,b,c) with a=b, the permutation (a,b,c)↦(a,c,b) derives first=third at the output. First=second need no longer hold. Thus failure to preserve E invalidates reuse of that unchanged ground in U7, not the action itself. The next step can instead receive E_P, or a richer joint relation. Applying the same construction to ⟨id,P⟩ derives the full source–output graph: the source satisfies E and output_u=source_(p(u)). Keeping only E_P generally loses this provenance: (a,b)↦a and (a,b)↦b have the same unrestricted one-field image, but answer different source questions when the sort has two values. Equality of marginal image relations cannot replace the joint graph when a continuation refers to the original source. Preserving that relation can use the actual selector and sufficient output; it does not require storing every original field or the entire graph as extra data.

**A relational promise can be weaker than recovering its fields.** If the request is only that output equalities C hold, the exact universal criterion for a supplied P is C⊆E_P. Sufficiency follows by the source paths; necessity again follows by separating distinct source classes. For a hidden P in a given family, with every choice admitted on the full X_E, check this inclusion for every admitted P. Their output values need not agree. For independent a,b of the same sort, identity and exchanging the two pairs of (a,a,b,b) both leave the first pair equal, although it can contain a or b. This does not guarantee retention of that pair's original value. Applying U7 to all participating fields would strengthen this relation-only request and could retain unnecessary information. Its least-view theorem is for the specified field-reading questions, not for every relational obligation.

**U10 (construct a requested agreement and retain an independent question).** The previous rules take P as given. A related construction can choose P itself. Fix a target output shape U, required same-sort equalities C on U, and the independent structural question Q on the original source T. Require the output to satisfy C; additional output equalities are allowed. For each sort s, let n_s count the distinct source E-classes selected by Q, and let m_s count all classes of sort s in the equivalence closure of C on U, including the singleton leaves of that sort.

If a sort occurs in U but nowhere in T, no U3 operation P:T→U exists. Otherwise there are structural P, M and R, uniform over the source interpretations, with

```
P(x) satisfies C,              R(P(x),M(x)) = Q(x),
```

and the minimum number of residual leaves is

```
sum over sorts s of max(n_s − m_s, 0).
```

*Construction and bound.* Assign each output C-class one source E-class of the same sort. Cover as many different Q-required classes as possible; fill remaining output classes from any source class of their sort. Every required sort is available by the preceding condition. Put each uncovered Q-class once in M and construct R by U5. Conversely, all leaves of any output C-class must select a single E-class, or a two-element interpretation would violate one of the required equalities. Thus P covers at most m_s requested classes of sort s. U5 forces all remaining classes into M, proving the bound. QED

For three independent same-sort fields a,b,c, requiring an equal local pair while retaining all three original fields gives ((a,a),(b,c)): two residual leaves are necessary and sufficient. This uses U3's permission to reuse an input occurrence. A permutation alone cannot create a guaranteed equality between distinct output occurrences whose distinct source occurrences were not already E-related. Neither result is a physical cloning or dissipation law. For each chosen P, U6 separately establishes relative information minimality. The leaf bound above is not a universal information ordering between different choices of P. Fixed output assignments, stricter equality patterns, linear-use restrictions or unavailable routes change this task. As before, a zero residual means no additional carrier is needed.

**U10a (retain the requested source binding, not just present agreement).** Preserving Q somewhere in the result does not make every new agreement an execution of the original request. With independent source fields (a,b), both ((a,a),b) and ((b,b),a) produce an equal local pair and retain the whole source. Only the first makes that pair equal to the original a.

The request can therefore additionally prescribe source addresses for some output leaves: P(x)_u must equal x_i. These are obligations for the constructed P to meet, not assumed facts about its output. Within each output C-class, all prescribed addresses must have its sort and belong to the same source E-class. This compatibility condition is necessary and sufficient for the assignments, provided every output sort is available at the source.

For each sort s let r_s count the distinct Q-required source classes already represented by these fixed output classes, and let u_s count the output C-classes of that sort with no prescribed source class. Then the exact minimum number of residual leaves is

```
sum over sorts s of max(n_s − r_s − u_s, 0).
```

*Proof.* Sort mismatches violate the typing requirement; distinct prescribed classes of the same sort are separated by a two-element interpretation. Compatible fixed classes supply exactly r_s requested classes; each free class can supply at most one more. U5 gives the lower bound. Assign free classes to still-unrepresented requested classes, fill any remaining free classes from the source, and retain the rest in M. U5 constructs the decoder, attaining the bound. Repeated fixed classes count only once; a fixed class outside Q counts toward neither r_s nor u_s. QED

In the example, requiring the first output leaf to use the original a binds the entire equal output pair to a. The construction ((b,b),a) is then refused on the full independent source domain, despite retaining a in its residual. The request's origin remains a separate ground. This refinement enforces its specified relation to the result; it does not derive a motive to choose it.

**U11 (derive a repeat block from the required return).** Suppose a nonempty finite H of E-preserving structural endomorphisms is specified by its source maps. One unknown h in H is fixed throughout a repeatable episode. Each call applies that same deterministic function to the current source; all these calls are available. The independently fixed question is Q, and its required answer refers to the source before an obligatory first call. Let S₀ be the classes selected by Q. We seek a common positive total call count k with

```
Q(h^k(x)) = Q(x)              for every h in H and every x in X_E.
```

Such a k exists exactly when every c in S₀ lies on a cycle of every γ_h. When it exists, its least positive value is the least common multiple of those cycle lengths. This constructs a block of k calls, or k−1 further calls after the obligatory first one, without identifying h or inspecting leaf values during construction.

*Proof.* Universal agreement of the two addressed readings is equivalent to γ_h^k(c)=c for each h,c: equal classes suffice by E; distinct classes are separated by a two-element interpretation. In a finite functional graph, a vertex returns to itself under a positive iterate exactly when it lies on a cycle. Its positive return lengths are precisely the multiples of that cycle's length. Their common positive lengths are therefore the multiples of the stated least common multiple. QED

The graph is of source classes, not of payload states. A class leading into a cycle without lying on it does not qualify. For h(a,b)=(a,a), the current output becomes fixed immediately, yet no positive repeat recovers the original question b on the full source domain. The question a does return after one call; full invertibility of h is not required.

As another example, let the hidden action on (a,b,c) be either (a,c,b) or (b,c,a), fixed throughout the block. The first-coordinate question has cycle lengths 1 and 3, so three calls return its original answer. Returning all three coordinates would instead require six calls, since the first action exchanges the other two. The weaker question does not require full-source return.

The post-first-call relation is {(h,x,y):y=h(x)}. It is not replaced by independent possibilities for h and y, and the target remains Q(x), not Q(y). The repeat operation on the whole is (h,y)↦(h,h(y)); it need not descend to one common operation on y alone. Thus U11 does not contradict U8's obstruction. The successful construction need not physically retain x: its relation to the requested answer is retained in the derivation. A repeated procedure name alone does not establish fixed h. Mutable hidden memory, restricted domains, completion detection and an implementation of the call controller require their actual relations. The least call count concerns this repeat-only scheme, not informational minimality, elapsed duration or all possible plans. An application must include any relevant intervening evolution in the actual step relation; the call notation does not identify physical waiting with an identity map. If that evolution changes the step, the fixed-h premise must be established for the resulting whole step or replaced by a joint model.

U5–U10a construct previously unspecified actions, suffixes and retained views within U3's declared grammar. U11 additionally uses the supplied repeat interface: applying an unknown function parameter is not an operation of the original opaque-leaf grammar. Each fixed h^k is structural, and the one repeat scheme has the proved common effect for all supplied possibilities. The native court implements the alias/product/projection fragment in two modes that ask different questions. The type-field mode identifies occurrences by their opaque generic type field and constructs a continuation or a necessary residual. Repeated type parameters there establish type-field identity, not equality of independently stored runtime values, and its verdict is not the universal U5 judgment: for one sort at two places it constructs what the relations mode refuses. The relations mode gives every leaf occurrence its own address in a declared whole (T, E), and only E equates distinct occurrences. In separate questions it constructs a U5 continuation or refuses it with a partition certificate, and it constructs a same-source retention plan whose residual is U6's least, in leaves of the grammar and in the relative order ≼_P. For a declared finite family of total structural actions it certifies that every member preserves E, or names a member and an E-edge it breaks (a refusal to reuse X_E, not of the action), then closes the requested classes under their class maps and constructs the stable view, its image actions and the decoder of Question (U7). For a separately declared nonempty family of such actions it constructs one common program on the classes of Observation or certifies one of the two U8 refusals. The selected member stays private. With the supplied repeat interface and the stated premise that one hidden member is fixed for the episode, it constructs U11's least common call count as the least common multiple of the class cycle lengths, or certifies a Question class on a tail of some member's class map. For a declared structural step it derives the changed relation E_P on the output, certifies that the step's image is exactly the fillings satisfying E_P, and judges a promised output relation by the inclusion C ⊆ E_P (U9). A declared joint image of the step with the identity keeps the source binding, and a marginal image does not. For a requested output agreement and an independent question it constructs the step itself, a same-source residual and the decoder with the exact least number of residual leaves, and it enforces prescribed source bindings as obligations of the constructed step (U10, U10a). Each mode replays a saved finite certificate against the current source. An exhausted depth, node or path budget leaves a request unresolved, not refused. Correct reading and replay are named premises, and the proofs also rest on the checked fixed foundation signatures. The source admission boundary does not cover arbitrary Swift. Source-correlated choices, related word blocks, partial actions, state-dependent availability, an interface executing the hidden choice, a call controller, physical copying and the origin of a request are outside the court. These results do not yet implement a general interactive synthesizer in the resident court. Their source relations, permitted operations and applicability to a physical carrier remain the same explicit obligations as in U3 and U4.

## §1d. Derive the obligation from a connected use

A receiver's applicability alone does not determine the result due from its source. For example, an exchange accepts every pair; supplying (a,a) instead of its original (a,b) remains applicable but changes the result when a≠b. The relevant ground is the connected source and use, not just the receiver's input domain. It also matters whether a replacement answer suffices or the same receiver must actually be applicable to the constructed boundary.

**U12 (preserve a connected partial use).** Let i:T→X and p:T→U be two specified readings of one source domain T. Let c:X⇀Y be a specified partial use, with domain D. Define its induced applicability and result by

```
E = {t in T : i(t) in D},       k(t) = c(i(t)) for t in E.
```

No independent target function is chosen here. A partial d:U⇀Y with

```
p(t) in dom(d) iff t in E,
d(p(t)) = k(t) for t in E
```

exists exactly when the following hold for all t,t′ in T:

1. If p(t)=p(t′), then t∈E iff t′∈E.
2. If p(t)=p(t′) and t,t′∈E, then k(t)=k(t′).

Its domain and value are uniquely determined on the reached image p(T). There is no uniqueness claim outside that image.

*Proof.* Necessity follows by applying one partial d to the same argument. For sufficiency form the graph {(p(t),k(t)):t∈E}. Condition 2 makes this a function. If p(t) belongs to its domain, some t′∈E has p(t′)=p(t), and condition 1 gives t∈E. The converse holds by construction. On every reached argument the required definedness and, where defined, value are forced. QED

This is a set-theoretic existence result, not an algorithm for acquiring or evaluating d. It needs no choice of representatives. If c is total on i(T), condition 1 is automatic and the result reduces to factorization of k through p. If only successful answers are preserved, condition 2 alone suffices; that weaker task need not preserve refusal. For example, reading only a from (a,b) cannot decide whether a receiver requiring a=b is applicable on the full two-element product, although its successful answer a is already present. Undefinedness here is absence of an admitted application, not a measured negative answer or a claim about physical nontermination.

The result Y must include whatever residual and effects the assertion is intended to preserve. Matching only a displayed answer establishes only that answer. Any relevant environment or internal receiver condition must occur in the connected source and use; an omitted parameter is not thereby fixed.

**U12a (factorization does not supply reapplication).** Suppose the task requires an adapter r:U→X from an explicitly available construction grammar, followed by the same c. It must separately establish, on reached arguments,

```
r(p(t)) in D iff t in E,
c(r(p(t))) = k(t) for t in E.
```

An available r with r∘p=i is sufficient. Full source-input recovery is stronger than these requirements and is not generally information-minimal. U12 alone supplies neither an admissible r nor its execution.

For a strict separation let A={0,1}, X=A², D={(0,0),(1,1)}, c(a,a)=a, T=D, i the inclusion and p(a,a)=a. Then d=id_A satisfies U12. Limit available adapters to identity wires, permutations, deletion/projections, composition and parallel composition, optionally including c; neither constants nor duplication are provided. Every constructor preserves or decreases wire count, so induction excludes any adapter A→A². A mathematical diagonal map exists, but this grammar cannot build it. Having a prepared diagonal source does not add a duplication operation. This obstruction is grammar-relative.

`ReapplyReceiverAfterRecovery` implements the sufficient recovery case at the level of VI type relations. Its supplied factor F recovers R.Left through F.Observation; the constructed suffix is F.Right followed by the same R. The seam and resulting R.Answer are derived without a second target field or a requested equality of final answers. Exchanging a generic pair twice gives such an F. Binding the recovered pair to its first or second projection gives the corresponding unknown component. Merely having R.Answer does not supply R.Left. This extends the joined-input obligation of `JoinedContinuation`; it does not make arbitrary open PredicateReading conformers semantically truthful or execute a physical receiver.

The construction derives an obligation relative to a supplied connected use. It does not derive why the system selects this use, performs it, or experiences its outcome. An internal account must also represent the selecting and enabling relations inside the same whole, rather than leave an external operator with an unexplained ability to trigger these constructions.

## §2. Representation

```
IN:   ∅
OUT:  Σ, COMPARE, Graph
      Invariants: I1 (finite), I2 (closed), I3 (permanent)
```

**2.1. Structures.** Choose finite ordered binary trees as the representation grammar. Write its terminal symbol NULL and its binary constructor PAIR:

- If A, B ∈ Σ then PAIR(A, B) ∈ Σ.
- NULL ∈ Σ, and NULL differs from every PAIR(A, B).
- PAIR is injective in its ordered arguments. Nothing else belongs to this grammar, and each tree has finite depth.

Σ is the initial algebra of F(X) = 1 + X². These explicit constructor premises define a representation, rather than derive the form of all physical relations from steps 1–3. A finite relational structure with a supplied finite signature and finite label encodings can be serialized into such trees. Different serializations can describe the same relational structure, so structural equality of encodings need not decide identity up to relabeling without an additional canonicalization or equivalence test. The tree domain is unbounded, while each member and each bounded fragment in a particular game are finite (I1, EiF EF5–EF6).

The syntax terminal NULL differs from Swift's `Null` protocol. The latter requires equality of two associated types. It neither collapses every equal-child pair to the terminal nor equates every equality witness with `Never` (EiF EF4). A binary serialization also does not require every physical interaction to be intrinsically binary.

**SC1 (Constraint refinement and representation loss).** Fix a model domain K. Adding a predicate c to an admissible set D gives D'={x∈D:c(x)}, so D'⊆D. Replacing an encoding E by a coarser encoding E'=g∘E instead enlarges its equality classes: ker(E)⊆ker(E'). The first operation excludes candidates. The second can merge their representations. Both are called compression in the project's prose, but their set-theoretic directions differ.

*Proof.* Every member of D' belongs to D by its definition. If E(x)=E(y), applying g gives E'(x)=E'(y). Neither implication establishes the other operation, a physical erasure, or an information gain from a new observation. In particular, asserting c does not prove that the actual input satisfies c.

For a total question q, an encoding is sufficient on D exactly when equal images of members of D imply equal q-answers (VI VC9). For x,y∈{0,1}, E(x,y)=y cannot determine q(x,y)=x on the full domain. Restricting to D={x=y} makes the decoder d(y)=y correct. The assumption has selected a domain where the answer follows. It has not established x=y for a supplied real input. An implementation of that inference needs both the reading construction and a justified input scope. VC12 and VC35 add the obligations under change.

This distinguishes two uses of `where`: requesting a premise of a family and checking a consequence derived by a constructor. `Law` §T and the generic witnesses in Verdict Is Invariant supply the second form. No new protocol label alone could establish the semantic adequacy of this encoding.

**2.2. Equality.** Two structures are either structurally identical or not. This is a fact about the structures, never an operation on them. Write the fact COMPARE : Σ × Σ → {equal, not_equal}:

```
COMPARE(NULL, NULL) = equal
COMPARE(PAIR(A₁,B₁), PAIR(A₂,B₂)) = equal  iff  COMPARE(A₁,A₂) = COMPARE(B₁,B₂) = equal
All other cases → not_equal
```

Structural identity is decidable on finite structures: finitely many components, finitely many comparisons. Projection (accessing parts of a pair) and recursion are traversal of existing structure. All derived operations (ordering, arithmetic, counting) are compositions of COMPARE and projection via Peano encoding.

**2.3. Graph.** A set G ⊆ Σ × Σ × {equal, not_equal} of recorded comparisons.

**2.4. System invariants.** These are separate obligations of the encoding and implementation. The fixed truth of a comparison does not derive I3:

| ID | Invariant | Basis |
|----|-----------|------------|
| I1 | Every structure and every candidate set in the game is finite | A faithful finite-tree representation and a uniform bound for the sets in play, as distinguished in EiF EF5–EF6. |
| I2 | The chosen operations and comparison semantics are fixed | The declared structural grammar and pure comparison on immutable inputs. Physical interventions require their own model. |
| I3 | G is append-only: G' ⊇ G at every cache update | An explicit retaining update, such as G'=G∪Δ with verified entries Δ. It is not a consequence of truth stability alone. |

**GC1 (Truth stability does not imply accessible retention).** Consider a closed whole `(a,b,C,R)` containing two fixed bits and two internal cache registers. Each register contains blank, equal or unequal. The transition `(a,b,C,R) → (a,b,R,C)` permutes all 36 whole states. The truth of a=b never changes. Starting with C holding that answer and R blank, the next accessible cache C is blank while R retains the answer. No distinction has left the whole. Thus a pure fixed comparison and whole-system reversibility allow retraction from a chosen accessible cache. The comparison can still be performed again.

**GC2 (Exact law of sound retaining updates).** Fix a finite domain D of immutable comparison keys and its correct answer map c. Let `T={(d,c(d)):d∈D}` be the truth graph. A sound cache is G⊆T. Given such G, a next cache G' is both sound and retaining exactly when `G'=G∪Δ` for some Δ⊆T.

*Proof.* Union with correct entries preserves both inclusion and soundness. Conversely, if G⊆G'⊆T, take Δ=G'∖G. Repeating the same insertion is idempotent. Strict growth occurs only when Δ contains a previously absent entry. The invariant follows by induction over these updates, rather than from the existence of T. An encoding revision or mutable input requires a new immutable key or a new cache context before this argument applies.

**GC3 (Raw recovery needs a compatible cache decoder).** Suppose a raw update retains `(r,e)`, so r is recoverable. This does not alone prove `decode(r)⊆decode((r,e))`. A latest-event decoder that returns only decode(e) drops the old cache when the event is empty. The compatibility law `decode((r,e))=decode(r)∪decode(e)` supplies decoded retention. With sound old and inserted facts, GC2 also supplies soundness. This distinguishes the `Permanent` relation on a raw record from the semantic cache read from it.

`AppendedCacheReading` pairs both raw records and their decoded collections. Under the stated union interpretation, `CacheByAppending` constructs `CachePermanent` from a structural frame and those readings. Its caller does not assume `CachePermanent`. Generic equality witnesses check that the raw and decoded transition endpoints match and that the old decoded collection is recoverable. The initial readings and inserted facts still need correct semantics. A bare `Permanent` conformance cannot establish them.

**GC4 (Finite identification does not require a permanent comparison cache).** Given finite F and a total fixed test, enumerate every candidate and retain the passing set S or its count and unique witness. Every comparison may be recomputed without memoization. The procedure still terminates and gives the same S, including whether |S|=1. It needs working storage but not an append-only store of comparison results. A valid cache can reduce repeated comparison work. This does not identify correctness with cache persistence, and the absence of a logical cache does not assert physical destruction of information in Ω.

A retracting cache need not satisfy `CachePermanent`. A latest-only decoder cannot recover every earlier fact from an append. The corresponding type refusals express these two boundaries.

GC2 is a logical cache law. Realizing it inside a fixed finite reversible whole for unlimited time is a further requirement, subject to the boundary in Verdict Is Invariant VC34. An immutable truth graph, a logical cache and a physical memory device are three distinct parts of that claim.

**2.5. Unity.** PAIR is the sole structural primitive: the act of distinction.

- **NULL** is its fixpoint: the pair where left(x) = right(x) = x. Boundary is where distinction self-terminates, never a separate symbol. Base case detection: left(x) = x (self-reference), not x = ⊥ (external symbol).
- **COMPARE** is structural recursion over pairs: two trees are identical iff their components are identical at every level, terminating at the fixpoint. Identity is what simultaneous traversal of two structures already is, never an external operation.
- **Projection** is destructuring: left(PAIR(A,B)) = A. A direct consequence of distinction having two sides.

One act: distinction. Three derived aspects: where it ends (boundary), whether two histories match (identity), which side you examine (access). The author keeps NULL and COMPARE as notation: they name structural properties of distinction, never independent entities. This is uniqueness of the primitive; see the note on uniqueness at the end of §0.

> Argues: ``OperationsClosed`` needs ``/Notation/Pair``.

## §3. Problem

```
IN:   Σ, COMPARE, Graph (from §2)
OUT:  Game, F, S, f*
      Candidate identification: R4; source adequacy remains separate
```

**3.1. Game.** A pair:

- Example pairs: {(I₁, O₁), ..., (Iₜ, Oₜ)} where each Iₖ, Oₖ ⊂ Σ, finite.
- Test input: I_test ⊂ Σ, finite.

**3.2. Encoding strategy (finite basis selection).** The system selects every output value from a finite basis present in the input. The system does not create new values: it identifies which basis elements belong in which output positions.

Supplying a finite codomain as an input basis makes every intended output value available for selection. It does not supply the selection rule or establish that the fixed feature grammar can express it. Theorem 4 separates a finite function graph from a program which executes that graph. A correct basis embedding must retain the relation to the original task (§1b).

**3.3. Functions.** For this finite extensional presentation, declare a finite input domain D containing the example and test inputs, a finite decoded-output family Y, and a candidate family F⊆Y^D. Two candidates are the same element of F exactly when their decoded outputs agree on every input in D. Thus |F|≤|Y|^|D|. For fixed output positions O and a common finite value basis V, Y⊆V^O gives |F|≤|V|^(|O|·|D|). The smaller bound |V|^|O| counts possible outputs at one input, not all laws over D.

An implementation may instead supply a bounded program grammar or another finite candidate enumeration. Its finiteness, evaluation and intended scope must then be established for that representation. Multiple programs may have the same behavior; the displayed bound counts distinct functions, not program texts. A finite F can also consist of functions on an infinite input domain, but its finiteness then needs another ground. Finite outputs alone do not bound such a law family. Identification on D also does not identify a law's behavior outside D. These distinctions concern the finite checking presentation, not a claim that every VI source or relation is a table.

**3.4. Example consistency.** S = {f ∈ F : f(Iₖ) = Oₖ for all k}.

> Argues: ``HasSolutions`` needs ``HasSigma``.

**3.5. Uniqueness within the encoding (R4).** |S| = 1. A decidable property of the encoding: the system computes |S| and reports the result (§3.6). Denote the unique element f*.

|S| > 1: insufficient to identify the complete candidate, and the system returns this as a diagnostic (§1). A coarser requested answer may already be settled (U2c). Each additional example can only drop candidates from S, never add one, with F and the law fixed. |S| = 1: the encoding identifies its unique candidate. Identification of the actual law additionally requires faithful observations and its representability in F. R4 alone does not check that premise (CS3).

**3.6. R4 is decidable under the checking premises.** Given a finite enumeration of the distinct candidates in F and a terminating example check for each, exhaustive checking computes S and |S|. These are supplied access and termination grounds, not consequences of abstract finiteness alone. No uniform runtime estimate follows without costs for enumeration, candidate evaluation, comparisons and storage. Theorem 3 bounds one specified class of comparisons, not the cost of this entire computation.

> Argues: ``ExactlyOneSurvives`` needs ``EqualityDecidable``.
> Argues: ``ExactlyOneSurvives`` needs ``HasSolutions``.

**3.7. Applicability.** Consider a task as a relation R(x,y): "y is a valid solution of x". Section 0 establishes decidable structural equality for its stated finite constructor representation. Applying the checking game to R requires three further conditions:

1. **Declared representation.** Candidate solutions have an interpretation in a specified constructor grammar.
2. **Computable verifier.** A supplied terminating check decides the encoded R on its stated domain. Decidable equality of syntax does not by itself decide an arbitrary relation on that syntax.
3. **Finite candidate space.** The admitted constructor expressions have an established finite bound or a supplied finite complete family F. A finite basis with unbounded assembly depth is insufficient.

These are applicability premises, rather than consequences of the existence of one finite form. The additional condition that turns this verification into identification is:

4. **Uniqueness (R4).** Exactly one candidate in F passes verification: |S| = 1.

**When |S| > 1.** Multiple candidates pass, so the complete candidate is not identified. A required question can nevertheless have one common answer on S (U2c); identifying more is unnecessary for that question. A separate selection criterion, such as a stipulated cost with a unique minimizer, may instead give a new relation R′ with one survivor. That selects under R′, not under R alone. Neither adding this criterion nor requiring a unique program is forced by a request which admits several implementations.

**When |S| = 0.** No candidate in the supplied F passes verification. This rejects that family for the stated test. A claim that no solution exists at all additionally needs coverage of all relevant solutions.

**Real boundary.** This inner checking procedure requires a supplied finite candidate enumeration and a terminating verifier. Choosing an encoding does not prove that those requirements can be met while retaining the original question. For example, "halts within N steps" has a finite simulation check. A positive result answers "eventually halts" positively, but a negative result does not answer it negatively. Full equivalence needs an established sufficient bound or another proof covering the omitted behavior; an executable bounded route needs a bound it can actually obtain. The bounded check can be useful without settling the original question.

There is a direct contact-level obstruction, already used in Liquid LQ3. Allow all binary sequences over an infinite set of coordinates, with access only through individual coordinate readings. The question asks whether any coordinate is one. After any finite transcript of zero answers, the all-zero sequence and a sequence with one at an unqueried coordinate give the same transcript but require different answers. An adaptive reader has the same obstruction along that all-zero transcript: its next queried coordinate depends on the same preceding answers. Thus this interface cannot issue a sound terminating negative answer on the all-zero source while remaining correct throughout that family. A source-bound universal relation or a sufficient coverage bound would be a stronger ground; it is not produced by calling the transcript a complete encoding.

The obstruction concerns that acquisition interface, not every VI construction. It shows exactly what §1b must prevent: a finite description of a completed contact is not automatically a sufficient description of the requested continuation or source question. Adequacy must be derived through the actual source relation, not assigned to the agent as an ability it is presumed to possess.

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
Given: rule with established membership in the declared F
For each example pair (I, O):
    If apply(rule, I) ≠ O → REJECT(compile, example k)
```

No candidate passes compilation unless it reproduces all example outputs. The REJECT names the example index: the structural address for the agent.

Membership can follow from construction in the admitted candidate grammar. A proposed rule from another route needs that same ground before Theorem 1 applies; example agreement alone does not establish membership in an arbitrarily restricted F. Naming the family or asserting a membership flag does not supply it. Without that ground the displayed comparisons certify only agreement with the examples. The finite covered-selection constructors of U2 supply addressed membership witnesses in their own declared grammar; this prose requirement is not an automatic check of arbitrary submitted programs.

For a finite witness, take distinct inputs u,v and distinct answers a,b. Let F contain only the constant-a law and let the only example be (u,a). Then S=F is a singleton. A submitted rule g with g(u)=a and g(v)=b matches that example but is outside F and differs from its survivor. Thus R4 and successful example comparisons alone do not establish Theorem 2 for an unadmitted submission. This is distinct from CS3's missing actual law: here the candidate being checked, rather than the intended law, is outside the declared family.

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

**Theorem 1 (Compilation).** If f′ is admitted as a member of the declared F and result = PASS for f′, then f′∈S.

*Proof.* PASS gives f′(Iₖ)=Oₖ for every example (§4.7). Together with f′∈F, this is exactly the definition of membership in S. QED

> Argues: ``PassImpliesMembership`` needs ``PipelineTotal``.
> Argues: ``PassImpliesMembership`` needs ``ResultDeterministic``.

**Theorem 2 (Safety).** For a candidate admitted to F, if |S|=1 and result=PASS, then f′=f*.

*Proof.* f' ∈ S (Theorem 1). S = {f*} (R4). f' ∈ {f*} → f' = f*. QED

U2–U2a realize the singleton and membership-to-identity steps on the finite support grammar. U2b realizes a constraint-derived assignment identity without enumerating candidates. Neither relies on the legacy Unique coordinate to supply a cardinality theorem. Here f* denotes the survivor defined in §3.5. Identifying a separately intended target additionally requires its representability and agreement with the observations.

> Argues: ``PassIsIdentification`` needs ``ExactlyOneSurvives``.
> Argues: ``PassIsIdentification`` needs ``PassImpliesMembership``.

**Corollary.** Given R4 and candidate admission to F, a compiling candidate equals f*. Without R4, compilation guarantees example consistency, not uniqueness. Compilation failure produces no output from that proposal.

**Remark (the scope of fixed-point language).** Define the partial identity c:F⇀F by c(f)=f exactly when f∈S. Its fixed points are precisely S, so R4 gives one fixed point of this particular map. From outside S the map has no action; inside S it leaves the supplied candidate unchanged. Thus it cannot itself move a rejected candidate into S. This restates the survivor condition; it does not construct a search, an attracting dynamics or a reason for the source to preserve that point. No order selecting a least fixed point has been supplied. The least-fixed-point construction of finite syntax and this partial identity on candidates are different constructions.

Within the same admitted family, safety follows from compilation (§4.7) and R4, however the agent found f′. Feature search, enumeration or another proposal mechanism may supply candidates. Each route must establish membership in that F and pass the same checks. The proposal method does not replace either ground. The resulting identity is with the survivor in F; application to the intended source still requires its established relation to that family.

**Theorem 3 (Identifiability).** Fix the finite game, its basis-selection candidates and R4. Let N count the input and reference-output atoms in that game. Under an exhaustive pair-enumeration schedule, at most N² top-level COMPARE calls classify every equality between their encoded values. That table suffices for the value comparisons in example verification. Exactly one candidate passes, identifying f* within F.

*Proof.* The N atoms supply at most N encoded values and hence at most N² ordered value pairs. Exhaustive comparison classifies each pair, and I3 retains those classifications. Each candidate output is selected from the input basis, so its equality with a reference output is in this table. Evaluating the candidate and consulting these equalities determines membership in S. R4 then leaves exactly f*. Different source positions can carry equal values: selecting different atoms does not itself establish unequal decoded outputs. The bound counts top-level equality calls, excluding candidate evaluation, enumeration of F, cache access and the internal cost of comparing composite values. QED

**Theorem 4 (Finite extensional presentation).** Let D and Y be finite nonempty sets and let f_T:D→Y be a total function. In the complete extensional family F=Y^D, its full graph of correct examples {(x,f_T(x)):x∈D} leaves exactly the candidate f_T. The same is true for every subfamily F₀⊆Y^D containing f_T.

*Proof.* The family has |Y|^|D| members. The target agrees with every supplied example. Any different g disagrees at some x∈D and fails that example. Therefore the survivors are exactly {f_T}. With injective codes for the finitely many input and output forms, each function graph has a finite tree representation. Given those codes and the complete correct graph, finite table comparison implements this extensional checking construction. QED

The complete graph contains the answers being identified. The theorem does not acquire these answers from an unknown source, establish their physical provenance, or guarantee their expression as an executable rule in the fixed feature grammar. Encoding a function graph as finite data and implementing its application are different obligations. In particular, §0 step 9 places a supplied finite object's encoding within a sufficiently large representation family; it does not establish that an independently selected program family contains the desired law. This separates finite presentability, acquisition of correct examples and program coverage.

**Corollary (application to an actual checking family).** If a finite candidate enumeration with terminating checks is supplied, the intended law belongs to it, the examples faithfully concern that law, and their survivor set is a singleton, Theorems 2 and 5 give its identification by exhaustive checking. Theorem 4 supplies a full-graph way of meeting the singleton condition when that graph is available. Fewer examples or a structural derivation can suffice; neither their availability nor universal discovery follows from the existence of a finite presentation. U2c can instead settle a coarser requested answer without identifying the full law.

**A finite law family need not have a finite input domain.** Let F be a nonempty finite family of n distinct total functions X→Y, with X otherwise arbitrary. There exists a set of at most n−1 inputs whose joint answers distinguish every member of F. Start with no chosen inputs, so all functions are in one agreement class. If some class contains distinct f,g, their extensional distinction supplies an x with f(x)≠g(x). Adding that input strictly increases the number of agreement classes. At most n−1 such refinements reach n singleton classes. This is an existence construction from distinguishing witnesses, not a procedure for finding them in every presented function language.

The bound can be necessary. On n−1 input positions, let f₀ always give one answer u, and let fᵢ differ from f₀ only at position i, giving a distinct answer v there. Every separating input set must contain every such position to distinguish fᵢ from f₀. On the f₀ path even adaptive coordinate acquisition needs all n−1 positions. The case n=1 needs no acquisitions. These examples establish the worst-case bound in this function-reading interface, not a cost law for arbitrary contacts.

To apply the result, the actual law must belong to F, the distinguishing inputs and their acquisitions must be available, and the retained answers must concern that same law. No finite enumeration of the entire X is needed. Conversely, existence of a finite separating family does not create those contacts or their reliable records. This positive result retains the possibility of finite identification over an unbounded source domain without converting a finite trace into a universal coverage premise.

**Theorem 5 (Completeness of exhaustive checking).** Given a finite enumeration of F, a terminating membership check for S and |S|=1, exhaustive checking reaches PASS with f'=f*.

*Proof.* Use the supplied enumeration, obtainable in the declared finite grammar with its bound (§0 step 7). Each membership check terminates. The enumeration reaches f*, the sole member of S, and its compilation passes by definition of S (§4.7). Theorem 2 identifies that passing candidate. QED

Theorems 1–2: soundness (PASS → correct). Theorem 5: completeness (preconditions → PASS). Extraction failure (§4.5–4.6) is a coverage limitation, and f* is still certifiable.

**Corollary (Solution-count classification).** Exhaustive checking of the supplied finite F determines whether |S|=1, |S|=0 or |S|>1. These mean unique identification, no passing candidate in F, and multiple passing candidates respectively. *Proof.* The terminating membership check classifies each enumerated candidate, so S and its count are obtained. The three cases partition its possible counts. Rejection of one proposed candidate does not classify S. A coarser question can be settled when |S|>1, as U2c shows. QED

### Inner Properties

**5.1. Termination.** The admitted run has finite enumerations of its candidates, examples, atoms and fixed features, and each invoked evaluation or primitive check terminates on its declared domain. Its displayed loops traverse those finite enumerations, so they and their finite composition terminate. QED. Finiteness of an input description alone would not prove termination of an arbitrary evaluator encoded in it.

> Argues: ``StepsTerminate`` needs ``StructuresFinite``.

**5.2. Complexity.** The algorithm terminates under §5.1's premises. Its loop counts concern the declared finite enumerations. Termination does not by itself give a practical time bound. Such a bound requires costs for the representation and each operation.

**5.3. Cache monotonicity.** I3 gives G_n⊆G_{n+1}. For a fixed finite set K of required comparison keys, the missing-key count is |K∖dom(G)| and cannot increase under that retention rule. Entries outside K contribute no saved comparison to this count. This measures missing keys, not total execution cost (§5.18).

**5.4. Encoding independence.** Each encoding defines its own function space F and its own f*. Under R4, PASS identifies f* for that encoding (Theorem 2). Cross-encoding agreement requires a correspondence establishing that the decoded answers concern the same target question on the declared domain. Two R4 checks alone do not establish it. Such a correspondence can itself be expressed through the actual readings and checked, as in Verdict VC45 and VC53.

**5.5. Totality.** For an admitted run satisfying §5.1, the inner pipeline is linear: ENCODE → VALIDATE → EXTRACT → COMPILE → EXECUTE. Two binary gates (basis validation, compilation) are the only conditional transitions in this specified pipeline. Its paths terminate at PASS, REJECT(basis), REJECT(compile), or MISMATCH. *Proof.* Section 5.1 establishes termination of the finite composition under its evaluation and enumeration premises; the declared control flow supplies these terminal alternatives and resolves score ties deterministically. QED. This is not a totality theorem for an arbitrary evaluator supplied as finite code.

> Argues: ``PipelineTotal`` needs ``StepsTerminate``.

### Loop Properties

These properties concern the full loop with the stated storage and traversal rules. Cache retention, diagnostic retention and nonrepeating enumeration must each be supplied. Finiteness alone does not imply any of those rules.

**5.6. Monotone cache order.** Under I3, one execution gives a chain `G₀⊆G₁⊆…` in the partial order of caches by inclusion. Distinct caches from different executions can be incomparable: {p} and {q} are an example. This is not a total order on all system states. A fixed domain of N comparison keys permits at most N strict additions, with any number of repetitions.

**5.7. Diagnostic accumulation (conditional).** If the diagnostic set H is updated by `H'=H∪{diagnostic}`, it grows weakly. Repeating the same REJECT adds no new diagnostic fact. A new timestamp may enlarge an event log without eliminating any additional candidate. I3 for comparison cache G does not by itself retain a separate H. Even a newly stored correct comparison can be redundant for the candidate question and leave S unchanged.

**5.8. Full loop determinism.** If the agent follows a fixed protocol (enumeration order over E), then: same task + same grammar + same protocol → same sequence of iterations → same result. The full loop is a deterministic function from (task, grammar, protocol) to {PASS(f*), REJECT}.

> Argues: ``ResultDeterministic`` needs ``OperationsClosed``.

**5.9. Loop termination.** If E is finite, the inner run terminates, and each encoding is tried at most once before exhaustion, the outer loop takes at most |E| iterations. A finite sum of finite runtimes is finite. Finiteness of E without that traversal rule permits repeating one failed encoding forever.

**5.10. Convergence.** The loop tries every encoding in E (finite enumeration). If any encoding's inner run produces PASS, the loop terminates with PASS. If no encoding produces PASS, the loop exhausts E and reports REJECT. The loop skips no encoding. An encoding may satisfy R4 yet produce REJECT if the extraction heuristic (§4.5–4.6) fails to find f*. An exhausted E without PASS proves only that the extractor failed on every encoding in E, and an R4-valid encoding may still be among them. This is an extraction limitation, never a soundness failure. Soundness (Theorem 2) is unconditional: any PASS is correct.

### Compositional Properties

**5.11. Games compose through a supplied boundary.** Let a:A→B and b:B→C be total operations on the declared finite domains, with the intermediate representation actually shared. Then b∘a is total. If separate checking games identify these operations, their composition is determined within that contract. *Proof.* For every admitted x, a(x) belongs to b's domain and b(a(x)) exists. Singleton component solution sets determine the selected a and b. Finiteness of their descriptions alone does not establish the shared boundary or identify this composition with a separately intended target. Those require the source, encoding and question correspondences. Verdict §6e and VC53 express such composition at actual endpoints. QED

**5.12. Component uniqueness needs joint admissibility.** Let F_T⊆F₁×F₂ be the declared joint domain and let each component check be decidable. Then S_T=F_T∩(S₁×S₂). If S₁={a} and S₂={b}, the joint solution set is {(a,b)} when (a,b)∈F_T, and empty otherwise. *Proof.* Substitute the two singleton sets into the intersection. Thus separate identification determines at most one joint candidate. It does not prove that candidate admissible. For F₁=F₂={0,1}, two checks requiring 0 each succeed separately, while a joint requirement that the coordinates differ excludes their pair. On the full product, component-wise PASS suffices. On a restricted joint domain, membership of the pair must also be established. QED

**5.13. Sub-game formation.** A sub-problem is a V=I checking game when its candidate domain is supplied as finite and its encoded check is decidable. Identifying one candidate additionally requires its own R4. Restricting a parent's finite domain and decidable check provides those first two properties. A newly invented question about the parent need not be such a restriction. Its result supplies a parent input only through a matching interpretation. Reuse of the parent's cache likewise requires the same comparison meanings and retained entries. These are construction conditions, not consequences of calling a task a sub-problem.

### Structural Properties

**5.14. Residual checking.** Restrict a fixed finite candidate game to the candidates compatible with a recorded node, retaining its decidable check. The residual domain is finite and the restricted check remains decidable. Retained cache entries apply when their source and comparison bindings are unchanged. This yields another checking problem. Its residual solution set can be empty, singleton or larger. A finite record of work already performed does not by itself bound all future work or establish a unique continuation.

**5.15. Structural recurrence across levels.** A candidate game and a game selecting its encoding can share a finite-domain, decidable-check pattern. The higher game needs a supplied finite encoding family E and a terminating check for each member. It need not have a unique passing encoding: different encodings can each identify their own candidate and give the same required decoded answer. Each level needs its own R4 to identify its complete candidate. U2c can settle a shared answer without selecting one encoding.

**5.16. Finite tower (conditional).** Finite games at each level do not by themselves bound the number of levels. Termination follows if every creation of a further level strictly decreases a supplied natural-number rank r. Then at most r descents, and r+1 levels including the initial one, are possible. *Proof.* A strict decrease lowers a nonnegative integer by at least one. Induct on its initial value. A fixed maximum level count is another sufficient premise. Taking finite power sets repeatedly proves finiteness at each stage, but gives no last stage. Even one candidate per level permits arbitrarily many levels (Existence Is Finite EF7). A proposed compression rule must actually establish strict descent of a well-founded rank to use this theorem.

**5.17. Agent-system role duality.** The system at level N has the same functional role as the agent's tool T2 at level N+1. *Proof.* System at level N: takes candidate, returns PASS/REJECT. This is what an agent at level N+1 calls (T2). The agent's encoding-selection process: takes encoding candidate, returns PASS/REJECT via run(). Same functional interface, different level. QED

### Extended Cache Properties

**5.18. Cache transferability.** A cached comparison applies in another game when it concerns the same encoded terms under the same comparison semantics. For a fixed required key set K_B and transparent cache reuse, the number of new comparison keys is |K_B∖dom(G)|≤|K_B|. *Proof.* Reuse removes already classified keys from this fixed set. The bound concerns comparison misses. It does not bound lookup costs, establish faster execution for every cache policy, or transport a comparison to a different encoding without a correspondence. QED

**5.19. Repetition with transparent memoization.** Repeat the same deterministic computation on the same input and retain all its comparison entries under the same keys. If cache hits return the recorded answer without changing the computation's meaning, the result repeats and no fresh equality evaluation is needed for those keys. This still permits traversal, lookup and output work. Fixed comparison semantics alone does not supply the retention or reuse policy.

### Information Properties

**5.20. Revelation, not creation.** COMPARE(a, b) does not create a fact. The result (equal/not_equal) is structurally determined before the call: the trees are already equal or not. COMPARE reveals what is already the case. *Proof.* COMPARE is a pure function of its inputs (I2). Its output is determined by the structure of a and b, which exist before the call. No randomness, no side effects. The comparison result is a pre-existing structural fact made explicit. QED

**5.21. Comparison records have a declared admission rule.** In the pipeline whose cache update inserts a fresh comparison record only through COMPARE, only that instruction creates such an event. This follows from the specified cache-writing rules. It does not establish that every equality must be discovered by executing a new comparison. PAIR depends on its inputs and can construct (x,x), whose two fields agree by construction. Projection can expose an equality already forced by the source relations. `ThreeContactsForceFourth` similarly derives a fourth equality from three actual contacts in a generic type body. These conclusions need no additional COMPARE premise. A comparison event, a retained certificate and a structurally established relation are distinct objects. Agreement AC5–AC6 give the evidence and source-binding criteria for such inferences.

**5.22. Working candidates shrink under sound retained constraints.** For a fixed game, the exact S={f∈F:f matches all examples} is unchanged by discovering another consequence of those examples. Let Ŝ(G) instead denote the candidates not yet excluded by the retained sound comparison facts. If G⊆G′ and admission requires satisfying every such fact, then S⊆Ŝ(G′)⊆Ŝ(G). *Proof.* Every true solution satisfies the sound facts. Adding constraints removes candidates from the working approximation or leaves it unchanged. A newly added fact can be redundant. Changing the observations, candidate family or interpretation is a different operation and needs the scope analysis of SC1 and CS3. QED

**5.23. Access follows the actual input binding.** A pure inner pipeline cannot distinguish two configurations that supply the same encoded input while differing only in an omitted graph or history. Substituting equal inputs gives equal outputs. This is a data-flow restriction. A finite description of the pipeline or its history can itself be represented in the stated tree grammar and supplied as input. Processing that description is not excluded by the primitive vocabulary. Its relation to the actual current configuration must be established, just as for any other source. The distinction is between a represented self-description and access to an unprovided state, not a universal prohibition of self-reference.

**5.24. Encoding-bounded scope.** The inner pipeline receives only the encoded representation. It has no access to the original task, the agent, the grammar, or any information not present in the encoding. Two different encodings of the same task create two separate, non-communicating pipeline executions. *Proof.* The pipeline's input is (encoded game, feature set). All pipeline operations (§4.1–4.8) reference only this input. No step references the agent, the grammar, or any external state. The pipeline is a pure function of its encoded input. QED

**5.25. Order within a declared traversal.** Fix the encoding, candidate space, comparison semantics and traversal rules, and vary only the order of a prescribed collection of comparisons. With GC2 updates, complete traversals produce the same union of facts, by associativity, commutativity and idempotence of union. An order may change how much work precedes a sufficient certificate. It is the only varied parameter in this comparison of protocols, not the only possible degree of freedom of an arbitrary agent or physical experiment.

For a nonrepeating enumeration of finite E, if at least one encoding returns PASS, the first PASS occurs between attempts 1 and |E|, depending on order. This counts encoding attempts, not atom comparisons, and depends on the chosen grammar and extractor. The N² bound on distinct atom-pair keys is a different bound. Repeated diagnostics and redundant comparisons need not prune any new candidate (GC2 and §5.7).

*Information-theoretic interpretation.* Three quantities need separate premises: the entropy of a distribution, the content of an observed branch, and the cost of an available experimental strategy.

**IQ1 (Information gain is conditional and question-specific).** Let X be an original candidate with a declared prior, Z=q(X) the required answer, R an already available record and Y a binary reading. Then `0≤I(Z;Y|R)≤H(Y|R)≤1` bit. Independence is not required. The quantities average over possible readings. Conditional entropy in this sense is an average of posterior entropies, as defined in [Shannon, 1948, §6](https://people.math.harvard.edu/~ctm/home/text/others/shannon/entropy/entropy.pdf). Using R and Y as an agent's next knowledge state requires retaining them or a sufficient reading of them. A memory update that discards old evidence does not inherit this bound on uncertainty reduction (GC3).

For a given prior, H(X)≤log₂|F|, with equality only for a uniform distribution on F. A verdict concerns H(q(X)), which can be smaller. A random-looking reading about another coordinate may give no information about this verdict. In a binary decision tree with no other uncounted source-dependent readings, exact recovery of Z requires mean depth at least H(Z). A worst depth d allows at most 2^d leaves, so d≥⌈log₂|q(F)|⌉ when every answer in q(F) must be covered. For full identification this uses q(X)=X. These are lower bounds on a successful protocol, not a construction of one. For the mean bound, complete leaf transcripts form a prefix code and determine Z. Their mean length is at least their entropy, which is at least H(Z).

**IQ2 (Support refinement need not lower entropy on each branch).** Give A, B, C probabilities 9/10, 1/20, 1/20, and read Y=1 exactly when X is B or C. Initially H(X)≈0.568996 bits. On the rare branch Y=1, the support shrinks from three sources to two, but their probabilities become 1/2, 1/2 and posterior entropy is one bit. Mean conditional entropy is only 0.1 bit. Thus the reading gives I(X;Y)≈0.468996 bits on average, while this one posterior is more uncertain than the prior in the Shannon sense.

For a noiseless event of prior probability p, the posterior/prior KL divergence is −log₂p: every retained probability is multiplied by 1/p. The rare branch here has gain log₂10≈3.321928 bits. This does not violate IQ1, whose one-bit bound concerns mean information. With a uniform prior and pure support restriction, posterior entropy instead equals the logarithm of the smaller support. The counterexample needs the nonuniform weights.

This observation can occur entirely inside a closed finite whole. Let the whole be `(X,M,P)` with three source values, one memory bit and one readiness bit. The fixed map `(X,M,P)→(X,M XOR Y(X),1−P)` permutes its twelve states. Prepare M=P=0. One step records Y and marks readiness, the next returns to preparation. The joint entropy is unchanged, and memory becomes correlated with X during the readout window. The prior describes possible complete configurations. It introduces no external source of randomness, reservoir or controller. Logical reversibility here gives no thermodynamic cost bound.

**IQ3 (The available questions determine cost and excess distinctions).** Take eight equiprobable sources. If the three binary-coordinate questions are available, full identification takes three questions. If only tests “is the source i?” for i=1,…,7 are available, the optimum is seven in the worst case and 35/8 on average. Every negative answer rules out at most one of those names. Testing each once and stopping at a positive answer attains these bounds. Entropy is three bits in both experiments.

Now ask only whether the source is the eighth. Its answer entropy is about 0.543564 bits. The same seven name tests still require seven in the worst case and 35/8 on average. Every successful complete transcript also identifies the full source: a positive name test identifies that name, and seven negative answers identify the eighth. If the target question itself is available, one reading suffices instead. A complete transcript can therefore carry more source distinctions than the final verdict requires. Whether an agent retains that transcript in accessible memory is a separate question (GC3).

For noiseless deterministic questions ending in full identification, conditional event probabilities along the complete transcript multiply to the prior probability of the identified source. Their negative logarithms therefore sum to −log₂P(X), whatever the successful order. The average is H(X). This invariant content need not equal the number or physical cost of questions. Restricted queries can be unbalanced or redundant, and destructive interventions can prevent successful identification altogether (VC26).

The former N²≥log₂|F| assertion also fails without a bridge between what these quantities count. Two basis values at five output positions permit 32 selection rules, with log₂|F|=5>N²=4. The four equality facts about the two basis values do not identify which rule selected the values at the five positions. Positional readings can do so. A supposed dimension bound likewise needs a specified candidate family and admissible question model.

`PreparedObservation` derives source retention, readiness and the declared reading as pure types. Distinct residuals need not coincide when their observations agree. The entropy and cost results follow from the mathematical arguments above, with their specified distributions and query vocabularies.

**IQ4 (A successful transcript refines the answer).** Fix a finite source set F, a positive prior on every source, a target Z=q(X), and a finite vocabulary of noiseless nondestructive binary questions. A deterministic successful policy chooses each question from previous readings and eventually answers q(X). Let T(X) be its complete sequence of question indexes and readings, not just its terminal answer. Correctness gives Z=f(T), and determinism gives T=g(X). The entropy chain rule therefore yields

```
H(T) = H(Z) + H(T|Z),       I(X;T|Z) = H(T|Z) ≥ 0.
```

Define the least excess over successful available policies as `e*=min H(T|Z)`. Set it to infinity if none succeeds. This concerns distinctions in the complete experimental transcript. It does not require the final accessible register to retain that transcript. A later compression can retain Z while the residual distinctions remain elsewhere inside Ω (GC3, M34–M35). In IQ3's eight-source name experiment, e*=3−h₂(1/8)≈2.456436 bits. With the direct target test available, e*=0. The prior describes possible whole configurations. It is not an external random input to their dynamics.

This uses standard information identities. The related [information bottleneck formulation, §3.1](https://arxiv.org/html/physics/0004057v1) optimizes compression while preserving information about a relevance variable. Here the extra restriction is that a representation must be a complete transcript realizable by the declared query vocabulary. An arbitrary encoder X↦q(X) does not supply such an experiment. This distinction is a research connection, not a claim of priority over information theory or decision trees.

**IQ5 (Exact criterion for no excess distinctions).** Under IQ4's premises, e*=0 exactly when there is a successful policy whose every queried test is constant on each target class still possible at that node. The requirement is conditional on the branch, not global constancy of every available test on every target class.

*Proof.* Full support makes H(T|Z)=0 equivalent to equal transcripts for every pair with equal target answers. If a queried test splits such a class at a reached node, those two paths have different prefixes forever, contradicting that equality. Conversely, a policy that never splits a possible target class gives every member of that class the same path. Success separates different answers, so the transcript partition is exactly the target partition. This supplies a finite recursive decision: stop on a single answer class. Otherwise choose a class-preserving strict split whose two children succeed. Each split reduces the support, so recursion terminates.

For example, four sources A₁,A₂,B,C have answers A,A,B,C. Available tests are u=(0,0,1,1) and v=(0,1,0,1). Ask u first. After zero answer A. After one ask v to decide B or C. Although v separates A₁ and A₂ globally, it is never asked on their branch. Thus e*=0. Removing every globally incompatible test would remove v and falsely rule out this successful experiment.

**IQ6 (Cost and excess need not select the same experiment).** Consider five uniform sources 0,…,4 with target q=(0,1,0,0,1) and four available tests:

```
u     = (0,1,0,1,1)       v     = (0,1,1,0,1)
name₁ = (0,1,0,0,0)       name₄ = (0,0,0,0,1)
```

Asking u and then v only after a one gives mean cost 8/5 and transcript partition {{0,2},{1,4},{3}}. Its excess is (3/5)h₂(1/3)≈0.550978 bits. Asking name₄ and then name₁ only after a zero gives mean cost 9/5 and partition {{0,2,3},{1},{4}}, with excess 2/5 bits. Both have worst cost two. Every root test splits a target class, so zero excess is impossible.

These choices lie on the cost/excess Pareto frontier. For each possible root, the unresolved child needs at least one more test: u or v leaves mass 3/5 unresolved, while either name test leaves mass 4/5. The displayed continuations attain those cost bounds. After a root split of the three-source target class, excess is already at least (3/5)h₂(1/3). A name root instead splits the two-source class and already costs 2/5 bits of excess. Later readings cannot undo a distinction in the complete transcript. This proves both frontier values.

There is also no single coarsest attainable successful transcript partition. Any correct common coarsening of the two displayed partitions must merge 0,2,3 and merge 1,4, giving exactly the unattainable target partition. The abstract sufficient quotient exists, but the family of experimentally attainable quotients need not contain a least element. This qualifies the use of a coarsest representation in VI: realizability is a separate condition. It does not contradict VC15, which preserves every declared possible future observation. Here one chosen experiment need only settle q, and may avoid other available observations. These are different sufficiency requirements.

For a finite support, consider the leaf partitions of reduced question trees. At a mixed support, each available strict split combines two child partitions, and mean costs combine with their conditional masses. Induction on support size covers all trees that stop when the answer is fixed. Removing nonsplitting questions and queries after a fixed answer cannot increase excess or cost, so these trees suffice for both minima and the Pareto frontier. Different paths with equal terminal answers remain separate blocks. Zero excess is the exact equality of the answer and transcript partitions.

`DirectAnswerRecord` supplies a pure-type witness when a direct reading is available. Equal certified answers give equal transcript fields, the answer is recoverable, and the actual source is separately retained. Equal transcript fields need not identify the whole records. These relations require the specified direct reading.

Finite decision-tree separation itself is established literature. For example, [Minimum Query Set for Decision Tree Construction, §4](https://www.mdpi.com/1099-4300/23/12/1682) requires the query family to separate differently classified pairs. That is the weaker feasibility condition checked in IQ3, not IQ5's within-class transcript condition. The present certificates assume known finite tables. Learning them from incomplete observations remains a separate problem. An internal controller and finite reversible completion can use VC32–VC34's construction. Neither an external observer nor permanent one-way record growth is a premise of this experiment model.

*Remark (axis alignment).* Fix F and let S(G) be the candidates satisfying every constraint recorded in G. Then G⊆G' implies S(G')⊆S(G), directly by the definition of satisfaction. This links these two chosen orders. Retaining a separate diagnostic set requires its own update law (§5.7), and no order on arbitrary physical or internal quantities follows from I3 alone. Deleting a redundant fact can leave S unchanged, so retraction need not reverse identification progress.

For nonempty fixed F, `1−|S|/|F|` measures the fraction eliminated. It equals one when S is empty, which is rejection, not unique identification. A unique survivor gives `1−1/|F|`. Monotonic elimination is therefore not sufficient to diagnose successful discovery: the gate must still distinguish |S|=0, |S|=1 and |S|>1.

**5.26. Cross-task saturation.** Fix a finite task collection D whose identified rules all belong to one common extensional family F under a shared decoding. Write g(t) for the required rule of task t, C=g(D), and K=|C|. These common-domain premises are necessary before rules from different games can be counted together. Four obligations remain separate: sound entries, retention, class coverage and selection of the right rule for the next task.

**CS1 (Count represented classes, not successful records).** Let L contain sound pairs (feature record, rule), with a retaining update. Its rule projection P(L)⊆C grows monotonically and has size at most K. The number of raw feature/rule pairs need not have that bound. Four tasks with rules (a,a,a,b) can produce three different feature records for a. Then |L|=3>K=2 while |P(L)|=1. Distinct successful tasks are not necessarily distinct represented rule classes.

Starting with coverage P₀, exactly K−|P₀| insertions of previously unrepresented classes suffice for full coverage. Repeated classes do not count. An arbitrary stream may repeat a forever, so no bound on successful events alone guarantees coverage. A stream that eventually visits every class does give eventual coverage, but that visitation is an additional premise. Two complete raw libraries can differ in their feature records. Their rule projections both equal C. Raw equality requires a shared canonical representation as well.

**CS2 (Coverage needs a usable dispatcher).** Suppose the runtime can read only a feature map E:D→Z before selecting a cached rule. A deterministic exact dispatcher d with g=d∘E exists precisely when

```
E(t)=E(u) ⇒ g(t)=g(u).
```

*Proof.* A function d returns the same result for the same input. Conversely, if each feature fiber has one required rule, assign that rule to its feature. The finite table defines d on E(D). A complete library supplies the selected rule only after this condition and its implementation are established. Two tasks with identical available features and different required rules defeat feature-only dispatch even when both rules are cached. This is the same factorization obligation used in Verdict §6c, now applied to task selection.

An exhaustive search through C with a total verifier accepting exactly the required rule can replace that dispatcher. Its verifier and cost are additional premises. Passing only new examples supplies exact rule identification only under the R4 and representation conditions already stated in §5. Newly encountered comparison keys can still require work. Zero new comparisons follows from full coverage of the keys actually used, not from coverage of rule classes alone.

**CS3 (Generalization also depends on the candidate family).** Let U be a fixed finite input domain, H⊆{0,1}^U a declared family of laws, and B a consistent record of input/answer observations. Define

```
V_H(B) = {h∈H : h agrees with every observation in B}.
```

If V_H(B) is nonempty and contains the actual law, a prediction at x is certain for every compatible law exactly when all h∈V_H(B) agree at x. A singleton suffices, but is not necessary for a particular prediction. This is a finite version-space specialization of verdict invariance, not a new principle of statistical learning. See [Mitchell, The Need for Biases in Learning Generalizations, §§2–3](https://www.cs.cmu.edu/~tom/pubs/NeedForBias_1980.pdf).

For H={0,1}^U with n=|U|, m distinct observed inputs leave exactly 2^(n−m) laws. Every unobserved input has both possible answers among those laws: change only that table cell and all observations remain identical. Thus observing all n inputs is necessary for guaranteed full identification under this unrestricted family and these point queries. A repeated input adds no constraint. Restricted families can permit transfer, provided they contain the actual law. The assumption that the target is representable, and the choice of query capabilities, also appear explicitly in [Angluin, Queries and Concept Learning, §1](https://homepages.math.uic.edu/~lreyzin/papers/angluin88.pdf).

For two inputs, assume the constant family H={(0,0),(1,1)} and observe the first answer 0. The sole survivor (0,0) predicts the second answer 0. But the actual law (0,1) also fits that observation and lies outside H. The restricted checker cannot discover its missing representability premise from this one observation. Enlarging H to all four tables restores uncertainty at the second input without deleting or falsifying the first observation. R4 proves uniqueness inside its declared family, not that the family covers the actual law.

More generally, new consistent evidence contracts V and can only enlarge the set of unanimously predictable inputs. Enlarging the candidate family expands V and can retract such certainty. Empirical records and family-dependent conclusions therefore need separate contexts. Retaining an old conclusion with its original assumptions is sound, but reusing it as unconditional after a model revision need not be. The unknown fixed law, its internal hypothesis record, query controller and memory all belong to Ω. Revising the hypothesis record does not change the actual law. VC32–VC34 supply a finite experiment completion when those controllers and windows are required.

The pure-type `ConstantTable` supplies an explicit law restriction. `PredictionsFromConstantTables` derives equal second-input predictions from equal first-input readings and the two constancy premises. It does not assume the second answers equal. Swift rejects both transferring this conclusion to a nonconstant table with the same training reading and treating that table as a member of the constant family. These witnesses expose the assumption that permits generalization instead of claiming that syntax established it for an unknown environment.

*Remark (saturation metrics).* For K>0, |P(L)|/K measures represented rule classes under the fixed common domain. It reaches one exactly at class coverage. It does not measure dispatch sufficiency, empirical coverage of U, or correctness of the assumed family H. For K=0 there are no classes to cover and this ratio is undefined. Retention remains an explicit cache law over the claimed window, not automatic permanent growth inside a finite reversible whole (VC34).

## §6. Interface

The loop (§1) has two participants with distinct functions, guarantees, and boundaries.

### System (inner half)

**Function:** Given an encoding, produce a certified answer or a structural diagnostic.

**Guarantees:** Output equals f* under R4 + PASS (Theorem 2). Compilation failure produces REJECT. Termination uses the finite-domain and traversal premises, determinism uses a fixed protocol, and cache correctness uses verified entries and the retaining update law GC2–GC3.

**Premises of this inner checking procedure**:

| Boundary | Why | Agent's role |
|----------|-----|-------------|
| Verification must terminate on admitted candidates | Finite syntax alone does not give a terminating semantic check | Supply the check and its termination ground; transfer any bounded answer to the original question only where justified |
| Exhaustive candidate checking needs a finite enumeration | This procedure must cover every candidate it claims to reject or identify | Establish the enumeration and its relevant coverage, rather than infer coverage from a chosen bound |
| f* is encoding-local | Cross-encoding agreement needs an established relation (§5.4) | Supply source-bound transport; the relation can belong to the same whole |
| Correctness is relative to R(x,y) | Example agreement or a singleton can concern the wrong question | Establish the verifier's relation to the intended requirement (§1b) |

The stated pipeline uses fixed selection and tie-breaking rules. Its proposal mechanism may be another internal construction. Assigning the encoding obligations to that mechanism does not prove it can satisfy them for every request.

### Agent (outer half)

**Function:** Provide encodings. Read diagnostics. Modify and re-submit.

**Obligations not discharged by the inner check alone**:

| Responsibility | Required ground |
|----------------|---------------------|
| Use a bound | Establish its sufficiency for the source question, or name the restricted question actually settled |
| Select encoding grammar E | Establish its constructor interpretation and the coverage needed for the request |
| Supply features | Relate their actual readings to the source; their names alone do not establish that relation |
| Stop the search | Supply a completion or exhaustion rule; §5.10 gives one for an available finite E |
| Interpret \|S\| > 1 | Check whether the required answer already agrees on S; selecting one complete law needs additional grounds |

**Agent boundaries** (what limits the agent's effectiveness):

| Boundary | Consequence |
|----------|------------|
| Search confined to a supplied E | Failure of all runs is a result about those runs; failure to find a rule inside a run need not exclude all rules in that encoding |
| Features are predefined per domain | REJECT(compile) is possibly "features too narrow", never proof of "task unsolvable" |
| Features held fixed in the stated inner run | This run does not derive a feature adaptation mechanism; a separate construction could supply one |

### Agent Toolset

Five proposed operations for organizing the encoding search:

| Tool | Derived from | Function |
|------|-------------|----------|
| T1: ENUMERATE | §5.10 (supplied finite E) | List all encodings in E |
| T2: RUN | §1 step 2 (call system) | Execute inner pipeline on one encoding |
| T3: READ | §1 step 4 (parse diagnostic) | Extract gate and structural address from REJECT |
| T4: MAP | §6 REJECT table (above) | Convert address to encoding component |
| T5: MODIFY | Grammar structure (finite components) | Replace component value with alternative |

With an available finite E and terminating runs, T1 and T2 find a passing encoding if one of those runs produces PASS. They do not create a passing encoding, guarantee a complete inner extraction, or establish its relation to the original task. T3–T5 can guide proposals, but a diagnostic address alone is not a progress or convergence proof. No minimality theorem for this five-operation toolset has been established. T2 invokes the stated inner pipeline; this interface description neither separates the participants from the whole nor prohibits an internal realization of both roles.

### What REJECT carries

Each REJECT is a message FROM the system TO the agent with a structural address:

| REJECT type | Structural address | Agent action |
|-------------|-------------------|--------------|
| REJECT(basis, value V at position P) | V ∉ input basis | Extend basis or change encoding |
| REJECT(compile, example k) | Rule fails on example k | Add features or change representation |
| MISMATCH | Compiles but wrong on test | Add training examples or refine features |
| \|S\| > 1 (if checked) | Multiple candidates pass | Check the required common answer; acquire a justified distinction only if needed |

### Encoding Selection

Given a bounded encoding grammar E = {e₁, ..., eₘ}:

```
For each e ∈ E:
    Run Algorithm(encode(task, e))
    If PASS → accept e; stop
If no e passes → REJECT
```

This terminates when the enumeration of E is available and each run meets §5.1. Accepting e here selects a passing run. Under candidate admission and R4, that run identifies its encoding-local f*. Settling the original task additionally requires the source-and-question transfer of §1b; selecting e does not perform that proof.

**What the grammar captures.** The grammar E defines HOW to represent task elements as binary trees. For grid tasks: which positional attributes to encode, what depth, which Peano mapping. Grammar design is per-domain (grids, sequences, trees), never per-task.

**The separation.** The agent provides the encoding, and the system checks candidates against the declared verification conditions. Section 5.25 compares traversal orders while holding the other choices fixed. Changing the encoding, candidate family, test or cache rules requires the corresponding premises again. Selecting an encoding does not by itself prove every behavior of its implementation.

## Appendix A: Proof Chain

This map summarizes the paper's arguments. Representation, bounds, target membership and cache rules enter where stated. They are not all consequences of the existence postulate. Each summary retains the scope of its cited argument.

```
DERIVATION (§0):
  A1:  A finite structure exists.                                        [postulate]
  A2:  A finite structure is not nothing.                                 [from A1: else postulate is vacuous]
  A3:  Structure ≠ nothing → a distinction exists.                        [from A2: "not" IS the distinction]
  A4:  Equality of finite ordered binary-tree encodings is decidable.    [§2.1 constructor premises + structural induction]
  A5:  The recursive comparison in A4 halts.                            [each descent enters a smaller finite tree]
  A6:  This comparison reads finite encoded data.                       [A4–A5]
  A7:  A finite alphabet and supplied uniform size bound give finite F. [representation and bound premises; not A6 alone]
  A8:  S = {y ∈ F : COMPARE(y, target) = EQUAL} is computable.           [A4 + A7; encoded target supplied]
  A9:  The intended target's encoding belongs to F and passes the test. [adequacy premise, §0 and CS3]
  A10: |S| is computable.                                                [from A8]
  A11: |S|=1 → verification = identification.                            [from A9 + A10]
  A12: Complete prescribed comparison orders accumulate the same facts. [§5.25; fixed rules and GC2 updates]
       Order is the varied parameter of this comparison of protocols.  [not a restriction on every possible agent]

SYSTEM (§2):
  I1: Each admitted tree is finite; the grammar is unbounded. [§2.1; finite search needs A7]
  I2: PAIR constructs; NULL terminates; comparison and projection read. [§2.1–§2.5 representation premises]
  I3: G is append-only under the specified cache update.  [GC2; truth stability alone does not retain a cache]

PROBLEM (§3):
  P1: Finite declared D,Y; F⊆Y^D, extensional on D.       [§3.3; representation premises]
  P2: |F| ≤ |Y|^|D|; Y⊆V^O gives |V|^(|O|·|D|).         [P1; finite D is required]
  P3: S = {f ∈ F : f matches all examples}.               [definition]
  P4: R4: |S| = 1. Singleton within F, not source adequacy. [§3.5; CS3]

IDENTIFIABILITY (§5):
  D1: N game atoms → ≤ N values → ≤ N² ordered value pairs. [I1]
  D2: Each top-level COMPARE classifies one value pair.    [I2]
  D3: Classifications permanent.                           [I3]
  D4: At most N² top-level calls classify all value pairs. [D1, D2, D3]
  D5: Candidate evaluation uses cached value equalities. [D4, P1; not a runtime bound]
  D6: |S| = 1 → exactly one passes → f* distinguished.    [P4, D5]

COMPILATION (§4.7):
  C0: The submitted rule is a member of the declared F.  [candidate construction/admission]
  C1: Checks f'(Iₖ) = Oₖ for all k.                      [§4.7]
  C2: Fail → REJECT.                                      [§4.7]
  C3: Admitted candidate + PASS → f' ∈ S.                 [C0, C1, P3]

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

FINITE EXTENSIONAL PRESENTATION (§5):
  FE1: Finite nonempty D,Y and f_T:D→Y are specified.       [Theorem 4 premises]
  FE2: Y^D is a finite family of function graphs.          [FE1]
  FE3: The full correct graph rejects every g ≠ f_T.       [extensional difference]
  FE4: The survivor set is {f_T}.                         [FE2–FE3]
  FE5: Tree representation of a graph does not supply its  [§3.2; §1b]
       acquisition, provenance or execution in a chosen grammar.

COMPLETENESS (§5):
  CM1: A finite enumeration of F is supplied by the grammar and bound. [A7]
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
  LP1: G_n ⊆ G_{n+1} in the cache inclusion order.         [I3; not a total order on states]
  LP2: H grows if diagnostics use H'=H∪{diagnostic}.       [§5.7; separate retention premise]
  LP3: Full loop deterministic with its fixed pure protocol. [§5.8]
  LP4: Nonrepeating traversal takes at most |E| iterations. [G1, T3, traversal premise]
  LP5: Exhaustive traversal finds a PASS-producing encoding. [§5.10; R4 alone need not make the extractor pass]

COMPOSITIONAL (§5.11–5.13):
  CO1: The output and input share a supplied boundary.       [§5.11; not I1 alone]
  CO2: Total operations compose on matching domains.         [TOT4, CO1]
  CO3: Component singleton sets need joint admissibility.   [§5.12: S_T=F_T∩(S1×S2)]
  CO4: A sub-game needs its finite domain and decidable check. [§5.13; its own R4 for identification]
  CO5: Reusing its result needs a matching parent input.     [CO4, CO1]

STRUCTURAL (§5.14–5.17):
  ST1: Restrict a finite domain and its decidable check.     [§5.14; retained bindings for cache reuse]
  ST2: The residual checking problem need not have R4.       [ST1]
  ST3: Two levels can share the checking pattern, not R4.    [§5.15; separate premises at each level]
  ST4: Tower depth is bounded by a supplied descending rank. [§5.16; finiteness of each level is insufficient]
  ST5: Agent at level N = candidate at level N+1.            [ST3; same role, not identity]
  ST6: System at level N = agent tool T2 at level N+1.       [ST5; functional duality]

CACHE (§5.18–5.19):
  CA1: Comparison agrees on the same terms and semantics.    [I2]
  CA2: Matching retained entries can be reused in game B.    [CA1, I3; §5.18]
  CA3: |K_B∖dom(G)|≤|K_B| for a fixed required key set.     [CA2; comparison misses only]
  CA4: Transparent retained memoization avoids fresh comparisons. [§5.19; traversal and lookup work remain]

INFORMATION (§5.20–5.25):
  IN1: COMPARE reveals pre-existing facts (revelation).      [I2: pure function]
  IN2: Fresh comparison events follow the cache writer rule. [§5.21: structural proofs remain possible]
  IN3: Sound retained facts shrink Ŝ(G); exact S is fixed.  [§5.22: fixed game]
  IN4: Omitted state is inaccessible without an input link.  [§5.23: equal actual inputs]
  IN5: Pipeline sees only encoded representation.            [pure function of input]
  IN6: Order is the varied parameter of a fixed traversal.   [§5.25: declared comparison family]

INFORMATION-THEORETIC (IQ1–IQ6):
  IT1: Mean binary question count ≥ H(q(X)).                [IQ1: exact finite tree]
  IT2: Worst count ≥ ⌈log₂|q(F)|⌉; achievability separate. [IQ1, IQ3]
  IT3: N game atoms supply at most N² ordered value keys.    [D1, D2; the declared comparison family]
  IT4: No general N² ≥ log₂|F| bridge.                      [IQ3: five-position example]
  IT5: f* at level N = substrate at level N+1.              [CO1, ST3, ST6]
  IT6: Exact transcripts may require extra distinctions.    [IQ4–IQ6: declared vocabulary]

AXIS ALIGNMENT (remark):
  AX1: More retained constraints leave fewer working candidates. [§5.22; two chosen orders]
  AX2: Elimination alone does not distinguish rejection from identification. [axis-alignment remark]
  AX3: No ordering of arbitrary quantities follows from I3. [§5.7 and the axis-alignment remark]

CROSS-TASK SATURATION (§5.26):
  SAT1: K=|g(D)|≤|F| under one common rule interpretation.  [CS1: shared domain]
  SAT2: Retaining sound entries grows their rule projection. [CS1, GC2–GC3]
  SAT3: |P(L)|≤K, while raw feature records may exceed K.   [CS1]
  SAT4: K−|P₀| fresh classes complete coverage.             [CS1: not arbitrary PASSes]
  SAT5: Exact feature dispatch iff g factors through E.      [CS2]
  SAT6: Complete libraries share C, not necessarily features.[CS1]
  SAT7: R4 alone does not certify target representability.   [CS3]
  SAT8: Enlarging the model family can retract predictions.  [CS3: evidence unchanged]
```

## Appendix B: Type construction

A declaration states the relation. A generic constructor derives its conclusion from the declared premises. For example, recording a reading R preserves its answer through the actual fact projection:

```swift
enum AcquiredAnswerFollows<R: PredicateReading>: Null
where R.Left: Structure {
    typealias Left = AcquireAnswer<R>.Right.Answer
    typealias Right = R.Answer
}
```

The caller supplies the reading and its structural source. Equality of the two answers follows through the recorded fact. This construction needs no value, method or runtime gate. The complete constructors are in `Sources/Examples/Acquisition.swift`. Their meaning depends on the stated reading relation and representation, not on the outcome of a separate experiment.

## Topics

### Related type declarations

- ``CandidatesOnlyLeave``
- ``Universality``
- ``OrderIsOnlyFreedom``
