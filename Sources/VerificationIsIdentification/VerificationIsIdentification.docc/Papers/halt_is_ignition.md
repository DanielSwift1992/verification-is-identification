# Halt Is Ignition (Succession)

A record inside a fixed finite family of facts can grow strictly only finitely many times. That does not make every process using it halt. This paper separates strict progress, eventual recurrence of an infinite finite-state run, and a declared handoff to another game. A terminal can have no move under one relation and an available successor under another. Calling the terminal saturated supplies neither relation.

The keypad on this very site is the whole paper in miniature. A wrong walk ends on a page with no onward link: a dead end, and nothing follows from it. The right walk's last keypress also ends the game, and it has exactly one continuation: the unlocked card. Both are halts. They differ in what they open, and that difference is not a property of the halt's own level at all.

## §0. Derivation

The finite progress argument requires strict growth on every nonterminal step. The recurrence argument requires an infinite run of a deterministic finite-state law. A successor game requires its own admitted construction. These premises are distinct. Liquid LQ9–LQ11 and Matter M8 already separate retention, acquisition and handoff.

## §1. Bounded Progress

**HF1 (Strict bounded progress limits nonterminal steps).** Suppose G ranges over subsets of a fixed finite fact family F, and every nonterminal step strictly enlarges G. Then there are at most |F|−|G₀| such steps. If the process continues whenever nonterminal, it must terminate by that bound. Repeated comparison can add no fact, so retention alone does not supply the strict-progress premise (LQ3, LQ9).

*Proof.* Each nonterminal step adds at least one previously absent member of F, and there are only |F|−|G₀| of them. An infinite repeat of a cached comparison is a counterexample when strict growth is omitted. Counting only fresh insertions bounds those insertions, not the number of other actions or physical time. QED

The remaining count |F|−|G| is a nonnegative strictly decreasing variant under these premises. A retaining update that adds nothing leaves it unchanged.

## §2. Recurrence of an Infinite Run

**HF2 (An infinite deterministic finite-state run is eventually periodic).** An infinite run in a finite state space repeats a state. Determinism then repeats the segment between its occurrences. The premise is an infinite run, not absence of a permanent record. A partial transition 0→1 with no successor from 1 terminates without such a record. A finite retaining process with an unchanged cache can instead repeat forever. Neither retention nor its absence alone decides termination.

*Proof.* Choose two occurrences of the same state in the infinite run. Equal states have equal next states, and induction gives repetition at every later offset. This says nothing about which partial laws admit an infinite run. QED

## §2a. Never Beyond a Finite State Space

HF2 settles the fate of an infinite run when the complete state space is finite. Beyond that premise the following section names what a finite record can certify about every future step. Labels marked history refer to accepted research notes listed in §9.

**Question.** Which finite record certifies that an actual run never reaches its target? How does that record change when the law is reversible and the target is an actual predecessor of the start?

**Result.**
1. Let an exact finite image follow one autonomous law and decide the target test. A bounded check of length at most the image size then decides the claim (HF7).
2. Evidence from finite prefixes, without a proved transfer, certifies those prefixes. A finite proof of a transfer can certify the whole future. Three sufficient forms of such a proof are known: an invariant set without periodic points, an independent barrier, and a category argument over the success sets (HF8). The list makes no claim of completeness. The category form certifies that starts without success exist and form a residual set. It does not certify the failure of a start given in advance.
3. A fully invariant set through the start contains its actual predecessor. When that predecessor is a target, conserved readings cannot exclude the target, and a barrier must exclude it. The start then belongs to the barrier's entry cut and never returns exactly. When an invariant measure is finite on a measurable barrier, the barrier's entry cut is null (HF9).

**HF7 (An exact finite image that reads the target supplies the horizon).** Let K be the declared domain of complete configurations, including the controller, its memory and the question's context. Let E map K onto a finite set Y, let one autonomous law U satisfy ET=UE on K, and let the target test be a function of E. An infinite deterministic run in a finite space is eventually periodic (Halt HF2). An exact finite image of a bijection is a permutation (VC20). When the target is an actual predecessor and the start is outside it, a positive forward hit then occurs within |Y|−1 steps (VC20b). If the start already lies in the target, its image returns to that target within at most |Y| steps. For termination, a complete finite control configuration bounds every guaranteed procedure by its size under the conditions of VC93 on legal commands and dead ends. An image that does not read the target supplies no horizon for it. The shift k↦k+1 on the integers has an exact one-point image, and that image leaves the test k=0 undecided.

**HF8 (Three sufficient forms).** A finite rule can name an infinite extension (Existence EF1). A bound for each candidate does not supply one bound for all candidates (EF6). Failure certified separately on every finite prefix leaves the unbounded claim open (history FPR86). Let R be a bijection on the actual domain, and let success at step n be the exact equality R^n x₀ = Jx₀ with R(Jx₀) = x₀. Success at some n is then exact periodicity of x₀ (history SL163a, TI53e). Injectivity belongs to this equivalence. Without injectivity, with R(x₀) = x₀ = R(Jx₀) and x₀ ≠ Jx₀, the start is periodic and never visits Jx₀. Each of the following forms certifies that success never occurs.
- **(a) Invariant set without periodic points.** A closed Γ through x₀ with R(Γ)=Γ and no periodic point. An invariant curve with irrational rotation is an example (history B11, IV155).
- **(b) Independent barrier.** A set Γ through x₀, defined independently of the run, with R(Γ)⊆Γ and Jx₀ outside Γ. Naming the unknown forward orbit Γ and assuming it avoids the target restates the claim (SL163a). A set invariant under every permitted action certifies in the same way that an actor never obtains a new input, and it needs no finite whole (Verdict VC92).
- **(c) Category.** Let the parameter range over a nonempty space I with the category property: a countable union of closed sets with empty interior has empty interior. Let the runs be continuous. Let Z_n be the closed set of parameters that succeed at step n. If every Z_n has empty interior, the parameters that never succeed form a dense G_δ set (history BC191, ZB81). The obligation is the empty interior of each Z_n on the same domain. It needs no common radius or gap across n. The conclusion is existence and residuality, which answers the question ∃x∀n without selecting a particular x.

**The category form belongs to a dichotomy** (history ZB81a). Let M be a nonempty space with the category property and relatively closed success sets S_n. Exactly one of two cases occurs. Either some S_n has a nonempty interior, so one fixed step succeeds throughout an open piece, or the union of the S_n is meagre, and a residual set of starts succeeds at no return under any stopping rule. The boundary of each S_n is nowhere dense, so adaptive stopping adds only a meagre set to the pieces with a fixed step. The second case is form (c). The first case leaves room for starts that never succeed outside the piece. On an open piece U inside S_N with no early return of memory carrying a wrong field, the rule "stop at the first literal return of memory" is correct, because that return comes no later than step N (history PC99c, MR95b). The rule needs a detector of the return and an end of contact. These form a separate executive link (history PC100a). A piece chosen after the proof is not thereby acquired from the original unknown class.

**HF9 (A target predecessor separates the forms).** Let T be a bijection on K with y=T⁻¹x in the target set G.
- Every reading C with C∘T=C gives C(y)=C(x), so no conserved reading excludes G (VC20a). A fully invariant set through x contains y (SL163a, correction B1). Form (a) keeps the target in Γ and excludes periodicity.
- Let a barrier B satisfy B(x), B(z)⇒B(Tz) and B∩G=∅. Then x belongs to the entry cut D=B∖TB, because x=Tz with z in B would put z=y in B. The start never returns exactly: T^k x=x with k≥1 would put x in T^k B, which lies inside TB.
- Let T be a bimeasurable bijection preserving μ, and let B be measurable with μ(B)<∞. The entry cut D=B∖TB is then null, because μ(TB)=μ(B) and TB⊆B (history SA48.2, accepted in its declared domain as SA49.4). The measure of the entire carrier need not be finite. The sets T^k D, k≥0, are pairwise disjoint: if T^k D met T^l D with l>k, some element of D would lie in T^(l−k)B, which lies inside TB. Under an invariant probability on the entire carrier, M36 applied to the indicator of B gives another proof. The local finiteness argument above needs only μ(B)<∞. The statement concerns one barrier. The union of the cuts of all possible barriers can have positive measure.

The barrier certifies the absence of a return. A record that a participant can read, together with its carrier and its update law, is a separate exhibit (history VIPR87). A complete recurrence carries no distinguishable lap count (M51), so such a record cannot be a function of a whole that returns completely.

**Rejected by name** (history SL163b, selection). The theorem must reject each of these substitutes:
- The existence of some invariant curve, offered as a curve through x₀.
- Agreement on every checked input, offered as agreement on all inputs (AP90e, GR155).
- Exactness at every finite order, offered as an exact return (EZ150f, TP162).
- An atomic result, offered as its transfer to the field without the Source form and phases (N1-132, PS138).

**Scope of §2a.** HF9 concerns certificates. A null set can contain individual starts (history SA47f). The measure is a premise. For the field of the §12 model, a Hamiltonian form alone supplies no finite invariant measure, and any other invariant measure needs its own proof (SA48.2, caveat).

## §2b. Stopping at the First Success Without a Clock

**Question.** When can one fixed test of the current state stop every admitted run exactly at its first success? The test reads only the state. It receives no step count and no record of the start.

**Setting.** Let P be an injective step on a set K and A⊆K the admitted starts. Each start x has a set of success times among k≥1, and n(x) is the least of them, or ∞. A terminal set T⊆K stops x at τ_T(x), the least k≥1 with P^k x in T. T is correct on A when τ_T(x)=n(x)<∞ for every x in A. Correctness here means stopping at the first success. A weaker requirement, stopping at some success, also appears in the history (SS92a). The two are compared after HF11.

**HF10 (Exact criterion).** A correct terminal set exists exactly when both conditions are true:
1. Every start has a first success, n(x)<∞.
2. Success times compose along re-admission: if P^j x lies in A with 1≤j<n(x), then n(x)=j+n(P^j x). The terminal times of one test compose in the same way (history SS92b).

*Necessity.* Correctness gives τ_T(x)=n(x)<∞. Let x′=P^j x lie in A with 1≤j<n(x). The run of x meets no point of T at steps 1 to j, because τ_T(x)>j. After step j it coincides with the run of x′, which first meets T at step n(x′). Hence τ_T(x)=j+n(x′), so n(x)=j+n(x′).

*Sufficiency.* Take T={P^(n(x))x : x in A}. Each start reaches T at n(x). Suppose P^k x=P^(n(x′))x′ with 1≤k<n(x) and x′ in A. Injectivity leaves three cases.
- If k>n(x′), then P^j x=x′ with j=k−n(x′) and 1≤j<n(x), so condition 2 gives n(x)=j+n(x′)=k, a contradiction.
- If k<n(x′), then x=P^(j′)x′ with j′=n(x′)−k and 1≤j′<n(x′). Condition 2 for x′ gives n(x′)=j′+n(x), hence n(x)=k, a contradiction.
- If k=n(x′), then x=x′ and k=n(x), a contradiction.

The first point of T on each run is therefore its first success. ∎

**HF11 (When re-admission is excluded).** In the field model of the research history the step is a bijection with an autonomous factor (u,m,I) that conserves I, and J is injective. Success of a start means the field Ju₀ of that same start together with the literal memory m₀, and every admitted start carries m₀. Suppose a re-admission x′=P^j x with j<n(x) satisfied condition 2. The runs of x and x′ would then share their first success state, which carries both Ju₀ and Ju_j. Injectivity of J gives u_j=u₀, and the factor would be periodic with period j. The success of x at n(x) would then reappear at the step i=n(x) mod j. For i>0 this step precedes j, and for i=0 the step j itself is a success, because then u₀=Ju₀. Both contradict j<n(x). Condition 2 therefore excludes every re-admission before the first success, and HF10 reduces to "every start succeeds and no start is admitted again before its first success" (history AD97a, AD97.1). For the full ready layer this is MR95b: the rule "stop at the first literal return of memory" is correct exactly when every first return is a success.

**First success and some success.** In the field model a test that stops every run at some success exists exactly when one stopping at the first success exists, because AD97a builds the set of first successes. A correct test in the weaker sense need not stop at the first success: a returning counter can skip an early success (history MR95c). The §12 contract asks for a success, so HF10 adds no ban on skipping to it.

**Scope of §2b.** HF10 certifies the existence of a terminal set. It does not supply a detector for T, an end of contact, or an observation that prepares T (history PC100a). The test may need parts of the state that a given executor cannot read. A rule blind to part of the state sees only the projection of the admission (history AD97g).

## §3. Retention and Reach Do Not Determine Fate

**HF3 (Each continuation claim needs its own premise).**

| premise | scope | conclusion |
| --- | --- | --- |
| Strict growth at every nonterminal step | Fixed finite fact family | HF1's finite bound |
| Infinite deterministic run | Finite complete state space | HF2's eventual repetition |
| Unbounded admitted reach | No acquisition or progress premise | No guaranteed continuation or saturation |

An unbounded space can contain a stopped or repeating process that never visits its other forms. Conversely, an actual stream can keep reaching new finite forms. The available reach and the realized continuation are different relations. LQ11 gives an exact finite-question completion condition, while LQ12–LQ14 distinguish admission from rearrangement. This table lists implications under premises, not an exhaustive classification from two flags.

## §4. A Terminal Is Read by Two Relations

**HF4 (Terminality is relative to a transition relation).** A form σ can satisfy Moves(σ)=∅ while a separately declared successor relation admits (σ,τ). These are different predicates on the same form. Their decidability requires the corresponding finite or otherwise decidable descriptions. The gate and its context can also change internally, as LQ12–LQ14 show. No immutability of every gate is required for a fixed relation to have a determinate answer.

## §5. Succession Is a Game One Level Up

**HF5 (A unique admitted successor can be identified under its own contract).** Specify a finite candidate family of successor games and a terminating relation deciding which may use σ as their board. Let Ignites(σ) be its survivors. Finite σ alone does not bound all possible encodings over it. Within the declared family, a terminal is one of three:

> Argues: ``Tower`` needs ``Ignites``.

- **sterile**, Ignites(σ) = ∅: a true end, and nothing is on this crystal.
- **ambiguous**, \|Ignites(σ)\| > 1: this contract does not identify one successor. An invariant question may need no selection. Choosing one requires an actual selection relation, whose symmetry requirements are given by VI1a.
- **reincarnating**, \|Ignites(σ)\| = 1: checking the successor relation identifies that unique candidate. Checking terminality alone does not establish this separate singleton property.

The successor relation can be carried by internal forms and changed through their actual constructions. Naming another level does not introduce an outside designer or make the successor available. A static singleton proof identifies a declared possibility. Its realization needs a binding to the continuing process.

## §6. Declared Continuations in the Repository

**HF6 (The examples carry particular continuation relations).** Organization's keypad describes missing and available outgoing links. `ReviewCycle.swift` separately connects each displayed year to its predecessor and committed cut, through Y2030. These are concrete declared continuations. The listed examples do not exhibit every cardinality class, and compiling their constraints does not prove an exhaustive physical fate or uniqueness among every possible successor encoding. They illustrate where a successor relation must be written.

## §7. Boundaries

**Not cosmology.** Heat death as saturation, recurrence without memory, dissipation as the record: the author keeps these rhymes in Learning Is Liquid's discipline (LL §6), borrowed vocabulary, no equation claimed, no statement about the physical universe.

**Fertility is open.** Whether rich crystals generically admit a successor constraint with \|Ignites\| = 1 (whether interesting worlds tend to leave keys or dust) is measurable per design and guaranteed by nothing here. It is the horn bet's sibling, named and left open.

## §8. Statement

1. Strict bounded growth limits nonterminal steps. Retention alone need not make a process halt (HF1).
2. An infinite deterministic finite-state run is eventually periodic. Terminal states remain possible (HF2).
3. Retention and unbounded reach do not by themselves select a temporal fate (HF3).
4. A terminal can be related to a successor under a different relation. Decidability requires the stated checking descriptions (HF4).
5. A finite successor contract has zero, one or several survivors. Its singleton proof identifies that declared successor (HF5).
6. The repository examples carry particular continuation constraints (HF6).
7. An exact finite image that reads the target bounds the first hit by the image size. Prefix evidence alone certifies only its prefix (HF7).
8. A finite proof that a run never reaches its target can take three known sufficient forms: an invariant set without periodic points, an independent barrier, or a category argument. The category form belongs to a dichotomy between a plateau and a residual set of starts that never succeed, and the two can coexist on different starts (HF8).
9. A target that is an actual predecessor of the start passes every conserved reading. A barrier must then exclude it, and its entry cut is null when an invariant measure is finite on the barrier (HF9).
10. One test of the current state stops every admitted run at its first success exactly when every run succeeds and success times compose along re-admission (HF10).
11. In the field model of the research history, composition excludes re-admission before the first success (HF11).

Progress, termination and succession require different relations. A static proof can connect them when its actual construction supplies those relations. Retaining a record, reaching a terminal and selecting a successor do not substitute for one another.

## §9. Dependency

| Source | Used |
|---|---|
| V=I | I1–I3, §5.6, §5.8, §5.20–§5.22, §5.26, Theorem 3, R4 (lifted in HF5) |
| IiI | §3 (saturation), §4 (the meta-level: encodings over the crystal) |
| PiR | M8 (ignition), M16 (the tower), M21 (no inverse). M36, M51 (§2a) |
| B | B8, B8b (the horn: finite basis, open reach) |
| LL | LQ9–LQ14: retention, progress, contact and rearrangement |
| PP | PP9 (the second agent is one's own past), PP14 (the self-supply ceiling) |
| Verdict | VI1a: internal reference requirements for an equivariant selection. VC20, VC20a–b, VC92, VC93 (§2a) |
| EiF | C6 (finitude), the infinite as potential. EF1, EF6 (§2a) |
| Research history (§2a–§2b) | SL163 `Research/2026-10-05-never-slot-and-false-neighbours.md`, BC191 `Research/2026-10-05-baire-reduction-of-never.md`, ZB81a `Research/2026-10-03-baire-dichotomy-of-adaptive-stopping.md`, SA48.2 and SA49.4 `Research/2026-10-01-admission-reading-and-measure.md`, TI53e–f `Research/2026-10-02-positive-density-and-transport-identification.md`, FPR86 `Research/2026-10-11-finite-prefix-radius-on-sa69.md`, PC99c and PC100a `Research/2026-10-03-positive-criterion-and-bridge.md`, SS92a–b `Research/2026-10-03-self-stopping-and-the-root-record.md`, MR95b–c `Research/2026-10-03-what-the-executor-must-remember.md`, AD97a and AD97g `Research/2026-10-03-source-phase-and-admission-distinction.md`. Further labels cited in §2a come from these notes, their sources and reviews: B11, IV155, SA47f, VIPR87, AP90e, GR155, EZ150f, TP162, N1-132, PS138 |
| Mathematical arguments | finite counting, deterministic recurrence, strict integer descent, the category property, measure-preserving bijections |

The finite bound concerns strict progress, and the successor classification concerns an established handoff contract. Their connection belongs in the actual source relations, as Matter M8 requires.
