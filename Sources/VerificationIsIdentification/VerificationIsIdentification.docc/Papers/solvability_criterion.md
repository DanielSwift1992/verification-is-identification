# The Solvability Criterion (Specification)

The framework delegates one thing and proves the rest. Every paper states it: *encoding is the agent's contribution; correctness is the system's guarantee* (V=I §1). This document takes that delegation seriously and asks what it leaves unsaid. The delegated slot is not a void — it is typed. A grammar that solves a domain must satisfy conditions the theorems already name: reach the rules (coverage), pin them from few examples (discrimination), make their space compress (generalization), place the held-out rules inside anchored balls (distribution), route to those balls (modulus), and find a certifiable rule inside the ball within budget (certifiability). Each is decidable or measurable on a candidate grammar. Together they convert "can a domain be solved, and how" from an aspiration into a specification: a conditional theorem whose consequent splits into a *safety* half that is fully proven and a *completeness* half that is budget- and certifiability-bound, and whose antecedent — a grammar meeting the conditions — is the entire open problem, now stated exactly. The contribution is not a solver. It is the type signature of one, the precise split between what is proven and what is delegated, and a proof of the proven half.

## §0. The Factorization

A solver of a domain factors into two parts, and the framework owns one of them completely.

```
   [ ENCODER ]                  →    [ V=I BACKEND ]
   grammar E* of features;            verify, identify, accumulate,
   the prior; supplied or learned     order, navigate, ball-route
   (the open problem)                 (papers 1–9; certified-SAFE)
```

The encoder is the agent's contribution (V=I §1; IiI §0, Source). The backend is the system, proven total and safe (V=I §5; IiI §3) — its guarantee is *never a wrong PASS* (Theorem 2), not *always a PASS*. A domain designed to defeat r=0 agents — pure memoization — targets the encoder exclusively by the factorization: it demands a grammar whose geometry is not flat, and the backend is invariant to the attack. **A domain's difficulty and the scope of V=I are disjoint by construction.**

## §1. The Conditions

Fix a grammar E\* and the evaluation set D_eval. The conditions split into two groups with a strict dependency, not into independent atoms.

**Constitutive (they make the rule f\*(τ) denote):**

**C1 (Coverage).** For every τ ∈ D_eval, f\*(τ) lies in the reachable closure of E\*. *Source: IiI §4 — the permanent boundary is the grammar; a rule outside it is permanent EMPTY. V=I Theorem 4 guarantees some grammar represents any finite deterministic task; C1 demands this fixed E\* does.* Decidable per task as the ledger fork EMPTY vs PASS within budget.

**C2 (Discrimination).** For every τ, some encoding e ∈ E\* makes |S_e(τ)| = 1 on τ's few training pairs. *Source: R4 (V=I §3.5), decidable (§3.6); the confusion-cover of InI S5b.* The failure is silent: an encoding yielding |S|=1 spuriously selects the wrong f\* — train-PASS, test-wrong. The TEST-WRONG count is the C2 deficit, a measured property of the grammar.

**Predicates over the certified rule set {f\*(τ)} (each presupposes C1∧C2 — they are stated in the encoding-local W-metric, DiC §11, which requires f\*(τ) realized and unique):**

**C3 (Compression).** {f\*(τ)} is r-compressible for some r > 0: N(r) < K (DiC G12); equivalently a modulus (G10) or a retrieval profile with mass below 50% (G10a). The flat case N(r)=K is "nothing to learn, only memorize." Measurable from the W-matrix of *certified* rules — and lens-relative: flatness is a choice of metric, not a property of the domain (IiI §7).

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
RETURN  PASS(f*(τ)) [safe by Thm 2]  or  EMPTY / |S|>1 / BUDGET [named]      (V=I §1)
```

*Proof of the safe half.* Any PASS is certified by compilation regardless of search (Theorem 2). Termination: the ball is finite (G8) and the budget caps the stream. Every terminal state is PASS-with-proof or a named failure. The completeness half adds C5 (a certifiable survivor is present and reached before budget) and, for cost, C4b (routing reaches it rather than scanning). QED

**E2.2 (Training cost).** Under C3–C4a, training is ball-saturation. With *uniform* hit probability over the N(r) eval-relevant balls, the expected number of training tasks to anchor them all is the coupon-collector value N(r)·H_{N(r)} ≈ N(r)·ln N(r) (IiI §6; DiC G11), a **lower bound** in general. Under *non-uniform* hits it is larger, dominated by the rarest ball: E[τ_sat] ≥ N(r)·H_{N(r)}, with the last ball costing ≈ 1/p_min (critical slowing, IiI §6). The "large prior the agent must hold" is the anchored cover — N(r) entries, not K.

**E2.3 (No memoization — a two-branch fork).**
- (a) *Trivial, grammar-invariant:* any r=0 accumulation (one stored answer per task) covers only exact matches (G11 at r=0 = the Saturation Theorem), so it cannot generalize to eval ≠ train. Airtight, and it is the trivial half.
- (b) *Load-bearing, grammar-relative:* whether a domain *forces* content-level r=0 depends on the grammar, since K is a property of (domain, grammar). A grammar as fine as one-rule-per-task admits no content compression and degenerates to r=0; a coarser lens lowers K. Whether *some* grammar achieves K ≪ #tasks (an interior r) is precisely the C3 open question.

The exclusion of memoization therefore rests on the train/eval condition (C4a) plus the grammar-relative K, not on train-internal K alone.

## §3. The Necessary Structure of Any Solver

**E2.4 (Two layers, relative to a covering grammar).** Relative to any fixed generating set Π whose closure covers D_eval, any system that solves D_eval without memorizing it must realize C1–C5: (i) a grammar reaching and resolving the rules — an encoder — over (ii) generalization within a compressing geometry — an r>0 ball-router. A system with only (i) and r=0 is a memorizer (E2.3a); with only (ii) and no covering grammar it returns EMPTY (C1). The forcing is *intra-closure*; NFL (inter-closure, §4) does not contradict it. This is the framework's structural prediction about the form of any solving intelligence — the shape working systems already take (grammar+search; perception+synthesis): the only shape C1–C5 admit, given a covering Π. *(This is the note's most robust claim: it is the contrapositive of E2.3 over the one-boundary result G12/N18.)*

**E2.5 (Where the difficulty must live).** The backend is proven-safe; C1–C2 (expressiveness) and C3–C5 (geometry + reachability) are conditions on the encoder. All irreducible difficulty of a domain is the construction of E\* — perception, abstraction, the priors. The framework does not remove this difficulty; it *localizes* it exactly and proves safety around it.

**E2.6 (The generalization signal decomposes).** What looks like one "generalization signal" splits into three independent priors, and a domain can grant one while withholding another:

- a *cost* prior — retrieval ranking cuts expected gate calls (a Y-axis effect, InI S4a); it speeds search and changes nothing about correctness;
- a *coverage* prior — the absolute nearest-anchor distance governs the solvable fraction (C4a); it, not the ranking, decides what is reachable;
- a *radius-predictability* prior — the modulus ω, the only thing the strong G10 buys over the weak G10a, and it buys cost-predictability, never soundness (G9/Theorem 2 are order-invariant).

A domain may grant the cheap prior (ranking) and withhold the expensive one (a global law), leaving coverage (C4a) the load-bearing question. The three were conflated whenever "does it cluster?" stood in for all of them.

## §4. The Open Antecedent

**NFL does not doom C4 — it is quantifier-disjoint.** IiI §4's no-free-lunch is ∀D-with-E-fixed (no protocol wins averaged over all distributions). A domain's claim is the dual ∃E\*-with-D-fixed. NFL never says "for the fixed D no E works." The framework already holds both: fixed-(D,E) saturation is a theorem (IiI §3 + Remark); all-D NFL is the boundary (IiI §4). They are the same statement at two quantifier scopes — intelligence beyond memoization exists exactly where the *fixed* closure's rule space is W-compressible (G12 remark), and NFL is that no *single* closure compresses *all* D. So the genuinely load-bearing question is **C1** — does a finite generating set Π have a composition-closure containing D — not C4a, which is the measurable shadow C1 casts on a train/eval split.

**Three values, not two.** Generalization is not binary: (A) *impossible* — over all D / all eval sets (NFL); (B) *reachable but not generalized* — τ inside closure(E\*) (C1 holds) yet outside every anchored ball (C4a fails): solved only from scratch, the r=0 regime a memorization-resistant domain defeats by design; (C) *generalized* — τ inside closure AND inside an anchored r>0 ball (C1∧C3∧C4): certified ball-routing, after N(r)·H_{N(r)} training. The clean theorem is the conditional E2.1; generalization proper lives entirely in the r>0 geometry (C3–C5), which is measurable but **not guaranteed** (DiC §11).

**The encoder regress — a two-floor resolution.** Whether the prior bottoms out in a finite universal prior *or* regresses conflates two floors the series keeps strictly separate:

- The **comparison substrate** — PAIR, NULL, COMPARE — is genuinely floored by the postulate (V=I §0 steps 1–4, §2.5): nothing runs below the first distinction. But this substrate carries **no perceptual content** (V=I §5.21: PAIR/NULL produce no information about existing structures; COMPARE only classifies equality). It is the *medium* of comparison, not a rung of perception.
- **Perception is the feature grammar** (DiD S3, S5: "the dimensionality lives in the agent's encoding apparatus, the target contributing none"), and it is delegated *all the way down* to an agent-given base grammar (V=I §4.4 "features predefined per domain"; the permanent grammar boundary, IiI §4). It is not floored by the postulate.

So the encoder ascends as a crystallization tower (rules → encodings → grammars; PiR §4) whose level-(N≥1) features are *discovered* by COMPARE over crystals (InI S8a) in the **coverage** regime, not the identification regime (IiI §4 meta-saturation: "not a unique f\* — the agent needs any one"; uniqueness only via an imposed tie-breaker, OiO O8). That tower terminates **if** the domain compresses at every level (PiR M16 *sufficient*, not necessary; the K_{N+1}≤2^{K_N} bound permits non-termination, M15; criterion: first metrically-uniform level, OiO O19/G12). Acquiring E\* by meta-saturation has a cost: |H\*|·H_{|H\*|}, where H\* is a minimal hitting set of working encoding-classes — the same coupon-collector arithmetic, one level up.

*The verdict:* the postulate floors the *medium*; perception (the grammar) is delegated at its own base and conditionally derivable above it, up to the level where the domain stops compressing — and no further. The only "finite universal prior" the framework admits is the postulate's primitive triple — universal because domain-independent, but it is the comparison medium, not a learned perceptual prior.

**Interactive extension.** Interactive environments extend C1–C5 through Law Is Target (LT4: identify the transition law f as a V=I game) and inherit its boundaries (LiT §6): the encoder must supply state/action features, and the conditions apply to the law's space.

## §5. Statement

1. A solver factors into encoder (delegated) and V=I backend (proven-safe); a domain's difficulty targets the encoder alone (§0).
2. The encoder is typed: coverage (C1), discrimination (C2) — constitutive; compression (C3), anchoring (C4a), routing (C4b), within-ball certifiability (C5) — predicates over the certified rules; distinct failure modes over one dependency chain (§1).
3. C1–C5 imply certified **safety** unconditionally and certified **completeness** only within budget and C5; training is N(r)·H_{N(r)} as a uniform lower bound, dominated by the rarest ball otherwise (E2.1–E2.2).
4. No-memoization is a two-branch fork: r=0 can't generalize (trivial, grammar-invariant); whether a grammar forces content-r=0 is grammar-relative, and a coarser grammar lowers K (E2.3).
5. Relative to a covering grammar, any non-memorizing solver must be two-layer; the generalization signal decomposes into cost, coverage, and radius-predictability priors; NFL is inter-closure and does not contradict this (E2.4–E2.6).
6. The open antecedent is the finiteness-and-coverage of the prior set Π (C1); perception is delegated at its base and conditionally closable above, the postulate flooring only the comparison medium (§4).

> **The theory never promised to see. It promised that, given sight, it is never wrong — and it names exactly what sight must deliver, and exactly which half of "solve" it can prove. Safety is unconditional; completeness is compression plus a budget; perception is the standing debt. The boundary between proven and delegated is, as ever in this series, a number you can compute.**

## §6. Dependency

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

The series proved what happens after the encoding is fixed, and proved it as *safety*. This note states what the encoding must be, splits the consequent into the safety it can prove and the completeness it cannot, and localizes the whole open problem in the finiteness of the prior. The conditions are the type of a solver; the open problem is an inhabitant of that type; and the proof stops where sight begins.
