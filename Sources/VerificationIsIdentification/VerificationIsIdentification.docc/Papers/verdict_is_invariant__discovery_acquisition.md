# Verdict Is Invariant (Correspondence) — Discovery acquisition

This part contains the original derivations for discovery acquisition.

Family and original section headings: <doc:verdict_is_invariant>.

Section setting: <doc:verdict_is_invariant#6h-A-distinguishing-question-is-not-yet-a-discovery-procedure>.

## Detail: §6h. A distinguishing question is not yet a discovery procedure

VC24 measures how much a sufficient predictive record would need to retain. It does not establish that an agent can acquire that record by one sequence of interventions. The following finite game makes this extra obligation explicit. A known table gives a finite carrier K, current observation E and total operations. The initial state is unknown. After reading E, the experimenter chooses an operation and reads E again. There is one evolving specimen, with no reset or fresh copy. The goal is to identify its original state, not just its final one. A physical realization must include the controller and its recording resources within Ω. The table alone does not certify that realization.

### VC25

**VC25 (A missing distinction has a bounded question witness).** Write N=|K| and k=|E(K)|. If two states have different future behavior, some operation word of length at most N−k distinguishes them.

*Proof.* Refine the partition of E by the observations after every word of length at most r. A new round compares E and the previous classes of every one-step successor. Equality of consecutive partitions implies stability under all operations, hence equality of every future answer by induction. Each strict round adds a class. Starting with k classes permits at most N−k strict rounds. Every pair separated at the limit was therefore separated by a word of at most that length. The empty word counts as the current reading.

The ordered-pair graph has finitely many vertices. A shortest path from (x,y) to a pair with unequal observations has no repeated vertex, since removing a repeated segment shortens it. Its operation labels therefore give a shortest separating word. This pair-specific witness need not provide one procedure that succeeds from every possible initial state.

### VC26

**VC26 (Pairwise distinguishability need not give one successful experiment).** Let E(A)=E(B)=E(C)=quiet and E(signal)=signal. Give the reduced system this table:

| Initial state | ask_A | ask_B |
|---|---|---|
| A | signal | A |
| B | A | signal |
| C | A | A |
| signal | A | A |

Every pair is distinguishable. The current reading separates signal from the others. ask_A separates A from B and C, and ask_B separates B from C. Thus the behavioral quotient has four classes.

Nevertheless there is no guaranteed identification strategy for the initial quiet class {A,B,C}. If its first operation is ask_A, initial B and C both become A with the same observed history. If it is ask_B, initial A and C both become A with the same history. No later deterministic operation can separate origins whose current states and available records coincide. Neither possible first action permits success for every initial state. Stopping before an action also fails on that class.

The quantifier difference is exact: `for every pair, some word` does not imply `one observation-dependent strategy for every initial state`. This belongs to the established problem of [adaptive distinguishing sequences](https://arxiv.org/abs/1902.01139). The VI contribution here is the explicit boundary on what a future-sufficiency certificate licenses, with a concrete refused discovery claim. Current-state convergence can still be achieved by merging candidates, but that does not identify the original state.

This does not refute the original fixed-target COMPARE game, where structural comparison need not disturb its target. VC26 concerns the dynamic extension with interventions on one evolving specimen. Reset, repeatable preparation or a fresh specimen changes the experiment and needs its own witness.

### VC26a

**VC26a (A symplectic comparison record is mutual).** In the abstract game a reversible comparison can leave its target unchanged: the permutation (x,y)↦(x,y⊕f(x)) is invertible for every initial y and does not change x. A finite-dimensional nondegenerate symplectic implementation restricts this. Let the whole be a symplectic product of two parts: the recorder M together with every memory, clock or controller it uses, and the target C. Let the comparison be a symplectic map Φ(m,c)=(F(m,c),ψ(m,c)) on an open product. At each point, D_cF=0 if and only if D_mψ=0: local differential dependence is mutual. On connected open factors, this also gives equivalence of global independence for the entire map ([UT80](../../../../Research/2026-10-10-use-leaves-a-trace.md)). A physical record of the target that leaves the target independent of the recorder therefore requires a failed hypothesis, for example a recorder prepared on a closed layer, a disconnected class of targets, a degenerate description, another comparison contract or non-symplectic dynamics. The statement concerns two complementary parts of the whole. It does not assert reciprocity between smaller subsystems.

### VC27

**VC27 (Finite reversible operations preserve the possibility of discovery).** If every available operation is a permutation of finite K, there is one preset word whose complete observation trace distinguishes all behavioral classes. If the behavioral quotient has m classes, a word of length at most `(m−k)(N−k)` suffices.

*Proof.* Each operation induces a permutation on the behavioral quotient: the quotient is stable, and VC20 makes its finite induced map bijective. Start with current observations. If two different original behavioral classes still have identical traces, their current classes remain different after any word already executed. VC25 supplies a word of at most N−k operations that separates those current states. Append it to the experiment. The new trace separates at least one previously unresolved pair and cannot remove any distinction already recorded. There are initially k trace classes and at most m to reach, so at most m−k such extensions suffice. The construction uses the known model to choose a fixed concatenated word, without knowing the actual starting state.

This preserves whole behavioral distinctions, which is the part of physical reversibility needed here. Finite permutations are a sufficient condition, not a necessary condition for a particular successful experiment. Keeping the whole state injective while allowing its inaccessible history to grow is a different condition and does not establish this result, as VC29 shows.

Replace ask_A in VC26 by exchange of A and signal, and ask_B by exchange of B and signal, leaving the other states fixed. Then the word ask_A, ask_B works. The traces for initially quiet A, B and C are respectively (quiet,signal,quiet), (quiet,quiet,signal), and (quiet,quiet,quiet). The initially visible signal is already identified. Swift computes the two post-action answers from the declared table through `TwoQuestionTrace<S>`.

### VC28

**VC28 (A finite discovery policy has a checkable success or obstruction certificate).** After a common observed history, a belief is the set of possible current states, with their distinct initial identities tracked. If an operation merges two candidates in that belief, a guaranteed original-state identification strategy cannot use it: those candidates have the same next observation and can never be separated within this model. If the operation is injective on the belief, partition its successors by the next observation.

A singleton belief succeeds. A larger belief succeeds if some injective operation has successful successor beliefs on every possible observation. The least fixed point of this rule is exactly the beliefs admitting a finite successful policy: induction on policy height proves both directions. There are finitely many nonempty beliefs, so this fixed-point iteration terminates. Each belief shares a common current observation. An empty candidate set is not a successful identification.

A positive certificate gives each successful belief a rank and an action, with all successor ranks strictly smaller, ending in singletons. A negative certificate gives a family of nonsingleton losing beliefs such that every action either merges candidates or has an outcome still in that family. An attempted finite successful tree starting in this family must have a branch remaining in it at every level, contradicting a successful leaf. These local obligations can be checked without trusting the synthesis loop. This is a finite deterministic guarantee. No noisy, probabilistic or reset experiment is silently included.

### VC29

**VC29 (A closed history can retain what its current scene cannot reveal).** For any deterministic T on K, take whole states to be nonempty finite histories h over K and define `F(h) = h followed by T(last(h))`. F is injective: removing the last entry recovers the entire previous h. Its current-scene observation satisfies `last(F(h)) = T(last(h))`, even if T is many-to-one. F is not onto: a one-entry history has no predecessor. Thus no information loss in the whole does not by itself establish a bijective dynamics on its full carrier. The image is finite when K is finite, but VC20's onto premise fails for F.

There need be no external program or clock. Let the whole be `(p,h)`, where p is a retained nonempty finite program of operation names. Its next action is `p[(length(h)−1) mod length(p)]`. Append the specified successor to h and retain p. The new whole determines the old whole by removing the last history entry. Both instruction storage and the step index are internal. This fixed autonomous rule describes any of the finite programs as different initial configurations, rather than importing a controller from outside Ω.

The trap model can therefore have an information-preserving history extension. After ask_A, B and C have different whole records but the same current scene. With read access only to that scene and the original operation vocabulary, its discovery obstruction remains. Granting history access changes the model and can remove the obstruction. Retention, accessibility and controllability must each have their own witness.

`RecordedFirstQuestion<S>: Permanent` stores the prior source and its computed next state. The generic Swift checks recover both the old source and the new current state. A separate refusal rejects identification of the B and C whole records after their current scenes have merged. This models finite records of unbounded possible length. It does not supply fixed memory capacity, physical unitarity or a derived thermodynamic arrow. The append law already selects an orientation and rules out predecessors at its boundary.

Both examples need three residual labels for predictive sufficiency inside their quiet class, yet their discoverability differs. Record size, pairwise distinction and a guaranteed single-specimen procedure are separate properties.

These results suggest a stronger development rule for VI: a proposed knowledge claim should state what would distinguish its remaining candidates, whether the required experiment preserves those distinctions until they are read, and what internal record makes that preservation checkable. Discoverability is an additional property of a question and an intervention protocol.

## Detail: §6i. Discovery of a verdict about an original state

VC28 requires original-state identification. VI2 and VC2 allow an exact answer without identifying its source. The distinction persists when observations require interventions. Fix a target map q on the original states of the known finite model. The experiment must return q(x_original), which need not equal q(x_current) after an intervention.

### VC30

**VC30 (Question-preserving beliefs).** Represent uncertainty after an observed history by a set of pairs `(current state, required original answer)`. Initially these are `(x,q(x))`, grouped by the current observation. An operation T maps `(x,a)` to `(T(x),a)`, then its observed result selects a branch. The answer label is transported, not recomputed. Duplicate pairs can be identified.

A belief with one answer label is sufficient, even if it contains several possible states or origins. A belief containing `(x,a)` and `(x,b)` for a≠b is an obstruction: future observations and operations on x are identical, while the required answers differ. Merging origins is therefore permitted precisely when no different required answers are collapsed into the same current state on that branch. This condition prevents immediate information loss for q. It alone does not guarantee that a later successful experiment exists.

*Proof.* The initial pairs state the target question. Each intervention changes only the current coordinate, so induction on a trace preserves the original answer attached to every surviving origin. A single answer is consequently correct for every remaining candidate. Two differently labeled instances of the same current state have identical future responses under every chosen operation, including choices made from those responses. No such experiment can guarantee the two different required answers. This is relative to the declared observations and operations, with no added history access or reset.

### VC31

**VC31 (Guaranteed verdict discovery).** On these finite labeled beliefs, mark single-answer beliefs successful. A nonterminal belief succeeds when some operation has successful children for every possible next observation. The least fixed point is exactly the beliefs admitting a finite guaranteed policy for q. Beliefs with a conflicting pair at one current state are unsuccessful.

*Proof.* Induct on finite policy height in one direction and on the iteration at which a belief is marked successful in the other. There are finitely many subsets of `K × q(K)`, so the iteration terminates. Rank-decreasing success certificates and closed losing families validate the result as in VC28, now using single-answer leaves instead of singleton-state leaves.

If q assigns a distinct answer to every original state, this specializes to original-state identification. If q is constant, no intervention is needed. Both conclusions follow directly from the terminal condition. Only beliefs reachable from the declared initial observation matter for its policy.

**An unfolded certificate needs no independent rank.** For a nonempty initial belief B, supply a finite tree with the following two constructors. A leaf returns a and requires every pair in its belief to have required answer a. An internal node specifies one admitted operation T and has exactly one child for every possible next observation o. That child's belief must equal

```
B_o = {(T(s), a) : (s, a) ∈ B and E(T(s)) = o}.
```

Only nonempty B_o occur in this exact form. Together the children cover every successor of B, and the displayed equality forbids dropping a difficult candidate, moving it to another observation, or recomputing its required original answer. The root beliefs are computed from the independent target q on the declared initial domain. The answer labels annotate possibilities for the verifier. They are not available inputs to the experimenter.

Exact belief reconstruction is sufficient, but soundness needs only coverage. A child may carry a finite overapproximation C_o with B_o ⊆ C_o, provided its certificate succeeds for every member of C_o and every possible actual observation has a child. Extra candidates can prevent a certificate from succeeding, but cannot make it return a wrong answer for an included actual candidate. The same applies to a root containing all declared initial pairs. This can avoid filtering a canonical successor set during certificate construction. The inclusion must preserve each actual pair's required answer. Replacing its answer label is not an overapproximation.

Each node is reached through its observation history. One action at that node therefore serves every candidate still compatible with the same history. It cannot depend on which hidden candidate is actual. The action must name an admitted operation of the model. In a resident realization its occurrence and source also need the relation supplied by `SelectedResidentTraceExtension`. A shared output question alone does not select that occurrence.

Soundness follows by induction on the supplied finite tree. An actual candidate belongs to the child selected by its next observation, with its original answer unchanged. At a leaf the common answer is therefore correct. Every branch ends because it enters a proper subtree. Conversely, a finite guaranteed policy unfolds into such a tree by attaching the beliefs computed along its histories. Assigning height to each subtree recovers the earlier rank certificate. A finite rank-decreasing graph can in turn be unfolded into a finite tree, possibly duplicating shared subproofs. Thus a separate numerical rank is unnecessary for the unfolded representation. Finiteness here is a property of the supplied constructor expression, not a consequence of arbitrary recursive `Pair` conformance.

This states the mathematical certificate independently of a search implementation. The Swift corpus checks transition traces and original-answer transport in `Discovery.swift`, actual reading selection in `ResidentExperiment.swift`, and source coverage with common answers through `CheckedCoverage`. A successful policy can return different answers in different children, whereas `CoveredJoin` certifies one common answer over its joined support. Those are different coverage obligations.

**Static successor coverage for one binary node.** `CoverDiscoverySuccessor` now binds a selected parent row `(s, a)` to its actual successor row `(T(s), a)` in the child support keyed by `E(T(s))`. The action is a path into the state's declared two-action table. Its path remains the same at every seam of the supplied `SequentialReading` composition, so different hidden parents cannot choose different actions, even when those actions happen to yield equal successor states. The quiet and signal child supports also remain fixed. Their distinct keys give one support per observable branch.

Each step removes one parent occurrence from the remaining proof obligations, using `CandidateRemoval`, while selecting membership in a child support without consuming that child occurrence. Thus several parents may reach the same child row. `CoveredDiscoverySuccessors` matches the independently declared parent support and requires an `EmptyCandidateSupport` remainder. For finite compositions of these steps and the existing finite selection constructors, induction on the composition proves that every declared parent has a covered actual successor with its original answer unchanged. This traversal discharges verification obligations. It is not an experiment performed separately on all possible origins, or a deletion of those origins from the physical whole. Endpoint equations on an arbitrary open `PredicateReading` do not establish this constructor interpretation.

**The empty remainder must preserve the distinction between a leaf and its payload.** The former `EmptyCandidateSupport` required only that both child types conform again. Since `CandidateLeaf<Never>` has two Never fields, adding a conformance for leaves with empty payloads was accepted. This supplied a concrete false completion: start with two addressed `CandidateLeaf<Never>` vertices, use the actual `AllocateIceVertex` constructor to allocate only the first, and pass the result to `AllocatedIcePorts`. The remaining second leaf was accepted as empty. This finite support and actual allocation step exposed a missing constraint in the emptiness condition.

`CandidateNode` now binds an associated `Leaf` in the original constructor conformance. A `CandidateLeaf<X>` supplies itself. A `CandidateFork` and Never supply Never at their root. `EmptyCandidateSupport` requires `Leaf == Never` as well as empty children. Thus a genuine leaf cannot become empty even when X is Never. A later local alias cannot replace the original associated-type witness used through the `CandidateNode` constraint. A default property on the empty protocol alone was insufficient: a constrained extension could shadow that alias. The tests separately exercise both alias shadowing and attempted conformance-witness replacement.

The resulting exclusion does not need finite depth. Along any finite child path from an empty support, each reached node still conforms to `EmptyCandidateSupport`. Its bound Leaf is therefore Never. Reaching a genuine `CandidateLeaf<X>` would require that nominal leaf type to equal Never, contradicting the constructor distinction. This is an induction on the inspected path, not on the depth of the entire graph. `LeaflessSupportCycle` consequently remains admissible: its two children return to itself and it contains no leaf on any finite path. It proves no terminal, finite unfolding or completed traversal.

For a finite declared support and a finite sequence of the actual removal constructors, this exclusion prevents completion with any leaf remaining. Both empty-payload occurrences must be removed, while their addresses and allocated ports remain distinct. `Checks/IceCoverage.swift` verifies the complete two-step allocation and refuses the false empty conformance, two alias overrides and a cycle containing a real leaf. These restrictions also protect Discovery's empty remainder. They do not turn arbitrary `CandidateRemoval` or `PredicateReading` endpoint claims into executions of the stipulated constructor rules. That source-binding obligation remains, including the direct checks in `FirstDiscoveryDecision` below.

`DiscoveryCoveredNode` instantiates the trap's first action for the question whether the origin was A. Parents B and C both use the same quiet child row `(A, no)`. The quiet support also includes an unused `(B, no)` row, demonstrating sound overapproximation. Its two terminal tags agree through `CheckedCoverage`. The signal support's terminal tag is yes. Separate compiler refusals reject an uncovered parent, a changed original answer, a wrong successor, a wrong observation branch, and a hidden-origin-dependent action. The common-answer proof is needed within each terminal support, not across the two branches.

`DiscoveryTerminalSupport` derives a terminal answer directly from the rows: a leaf supplies its original-answer field, and a fork conforms when both derived answers coincide. Induction on the finite support therefore gives the common answer without accepting an unrelated terminal reading as evidence. `AnsweredDiscoveryNode` uses these very supports in its successor-coverage equations and produces the selected action address together with the quiet/signal answer table. Its two answers need not coincide. Swapping the terminal supports breaks the coverage seam, and adding a conflicting target prevents the terminal conformance.

The two clauses `ReadQuietDiscoveryAnswer` and `ReadSignalDiscoveryAnswer` receive only an observation and this prepared table. `DiscoveryObservedAnswersMeetOriginalQuestion` composes the certified action's actual table transition, the next-state observation, and the matching decoder for each declared origin. All three outputs equal their original target fields. A signal decoder after an actual quiet observation fails the composition equation. The verifier uses target annotations to certify a table that works for every candidate. The resulting decoder does not receive an annotation identifying the actual origin.

**Adversarial admission and a direct finite check.** The open interfaces permit a positive forgery: `ForgedDiscoveryCompletion` declares the input with all parents and the output with an empty remainder, while assigning no to the signal branch. `AnsweredDiscoveryNode` accepts these endpoints. Its actual signal decoder then returns no where the independently declared original A row requires yes. The positive zero/successor witness establishes that difference. This does not make Swift derive an equality between distinct answers. It shows that endpoint admission cannot certify the claimed traversal of the constructor grammar. A new freely conformable proof marker would leave the same gap.

`FirstDiscoveryDecision` instead checks the existing three-row consumer directly. The first actual successor observation must be signal and the other two quiet. Their original target fields therefore determine the two table entries, and the latter two targets must agree. The proposed node must name these exact parent rows, the first-action address and this derived table. These are equations on the source and proposed output, with no supplied coverage or terminal witness used as authority. They are necessary and sufficient for that table in this explicit observation pattern. A bare correct table passes without any coverage story. The forged table fails, as do conflicting quiet targets and a substituted source pattern.

The execution check also binds the selected successor directly to the state's first table field. A freely declared `CandidateRemoval` can otherwise carry the right source and action address while naming a different successor. That forged selection now fails at the actual transition seam. Only the three current rows and their first successors enter this direct proof. Their state descriptions may have cyclic continuations: finiteness of the whole or of the unfolded transition graph is unnecessary. The original finite coverage constructions remain useful expressions whose soundness has the stated inductive interpretation. They are no longer the sole basis for admission of this concrete consumer.

This closes a one-action decision on that three-row source pattern with two nonempty observation branches. It does not seal public protocols or supply a checker for every finite policy tree. The table and its decoder clauses are prepared symbolic components, not an account of their physical manufacture. An arbitrary finite tree still needs nonterminal child composition and observation-history control, including unreachable branches if empty supports are represented. Initial target correctness and the interpretation of the declared transition table remain premises. The reduced observation path does not assert reversibility of the whole. VC29 and the resident acquisition relations address retention separately.

`SameActualReadingLeavesDifferentRequiredAnswers` checks identical actual readings after the first trap intervention while a zero/successor witness separates the required original answers. A refusal attempts to compose that available reading with a projection of the verifier's candidate answer tag. Its decoder expects the annotated candidate, not the actual observation, so the input equation fails. This checks a concrete obstruction to answer leakage. It is not a general policy-tree certificate.

In the trap of VC26, take q(A)=yes and q(B)=q(C)=q(signal)=no. Following a quiet initial reading, ask_A gives signal only for original A. Original B and C both become current A with observation quiet and original answer no. Their merger is harmless for this question. Returning q(current A)=yes instead would answer the wrong question. The initial signal is handled immediately by its distinct initial observation.

By contrast, asking whether the original state was C cannot be guaranteed in that same experiment model: ask_A merges B with C and ask_B merges A with C, collapsing different required answers whichever first intervention is chosen. Thus discoverability belongs to the pair of a question and a protocol. It is not a yes-or-no property of the source table alone.

`AdvanceQuestionTag<C>` transports an answer tag with the evolving source. Preservation of the tag follows by projection. Its initial correctness remains a premise. A candidate tag is not an answer already accessible to the experimenter. Substituting a current-state answer for a different retained original-answer tag violates this relation.

A terminal belief may contain distinct source histories whose original-question labels all equal no. It then determines that verdict without determining the original source. Combining equal belief pairs reduces the question-specific record while their distinct origins remain in the whole. A realization retaining those origins is supplied by VC29.

## Detail: §6j. The experimenter is part of the experiment

A certificate writer may know a table and its target question without knowing the actual original state. That distinction must survive implementation. An original-answer annotation is a proof object, not a sensor reading.

### VC32

**VC32 (A successful verdict policy compiles to observation-only control).** Given the finite model of VC31 and a verified successful certificate, construct a finite controller with a prepared boot state and one memory state for each belief reached under the selected policy. Its boot transition reads E(x). Each active memory state names one action. After that action, the next E(x) selects the next memory state. Each terminal memory state names one answer. Neither q(original) nor the actual original state is a controller input.

*Proof.* Initially E(x) chooses exactly its certified root belief. Inductively, the stored memory names the belief obtained from the same observed history. The action is fixed by that memory. Grouping its successors by observation gives one branch for each possible reading, so the branch update requires only that reading. Certificate ranks decrease until a terminal memory is reached. Its answer agrees with every original candidate, hence with the actual one. The belief labels and ranks justify the construction but need not be present in the executable table. One boot step plus the maximum root rank bounds the number of joint steps until an answer. This is a sufficient memory construction, not a minimum-size controller theorem.

The resulting scene/controller pair has a single autonomous transition F: boot acquires a reading, an active controller chooses and records a branch, and a terminal controller keeps its answer. The fixed controller table is part of this machine's transition law. It can equivalently be carried as an unchanged program coordinate. No external sequence of choices is supplied during execution. Preparing that table and boot state remains a premise. This closes the control loop, but it does not establish that F is injective.

### VC33

**VC33 (Reversible branches do not imply reversible feedback).** Let s(E(x)) choose an operation, and let every T_a be a permutation of K. Put D_a={x:s(E(x))=a}. The feedback map F(x)=T_s(E(x))(x) is injective exactly when the sets T_a(D_a) for distinct selected actions are pairwise disjoint.

*Proof.* Inside one branch, injectivity follows from T_a. Across branches it holds exactly when the output images do not intersect. For K={0,1}, let the reading reveal x, choose identity at 0 and bit-flip at 1. Both branches are permutations, but both selected outputs are 0. The selected branch label restores injectivity of the prepared-slice encoding `x → (s(E(x)),T_s(E(x))(x))`: equal labels select the same invertible map. For a controller with existing memory, its overwritten distinctions must also be accounted for. Merely retaining the latest action is not a general proof that the entire joint transition is invertible.

This is the familiar requirement that inverse branches have distinguishable ranges. Bennett states the corresponding condition for reversible machines and constructs computations that retain intermediate information before recovering prepared workspace. No priority over that result is claimed. [Bennett, 1973](https://www.cs.princeton.edu/courses/archive/fall06/cos576/papers/bennett73.html).

### VC34

**VC34 (A prepared finite experiment has a finite reversible completion).** Let z=(x,m) be the joint configuration of VC32. Fix H at least the bound on completion, padding finished controller states with identity steps. For each original x, form the prefixes h_t=(z_0,...,z_t), 0≤t≤H, of the deterministic run beginning at z_0=(x,boot). Define the whole carrier to contain these prefixes, and define U(h_t)=h_(t+1) for t<H and U(h_H)=h_0. Then U is a permutation of |K|(H+1) whole states. During the first H steps, the last-configuration projection follows the autonomous experiment exactly.

*Proof.* Prefixes from distinct originals differ at their first configuration. Prefixes on one run differ in length. Each run therefore forms a disjoint cycle of H+1 states. Its unique predecessor is obtained by shortening a noninitial prefix or by taking the last prefix at the initial phase. History length supplies an internal phase. Mergers of current scenes or controller memories cannot merge these whole states.

The closing step is an abstract recovery transition of the whole after the promised window. It need not belong to the agent's allowed scene operations, and the agent is not granted access to hidden history. The construction assumes prepared memory and sufficient finite capacity. It gives no locality, energy or efficient implementation bound. It does not preserve an unbounded number of distinct historical occurrences or an ever-growing archive.

There is a matching limit. If R is a forward-invariant set of a finite permutation, U(R)⊆R implies U(R)=R, hence U⁻¹(R)=R. No state outside R can enter it. Thus an initially unready finite reversible whole cannot acquire a readiness property that is then maintained forever. A finite readout window is compatible with reversibility. Newly acquired absorbing readiness requires changing at least one of those assumptions. Terminal self-loops in the reduced controller do not prove permanent storage in the whole.

`RecordedControllerStep` requires both actual input coordinates. Its retained whole then recovers the prior configuration and both updated projections. Observation-only access requires the controller's separate factorization through its observation and memory. Preservation of the whole alone does not supply that factorization.

## Detail: §6k. A certificate's scope under composition

### VC35

**VC35 (Reuse must preserve the certified input scope).** Let D⊆X be the certified input set and f,g:X→Y total components. Their agreement on D survives a common deterministic suffix k:Y→Z, since equal outputs give equal k-outputs. A prelude h:X→X is different. If Y has at least two values, agreement on D implies agreement of f∘h and g∘h on D for every such pair f,g exactly when h(D)⊆D.

*Proof.* If h maps D into D, substitute its output into the given equality. If some x∈D has h(x) outside D, choose f and g equal on D and different only at h(x). Then the composed outputs differ at x. This proves the universal criterion. A restricted hypothesis family can support additional inferences, as System CS3 illustrates. QED

For admissible preludes H, let R be the least H-closed input set containing D. Equivalently, R is the union of w(D) over all finite H-words, including identity. Agreement f|R=g|R is exactly safe replacement after every such prelude from D when the component output itself is observed. Sufficiency is substitution. For necessity, every r∈R is some w(x), so a difference at r appears in that context. This is the input-scope form of VC15, not a new claim that sample equality is an unrestricted program congruence.

The suffix here reads only the component output. Effects, timing or direct inspection of implementation identity require their own state and observation axes. For multiple substituted occurrences, R must also cover the operations feeding each occurrence. Proving agreement on R need not mean measuring every point independently: a sound structural argument can supply it. Adding an allowed context can enlarge R. The old certificate remains true on its old scope but does not automatically prove the enlarged statement. A valid global R4 identification is not contradicted by this boundary.

*Closed counterexample.* On X={0,1,2}, f is identity, g swaps 1 and 2, and h swaps 0 and 1. At D={0}, f(0)=g(0)=0. After h, their outputs are 1 and 2. With H={g}, R={0}. Adding h gives R=X. All these operations are permutations. In the complete 36-state construction, Ω also contains the resident f/g choice, the bare/prelude mode and phase 0…2. Phase 0 optionally applies h, phase 1 applies the chosen component, and phase 2 wraps. The inverse reverses the phase's chosen permutation.

With value prepared at zero and a uniform f/g choice, whole entropy remains one bit. The bare ready output carries zero information about that choice, while the prelude mode's output carries one bit. The changed experiment reveals an internal distinction, without anything entering Ω. Readiness is a finite window, and these tables give no physical energy or hardware bound.

`PostPairAgreement` derives a verdict after the specified output-pair context. Agreement about the first table reading does not imply agreement about the second reading or the whole table. Arbitrary effects and higher-order contexts require their own compatibility relations.

Program congruence is established semantics. See [Software Foundations, Behavioral Equivalence Is a Congruence](https://www.cs.cornell.edu/courses/cs4160/2019sp/terse/plf/Equiv.html). The specific finite scope argument is given above. No priority for contextual equivalence is claimed.

## Detail: §6l. One question across different representation codes

The earlier certificates compare readings in a common declared encoding. Transmission can change the representation code itself. A wire pair (h,x) and a native pair (x,h) can preserve one payload question without being the same record, and projecting the payload x need not retain h.

### VC36

**VC36 (Compatible factorizations compose across codes).** Let A, B and C be representation carriers with total questions q_A, q_B and q_C into one answer set. Let t:A→B and s:B→C be total maps. Suppose

    q_B(t(a)) = q_A(a) for every a∈D_A,
    q_C(s(b)) = q_B(b) for every b∈D_B,
    t(D_A) ⊆ D_B.

Then q_C(s(t(a)))=q_A(a) for every a∈D_A.

*Proof.* For such a, t(a) belongs to the second certificate's domain. Substitute b=t(a) in its equation and then use the first equation. Iteration proves the result for every finite compatible path. Identity is the empty path. Neither injectivity of t nor recovery of all of a is required. QED

The shared middle question must have the same interpretation in both equations. Agreement of its name or of one observed answer is insufficient. Also, individual correctness of the equations does not imply domain coverage. For A=B=C={0,1}, let all questions be identity, t be identity, and s be constant zero. The first certificate is valid on D_A={1}, the second on D_B={0}, yet their proposed composition on D_A gives the wrong answer. This is VC35's scope boundary applied to a representation path.

No new lattice protocol is needed for the construction. `AddressedRepresentation` retains both a code and its data as distinct input addresses. `AddressedReading<R>` embeds a supplied R in one tagged representation grammar: its input is `AddressedRepresentation<R.Encoding,R.Left>`, its answer and semantic question are R's, and its encoding is `TransportEnvelope`. The original encoding is therefore retained in the input, not discarded by the common envelope. Within the specified native, wire and scalar constructors, this is a disjoint tagged domain with a defined decoder for each code. An arbitrary supplied `PredicateReading` still needs its own semantic justification.

`JoinedFactorization<F,G>` conforms to `ReadingFactors` from the two existing factorizations with the sole added premise `F.Right == G.Left`. It joins the observations using `SequentialReading`. Equality of the outer answers follows through the shared actual reading. Source, destination, model, encoding and question addresses follow through the same seam. No final answer equality is requested from its caller. `IdentityFactorization` supplies the empty path. These generic bodies certify every finite path constructed this way.

Exact identity of the intermediate reading is a sufficient witness and is stronger than semantic equivalence of two independently described readings. The construction does not claim that nominal identity is the only possible proof of a valid handoff. Supplying a justified equivalence would require another witness. ReadingFactors' equations alone do not enumerate all sources or prove the physical accuracy of a declared decoder.

The concrete generic path is

    (NativeLayout, (x,h)) → (WireLayout, (h,x)) → (ScalarLayout, x).

NativePayload reads the left coordinate, WirePayload the right, and ScalarPayload its whole input. `LayoutFactorization` and `PayloadFactorization` prove the same payload answer by expanding these projections for every permitted pair. `Checks/Transport.swift` joins them, checks the outer endpoints and retains the source code. Independent refusals change an input or output code, output data, question, model, decoder, or intermediate source, and reject promotion of payload agreement to source identity or hidden-field recovery. Two different sources with the same payload give the same final image by a generic witness, so full identification is unnecessary for this transfer.

### VC37

**VC37 (A closed realization and the limit of end-to-end agreement).** A finite whole can realize that path on a prepared slice while retaining all source distinctions. Its complete state is (x,h,u,v,z,c), with five bits and an internal phase c∈{0,1,2}. The native source is (x,h), the wire buffers are (u,v), and the receiver buffer is z. At phase zero XOR (h,x) into (u,v). At phase one XOR v into z. Phase two changes no bit. Each step advances c modulo three. This is a permutation of all 96 complete states: decrement the phase and repeat its XOR to invert the step.

Prepare u=v=z=0 at phase zero. The next wire is (h,x), and the next receiver value is x. Source and wire remain inside the whole. All four prepared source alternatives have different ready whole states, while the receiver's two values cannot recover h. Thus a local lossy representation map can be implemented within globally reversible dynamics under explicit preparation. The model has no external clock, random tape or discarded residual. Readiness is a phase window, without an endless supply of freshly blank buffers.

For arbitrary initial buffers, the next wire is (u⊕h,v⊕x) and the final receiver is z⊕v⊕x. Under the fixed wire question that reads its second bit, the intermediate payload is correct exactly when v=0. The final payload is correct exactly when z=v. For v=z=1 the intermediate answer is wrong and the final answer is right. Of 32 phase-zero states, eight exhibit this cancellation. This establishes a strict distinction between end-to-end correctness and the proposed factorization into locally preserving steps. A direct certificate on this alternative preparation can be valid, while certifying each intermediate reading under the original interpretation fails. Changing the wire decoder to complement its bit would change that contract.

Matter M72 gives the complementary implication. An established endpoint recovery through a specified composition supplies an adequate middle decoder by composing the remaining process with the final decoder. `RecoveryBeforeSuffix` constructs this relation at the actual seam. That derived decoder can differ from the wire reading just tested. Endpoint recovery therefore forces sufficiency of a complete intermediate interface, while leaving the proposed local interpretation open to failure.

This supplies a limited bridge to The Cut. All participating records and their transitions can remain internal to one whole while occupying different relational roles. A transfer certificate preserves a stated question through those roles. The existence of an interaction does not establish that it preserves that question. The finite construction is not a physical law, a proof of every proposed history commitment, or a hardware cost claim.

The general composition proof is substitution. The representation codes and projection semantics are supplied by the constructors.

## Detail: §6m. Saturation with a reason for every new distinction

VC15 defines the coarsest behavior-preserving quotient. A final partition alone does not explain why its distinctions are required. The certificate in this section supplies both directions: each added distinction is a future reading, and the resulting representation supports every declared operation.

### VC38

**VC38 (Certified least autonomous refinement).** Fix a nonempty finite K, a total reading E and a finite vocabulary O of total maps K→K. Start with the single feature E, represented by the empty operation word. Maintain a finite list of features E∘w_i, with words executed from left to right, and let F be their joint reading. If F(x)=F(y) but F(Tx)≠F(Ty) for some T∈O, choose a current feature E∘w_i that distinguishes those successors. Add the feature obtained by executing T and then w_i before reading E. Stop when every T preserves equality of F-images.

This procedure terminates after at most |K|−|E(K)| additions. Its final kernel is exactly the behavioral equivalence of VC15, and its image carries well-defined operations. It is therefore the coarsest autonomous refinement of E, up to a change of class names.

*Proof.* The new feature distinguishes the selected pair, so each addition strictly increases the number of classes. Every feature is a permitted future reading of E, so behaviorally equivalent states are never split. At termination, equal F-images have equal successor F-images under every operation. They also have equal E-readings, since E remains a feature. Induction on finite words therefore shows that equal F-images give equal answers to every future E-question. The two inclusions identify the final kernel. There are at most |K| classes, proving the bound. Each new word prefixes one earlier word, so its length is at most the number of additions. QED

Minimality is relative to the original reading and vocabulary. If an existing record must be retained, include it in E. The result minimizes distinctions among autonomous refinements of that E. It does not minimize feature count, sensor cost, execution time or physical memory. Different valid witness choices can produce different feature lists with the same final partition.

A refinement witness contains a pair, an operation and a previously admitted suffix word. The pair agrees under the old features and differs under the prefixed future reading. The final equivalence is exactly the common kernel of the admitted features. Thus every retained distinction has an observation witness. Together with the observation equation and one commuting equation per operation, this yields preservation for every finite word by induction. Extra distinctions and missing closure fail different premises. The transition system and its interpretation remain explicit inputs.

This is established finite-state semantics. The [Cornell account of DFA minimization](https://www.cs.cornell.edu/courses/cs4120/2026sp/notes/leximpl/#dfa-minimization) explains how distinguishing suffixes propagate backward through transitions. Here the initial reading may have more than two answers, and the certificate retains a reason for each refinement. No new minimization theorem is claimed.

Interference Is Substitution IiS19 supplies a finite-dimensional linear case with an infinite state carrier. Backward closure of quantum effects stabilizes by a dimension bound. Each added direction has two valid states that agree on the old space and differ on a permitted future reading. Instrument branches retain history probabilities, so averaging away their outputs does not certify the larger family of outcome-dependent continuations.

### VC39

**VC39 (Separate saturation need not cover mixed continuations).** Completing one reading separately under O_1 and O_2, then combining the two completed images, need not give an autonomous image under O_1∪O_2. The combined vocabulary also permits mixed words absent from either separate completion.

*Counterexample.* Let K consist of four bits (a,b,c,r), let E=a, let O_1 contain the swap of a,b, and let O_2 contain the swap of b,c. The first completion reads (a,b), and the second reads a. Their combined kernel still reads only (a,b). Executing swap_bc and then swap_ab makes the next alpha reading equal c. Thus (0,0,0,r) and (0,0,1,r) require separation despite agreeing under both separately completed descriptions. The combined completion reads (a,b,c): each coordinate is a future alpha reading, and both swaps update that triple from itself. The retained fourth coordinate r never affects an allowed future reading. There are eight classes of sixteen states, so the completion still does not identify the entire source. The restriction concerns the declared alpha question and its continuations. Adding a question that reads r changes the completion to sixteen classes. No claim that r is inaccessible to every possible internal interaction follows.

This does not contradict preservation under a union of operation sets when the same partition is already stable under each set. That common partition would be stable under their union. Here the two separately stable partitions are different, and the more detailed one fails closure under the other swap.

For a whole with a resident schedule, add an internal phase in {0,1,2}. Phase zero swaps b,c, phase one swaps a,b, and phase two changes no bit. Each step advances phase. This fixed permutation has 48 complete states, with r retained, and needs no outside action selector. Starting at phase zero, sources 0000 and 0010 give observation traces (phase,a) of `(0,0),(1,0),(2,0)` and `(0,0),(1,0),(2,1)`. The first two readings agree. The mixed continuation exposes c on the third. Saturation under this one whole transition yields 24 classes, retaining phase and a,b,c and ignoring r. The construction is a finite logical model, without a new physical clock law.

The Swift witness uses the existing BeamShape coordinates as symbolic a,b,c. `FullSpectrumReading` reads all three. `SpectrumFirstTransition` and `SpectrumSecondTransition` give commuting squares for the two swaps by computing source and image updates separately. `AppendSpectrumFirst` and `AppendSpectrumSecond` are scoped aliases of the existing `JoinedTransition`. They extend any matching certified path, supplying every finite interleaving without additional path wrappers. `SpectrumAlphaFactors` retains the original alpha question. Three generic equality witnesses show that each image coordinate is alpha after the empty word, swap_ab, or swap_bc followed by swap_ab. These are the two directions of the coordinate instance of VC38. This is not a physical conversion model for spectral lines or a proof that nominal BeamShape type identity equals coordinate equality.

The tool also reconstructs the entropy example of PiR M38–M40 automatically. It starts with four cells on eight whole states and adds one future reading: states 1 and 2 in the same clock phase give different readings after a tick. The result is exactly the six-cell autonomous refinement previously proved by hand. Splitting all eight states would be unnecessary, and a certificate claiming that extra refinement without distinguishing features is refused. PiR M41 separates this change of resolution from entropy change under time evolution at a fixed resolution.

**Sufficiency is not acquisition.** These features are functions of a state in the supplied model. Computing them from its full transition table does not give an internal observer those values on an unknown actual state. In `discovery_trap.json` the completed partition has four singleton classes, yet no allowed single-run policy identifies the initial state (VC26, VC28–VC31). Different distinguishing experiments cannot automatically be performed on the same unchanged specimen. A measurement strategy, retained memory, reset or reversible completion requires the separate constructions of §§6h–6j. The whole-system principle locates those resources internally, without supplying them by the act of naming a feature.

## Detail: §6n. Acquisition and reuse are type relations

A generic constructor supplies the related axes, and its body satisfies the conclusion under the stated premises. Recording, refinement and retained access are these relations themselves.

### VC40

**VC40 (A recorded question factors through its fact).** Given a declared reading R of source S, construct a fact containing only R's space, encoding, question and answer. The complete record pairs S with that fact. Its source projection recovers S, and its fact projection can answer the original question.

`RetainedReadingRecord` binds the stored fact to the actual reading and source. `RecordReading<R>` supplies this relation. The fact is `AnswerFact<Sigma,Encoding,Question,Answer>`, a sealed payload conforming to `HasVerdict`. Its generic arguments and associated types contain no original-source coordinate. It is not itself a `PredicateReading`: the question is not a substitute source. In particular, two two-input sources with equal first answers produce the same first-fact type even if their second fields differ. `EqualFirstFacts` checks that equality for arbitrary such source pairs.

`RecordedAnswerReading` reads the fact's answer and preserves its question and encoding. `ReadRecordedAnswer<F>` requires only F's `HasVerdict` axes; its actual source is the payload F. Reading that payload establishes what it contains. The link to an original source belongs to `RetainedReadingRecord` and `AcquiresAnswer`. `AcquireAnswer<R>` conforms to `AcquiresAnswer`, hence `ReadingFactors`, by constructing the record, its fact observation and the fact decoder. Its caller supplies R and the structural source bound, not equality of the direct and recorded answers. The compiler derives that equality by projection. This represents an internal acquisition relation with a retained whole, using pure types under Law §0′.

> Argues: ``RetainedReadingRecord`` needs ``Permanent``. The whole's source projection recovers the input beside the new fact.
> Argues: ``RecordedAnswerReading`` needs ``PredicateReading``. The fact is the actual decoder input, and its question and answer determine the reading's context and output.
> Argues: ``AcquiresAnswer`` needs ``ReadingFactors``. The record observation connects the direct source reading to the fact decoder.

### VC41

**VC41 (Evidence refinement preserves a decoded answer).** Suppose F factors a question q through an observation E. Suppose G factors E itself through a richer observation H: G.Left is exactly F.Observation. Then q factors through H. Its decoder first recovers E's image through G.Right and then applies F.Right.

`EvidenceRefinesQuestion` binds that complete seam. `AnswerOnRefinement<F,G>` constructs the composed decoder and conforms to `ReadingFactors` under the seam premise alone. `RefineAnswer<F,G>` supplies this constructor as the conclusion of `RefinementPreservesAnswer`. The result's direct question is F.Left, its observation is G.Observation, and its decoded answer equals F.Answer. No equality of final answers is requested from the caller. `JointEvidenceRetainsFirst` supplies a generic example: an additional reading of the same source extends the evidence while its first projection recovers the old reading.

> Argues: ``EvidenceRefinesQuestion`` needs ``/Notation/Pair``. Its sides are the earlier factorization and the recovery of that factorization's observation.
> Argues: ``RefinementPreservesAnswer`` needs ``EvidenceRefinesQuestion``. The recovery seam supplies the intermediate image required by the composed decoder.

This is a constructive scope rule. It supplies the decoder that justifies reuse under refined evidence. It does not assert that matching raw bytes prove compatibility or that every valid scope relation must have this particular representation. A different source, question or encoding cannot silently replace the stated seam.

Matter M55 uses the same composition to test a closed recovery chain. If its final observation is exactly its initial reading, the remaining legs construct the reverse of any chosen leg. Therefore an established strict gain cannot occur on that cycle. `RecoveryCycleDerivesReverse` checks the actual closing seam, and its positive repeated-evidence construction shows that different layouts can still have equal recoverable content. No new refinement principle is needed.

### VC42

**VC42 (A certified question is already readable from its evidence).** An `ObservationTrace` relates a source to its memory. `StartObservations<S>` uses the empty memory Never. `AppendObservation<T,R>` retains T's memory and adds R's source-free fact, with R tied to the same source. The resulting memory contains the extension itself.

Let F: ReadingFactors and T: ObservationTrace, with F.Left.Left == T.Left and F.Observation.Answer == T.Right. F already contains its decoder F.Right. The factorization gives F.Right.Left == T.Right, F.Right.Predicate == F.Left.Predicate and F.Right.Answer == F.Left.Answer. These equalities follow by substitution from the two matching endpoints and the factorization equations.

`AnswerInTrace<T,F>` names exactly F.Right under these premises. It is a constrained typealias. The complete reading type, not only its answer, is identical to the decoder already in the certificate. A second application object, output trace or verdict flag would duplicate information for this question. The memory is the existing decoder input, and no larger memory is required by the derivation.

Source compatibility still matters even when two memories coincide. The same first fact can belong to a constant pair or an unrestricted pair. A certificate about one source does not become a certificate about the other through payload equality. The scope conditions belong at the naming relation, while the named reading remains F.Right.

Among admissible pairs (T,F), pairs with the same decoder F.Right have the same scoped reading type. This projection identifies the reading while the contexts and their witnesses can remain distinct in the whole. It uses equality of the actual decoder type. Identifying every semantically equivalent decoder would require a further relation.

> Argues: ``ObservationTrace`` needs ``/Notation/Pair``. The trace relates the source to its recorded evidence.
> Argues: ``EmptyObservationTrace`` needs ``ObservationTrace``. Its memory is the empty floor for a specified source.
> Argues: ``ExtendedObservationTrace`` needs ``ObservationTrace``. Its memory contains the previous memory and the newly recorded fact.

This is a relation of sufficiency. A claim about the duration or energy of a physical use requires a specified cost model.

**A family witness.** For T: Null, T.Left == T.Right. `ConstantSecondFactors<T>` derives the second answer through the first reading. `ConstantSecondFromTrace` reads it from the stored fact. Any further use of that certificate names the same one-fact memory.

For a general two-input Pair, that conclusion does not follow. The generic negative witness `RejectedUnmeasuredSecond<T>` attempts the same factorization with only T: Pair and fails to compile. The concrete source `(Quiet, Signal)` shares its first fact with `(Quiet, Quiet)`, so the first fact cannot distinguish their second answers. Adding the actual second observation settles its second answer. `RetainTraceAnswer` also carries the old first-answer certificate through the retained memory prefix. Both later answers reuse a trace containing exactly two observations.

**Retained answers need no uniform context across all facts.** Suppose q(x)=d(E(x)) in the original question's context. Extend that same source's memory to H(x)=(E(x),f_r(x)), where the additional fact f_r has its own space, encoding and question. Then q(x)=d(π₁(H(x))). This follows from π₁(H(x))=E(x) and the original factorization. No value or context of f_r enters the decoder. The old memory, source and decoding relation are retained, so this is no translation of r into q's context.

`TraceEvidenceIn<T,S,E>` exposes the constructed memory in the context of a supplied decoding path. It leaves every fact's original verdict coordinates intact. `TraceEvidence<T>` names the case using the latest reading's context. `RetainTraceAnswer<T,F>` uses F's original context and `PrefixMemoryAnswer` to reach its actual old input. It requires the same source and the actual retained prefix, with no equality between F's context and the new reading's. The general witness `RetainedTraceUsesOriginalReading` derives the complete original reading under these two premises. `MixedTraceAnswersFromOneMemory` and `MixedTraceKeepsBothContexts` construct two source readings with the same question and answer but different spaces and encodings. Both answers are readable from one trace, and their original contexts remain different. The attempted `ComparedReadings` conformance is refused, as are a substituted source and the wrong old memory.

This corrects an unnecessary restriction in the earlier constructor: choosing the latest fact's context for every use of memory made retention demand that all appended readings share it. Coexistence requires neither a global reinterpretation of the facts nor agreement between their questions. It also supplies no general common acquisition of incompatible physical measurements: `AppendObservation` still requires declared readings of the same source, whose physical availability must be established separately.

The source, memory and operations are related within one type-level whole. There is no runtime learner supplied with a hidden source index. The input reading is still an explicit premise: the concrete table constructors derive its answer by field projection. Certifying a physical sensor requires establishing its reading relation.

### VC43

**VC43 (Stored disagreement does not supply an invariant answer).** Let P and Q be two `HasVerdict` payloads that are also `Structure`, with identical space, encoding and question. Their pair is a well-formed record. `ReadRecordedAnswer<P>` and `ReadRecordedAnswer<Q>` recover their respective answers and meet `ComparedReadings`. None of these relations requires P.Answer == Q.Answer. Joining these readings under `VerdictIsInvariant` does require that equality.

*Derivation.* The pair preserves both payload addresses. Each decoder projects the four verdict coordinates from its own input. The three assumed context equalities establish comparability. Invariance adds equality of both projected answers to one answer. Taking P.Answer = Quiet and Q.Answer = Signal gives a record and comparable readings, but no such invariant join for these distinct answer types. If the answer types coincide, `JoinedVerdict` supplies the join under precisely the remaining context equalities.

The Cut §18 distinguishes the existence of conflicting records from settlement in one answer. Here this distinction is expressed without a new truth-value type or a contradiction evaluator. The facts can originate in different sources; their coexistence does not assert that one source has both answers to one reading. Even when records purport to concern one source, reading their contents and certifying their accuracy remain different relations. This construction does not establish a paraconsistent logic or a simultaneous valuation of every possible observation. It specifies which relation is present and which stronger relation is absent.

The constructors are in `Sources/Examples/Acquisition.swift`. The generic consequence witnesses and nearby incompatible constructions in `Checks/Acquisition.swift` distinguish preserved evidence from a wrong answer, retargeted question, substituted source, missing fact or discarded prefix. They also distinguish a readable payload from a source reading, and comparable stored answers from an invariant verdict.

Sections 6a–6m retain their own mathematical and encoding premises. A historical finite enumeration does not become a general type proof because this section has been added. Untranslated probabilistic and optimization results remain separately identified research results.

## Cross-page mentions

Labels mentioned here: <doc:interference_is_substitution__positive_channels#IiS19>, <doc:permanence_is_resistance__records_entropy#M38>, <doc:permanence_is_resistance__records_entropy#M40>, <doc:permanence_is_resistance__records_entropy#M41>, <doc:permanence_is_resistance__retention#M55>, <doc:permanence_is_resistance__retention#M72>, <doc:verdict_is_invariant__finite_records#VC15>, <doc:verdict_is_invariant__finite_records#VC2>, <doc:verdict_is_invariant__recovery_memory#VC20>, <doc:verdict_is_invariant__recovery_memory#VC24>, <doc:verdict_is_invariant#VI2>.

Mentions of this page’s labels: <doc:interference_is_substitution__positive_channels> (VC38), <doc:interference_is_substitution__support_calibration> (VC35), <doc:learning_is_liquid> (VC30), <doc:learning_is_liquid> (VC34), <doc:learning_is_liquid> (VC38), <doc:learning_is_liquid> (VC39), <doc:learning_is_liquid__medium_contacts> (VC35), <doc:learning_is_liquid__reconstructed_sides> (VC38), <doc:permanence_is_resistance> (VC26a), <doc:permanence_is_resistance> (VC35), <doc:permanence_is_resistance> (VC36), <doc:permanence_is_resistance> (VC42), <doc:permanence_is_resistance__forced_answers> (VC26), <doc:permanence_is_resistance__forced_answers> (VC26a), <doc:permanence_is_resistance__forced_answers> (VC30), <doc:permanence_is_resistance__forced_answers> (VC31), <doc:permanence_is_resistance__forced_answers> (VC38), <doc:permanence_is_resistance__records_entropy> (VC31), <doc:permanence_is_resistance__records_entropy> (VC32), <doc:permanence_is_resistance__records_entropy> (VC33), <doc:permanence_is_resistance__records_entropy> (VC34), <doc:permanence_is_resistance__records_entropy> (VC38), <doc:permanence_is_resistance__records_entropy> (VC40), <doc:permanence_is_resistance__records_entropy> (VC42), <doc:permanence_is_resistance__retention> (VC37), <doc:permanence_is_resistance__retention> (VC38), <doc:permanence_is_resistance__retention> (VC40), <doc:permanence_is_resistance__retention> (VC42), <doc:permanence_is_resistance__reusable_requests> (VC38), <doc:verdict_is_invariant> (VC42), <doc:verdict_is_invariant> (VC43), <doc:verdict_is_invariant__finite_policies> (VC31), <doc:verdict_is_invariant__finite_policies> (VC33), <doc:verdict_is_invariant__finite_records> (VC30), <doc:verdict_is_invariant__finite_records> (VC31), <doc:verdict_is_invariant__relative_questions> (VC30), <doc:verdict_is_invariant__relative_questions> (VC31), <doc:verdict_is_invariant__reusable_images> (VC39), <doc:verdict_is_invariant__reusable_images> (VC40), <doc:verdict_is_invariant__reusable_images> (VC41).
