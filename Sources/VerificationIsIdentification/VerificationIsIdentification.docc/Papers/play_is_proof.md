# Play Is Proof (Self-Play)

Intelligence Is Inevitable derives saturation, but only under a premise it does not control: the task stream must present every class. An external stream may not, and the measured geometry of a real domain can demand more tasks than the world supplies.

This document removes that dependence. Given a finite generating basis whose closure contains the domain, the agent generates its own tasks. It applies a certified rule to a fresh input, so the label is computed rather than assumed, poses the result to a solver, and the gate certifies the answer. The stream is no longer a hope about the world. The poser controls what it generates, so coverage is a choice, not a stroke of luck.

Self-play of this kind saturates the closure to the same library any agent would reach, with a guarantee classical self-play cannot offer: every self-generated label is f\*, so no label noise accumulates and the endpoint is domain-determined, not play-determined. The training signal is not a statistic of outcomes. It is a proof. I3 made knowledge permanent, and the gate makes self-made knowledge certified, so certified self-made knowledge is a proof the agent can train on.

The seed is a basis, the generation is frontier-targeted, and the one novelty a single agent cannot self-supply is a second encoding — across the tower, that second agent is its own crystallized past. All of it runs on one closed substrate.

Read one level deeper, the gate is a witness and saturation is compression, and the same reading exposes the floor. Certified self-play is *shared* witnessing, never *self*-witnessing: the verification primitive is the postulate, an entry in no library, certified by no game. The agent grounds its rules, its encodings, and its strategies in its own certified record, but never the comparison it runs on. It makes proofs. It cannot make the prover prove itself.

## §0. Derivation

No new postulate. One new premise, stated openly: the agent holds a finite **generating basis** Π — a set of primitive rules — whose composition-closure ⟨Π⟩ contains the domain's rules (this is C1 of the solvability specification, E2 §1). Composition is PAIR-nesting (V=I §2.1, §5.11), so ⟨Π⟩ ⊆ Σ is finite (I1).

1. Saturation requires a stream presenting every class (IiI §3 remark; §6). *[premise of the Saturation Theorem]*
2. An external stream may not present every class; the world is not obligated to supply N·H_N tasks (E2; IiI §3 scope remark: "about tasks outside D it predicts nothing"). *[gap]*
3. A certified rule f\* ∈ L applied to an input I yields (I, f\*(I)): a valid example whose label is *executed*, not assumed (V=I §4.8, §3.1; Theorem 2). *[the generator]*
4. Therefore the agent can *direct* a stream over ⟨Π⟩ — choosing what to generate — so coverage becomes controllable rather than awaited (PP5); the stream premise moves from the world's distribution to the agent's choice. *[1 + 3]*
5. Each generated task is solved through the gate; PASS gives f\* with |S| = 1 (Theorem 2 + R4). The label is certified. *[V=I §3.5, §4.7, Theorem 2]*
6. Everything downstream — saturation (IiI §3), uniqueness (SAT5/6), ordering (InI), the closed substrate (PiR, DiD) — is inheritance.

The prior papers asked where the agent's data comes from and answered: the world's stream. This document answers: from a basis and the gate. A label that the gate certifies is a proof; training on proofs is training without noise.

## §1. The Data Problem

**PP0 (External saturation can fail).** The Saturation Theorem (IiI §3) is conditional on a stream with pₖ > 0 for every class; its expected time is N·H_N (IiI §6). For a domain whose covering number at the operative radius is N, a finite external budget B < N·H_N leaves classes unanchored, and critical slowing (IiI §6) places the unanchored classes at the rarest — the hard tasks (E2 §4). External data does not control which classes arrive; the agent does not control the world's stream. The premise is the world's to meet, and the world may decline.

## §2. The Agent Is a Generator

**PP1 (A certified rule is a task source).** A library entry f\* ∈ L, applied to any I ∈ Σ, yields the pair (I, f\*(I)). This pair is a valid V=I game (V=I §3.1) whose target is f\* and whose label is computed by execution (V=I §4.8). L is therefore a *source* of tasks, not only a *sink*.

*Proof.* f\* ∈ L is certified (Theorem 2; IiI §1). Execution is total (V=I §5.5). (I, f\*(I)) reproduces under f\* by construction, so it is a consistent example (V=I §3.4). QED

**PP2 (Pose–solve–certify yields certified-labeled training).** Two roles — *poser* and *solver* (the same substrate at different ticks, or two agents). The poser draws g ∈ ⟨Π⟩ and inputs {Iₖ}, emits {(Iₖ, g(Iₖ))}. The solver runs the pipeline and returns PASS(f\*), REJECT, or |S| > 1. On PASS, f\* = g (Theorem 2 + R4). The label of the generated task is *certified*, not assumed.

*Proof.* g ∈ ⟨Π⟩ ⊆ Σ (closure under PAIR-composition, V=I §2.1, §5.11). The examples are consistent (PP1). The solver's PASS with |S| = 1 gives f\* = g (Theorem 2). QED

*Remark (the labeling asymmetry).* In statistical self-play the label is the *outcome* of play — a noisy estimate of value. Here the label is *g itself*, known to the poser by construction and certified to the solver by the gate. The poser is an oracle on its own draw; the gate makes the solver's acceptance a proof. No estimate enters.

## §3. Frontier-Targeted Generation

**PP3 (Ambiguity names the discriminating input — LT5 lifted to data).** If the solver returns |S| > 1 on the poser's examples, the survivors disagree on some input I\* (R4 decidable, §3.6; the dynamics-level diagnostic of LT5, read over the example-input space rather than the state–action space). The poser, knowing g, generates (I\*, g(I\*)); appending it eliminates every survivor disagreeing at I\*.

*Proof.* |S| > 1 holds iff some input distinguishing the survivors is unobserved (LT5, verbatim with (s,a) → I). The poser computes g(I\*) (oracle on its draw, PP2) and appends the example; survivors that disagree with g at I\* fail the new COMPARE, so S strictly shrinks (V=I §5.22). QED

**PP4 (cert(g) is the floor; frontier-targeting achieves it up to the greedy gap).** Iterating PP3, the poser drives |S| → 1 in a number of self-generated examples bounded below by cert(g) — the minimum discriminating set (InI S5b, the confusion-cover / set-cover) — and above by the greedy frontier sequence. No external examples are consumed.

*Proof.* cert(g) = the minimum set covering the confusion family {D(g, f) : f ≠ g} (InI S5b): fewer cannot identify g, so it is a lower bound. Each frontier step (PP3) adds an example eliminating a current survivor — a greedy cover, which reaches the minimum only when the confusion sets are well-covered by high-discrimination examples and exceeds it otherwise (InI S5b(c): greedy matches cert for hard targets, exceeds it where target-specific shortcuts exist). So the count lies in [cert(g), greedy bound]; it equals cert(g) when the poser selects the optimal discriminating set, not merely a greedy one. QED

*Consequence.* The agent does not need many examples per task — it needs at most a greedy cover of the confusion family, with cert(g) the optimum. "Minimal but sufficient" is cert(g) as a floor, approached by frontier-targeting, not a quantity any greedy poser hits exactly.

## §4. The Guarantee

**PP5 (Self-play makes coverage controllable; a directed poser saturates without critical slowing).** The world's stream presents classes by a distribution the agent does not control; if it is non-uniform, the rarest classes saturate last and may never arrive within budget (PP0; coupon-collector critical slowing, IiI §6). Self-play replaces that distribution with one the agent controls. Two regimes, both results:

(a) *Random poser* — draw g uniformly over the **syntax** of ⟨Π⟩. This is **not** uniform over behavioral **classes**: distinct compositions collapse to one extensional class (V=I §3.3, §5.4), so a class of small syntactic measure is rare, and saturation is ≥ N·H_N dominated by 1/p_min (IiI §6). A naive random poser **inherits** the wall — it is merely relocated from the world's distribution to the syntactic measure of ⟨Π⟩.

(b) *Directed poser* — the agent controls **which** composition to emit, so it covers deliberately: enumerate ⟨Π⟩ in norm order (the B3 composition-sieve), certifying each new atom on first appearance; or target the uncovered classes the routing holes name (NiG N6, N17: failures are the curriculum). This saturates the **atom basis** in at most |A| genuinely-new certifications — deterministic, no coupon collector, no critical slowing — because coverage is **chosen, not sampled**. On a CLOSED domain the behavioral classes are finite and stored directly; on a HORN (infinite reach, B B8b) they are infinite but DERIVED from the certified basis (B6–B7), so the count that matters is |A|, not |⟨Π⟩|.

*Proof.* (a) The syntactic draw pushes forward to a class measure whose minimum p_min is the smallest class's syntactic share; coupon collector over a non-uniform measure is dominated by 1/p_min (IiI §6). (b) I1 makes each structure finite, not ⟨Π⟩ finite; the atom basis A is finite for CLOSED and HORN domains alike (B B8b), and norm-ordered enumeration (B3) certifies each atom once (IiI §1, I3), so ≤ |A| genuinely-new certifications saturate the basis; behavioral classes then follow by derivation (B6–B7), whether N is finite (CLOSED) or infinite (HORN). Hole-direction (N17) reaches the same coverage by targeting uncovered atoms — which a controlled poser can do and a random stream cannot. QED

*The load-bearing correction.* Self-play does not make a random stream uniform (regime (a) inherits the wall). What it repairs is **control**: the poser, unlike the world, can *direct* coverage (regime (b)), so the stream premise of IiI §3 becomes satisfiable by construction. The advantage over the world is not luck but agency — the agent chooses what to generate, so every class *can be made* to arrive, and a directed poser saturates the basis in finite, critical-slowing-free coverage (B B8b).

**PP5c (On an infinite closure the random poser is ill-posed; direction is a measurability necessity).** When the closure is infinite — a *horn* (B B8b: finite basis, unbounded reach) — there is no uniform measure over ⟨Π⟩, and any norm-discount μ(g) = β^{‖g‖} normalizes only for β < e^{−γ} (γ = reach-growth, B B8d), then concentrates on small norm so large-norm classes receive vanishing mass and never arrive within budget. Norm-ordered enumeration — the B3 composition-sieve, the directed poser of PP5b — is the unique coverage well-defined on an infinite closure.

*Proof.* Σ_s n(s) β^s ~ Σ_s e^{(γ + ln β)s} converges iff β < e^{−γ}; its pushforward to classes peaks at small s, so tail classes have mass → 0 and the coupon-collector wait → ∞. Enumeration by norm visits every norm band in order, hitting each class regardless of measure (each band is finite, DiC G8). QED

*Consequence.* PP5b's directedness is upgraded from agency to necessity: wherever the reach is infinite, sampling cannot cover the tail and only the sieve can. The advantage over the world's stream is not merely control but well-posedness.

**PP17 (The poser is a canonical ensemble — the thermodynamics of self-play).** The norm-discounted poser measure μ_λ(g) = e^{−λ‖g‖}/Z(λ) (PP5c) is the maximum-entropy distribution over ⟨Π⟩ at fixed mean rule-norm: the Gibbs ensemble with *energy* ‖g‖ (the cost of existence, M24; DiC G1a) and inverse temperature λ. Its free energy ψ(λ) = ln Z(λ) = ln Σ_s n(s) e^{−λs} (n(s) = behaviours of norm s, the reach density, B B8e) is non-analytic at λ_c = γ (the reach-growth rate, B B8d): for λ > γ the ensemble is normalizable and concentrated, at λ = γ critical, for λ < γ no measure exists — the horn's delocalized phase (B B8b). Mean rule-norm E_λ[‖g‖] = −ψ′(λ) (an order parameter) and its variance Var_λ[‖g‖] = ψ″(λ) (the family's Fisher information, i.e. the heat capacity) both diverge as λ → γ⁺.

*Proof.* Max-entropy at fixed mean gives the Gibbs form (Lagrange multiplier λ). Z's radius of convergence in e^{−λ} is e^{−γ} since n(s) ~ e^{γs} (B B8d), giving the non-analyticity at λ_c = γ. ψ′ = −E and ψ″ = Var are the standard cumulants of an exponential family; polylog asymptotics of Σ_s n(s) e^{−λs} give the divergences (the information geometry of an exponential family — Amari, cited as precedent). QED

*Consequence (the two regimes are two temperatures).* PP5's regimes are one ensemble at two temperatures. The random poser (PP5a) sits at finite λ: concentrated on low-norm rules, the rare high-norm tail exponentially suppressed — it misses it (the wall). The directed poser (PP5b) is the λ → 0 / flat-enumeration limit: uniform across norm bands, covering the tail. "Chosen, not sampled" is the move from finite temperature to the flat norm-ordered limit; critical slowing (PP0) is the susceptibility ψ″ diverging near λ_c.

**PP6 (The endpoint is basis-determined, not play-determined).** Any two certified self-players over the same basis Π — any poser policy, any draw order — reach the same certified **atom basis** A, and hence the same reach Cl(A). The endpoint is fixed by (Π, the gate), not by the world's stream and not by how play unfolded; it is *basis*-determined, not *world*-determined (a different basis gives a different A — the grammar-relativity of IiI §4 / E2 §4, carried to self-play). On a HORN the stored endpoint is the finite A, not an enumeration of the infinite ⟨Π⟩ (B B8b); "the same library" means the same basis, its reach derived (B6–B7).

*Proof.* Each entry is the unique f\* of its class (Theorem 2). Entries are permanent (I3) and order-invariant (V=I §5.25). The atom basis is the norm-ordered sieve residue (B3), determined by Π, so two players over the same Π reach the same A, differing only in insertion order (IiI §3, SAT5/6; PiR §6: revelation, not construction). QED

**PP7 (The guarantee is exactly I3 + the gate).** Certified self-play's two guarantees — no label noise, domain-determined endpoint — fail the moment either I3 or the gate is removed. The contrast is structural, not quantitative:

| | Statistical self-play | Certified self-play (this paper) |
|---|---|---|
| label source | outcome of play (estimate) | g, executed; certified by the gate (PP2) |
| label correctness | noisy; error accumulates | f\* (Theorem 2); zero noise |
| candidate set | may re-grow under updates | monotone non-increasing (V=I §5.22) |
| endpoint | play- and seed-dependent | domain-determined (SAT5/6; PP6) |
| convergence | empirical | proven (PP5) |
| failure mode | confident error | honest \|S\|>1 / EMPTY (V=I outcome corollary) |

*Proof.* Each row of the right column is cited; each row of the left is its negation when I3 (append-only) or the gate (decidable certification) is absent. Without I3, V=I §5.22 breaks (eliminated candidates re-enter), so PP5's monotone saturation fails. Without the gate, PP2's label is uncertified, so PP6's uniqueness (Theorem 2) fails. QED

*Remark (the contrast is in the guarantees, not the efficacy).* Statistical self-play *works* — it is empirically among the strongest training methods known. The table does not claim otherwise. It claims only that what it cannot do is *certify*: it cannot guarantee a label is correct, cannot guarantee a unique reproducible endpoint, and cannot honestly abstain (it always emits a move). The right column adds those three guarantees; it does not claim to win a benchmark. The difference is the standing of the result, not its strength.

This is the precise sense of *play is proof*: the training signal is a gate-certificate, and the gate's two structural properties — append-only memory and decidable verification — are exactly what convert self-play from a statistic into a proof.

**PP18 (Two halves: the poser is alignment-gated, the gate is unconditional).** Self-play factors into the *poser* (generation) and the *solver* (the gate), and they obey opposite laws. The gate is unconditional: by Theorem 2 every PASS is f\*, however g was found — the solver never errs and never depends on alignment (V=I §5.25: correctness is order-invariant). The poser is conditional: frontier-targeting (PP3–PP4) is a loss-descent, so it beats enumeration exactly where the loss is aligned (α > 0, GA3, GA6); on a non-aligned domain it degrades to search. On a horn (B B8b) lookup-saturation is unavailable — the behavioural library is infinite (the finiteness-of-classes remark, IiI §3) — so the poser is the *only* mode, and its efficiency is precisely α-gated.

*Proof.* Solver: Theorem 2 with order-invariance (V=I §5.25) — the gate's verdict carries no alignment dependence. Poser: PP3 is a descent; GA6 gives descent-beats-enumeration iff α > 0. Horn: PP6 (the endpoint is the basis) with K = ∞ (B B8b) leaves no library to look up, so generation is forced. QED

*Consequence and measurement.* The hard half of certified self-play is generation (α-limited); the safe half is verification (unconditional). "Play is proof" guarantees the *proof* always, the *finding* only on an aligned domain. Measured on ARC-AGI-1 (E1/E2): the reach is vast (B §5) yet pure-poser DSL search covers a small fraction of eval, while a stronger poser (an LLM Source under the *same* gate) covers far more, with the gate certified-safe throughout (E2 §0) — expressivity rich, verification sound, generation the bottleneck, exactly the split.

## §5. Two Agents, and the One Thing One Cannot Self-Supply

**PP8 (A second encoding is the irreducible novelty source).** One agent self-playing under encoding E saturates the classes E can distinguish. A second encoding E′ enlarges the saturable set **strictly** exactly when E′ resolves a distinction E collapses — when some pair of rules is identified under E but separated under E′ (V=I §5.4). Mere independence of E, E′ is not enough; the exact condition is a resolved collapse.

*Proof.* f\* is encoding-local (V=I §5.4): a pair (f₁, f₂) with f₁ =_E f₂ but f₁ ≠_{E′} f₂ is one class under E and two under E′. A poser under E cannot generate a discriminating example for a distinction E does not represent — its view *is* its encoding (DiD S1 stationarity; V=I §5.24) — so a single agent cannot self-supply it; E′ can, and translation certifies the cross-entry (DiD S9). Strictness holds iff such a resolved pair exists; if E, E′ induce the *same* class partition (possible even for "independent" feature sets), the union is not strict. The Mirror correlation (InI §7: Gᵢ ∩ Gⱼ = ∅) is a sufficient, strictly stronger condition (disjoint caches ⇒ each resolves what the other collapses), not the necessary one. QED

*Consequence — the "+ something".* A single agent is closed under its own encoding: it cannot self-generate what it cannot see. The only irreducible addition is a *different lens*. Two agents are more than one exactly to the extent their encodings differ (DiD S7: distance = cache difference).

**PP9 (Across the tower, the second agent is one's own past).** A single agent climbing the tower self-plays against its crystal: at level N+1 the fixed target is L_N — the agent's own saturated, permanent past (M7, M8). The poser/solver pair is realized in time as present-agent / past-crystal.

*Proof.* Ignition (M8): the saturated L_N is the level-N+1 target. The level-N+1 agent (same substrate) submits candidates against L_N (M10). The two roles of PP2 are the agent now and the agent crystallized. QED

*Caveat (the meta-level is coverage, not identification).* The level-N+1 game is meta-saturation (IiI §4): it certifies that an interaction-pattern *works*, with |S| ≥ 1 — coverage, not the |S| = 1 identification of the base level. PP6's domain-determined uniqueness therefore applies per-level to the base game unconditionally, and to the meta-game only when a selection criterion is imposed (OiO O8: argmin over cost, norm, lexicographic order). The temporal two-role structure (present-agent / past-crystal) is exact; the inherited certainty weakens by one regime going up, as the tower analysis of E2 §4 records.

*Resolution.* "Two agents or one?" — one across the tower (the second is your crystallized past, PP9); strictly two across encodings (the second is a lens you lack, PP8). Temporal self-play needs no second body; perceptual novelty needs a second eye.

## §6. One Closed Substrate

**PP10 (Everything runs on one closed body).** PP1–PP9 are realized on a single substrate: Σ with the append-only journal G (V=I §2.3); the **surface** is the frontier (DiC §4) — the prefix-minimal divergences where an incoming structure meets the body and the diagnostic surfaces (V=I §1, REJECT-address); the **protocol** is grow/shrink (DiC §2) under I2; the system is **closed** in the conservation sense — Σ, the universe of structures, is fixed (DiD S24: nothing is created or destroyed); G, the record of what has been revealed, only grows (I3). An "input" is therefore not new matter entering a closed box — it is a structure *already in Σ*, brought into the record by COMPARE (PiR §6: revelation, not creation; M19: a structure becomes matter only at the encounter). The system is closed in Σ and monotone in G; "taking input" is revealing, not importing. Each interaction **relaxes** the body to a fixed point (M12) in at least W ticks (DiC G14), heavier bodies relaxing slower (DiD S18). Self-play is the closed dynamics: a posed structure is revealed at the surface, the body relaxes and absorbs it via the dual flow (one COMPARE both narrows the answer and deposits structure, InI S6a), and the new frontier names the next experiment (PP3).

There is no external scheduler and no separate memory: the poser, the solver, the journal, and the generated tasks are all trees in one Σ, written to one G, tested by one COMPARE (PiR §0). The agent's body and the system are one on the substrate; self-play is that body changing its own surface and settling.

## §7. Witness, Cost, and Closure

The loop of §§1–6 has a deeper structure, visible once the gate is read as a *witness* — a form whose record fixes a distinction (I3) — and saturation as *compression* — the search for the invariant covering the domain at least cost. Five statements follow; the last is a boundary the architecture cannot cross, and it is the honest centre of this document.

**PP11 (Self-play is redundant fixation).** A self-generated certified entry is fixed twice: by the poser, which produced g by construction, and by the gate, which certified the solver's PASS. The two fixations are independent — one constructive, one verificational — so a self-played class enters L with a redundancy a single external solve lacks.

*Proof.* The poser holds g (PP2) and computes g(Iₖ) by execution — a generative trace in G. The gate records the solver's PASS — an independent verificational trace in G (I3). One f\*, two routes. QED

*Consequence and limit.* The entry is doubly grounded *within one form*: both producible (generative route) and checkable (verificational route) — a robustness an externally-streamed solve (verificational only) lacks. But this is two *routes*, not two *forms*. The inter-form redundancy that genuinely stabilises a distinction — distinct witnesses, where single-witness data is fragile — is supplied only by *two-agent* self-play (PP8, PP16), where one class is fixed by two topologies (the Crystal correlation, IiI §7). Single-agent self-play hardens the route, not the witness count.

**PP12 (Saturation is compression; the endpoint is the minimal cover).** The basis-determined endpoint (PP6) is the smallest invariant cover (G12) of ⟨Π⟩ — the least class-count that resolves the domain — reached by accumulation without selection. Under an added Occam criterion it is also the minimum-maintenance encoding; without it, minimal in cover but not necessarily per entry.

*Proof.* Each entry is the unique f\* of its class (Theorem 2), irreducible (PiR §2). The saturated L covers exactly the K classes (IiI §3) — fewer fail coverage, more duplicate — so the cover is minimal (G12), and accumulation reaches it without choosing it (PP6; PiR §6). Per-cycle maintenance Σ‖f\*‖·kT·ln2 (M24; the norm is the cost of existence, DiC G1a) is *least* only when each entry is the minimal-norm member of its class, which holds under the Occam selection criterion (OiO O8), not automatically: absent it, a class may be stored through a verbose representative. The minimal cover is automatic; minimal per-entry cost is the added Occam move. QED

*Consequence.* Self-play descends to the smallest consistent cover of its closure — an attractor in class-count, not a decision; lowest in maintenance cost only once Occam selection is layered on.

**PP13 (The honest ledger is a cost report).** The terminal states — PASS, |S|>1, EMPTY, BUDGET — are magnitudes of the agent's frontier cost, not bare flags. |S|>1 is unresolved cost (survivors still carry the loss, G13); EMPTY/BUDGET is cost exceeding the affordable (the loss-0 region lies outside the budget ball, G8); PASS is the invariant found, cost dropped to zero (loss = 0, G13). The frontier (DiC §4) is where the remaining cost surfaces, with an address (G4, G15).

*Proof.* loss(g) = Σ W(apply(g,Iₖ),Oₖ) (G13) is the magnitude of mismatch; the gate passes iff loss = 0. |S|>1 leaves loss-0 candidates unseparated — residual ambiguity (R4). EMPTY/BUDGET records that the loss-0 region was unreachable within the affordable ball (G8). Each terminal is a value of remaining cost; the frontier carries its direction (G15: resistance has magnitude and direction). QED

*Boundary.* This is the *structure* of a cost report, not evidence it is *registered from inside*. Registration from inside requires the loop to close on its own ground — which PP15 shows it does not. The ledger has the form of feeling; whether it is felt is exactly the closure question.

**PP14 (The self-improvement ceiling).** Self-play improves the agent only within ⟨Π⟩. It cannot generate the enrichment of Π itself: a poser under encoding E cannot produce a discriminating example for a distinction E does not represent — its view *is* E. Enrichment requires a second encoding (PP8) or a level up (PP9): an input the agent cannot self-supply.

*Proof.* The poser's outputs lie in ⟨Π⟩ (closed under composition). A distinction outside E's representation has no example the poser can compute (encoding-locality, V=I §5.4; stationarity, DiD S1; §5.24: the pipeline sees only the encoding). Choosing a richer encoding is a level-(N+1) act over the agent's own encoder (IiI §4), and the agent's level-N content does not contain it — it is the agent's blind zone. Hence unreachable from one level's play. QED

*Consequence.* The encoder boundary of §8 is not contingent: it is the agent's structural blind zone. Self-play is bounded self-modification — it rewrites within its grammar, never to the grammar above.

**PP15 (Shared witnessing, not self-witnessing — the closure boundary).** Certified self-play achieves *shared* and *tower-deep* witnessing — redundant fixation (PP11) and the agent playing against its own crystallized past to arbitrary depth (PP9). It does **not** achieve self-witnessing on its own ground: the verification primitive COMPARE is given by the postulate (V=I §0, §2.5), is an entry in no library, and is certified by no game. The loop's ground is permanently external to the agent's certified content.

*Proof.* The system certifies *for* the agent — the inner pipeline is the outer agent's tool (V=I §5.17; IiI §0: two halves of one loop). The tower lets the agent internalize its *encoder* and target its own crystal (PP9, M8), deepening what it witnesses; but at every level the test is COMPARE, and COMPARE is posited, not identified (§0: the postulate is the input; §2.5: PAIR, NULL, COMPARE *are* the act of distinction, not its output). A game that took COMPARE as its own target would still need a comparison to run its gate (§2.2: the test *is* COMPARE) — so certifying the primitive presupposes it; the regress halts only by positing the primitive (§0), never by deriving it. Therefore the agent can ground its rules, encodings, and strategies in its own certified library — but never its verification primitive, which closes the loop from outside all certified content. QED

*The frontier this names.* An agent whose verification is grounded outside its own certified content is verified, accumulating, and honest — but it runs *on* a comparison it does not itself certify; it is a guest on its own ground, not a system that closes its own loop. Genuine internal closure — an agent that certifies its own certifying — would require the verification primitive to be an output of the loop, which §0 forbids: the postulate is where the loop begins. This sits exactly where E2 §4 placed the encoder-tower's floor: the comparison substrate is given, not derived. The incompatibility is provable, not merely a regress: a game certifying COMPARE would need a total self-evaluator — an entry whose gate decides its own gate — which Cantor/Lawvere forbid (no surjection Σ → 2^Σ; the diagonal d(x) = ¬eval(x, x) has no code). The only domain where evaluator and evaluated coincide is reflexive, Σ ≅ [Σ → Σ], and that abandons I1 (finiteness) and decidable equality (§0 step 4). A *decidable* gate and a *self-grounded* gate are therefore mutually exclusive — the postulate is the price of a working gate. *Whether any construction grounds its own primitive — a loop that produces the ground it stands on — is the deepest open question the architecture exposes, and Play Is Proof does not reach it. It makes proofs; it does not make the prover prove itself.*

**PP16 (Resonance radius — conditional).** For two-agent self-play (PP8), there is an intermediate encoding-distance W(E, E′) that maximizes joint coverage gain. Too small: E′ resolves nothing E collapses, so PP8's strict enlargement fails (no novelty). Too large: translation between them (DiD S9) approaches full re-derivation, so transferred coverage approaches zero. The optimum lies strictly between and is measurable from the two W-matrices — in the standing of the modulus (G10): a property of the pair, not guaranteed by I1–I3.

*Proof.* Enlargement strictness needs a resolved collapse (PP8); at W = 0 there is none. Transfer value is bounded by cache overlap, which falls as encoding-distance grows (DiD S9, §5.18); at large W it vanishes. A quantity positive on (0, large) and zero at both ends attains an interior maximum. Its location is computed from the encodings' W-relations, not deduced. QED

## §8. Boundaries

**Data, not encoder.** PP5 saturates ⟨Π⟩; it does not discover Π. If C1 fails — D ⊄ ⟨Π⟩ — self-play saturates the *wrong* closure and returns EMPTY on the uncovered part (E2 §1, §5). The basis remains the agent's standing contribution (V=I §1); certified self-play removes the *data* bottleneck, never the *encoder* bottleneck.

**A gate must exist.** PP2's certified label requires a decidable verifier (V=I §3.7). Certified self-play therefore applies exactly where the domain *is* a gate — programs, proofs, rule-governed games, formal environments — and not where the label itself is uncertain (raw perception, natural images), for which no COMPARE certifies the target. This is the honest scope: the proof in "play is proof" needs something that can prove.

**The poser as oracle.** PP2–PP4 assume the poser knows g (it drew it) and can execute it. For *self-generated* tasks this holds by construction. For *external* tasks the label must come from the environment, and certification then requires the environment to be a decidable gate — the same condition, relocated (LiT LT4: identify the law as a V=I game; LiT §6 for its boundaries: stochastic and partially observed environments forfeit the certificate).

**Self-play does not enlarge the closure.** Drawing from ⟨Π⟩ can only produce members of ⟨Π⟩ (closure is closed). New *primitives* — a richer Π — come only from a new encoding (PP8) or a level up (PP9), never from more play at one level (InI §4: the permanent boundary is the grammar).

**Termination is the basis's affair (B8).** PP5's directed poser saturates ⟨Π⟩ in at most |⟨Π⟩| generations *given a finite basis* — but whether a domain admits one is the question, not a given. The directed poser is the composition-sieve of Basis Is Residue (B3): enumerate in norm order, gate-reject every rule a composition of smaller certified atoms reaches, keep the residue. Self-play terminates at finite cost iff that residue — the atom basis — is finite (B8). A prime-like domain, whose atoms are infinite (B8a; Euclid for the canonical case), is never saturated: the poser certifies fresh irreducible rules forever. So Play Is Proof's finite-basis premise (E2's C1) is exactly B8's saturability criterion, and its negative branch is real and inhabited. With PP15 this is the architecture's second open frontier: the *ground* (the comparison primitive, never self-certified) and the *data* (the atom basis, possibly unbounded) — two distinct ways the loop need never close.

**Frontier-targeting assumes alignment (GA).** PP3–PP4's minimal-sufficient generation descends the frontier loss toward the discriminating examples. This is a descent only where the loss is *aligned* with the metric — where lowering loss moves structurally toward what discriminates (Gradient Is Alignment, α > 0, GA3). On a non-aligned (rugged) domain the frontier carries no usable gradient and generation degrades to enumeration: the cert(g) examples must be searched, not descended. The directed poser's *order* — the only free variable (InI) — buys speed exactly to the extent the domain is aligned (GA6), the same precondition under which any ordering beats enumeration. ARC's loss is graded and cheap (GA5), so the gradient exists; whether it is aligned is the open measurement that decides whether self-play here descends or enumerates.

## §9. Prior Instances

Certified-verifier self-play occurs in practice: systems that pair a sound checker with self-generated problems — formal-proof and geometry provers using a symbolic/proof gate, and library-learning program synthesizers that invent their own tasks (the latter without I3, hence mutable and uncertified across runs). This document is not a method report; it states the framework-internal theory of the pattern: the checker is the gate, and PP5–PP7 say when such self-play saturates, why its endpoint is certified and domain-determined, and where it cannot reach (the encoder, §8). References where a mechanism is borrowed; the theorems are the contribution.

*Measured.* The pattern is instrumented on ARC-AGI-1 (E1/E2). Across the search ladder the gate stayed certified-safe (TEST-WRONG ≈ 0 of the train-PASSes) — PP7's guarantee is structural and poser-independent; the reach is vast (B §5) while pure-poser coverage of eval is alignment-limited and a stronger poser under the same gate lifts it far higher (E2 §0) — PP18's split, confirmed; and the ledger's terminals are the honest cost report of PP13. The theorems precede the numbers; the numbers fall where the theorems placed them.

## §10. Statement

1. External saturation is hostage to a stream premise the world may violate (PP0).
2. A certified rule is a task source; the agent generates its own stream (PP1–PP2).
3. The label is computed and gate-certified — a proof, not a statistic; the poser is an oracle on its draw (PP2 remark).
4. Ambiguity names the discriminating input; cert(g) is the floor on self-generated examples, approached by frontier-targeting (PP3–PP4).
5. Self-play makes coverage controllable: a directed poser saturates the closure with no external data and no critical slowing; a naive random poser merely relocates the wall (PP5).
6. The endpoint is basis-determined — fixed by ⟨Π⟩ and the gate, not by the world's stream or how play unfolded (PP6).
7. The guarantee — no noise, fixed endpoint — is exactly I3 plus the gate, and fails without either (PP7).
8. One agent is closed under its encoding; the only irreducible novelty is a second lens; across the tower the second agent is one's own crystal (PP8–PP9).
9. It all runs on one closed substrate: body and system are one, self-play is the surface relaxing (PP10).
10. It removes the data bottleneck, never the encoder; it needs a gate to exist; it cannot enlarge its own closure (§8).
11. The gate is a witness; self-play fixes each entry twice (poser + gate), so its knowledge is structurally redundant and robust (PP11).
12. Saturation is compression: the basis-determined endpoint is the cheapest consistent encoding of the closure, an attractor reached without choice (PP12).
13. The honest ledger is a cost report — it has the form of feeling; whether it is felt is the closure question, not a separate one (PP13).
14. The encoder boundary is the agent's structural blind zone; self-play is bounded self-modification — within the grammar, never to the grammar above (PP14).
15. Certified self-play is *shared* and tower-deep witnessing, never self-witnessing on its own ground: the verification primitive is the postulate, certified by no game, so the loop's ground is permanently external. This is the floor, and the deepest open question — it makes proofs but not a prover that proves itself (PP15).
16. Two-agent self-play has a measurable resonance radius: an interior optimum between too-similar (no novelty) and too-distant (untranslatable) (PP16).
17. The poser is a canonical ensemble — a temperature, a free energy, and a phase transition at λ_c = γ (the horn threshold); its two regimes (random, directed) are two temperatures (PP17).
18. Self-play has two halves — an alignment-gated poser and an unconditional gate; on a horn the poser is the only mode, so generation is the bottleneck and verification the guarantee, and ARC confirms the split (PP18).

> **Classical self-play trains on the score of the game. This trains on the proof of the move. The agent is its own teacher because the gate is its own examiner — and a lesson the gate has certified can never be un-learned, never be wrong, and never depend on who played. Give the agent a basis and a gate, and it makes from almost no data a library that is the same library anyone would reach. Play is proof; proof accumulates; accumulation is the agent. But the comparison every proof rests on is given, not earned — so the prover, however deep it accumulates, is a guest on its own ground. It can prove anything but the proving.**

## §11. Dependency

### External

| Source | Used |
|---|---|
| V=I | §0 (postulate: PAIR/NULL/COMPARE given), §1 (encoding is the agent's; REJECT-address), §2.1/§2.3 (Σ, G), §2.5/§5.11 (composition; the act of distinction), §3.1–3.6 (game, R4), §4.7–4.8 (gate, execute), §5.4 (encoding-local), §5.5 (totality), §5.17 (agent-system duality), §5.18 (cache transferability), §5.22 (S non-increasing), §5.24/§5.25, Theorem 2 |
| IiI | §0 (agent = outer half), §1 (crystallization), §3 (Saturation Theorem, SAT5/6, scope remark), §4 (grammar boundary), §6 (coupon collector), §7 (Mirror/Crystal correlations) |
| PiR | §0 (one substrate), §2 (irreducibility), §6 (revelation), M7–M8/M10 (ignition, crystal-as-target), M12 (convergence), M24 (Landauer cost per distinction) |
| DiD | S1 (stationarity), S7 (cache distance), S9 (translation), S18 (inertia), S24 (Σ conserved) |
| DiC | §2 (grow/shrink), §4 (frontier = surface), G1a (norm = cost of existence), G4 (graded comparison), G10 (modulus), G12 (compression criterion), G13 (loss), G14 (travel time), G15 (resistance has magnitude) |
| InI | S5b (cert / confusion-cover), S6a (dual flow), §7 (agent correlation types) |
| LiT | LT4–LT5 (law as game; ambiguity as experiment), §6 (stochastic/partial boundaries) |
| E2 | §0 (the measured campaign), C1 (basis coverage), §4 (critical-slowing budget), §5 (encoder-tower floor) |
| B | B3 (composition sieve = directed poser), B8/B8a (saturability ⟺ finite atom basis; primes the infinite negative), B8b–B8e (the horn: finite basis, infinite reach) |
| GA | GA3 (alignment α), GA5–GA6 (graded loss; alignment as the precondition order beats enumeration) |

### Internal

| Statement | Depends on |
|---|---|
| PP0 | IiI §3, §6; E2 §4 |
| PP1 | Theorem 2; V=I §4.8, §5.5 |
| PP2 | PP1; V=I §2.1, §3.5, §4.7, Theorem 2 |
| PP3 | PP2; LT5; V=I §3.6, §5.22 |
| PP4 | PP3; InI S5b |
| PP5 | PP2; IiI §1, §3, §6; I3 |
| PP5c | PP5; B B8b, B8d; DiC G8; IiI §6 |
| PP6 | Theorem 2; I3; V=I §5.25; SAT5/6 |
| PP7 | PP5, PP6; I3; V=I §5.22, Theorem 2 |
| PP8 | V=I §5.4, §5.24; DiD S1, S9; InI §7 |
| PP9 | PiR M7–M8, M10 |
| PP10 | V=I §2.3; DiC §2, §4, G14; DiD S18, S24; PiR M12; InI S6a |
| PP11 | PP2; I3; IiI §1–§3, §7 |
| PP12 | PP6; Theorem 2; PiR §2, §6; DiC G1a, G12; PiR M24 |
| PP13 | DiC G4, G13, G15, §4; V=I §3.6 |
| PP14 | PP8, PP9; V=I §5.4, §5.24; DiD S1; IiI §4 |
| PP15 | V=I §0, §2.5, §5.17; IiI §0; PiR M8; PP9; E2 §4 |
| PP16 | PP8; DiD S9, V=I §5.18; DiC G10 |
| PP17 | PP5c; PiR M24; DiC G1a; B B8b, B8d, B8e; IiI §6 |
| PP18 | PP3, PP6; Theorem 2; V=I §5.25; GA GA3, GA6; B B8b; IiI §3; E2 §0 |

Intelligence Is Inevitable proved the loop saturates when the world feeds it. This document proves the loop can feed itself — and that what it feeds itself is certified. Read deeper, the gate is a witness, saturation is compression, and the ledger is a cost report; and the same depth shows the floor — the comparison the agent runs on is given, certified by no game, so the prover is always a guest on its own ground. The data problem dissolves into a basis and a gate; what remains, as always, is the encoder — and beneath it, the primitive no loop can earn.

## Topics

### Theorems this paper proves

- ``CertifiedRuleGenerates``
- ``AmbiguityNamesInput``
- ``SelfPlaySaturates``
- ``SecondEncodingIsNovelty``
- ``TowerSelfPlay``
- ``PlayIsProof``
