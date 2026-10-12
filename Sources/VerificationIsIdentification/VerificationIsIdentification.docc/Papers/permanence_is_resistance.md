# Permanence Is Resistance (Matter)

This paper studies a retained result as a constraint on later operations. Permanence, uniqueness of a decoded answer and cost of using that answer require different premises. Their intersection is the formal role called matter here. A proved structural constraint applies to every realization of its premises, including actual interactions within the whole. The task is to identify those premises in the interaction, then derive what every compatible construction must preserve. The finite witnesses below separate a closed whole, accessible records and the entropy of a chosen reading.

## §0. One Act

V=I §2 specifies a finite representation grammar using a structural primitive:

- **PAIR(a, b)**: the act of distinction. Two sides held together by a boundary.

Two aspects follow:

- **NULL**: the declared terminal of the finite expression grammar. Swift's `Null` instead constrains the two sides of a `Pair` to be equal. It does not require either side to equal the conforming type or prove that recursive descent ends (EiF EF4, Law §4).
- **COMPARE(a, b)**: structural comparison in that grammar. Two encoded trees match when their constructor shapes and corresponding components match, down to the declared terminals. This identifies encoded expressions; identifying the histories they describe also requires a faithful encoding. Any realized comparison takes place within the whole.

Within this representation, PAIR is the structural constructor, terminal recognition ends a path, comparison asks whether encoded trees agree, and a projection selects a side. Expressing them in one grammar does not establish that they are one numerically identical occurrence or that every actual interaction has this grammar. The Cut's stronger unity claim has its own relational argument and scope; the results below do not acquire it from the syntax (V=I §2.5).

The encoded objects considered here are finite binary trees built from PAIR, terminating at the declared terminal; arbitrary recursive Swift conformances need not have that finite form. A represented L, τ or E can be such a tree when its chosen description belongs to Σ. Their roles differ: τ specifies the question, L retains acquired answers, E specifies an encoding. Structural comparison identifies these descriptions. Its applicability to their referents still requires the corresponding reading relation.

## §1. Resistance

Fix a target, an encoding and a comparison procedure. An unequal comparison constrains which candidate can pass that procedure. It does not make the source change to agree with the candidate. A persistent search still needs coverage of the candidate space to reach an existing solution; repetition alone can remain unsuccessful.

> Argues: ``Resistant`` needs ``Decidable``.
> Argues: ``Resistant`` needs ``HasDistance``.

The target and agent are internal roles in the whole. A fixed target in this game does not imply a world unaffected by the agent: the agent's records and operations already change part of that world. Resistance names the mismatch in the declared comparison. Physical hardness, inertia and energy expenditure do not follow from this definition.

## §2. What the Library Is

A library stores keyed results and their scope. Starting from an empty library, a successful task can add a new entry; a repeated result may add none. Sound retention preserves entries under a fixed interpretation (M21). A represented library can be a finite list of pairs `(rule, encoding)`, itself encoded as a tree.

> Argues: ``Matter`` needs ``KnowledgeAccumulates``.

| Property | Required condition | Consequence |
|---|---|---|
| Retained | Faithful append-only update | Existing scoped records remain in the library |
| Unique answer | Singleton solution set in the declared semantics | Every correct candidate denotes that answer |
| Resistant | Fixed target and comparison | A mismatching candidate fails that comparison |

Uniqueness of an answer does not establish a shortest program or irreducible representation. Two encodings can denote the same function at different sizes. Minimality needs the explicit representation and cost comparison of Basis B6–B8. The formal protocol `Matter` combines existing interfaces; it does not derive physical permanence or representation minimality from their names.

## §2a. From the whole to a forced answer

Derivations: <doc:permanence_is_resistance__forced_answers#Detail-2a-From-the-whole-to-a-forced-answer>.

### Questions that force an answer

Derivations: <doc:permanence_is_resistance__forced_answers#Detail-Questions-that-force-an-answer>.

### Where further precision changes the conclusion

Derivations: <doc:permanence_is_resistance__forced_answers#Detail-Where-further-precision-changes-the-conclusion>.

## §2b. A Past Distinction Crosses Every Cut

Derivations: <doc:permanence_is_resistance__forced_answers#Detail-2b-A-Past-Distinction-Crosses-Every-Cut>.

## §3. The Transition

Reuse replaces some acquisition or derivation with retrieval and checking. In a sequential lookup model with K entries and F constant-cost features per entry, lookup uses at most K·F feature comparisons. The cost of checking, retrieving the features, building and maintaining the library must be added. An old derivation cost greater than this full bill gives a saving; the reverse inequality gives a loss.

Retained access is expressed by the same record supplying a later answer (VC42). No new source distinction is needed when the question already factors through that record. A runtime or energy advantage needs a separate cost interpretation (AI6, M27).

A retaining resolution map can stop changing when all its declared questions are covered. Its construction can include repeated unsuccessful work, and PASS need not add a fresh entry. This scoped fixed point is the sense of crystal used below. Continued activity of the whole need not alter that map.

## §4. Levels

A retained result can become the declared input or target of another game. The next game still needs its own candidates, question, allowed operations and controller. One whole contains all these roles. No external designer is required by the model, but internal closure alone does not construct a successor policy.

### Time

### M1

**M1 (An operation clock).** A sequential comparison model may index completed operations by natural numbers. This is its counting convention. It does not exclude continuous physical time or additional internal processes in an implementation.

### M2

**M2 (Trace-determined state).** Fix the initial state and deterministic update rule, and include every state-changing input in a complete operation trace. Replaying that trace gives the same final state independently of an omitted wall-clock label. This follows by induction on the trace. If timing affects the update, timing belongs in the inputs and cannot be omitted.

### M3

**M3 (Replay equivalence).** Two copies of that same initialized machine receiving the same complete trace have equal states at every corresponding step. Equal Boolean comparison results alone are insufficient: comparing different pairs can return `equal` while writing different cache keys. The operands and update data matter.

### M4

**M4 (Level-relative counts).** A declared macro-operation can contain several lower-level operations. A high-level tick counts completion of that macro, while lower-level work counts its constituent actions. Their dependencies need not form one chain. Distance G14a–G14b constructs compatible tree-edit rounds and separates the number of edits from the longest dependency chain using actual applications. Assigning physical durations or hardware resource limits requires a realization of that interface.

> Argues: ``Tower`` needs ``HasTime``.

### M5

**M5 (Conditional nesting bound).** Suppose each level-(n+1) operation uses at most b_n level-n operations and has no uncharged overhead in this counting unit. If each level-n operation costs at most T_n base operations, then T_(n+1) ≤ b_n T_n. With T_0=1, induction gives T_N ≤ ∏_(n<N) b_n. The number of task classes K_n is not a bound on retries or search, so replacing b_n by K_n needs an extra operation bound. This is an upper bound, not a proof that every higher level is strictly or exponentially slower.

> Argues: ``Tower`` needs ``HasCost``.

### Ignition

### M6

**M6 (Mutable target boundary).** A changing library that changes during a comparison sequence cannot be treated as one unchanged target without modeling those changes. An immutable snapshot can be a target before the changing library saturates. Incompleteness alone does not forbid targethood.

### M7

**M7 (A scoped stable result).** If the update rule adds only missing entries from a fixed finite declared set, complete coverage leaves no new entry to add. Stability follows for that update rule. It does not prove complete future-task coverage after a scope change, nor minimality of an encoding.

### M8

**M8 (A sufficient handoff).** A stable library can be supplied as the target of another game once its representation, candidate space and comparison procedure are declared. Saturation is one sufficient way to obtain stability under M7. It is not the unique instant at which a target becomes possible: a partial snapshot already supplies a counterexample to that earlier necessity claim.

> Argues: ``Ignites`` needs ``LibrarySaturates``.
> Argues: ``Ignites`` needs ``Matter``.

The `Ignites` intersection records a chosen architecture's saturation and matter premises. Its conformance does not execute a handoff, instantiate a controller or prove the absence of other constructions.

### M9

**M9 (An internal successor needs a mechanism).** The next game may be built and run entirely within the whole. Merely having a library, other structures and a comparison operation does not guarantee it will run: a system can retain the library and repeat one old query indefinitely. Automatic ignition requires an actual transition or scheduling premise.

### M10

**M10 (Iterated handoff).** When M8's interfaces and an internal controller are supplied at each step, one result can become another game's input. Iterating that construction is a model of a tower. A finite number of candidates at each level supplies no bound on the number of levels.

### Exhaustion and Form

### M11

**M11 (Novel-comparison bound).** On a fixed finite comparison domain D, at most |D|² ordered pairs can enter a faithful retaining cache for the first time. The total number of calls can be arbitrarily large: repeating one pair does not visit the others. Full coverage requires a schedule covering every pair. A finite discovery budget requires bounds on that schedule, not just on the number of possible records (M26).

### M12

**M12 (Stabilization of finite retaining records).** Let L_t and G_t grow by inclusion within fixed finite record sets. There are at most the sum of those sets' sizes strict additions; hence along an infinite trace the two records eventually stop changing. This follows because the finite set of actual addition times has a last member, if it is nonempty. It gives no uniform time to that last addition and no guarantee that unvisited records or unresolved questions are covered. Stabilized records do not make the whole state stationary; clocks and repeated operations can continue.

### M13

**M13 (Properties of a library need witnesses).** Multiple entries can support shared structure or a shorter dispatch tree. They need not do so, and such structure can exist before coverage is complete. For identifying K nonempty answer classes with binary queries, worst-case depth is at least ⌈log₂K⌉ by the leaf bound. Attaining that depth requires suitable queries. Uniqueness of each class's answer supplies no such queries (S3a, S5).

### M14

**M14 (Different descriptions can have different tasks).** A higher-level operation may ask about relations among entries instead of one entry. Which relations it can read and how long they take depend on its interface. Coarser descriptions and slower ticks are possible design choices, not consequences of the level number.

### M15

**M15 (Successor parameters require more than the library).** If a new interface is exactly a vector of K Boolean match outcomes, there are at most 2^K such vectors. Actual distinguishability, available queries and costs require their own specification. Under IID uniform draws over K′ classes, complete acquisition from scratch has mean K′H_(K′) draws. The library alone establishes neither that sampling law nor K′<K. A binary decision tree for K′ classes again obeys M13's lower bound.

### M16

**M16 (Conditional tower termination).** If a declared integer rank K_n strictly decreases whenever K_n>1 and construction stops at K_n≤1, it stops after at most K_0−1 decreases for K_0≥1. Neither strict descent nor the stopping rule follows from closure, finite individual games or the existence of compression. This rank argument does not prove a globally shortest representation of the original domain.

### M17

**M17 (A constructed tree boundary).** Every finite tree constructed by the declared PAIR/NULL grammar has terminating paths by structural induction. This claim is about those expressions. Arbitrary recursive type conformances can contain cycles, and the type named NULL does not remove the need to state the construction grammar.

### Protocol

### M18

**M18 (A library with a lookup procedure).** A fixed library and a fixed deterministic lookup procedure determine a trace from the full input. Different inputs can traverse different branches. The library's tree alone does not select a unique procedure. All lookups are internal operations of the whole.

### M19

**M19 (Resistance during a declared comparison).** In the comparison model, mismatch is encountered at a comparison event. The chosen operation count can assign zero comparison work between events. That convention proves nothing about passive physical maintenance, other internal dynamics or existence of matter between comparisons.

### M20

**M20 (Reuse preserves a scoped answer).** A stored conditional result can be reapplied when its assumptions, question and representation remain valid. Restricting a nonempty compatible family preserves a common answer; widening it may require a new proof (CS3, VC35–VC36, AI6). Repeating a successful lookup is consistent with the certificate, but is not independent evidence that an assumed model describes the source. Memory integrity and access are additional implementation obligations.

### M21

**M21 (Retention is a declared update property).** For a fixed fact vocabulary and decoding, a retaining cache update satisfies G_t⊆G_(t+1). I3 imposes this relation on the permitted record trajectories. Truth of a pure comparison alone does not implement accessible storage (System GC1–GC3). The record update and its faithful interpretation must be supplied.

This restriction on forward cache updates does not forbid an inverse for the complete physical evolution or recovery of a prior record. An append retains its predecessor as a component (M29), and the closed examples in M30–M37 preserve the entire input while changing local access. The protocol `NoInverse` constrains `Library: Permanent`. It does not express a theorem that the complete whole has no inverse map.

### M22

**M22 (Lifetime follows the retention premise).** If a certified fact is accessible at time t and every subsequent permitted step retains it under the same faithful decoding and access conditions, induction preserves it at every later step. This is a conditional statement about those updates, not a physical proof of unlimited record lifetime after finite work.

A physical realization must account for its controls, storage and permitted reading window. An indefinitely retained newly acquired record does not follow from injectivity, a stable truth value, or finite work alone (M33, M36–M37). Likewise, an ignition state persists only while the conditions that define it persist. Mathematical recovery of the past and persistent access to the record are separate properties.

### M23

**M23 (Cumulative capacity and overlap).** Faithful retention across N completed domains with disjoint scoped record keys gives |L|=Σ_i K_i when domain i adds exactly K_i entries. This is finite for finite N and finite K_i. Unbounded growth additionally requires unboundedly many distinct additions and adequate storage; persistence alone does not provide them.

If m of K target classes are already correctly covered in the same scope, IID uniform draws over those K classes take mean K·H_(K−m) draws to see all remaining classes. At j unseen classes, the chance of a new class is j/K, so the expected waiting time is K/j; summing proves the formula. Semantic overlap must be established, not inferred from similar labels. The formula counts acquisition draws, not dispatch, checking or maintenance cost. A logarithmic lookup improvement requires the query structure of M13. Accumulation can help, remain neutral or become expensive under different resource accounts.

### Cost

Derivations: <doc:permanence_is_resistance__cost#Detail-Cost>.

## §4a. The closed whole, records and entropy

Derivations: <doc:permanence_is_resistance__records_entropy#Detail-4a-The-closed-whole-records-and-entropy>.

## §4b. Time, cell volume and the entropy of a reading

Derivations: <doc:permanence_is_resistance__records_entropy#Detail-4b-Time-cell-volume-and-the-entropy-of-a-reading>.

## §4c. The same internal acquisition, its entropy and its order

Derivations: <doc:permanence_is_resistance__records_entropy#Detail-4c-The-same-internal-acquisition-its-entropy-and-its-order>.

## §4d. Restore the instrument, retain the distinction

Derivations: <doc:permanence_is_resistance__records_entropy#Detail-4d-Restore-the-instrument-retain-the-distinction>.

## §4e. A retained distinction can have two different futures

Derivations: <doc:permanence_is_resistance__records_entropy#Detail-4e-A-retained-distinction-can-have-two-different-futures>.

## §4f. Learning a routing law redistributes uncertainty inside the whole

Derivations: <doc:permanence_is_resistance__records_entropy#Detail-4f-Learning-a-routing-law-redistributes-uncertainty-inside-the-whole>.

## §4g. Which future must carry a real distinction?

Derivations: <doc:permanence_is_resistance__retention#Detail-4g-Which-future-must-carry-a-real-distinction>, <doc:permanence_is_resistance__frame_acquisition>, <doc:permanence_is_resistance__contact_rigidity>, <doc:permanence_is_resistance__support_renewal>, <doc:permanence_is_resistance__reusable_requests>, <doc:permanence_is_resistance__joint_laws>, <doc:permanence_is_resistance__reacquisition_residue>, <doc:permanence_is_resistance__balance_clock>, <doc:permanence_is_resistance__uniform_routing>.

## §4h. Recovering dependence from admissible records

Derivations: <doc:permanence_is_resistance__recovery_remainder#Detail-4h-Recovering-dependence-from-admissible-records>.

## §4i. What an unrestricted internal remainder permits

Derivations: <doc:permanence_is_resistance__recovery_remainder#Detail-4i-What-an-unrestricted-internal-remainder-permits>.

## §5. Candidate Physical Correspondences

Derivations: <doc:permanence_is_resistance__physical_models#Detail-5-Candidate-Physical-Correspondences>.

### Quantum measurement

Derivations: <doc:permanence_is_resistance__physical_models#Detail-Quantum-measurement>.

### Crystallization

Derivations: <doc:permanence_is_resistance__physical_models#Detail-Crystallization>.

### The Higgs mechanism

Derivations: <doc:permanence_is_resistance__physical_models#Detail-The-Higgs-mechanism>.

### Discrete self-similarity in gravitational collapse

Derivations: <doc:permanence_is_resistance__physical_models#Detail-Discrete-self-similarity-in-gravitational-collapse>.

### Finite energy, concentration and the class of continuations

Derivations: <doc:permanence_is_resistance__physical_models#Detail-Finite-energy-concentration-and-the-class-of-continuations>.

## §6. Discovery within a fixed question

For a fixed adequate model with one admissible answer f*, a successful search identifies that answer. Earlier ignorance did not create an alternative correct value. The actual search still creates physical records and can construct a new representation of the answer within the whole.

Uniqueness of the decoded answer does not make every saturated library byte-for-byte identical or shortest. Canonicalization, representation, coverage and cost remain separate questions. This distinction keeps discovery of a constrained answer compatible with construction of the internal means of accessing and using it.

**A given occurrence and a determining source.** Fix a nonempty relation R⊆X×A, independently of the answer sought. Its members are admitted contact descriptions. On R itself the projections p(x,a)=x and r(x,a)=a are functions, however many answers R admits at one x. Thus every relation has a presentation in which a complete contact determines its answer. That presentation alone imposes no determinacy on the source X.

The exact further requirement is

    r = f ∘ p on R
        iff each x in p(R) has exactly one related answer.

If such f exists, two contacts (x,a),(x,b) give a=f(x)=b. Conversely, the unique answer defines f on p(R), with no selected representative needed. This is Verdict §6c's factorization criterion applied to the contact rather than a presupposed function on X. Restricting to a singleton actual contact makes the equation automatic on that singleton. It does not establish the equation on the independently declared source domain.

For R={(x₀,0),(x₀,1)}, the complete contacts have definite and different answers, while their source readings agree. Adjoining a variable h and writing a=h gives a deterministic projection only after h is supplied. If h is claimed to be determined by x₀, the original two-answer conflict returns. If it is a further actual source distinction, its availability and relation to the contact must be established. If it names the result after the contact, it supplies a record. No external cause is required by either contact description, and no global temporal order is assumed by this argument. Reading a completed occurrence, recovering an answer from an addressed source, and physically bringing about that occurrence remain different obligations.

This distinction prevents a circular interpretation of the given. One actual reality does not require a proposed description of a part to determine every other part. Calling the full occurrence the input can hide precisely the dependence being sought. The retained-source construction of M71 already checks the static boundary: two records retain the same H and all its supplied readings while carrying the positively different new answers Never and Lit1. No second constructor is needed for the same obstruction. These are admitted extensions of the stated equations; their physical availability is not inferred.

The questions used to define completeness also have a domain. A total q:X→A presupposes one answer at each admitted x and a shared meaning of answer equality. A partial or multivalued contact needs its actual availability and result relation before that representation is justified. LQ16 supplies one conditional derivation of determinacy from contact laws. PP15 gives a distinct obstruction: representing a transformation of an evaluator's own diagonal forces that transformation to have a fixed point. A demand using a transformation with none can be inscribed, but its stipulated total answer relation cannot be realized. This uses the answer relation, without requiring all questions to be classical propositions. Placing the question's name inside the whole supplies neither its realizability nor an instrument that can perform the contact.

Finally, a counterconstruction tests exactly the premises it satisfies. M52 retains its source in the represented history while its later current-state projection merges source values. It therefore separates historical retention from later recovery. Calling that merged projection the whole and discarding the distinguished histories would drop the historical premise. It could not refute The Cut §5's conjunction on that basis. An admitted representation that separates two proposed answers shows that the stated relations leave the question open. It does not establish two physically possible realities or intrinsic randomness. A physical necessity argument must carry the actual source relations through this same distinction.

## §7. Dependency

### Documents

| Source | Sections used |
|---|---|
| V=I | §2 (Σ, PAIR, NULL, COMPARE, I1, I2, I3), §2.5 (Unity) |
| | §5.14, §5.16, §5.20, §5.22, §5.24, §5.25, Theorem 2 |
| IiI | §0 (agent), §1 (crystallization), §2 (I3 for agent) |
| | §3 (saturation, uniqueness), §4 (tower), §5 (A1–A4), §6 (coupon collector) |
| Verdict | VC26a (§2b) |
| Distance | G14d (§2b) |
| Research history | §2b: SA48.2 and SA49.4 `Research/2026-10-01-admission-reading-and-measure.md`, AD97b `Research/2026-10-03-source-phase-and-admission-distinction.md`, HPU77 `Research/2026-10-10-unknown-receiver-and-hand-off-price.md`, HOR45 `Research/2026-10-06-completion-hand-off-review-codex.md`, and the earlier sources these notes cite |

### Circuit

V=I supplies comparison and identification relations. Intelligence Is Inevitable specifies conditional acquisition and coverage. This paper studies retained outputs, their possible handoff to another game, and the boundaries imposed by a closed whole. The return of a result as a later target is an operational construction when its controller and interfaces are supplied (M8–M10), not a circular proof of their existence.

### Agent

A total checker terminates on each declared input. Scoped soundness establishes that accepted outputs satisfy its claim; it does not imply that a generator reaches acceptance or that the encoded family includes the physical source. Those acquisition and adequacy premises remain explicit (CS3, AI6). A type interface is not an executing physical agent.

### Physical correspondences

Section 5 lists candidate bridges and the premises they still lack. None is counted as a completed verification of the VI axioms. The finite experiments in §§4a–4b establish their stated mathematical relations, with physical interpretations limited to the separately supplied models.

## Cross-page mentions

Labels mentioned here: <doc:learning_is_liquid__reconstructed_sides#LQ16>, <doc:permanence_is_resistance__cost#M26>, <doc:permanence_is_resistance__cost#M27>, <doc:permanence_is_resistance__records_entropy#M29>, <doc:permanence_is_resistance__records_entropy#M30>, <doc:permanence_is_resistance__records_entropy#M33>, <doc:permanence_is_resistance__records_entropy#M36>, <doc:permanence_is_resistance__records_entropy#M37>, <doc:permanence_is_resistance__retention#M52>, <doc:permanence_is_resistance__forced_answers#M71>, <doc:verdict_is_invariant__discovery_acquisition#VC26a>, <doc:verdict_is_invariant__discovery_acquisition#VC35>, <doc:verdict_is_invariant__discovery_acquisition#VC36>, <doc:verdict_is_invariant__discovery_acquisition#VC42>.

Mentions of this page’s labels: <doc:permanence_is_resistance__cost> (M15), <doc:permanence_is_resistance__cost> (M16), <doc:permanence_is_resistance__records_entropy> (M23).

## Topics

### Parts

- <doc:permanence_is_resistance__forced_answers>
- <doc:permanence_is_resistance__cost>
- <doc:permanence_is_resistance__records_entropy>
- <doc:permanence_is_resistance__retention>
- <doc:permanence_is_resistance__frame_acquisition>
- <doc:permanence_is_resistance__contact_rigidity>
- <doc:permanence_is_resistance__support_renewal>
- <doc:permanence_is_resistance__reusable_requests>
- <doc:permanence_is_resistance__joint_laws>
- <doc:permanence_is_resistance__reacquisition_residue>
- <doc:permanence_is_resistance__balance_clock>
- <doc:permanence_is_resistance__uniform_routing>
- <doc:permanence_is_resistance__recovery_remainder>
- <doc:permanence_is_resistance__physical_models>

### Related type declarations

- ``Matter``
- ``NoInverse``
- ``Converges``
- ``Ignites``
- ``Tower``
- ``FiniteDiscovery``
