# The Solvability Criterion for ARC (Specification)

The framework delegates one thing and proves the rest. Every paper states it: *encoding is the agent's contribution; correctness is the system's guarantee* (V=I §1). This document takes that delegation seriously and asks what it leaves unsaid. The delegated slot is not a void — it is typed. A grammar that solves ARC must satisfy conditions the theorems already name: reach the rules (coverage), pin them from few examples (discrimination), make their space compress (generalization), place the held-out rules inside anchored balls (distribution), route to those balls (modulus), and find a certifiable rule inside the ball within budget (certifiability). Each is decidable or measurable on a candidate grammar. Together they convert "can ARC be solved, and how" from an aspiration into a specification: a conditional theorem whose consequent splits into a *safety* half that is fully proven and a *completeness* half that is budget- and certifiability-bound, and whose antecedent — a grammar meeting the conditions — is the entire open problem, now stated exactly. The contribution is not a solver. It is the type signature of one, the precise split between what is proven and what is delegated, and a proof of the proven half.

## §0. The Factorization

A solver of ARC factors into two parts, and the framework owns one of them completely.

```
   [ ENCODER ]                  →    [ V=I BACKEND ]
   grammar E* of features;            verify, identify, accumulate,
   the prior; supplied or learned     order, navigate, ball-route
   (the open problem)                 (papers 1–9; certified-SAFE)
```

The encoder is the agent's contribution (V=I §1; IiI §0, Source). The backend is the system, proven total and safe (V=I §5; IiI §3) — its guarantee is *never a wrong PASS* (Theorem 2), not *always a PASS*. ARC-AGI was designed to defeat r=0 agents — pure memoization (E1 §0; Chollet's core-knowledge priors). By the factorization, that design targets the encoder exclusively: it demands a grammar whose geometry is not flat. The backend is invariant to the attack. **The difficulty of ARC and the scope of V=I are disjoint by construction.**

*The factorization is measured, not posited.* The deep-end campaign (ARC_RESULTS.md) climbed monotonically to ≈74–80% pass@2: the hand-DSL grammar saturated dry at ≈9.8% (IiI §4 grammar boundary — a certificate, not a failure), and an LLM Source reading the train pairs (IiI §3: an approximate Source; the gate carries all guarantees) carried the rest, with the backend producing **zero wrong PASSes beyond 4 permanent TEST-WRONG**, all four at the evidence-sufficiency boundary (wide rule families under 2–4 train pairs — the R4 |S|>1 boundary, not backend faults). Difficulty localized to the encoder; the backend stayed certified-safe throughout. §1 specifies the encoder the backend requires.

## §1. The Conditions

Fix a grammar E\* and the evaluation set D_eval. The conditions split into two groups with a strict dependency, not into independent atoms.

**Constitutive (they make the rule f\*(τ) denote):**

**C1 (Coverage).** For every τ ∈ D_eval, f\*(τ) lies in the reachable closure of E\*. *Source: IiI §4 — the permanent boundary is the grammar; a rule outside it is permanent EMPTY. V=I Theorem 4 guarantees some grammar represents any finite deterministic task; C1 demands this fixed E\* does.* Decidable per task as the ledger fork EMPTY vs PASS within budget (E1 §4).

**C2 (Discrimination).** For every τ, some encoding e ∈ E\* makes |S_e(τ)| = 1 on τ's two-to-five training pairs. *Source: R4 (V=I §3.5), decidable (§3.6); the confusion-cover of InI S5b.* The failure is silent: an encoding yielding |S|=1 spuriously selects the wrong f\* — train-PASS, test-wrong. The TEST-WRONG count is the measured C2 deficit (campaign: 4/≈322).

**Predicates over the certified rule set {f\*(τ)} (each presupposes C1∧C2 — they are stated in the encoding-local W-metric, DiC §11, which requires f\*(τ) realized and unique):**

**C3 (Compression).** {f\*(τ)} is r-compressible for some r > 0: N(r) < K (DiC G12); equivalently a modulus (G10) or a retrieval profile with mass below 50% (G10a). The flat case N(r)=K is "nothing to learn, only memorize." Measurable from the W-matrix of *certified* rules.

**C4a (Anchoring — the distribution bet).** Every eval rule lies within 2r of some *training* anchor: ∃ a ∈ L_train, W(f\*(τ), f\*(a)) ≤ 2r (DiC G11). This is a sample-saturation property — a coupon-collector fact about which balls training happened to hit (IiI §6), *not* a grammar property.

**C4b (Routing — the modulus).** Task-side proximity finds the anchor of C4a: the anchor nearest τ under task-side W is one whose rule satisfies C4a. *Requires the strong modulus G10.* Under the weak (G10a) regime, C4b holds only statistically — routing beats random but is not guaranteed to reach the 2r-anchor; the protocol then falls back to scanning anchors (G10 fallback), and the per-query cost is O(N(r)) scans, not one routed ball.

**C5 (Within-ball certifiability).** For the routed anchor a, the W-ordered stream over B(f\*(a), 2r) reaches a candidate compiling to f\*(τ) within budget. *Source and warning: DiC G8 proves the ball is a finite set of Σ-structures; it does **not** prove the ball contains a certifiable RULE the search reaches. NiG N15 is explicit: the region is never empty in Σ, but whether it holds a certifiable entry "is the domain's affair — acquisition, not deduction."* C5 is the navigability/non-blankness of the ball interior (NiG N11), at the operative radius and budget.

**Dependency, not independence.** {C1,C2} are *constitutive* of the point f\*(τ); {C3,C4a,C4b,C5} are *predicates* over it, each well-formed only when C1∧C2 hold. The honest claim is not "four (or six) independent conditions" but **distinct failure modes over one dependency chain** — and each maps to a ledger terminal: EMPTY (C1), |S|>1 (C2), flat-matrix (C3), no-anchor (C4a), scan-blowup (C4b), BUDGET / empty-in-ball (C5).

## §2. The Conditional Theorem

**E2.1 (Conditional solving, split).** If E\* satisfies C1–C5 with radius r, then a V=I agent on D_eval is:

- **Certified-SAFE (unconditional, proven):** every PASS it returns is f\*(τ) (Theorem 2 — safety is independent of how the candidate was found, DiC G9). It is *never wrong*; non-solves return a named ledger state (EMPTY / |S|>1 / BUDGET), never a wrong answer (V=I outcome corollary).
- **Certified-COMPLETE within budget (conditional on C5):** it returns PASS(f\*(τ)) for every τ whose ball interior is certifiable and searched within budget. Completeness rests on enumeration of the ball (V=I §5.10), bounded by C5; it is *not* claimed unconditionally.

```
ROUTE   τ to its nearest training anchor a (G9; guaranteed-on-target only under G10/C4b,
        else a scan — see C4b)
SEARCH  B(f*(a), 2r) under the compilation gate, W-ordered                 (G8 finite, G11, G13)
RETURN  PASS(f*(τ)) [safe by Thm 2]  or  EMPTY / |S|>1 / BUDGET [named]      (V=I §1; E1 §4)
```

*Proof of the safe half.* Any PASS is certified by compilation regardless of search (Theorem 2). Termination: the ball is finite (G8) and the budget caps the stream. Every terminal state is PASS-with-proof or a named failure. The completeness half adds C5 (a certifiable survivor is present and reached before budget) and, for cost, C4b (routing reaches it rather than scanning). QED

**E2.2 (Training cost).** Under C3–C4a, training is ball-saturation. With *uniform* hit probability over the N(r) eval-relevant balls, the expected number of training tasks to anchor them all is the coupon-collector value N(r)·H_{N(r)} ≈ N(r)·ln N(r) (IiI §6; DiC G11), a **lower bound** in general. Under *non-uniform* hits it is larger, dominated by the rarest ball: E[τ_sat] ≥ N(r)·H_{N(r)}, with the last ball costing ≈ 1/p_min (critical slowing, IiI §6). The "large prior the agent must hold" is the anchored cover — N(r) entries, not K.

**E2.3 (No memoization — a two-branch fork).**
- (a) *Trivial, grammar-invariant:* any r=0 accumulation (one stored answer per task) covers only exact matches (G11 at r=0 = the Saturation Theorem), so it cannot generalize to eval ≠ train. Airtight, and it is the trivial half.
- (b) *Load-bearing, grammar-relative:* whether ARC *forces* content-level r=0 depends on the grammar, since K is a property of (ARC, grammar). Under the standard DSL, K₁ ≈ #tasks (measured: 391/400 ≈ 98% distinct), so that grammar admits no content compression and degenerates to r=0. But this is not grammar-invariant: a coarser lens already lowers K (K₂(signatures)=181 < K₁=391, §4). Whether *some* grammar achieves K ≪ #tasks (an interior r) is precisely the C3 open question — and K₂ is first evidence it can.

The ARC-specific exclusion of memoization therefore rests on the train/eval condition (C4a, unmeasured) plus the grammar-relative K, not on train-internal K₁ alone.

## §3. The Necessary Structure of Any Solver

**E2.4 (Two layers, relative to a covering grammar).** Relative to any fixed generating set Π whose closure covers D_eval, any system that solves D_eval without memorizing it must realize C1–C5: (i) a grammar reaching and resolving the rules — an encoder — over (ii) generalization within a compressing geometry — an r>0 ball-router. A system with only (i) and r=0 is a memorizer (E2.3a); with only (ii) and no covering grammar it returns EMPTY (C1). The forcing is *intra-closure*; NFL (inter-closure, §5) does not contradict it. This is the framework's structural prediction about the form of any ARC-solving intelligence — the shape the field's working systems already take (DSL+search; perception+synthesis): the only shape C1–C5 admit, given a covering Π. *(This is the note's most robust claim: it is the contrapositive of E2.3 over the one-boundary result G12/N18.)*

**E2.5 (Where the difficulty must live).** The backend is proven-safe; C1–C2 (expressiveness) and C3–C5 (geometry + reachability) are conditions on the encoder. All irreducible difficulty of ARC is the construction of E\* — perception, abstraction, the priors. The framework does not remove this difficulty; it *localizes* it exactly and proves safety around it. The campaign measured this localization: difficulty in the encoder (the 9.8%→74% climb was Source quality), backend certified-safe throughout.

## §4. What ARC-1 Measured, Against the Conditions

The geometry study (this session's scripts `arc_phase2*.py`, `arc_phase3_omega.py`; not yet folded into E1's committed numbers) reads as evidence for one grammar (Hodel's DSL):

| Condition | ARC-1 evidence | Reading |
|---|---|---|
| C1 Coverage | 400 train solvers certified; eval climb to ≈74–80% (LLM Source) | holds broadly; the deep EMPTY tail is where C1 is still open |
| C2 Discrimination | 4 permanent TEST-WRONG of ≈322 train-PASS (≈1.2%) | holds 98.8%; deficit measured, all at the |S|>1 boundary |
| C3 Compression | **form-relative** (see below) | r=0 out under content-W; r>0 thin, template-level |
| C4a Anchoring | **not measured on eval** | the decisive distribution bet |
| C4b Routing | G10a domain — **no global modulus, retrieval present** | routing is statistical, not guaranteed; scan-fallback |
| C5 Certifiability | content ball-interiors plausibly certifiable-sparse | partial evidence *against* C5 at content radius |

**C3 is form-relative — "flat" is a choice of metric, not a property of the domain.** Under cost-W the full-set declared fork reads CLUSTERED (canon N(diam/4)=27 ≤ threshold 97, δ=12); it flips to FLAT only after size-control / bulk-trimming (101 vs 88), and that flip is lens-sensitive (CLUSTERED again under the inline encoding). Under the **resolution form** d_k (DiC G5) it is CLUSTERED at every depth, size-clean, with covering curve N(diam/4) = 2,3,3,6,11,61 (k=2..12) surviving per-band size control — a coarse-to-fine generative cone. And the signature lens gives **no global modulus but a real retrieval signal** (Spearman(W_sig,W_rule)≈0; sig-NN rule-distance percentile median 38% < 50%) — exactly DiC G10a, "the form the world tends to offer." K₂(signatures)=181 < K₁=391. The honest verdict is not "flat" but: *content carries no smooth modulus and compresses only under the resolution/template view; ARC under a standard grammar is a G10a domain.*

**The G10a decomposition (qualitative; the over-formalized versions did not survive verification).** Three things that look like one "generalization signal" decouple: (1) the retrieval *percentile* is a **cost** prior — it cuts expected gate calls (an S4a / Y-axis effect; measured P6 ordering speedup ≈9–28× over random, beyond the naive 1/(2·0.38)≈1.3× floor, because passing programs cluster tighter than the median anchor); (2) the *absolute* nearest-anchor distance is a **coverage** prior — it, not the percentile, governs the solvable fraction (C4a); (3) the presence of a modulus ω is a **radius-predictability** prior — the only thing strong-G10 buys over G10a, and it buys cost-predictability, never soundness (G9/Theorem 2 are order-invariant). ARC's design grants the cheap thing (ranking) and withholds the expensive thing (a global law) — leaving coverage (C4a) the real, unrun question.

**A sample-budget prediction (critical slowing).** Saturating the template cover (N=K₂=181) needs ≈ N·H_N ≈ 1046 uniform tasks; ARC-1 supplies 400. Under any skew the rarest template ball costs ≈1/p_min alone (hundreds to thousands of tasks). So ARC-1's training set is **provably below saturation of its own template cover**, and critical slowing places the unanchored balls at the rarest templates — the novel-combination hard tasks the benchmark is built from. This predicts the *sign* of the unrun C4a measurement (fail-on-rarest under the 400-task budget) and attributes the hard tail to a sample-budget wall, separable from grammar-coverage (BUDGET vs EMPTY, E1 §4).

## §5. The Open Antecedent

**NFL does not doom C4 — it is quantifier-disjoint.** IiI §4's no-free-lunch is ∀D-with-E-fixed (no protocol wins averaged over all distributions). ARC's claim is the dual ∃E\*-with-D_ARC-fixed. NFL never says "for the fixed D_ARC no E works." The framework already holds both: fixed-(D,E) saturation is a theorem (IiI §3 + Remark); all-D NFL is the boundary (IiI §4). They are the same statement at two quantifier scopes — intelligence beyond memoization exists exactly where the *fixed* closure's rule space is W-compressible (G12 remark), and NFL is that no *single* closure compresses *all* D. So the genuinely load-bearing ARC question is **C1** — does a finite generating set Π (Chollet's core priors) have a composition-closure containing D_ARC — not C4a, which is the measurable shadow C1 casts on a train/eval split. The campaign's fingerprint (74% with TEST-WRONG=4 at the |S|>1 boundary, a deep EMPTY tail) is exactly a *finite-but-incomplete* Π.

**Three values, not two.** Generalization is not binary: (A) *impossible* — over all D / all eval sets (NFL); (B) *reachable but not generalized* — τ inside closure(E\*) (C1 holds) yet outside every anchored ball (C4a fails): solved only from scratch, the r=0 regime ARC defeats by design; (C) *generalized* — τ inside closure AND inside an anchored r>0 ball (C1∧C3∧C4): certified ball-routing, after N(r)·H_{N(r)} training. The clean theorem is the conditional E2.1; generalization proper lives entirely in the r>0 geometry (C3–C5), which is measurable but **not guaranteed** (DiC §11).

**The encoder regress — a two-floor resolution (correcting this note's earlier binary).** The earlier draft asked whether the prior bottoms out in a finite universal prior *or* regresses. Both horns are wrong as posed, because they conflate two floors the series keeps strictly separate:

- The **comparison substrate** — PAIR, NULL, COMPARE — is genuinely floored by the postulate (V=I §0 steps 1–4, §2.5): nothing runs below the first distinction. But this substrate carries **no perceptual content** (V=I §5.21: PAIR/NULL produce no information about existing structures; COMPARE only classifies equality). It is the *medium* of comparison, not a rung of perception.
- **Perception is the feature grammar** (DiD S3, S5: "the dimensionality lives in the agent's encoding apparatus, the target contributing none"), and it is delegated *all the way down* to an agent-given base grammar (V=I §4.4 "features predefined per domain"; the permanent grammar boundary, IiI §4). It is not floored by the postulate.

So the encoder ascends as a crystallization tower (rules → encodings → grammars; PiR §4) whose level-(N≥1) features are *discovered* by COMPARE over crystals (InI S8a) in the **coverage** regime, not the identification regime (IiI §4 meta-saturation: "not a unique f\* — the agent needs any one"; uniqueness only via an imposed tie-breaker, OiO O8). That tower terminates **if** the domain compresses at every level (PiR M16 *sufficient*, not necessary; the K_{N+1}≤2^{K_N} bound permits non-termination, M15; criterion: first metrically-uniform level, OiO O19/G12). Acquiring E\* by meta-saturation has a cost: |H\*|·H_{|H\*|}, where H\* is a minimal hitting set of working encoding-classes — the same coupon-collector arithmetic, one level up, with the same N<K compressibility precondition.

*The verdict:* the postulate floors the *medium*; perception (the grammar) is delegated at its own base and is conditionally derivable above it, up to the level where the domain stops compressing — and no further. E2's open antecedent "find E\*" is permanently delegated at the perceptual base and conditionally closable above it, the boundary being a measurable number (the metrically-uniform level, G12/O19). The only "finite universal prior" the framework admits is the postulate's primitive triple — universal because domain-independent, but it is the comparison medium, not a learned perceptual prior.

**Interactive extension.** ARC-AGI-3 environments extend C1–C5 through Law Is Target (LT4: identify the transition law f as a V=I game) and inherit its boundaries (LiT §6): the encoder must supply state/action features, and the conditions apply to the law's space.

## §6. Statement

1. A solver factors into encoder (delegated) and V=I backend (proven-safe); ARC's difficulty targets the encoder alone, and the campaign measured this (§0).
2. The encoder is typed: coverage (C1), discrimination (C2) — constitutive; compression (C3), anchoring (C4a), routing (C4b), within-ball certifiability (C5) — predicates over the certified rules; distinct failure modes over one dependency chain (§1).
3. C1–C5 imply certified **safety** unconditionally and certified **completeness** only within budget and C5; training is N(r)·H_{N(r)} as a uniform lower bound, dominated by the rarest ball otherwise (E2.1–E2.2).
4. No-memoization is a two-branch fork: r=0 can't generalize (trivial, grammar-invariant); the standard grammar forcing content-r=0 is measured and grammar-relative, with K₂=181 first evidence a coarser grammar lowers it (E2.3).
5. Relative to a covering grammar, any non-memorizing solver must be two-layer; NFL is inter-closure and does not contradict this (E2.4–E2.5).
6. ARC-1 under a standard grammar is a G10a domain: a cost discount (retrieval), no coverage guarantee (no modulus), content compressing only in the resolution/template form; C4a, C4b, C5 on eval are the decisive unrun frontier, and a sample-budget wall is predicted at the rarest templates (§4).
7. The open antecedent is the finiteness-and-coverage of the prior set Π (C1); perception is delegated at its base and conditionally closable above, the postulate flooring only the comparison medium (§5).

> **The theory never promised to see. It promised that, given sight, it is never wrong — and it names exactly what sight must deliver, and exactly which half of "solve" it can prove. Safety is unconditional; completeness is compression plus a budget; perception is the standing debt. The boundary between proven and delegated is, as ever in this series, a number you can compute.**

## §7. Dependency

| Source | Used |
|---|---|
| V=I | §1 (encoding is the agent's), §3.5–3.6 (R4), §5.10 (completeness by enumeration), §5.21 (PAIR/NULL carry no information), §5 (safety), Thm 2, Thm 4 |
| IiI | §3 (Saturation Theorem, K; scope Remark), §4 (grammar boundary; NFL ∀D-with-E-fixed; meta-saturation = coverage), §6 (coupon collector, critical slowing) |
| DiC | G8 (finite balls — of Σ-structures, not of certifiable rules), G9 (W-order; safety order-invariant), G10/G10a (modulus / retrieval modulus), G11 (ball saturation), G12 (compression criterion; flat = memorize), §11 (encoding-local geometry; G10–G12 not guaranteed) |
| NiG | N11 (navigable ball interiors), N15 (certifiable entry is the domain's affair — the C5 warning), N18 (one boundary) |
| OiO | O8 (uniqueness only by tie-breaker), O13 (strategy saturation), O19 (tower terminates at metrically-uniform level) |
| InI | S4a (Y-axis ordering value), S5b (cert), S8a (level invariance — mechanism, in coverage regime) |
| PiR | M16 (tower termination — sufficient premise), M28 (finite total discovery cost) |
| DiD | S3, S5 (perception = the encoding apparatus's dimensionality) |
| LiT | LT4, §6 (interactive extension and its boundaries) |
| E1 | §0 (r=0 defeat by design), §4 (ledger forks EMPTY/|S|>1/BUDGET), §7 (K₂ ignition — specified; this session realized a version, not yet committed) |

The series proved what happens after the encoding is fixed, and proved it as *safety*. This note states what the encoding must be for ARC, splits the consequent into the safety it can prove and the completeness it cannot, and localizes the whole open problem in the finiteness of the prior. The conditions are the type of a solver; the open problem is an inhabitant of that type; and the proof stops, honestly, where sight begins.
