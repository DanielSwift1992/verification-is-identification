# The Measured Geometry of ARC-AGI-1 (Measurement)

The nine theory documents derive a chain: certified identification (V=I), inevitable saturation (IiI), crystallized output (PiR), inter-agent metric (DiD), ordering as mechanism (InI), structural metric W (DiC), navigation (NiG), certified strategies (OiO), and dynamics via law identification (LiT). The chain's load-bearing conditional claims — modulus ω (G10), compressibility (G12), navigability at small radius (N11), strategy clustering (O15) — are not derivable from I1–I3. They are measurable properties of a domain. This document is the measurement. The domain is ARC-AGI-1: 400 public training tasks, 400 public evaluation tasks, grids up to 30×30 over 10 colors, 2–5 training pairs per task, scoring at two attempts per test input. ARC was designed so that evaluation tasks require novel combinations of core priors — designed, in the series' vocabulary, to defeat r = 0 agents (pure memoization). It is therefore the correct instrument for the one question that separates this framework from a cache: does the rule space cluster? Every phase below produces a number; every number tests a named statement; both outcomes of every fork are results. No phase requires a result from a later phase to be reportable.

## §0. What Is Being Tested

| # | Claim | Source | Measurement | Refuted if |
|---|---|---|---|---|
| P1 | Rule classes are few relative to tasks: K < 400 after structural dedup | IiI §2 (signature) | K = distinct rule trees among certified solvers | K ≈ 400 (no two tasks share a rule) |
| P2 | The rule space clusters: N(r) ≪ K at moderate r | DiC G12 | covering numbers from the W-matrix | N(r) ≈ K for all r < diam (flat matrix) |
| P3 | A modulus exists under some signature lens: nearby tasks have nearby rules | DiC G10 | scatter of W(sig_i, sig_j) vs W(rule_i, rule_j); Spearman ρ | no signature basis yields positive correlation |
| P4 | The rule space is tree-like: δ ≪ diam | NiG N11 premise | sampled Gromov four-point δ | δ comparable to diam |
| P5 | The anchor graph is navigable below the diameter: ρ_nav ≪ diam | NiG N9 | binary search over ρ with full greedy check | ρ_nav ≈ diam |
| P6 | W-ordered search beats baseline ordering at equal budget | NiG N12; InI S6; DiC G9 | attempts-to-PASS, anchored W-order vs random vs breadth-first | no separation of the distributions |
| P7 | Min-norm selection beats random selection inside S | OiO context; DiC G1a (Occam as maintenance cost) | held-out accuracy of argmin ‖·‖ member of S vs uniform member | accuracies indistinguishable |
| P8 | Saturation follows coupon-collector dynamics with critical slowing | IiI §6 | new-class discovery curve over a task stream | curve inconsistent with K·H_K profile |
| P9 | Routing failures name productive curriculum | NiG N17 | solve-rate gain from hole-directed task acquisition vs random acquisition | no gain |
| P10 | Trace replay yields cheap certified strategies | OiO O20.3 | cost(σ_replay) vs cost(random order) on repeat classes | replay no better than random |

P2–P5 share one honest fork. If the matrix is flat: by G12's own remark, ARC-under-this-grammar is formally "nothing to learn, only memorize" — a theorem-grade negative result about a benchmark, established by measurement rather than opinion. The fork is symmetric; both branches are publishable; the protocol does not depend on which branch obtains.

## §1. Phase 0 — Encoding

**Grammar.** Adopt an existing open DSL for ARC with hand-written solvers covering all 400 training tasks (Hodel's arc-dsl, ~160 primitives) as the grammar E. The grammar is the agent's contribution (V=I §1); adopting a community grammar additionally makes every downstream number comparable to prior work.

**Programs into Σ.** A DSL program is an AST: encode primitives as Peano-tagged nodes, composition as PAIR nesting, termination at NULL (V=I §2.1, §4.1). This makes ‖program‖ and W(program₁, program₂) defined and computable by one traversal (G1a, G2a). Extend `delta.py` from binary trees to labeled ASTs: a label is a Peano numeral in a fixed left branch; W then needs no modification.

**Grids into Σ.** Already specified: atom(r, c, v) = PAIR(PAIR(row, col), value), taxicab geometry derived (G7).

**Task signatures.** A signature is a tuple of cheap COMPARE-predicates computed from the training pairs alone, before any solving: grid-size relation (equal / scaled / cropped), input–output color-set relation (preserved / reduced / recolored), object count via 4-connectivity (in, out, ratio), symmetry tests (horizontal, vertical, rotational, per pair), background stability, cell-count conservation. Signatures are structures in Σ; W on signatures is the task-side distance for P3. The signature basis is a lens (IiI §7): P3 is a search over a small family of bases, and reporting which basis succeeds (or that none does) is part of the result.

**Deliverable 0.** `encode.py`: DSL-AST ↔ Σ, grid ↔ Σ, signature extractor. Machine check: W on encoded Peano numerals returns |n − m| (G6); W on encoded cells returns taxicab (G7) — the two internal-instance theorems double as unit tests.

## §2. Phase 1 — Bootstrap the Crystal

Run all 400 hand-written solvers through the compilation gate: each must reproduce every training pair and the test pair of its task. Each PASS crystallizes an entry (rule tree, task id). Legality: Theorem 2 — safety comes from verification, not from how the candidate was found; the source may be another agent's manual work (the bootstrap lemma; an amendment slot in IiI §3).

**Measurements.**

- K: the number of structurally distinct rule trees (COMPARE-dedup over the 400). Tests P1.
- The norm distribution ‖rule‖ across the library: the cost-of-existence profile of ARC's solutions.
- Gate failures, if any: a hand solver failing its own task is a data point about the gate or the port, resolved before proceeding.

**Deliverable 1.** The certified library L: 400 entries, each carrying its proof-of-PASS (the recorded gate run). By SAT5–SAT6 the library is unique up to insertion order: any party re-running this phase obtains the same L. Reproducibility is by construction, not by promise.

## §3. Phase 2 — Measure the Geometry

All quantities below are finite computations over data produced in Phase 1. Estimated cost: the W-matrix is 400² ≈ 160k traversals of small trees — minutes, not hours.

| Quantity | Computation | Tests |
|---|---|---|
| W-matrix | pairwise W over rule trees | substrate for everything below |
| N(r) | greedy set-cover over the matrix, swept over r | P2 (G12) |
| dendrogram + λ-separation | hierarchical clustering; check nested-cover premise | N11 premise |
| δ | Gromov four-point condition over ≥10⁵ sampled quadruples | P4 |
| ρ\* | max MST edge | N2 |
| ρ_nav | binary search over ρ; full (start, target) greedy check per probe (N7: decidable) | P5 (N9) |
| greedy success + stretch profile | per ρ between ρ\* and diam | NiG §7 |
| degree distribution | histogram of deg(a) per ρ | N14 attachment signature |
| ω scatter | W(sig) vs W(rule) over all pairs, per signature basis | P3 (G10) |
| common skeleton | ∩ D(rule) over L via G4a | the domain's invariant core |

**Reporting.** Every number is published with the matrix it came from. The flat-fork criterion is fixed in advance: the domain counts as clustered if N(diam/4) ≤ K/4 and δ ≤ diam/8; otherwise flat. (The thresholds are declared before measurement so the fork cannot be argued after it.)

Two amendments from the first execution, declared so later runs inherit them. *Graded verdict:* alongside the binary fork, the full N(r) profile and its shape class (graded decline vs plateau-then-collapse) are reported — the theory consumes covering curves, never a single bit (G12), and a borderline binary outcome is itself a result; the fork criterion is exactly the binarity-as-resolution-artifact the series' own resolution family (G5) predicts will be crude. *Lens robustness:* every Phase-2 quantity is reported under at least two canonical encodings (constitution/inline and order-invariant canonical); a verdict that flips across lenses is reported as lens-relative, never as a property of the domain. Quantities observed lens-stable so far (the δ class, the profile shape) carry domain-level claims; lens-sensitive ones (strict fork at declared thresholds) carry lens-level claims.

**Deliverable 2.** The map: the first measured geometry of an ARC rule space — K, N(r), δ, ρ\*, ρ_nav, ω, degree law, skeleton.

## §4. Phase 3 — Inference on the Evaluation Set

For each of the 400 public evaluation tasks, the pipeline:

1. **Signature** (Phase 0 extractor; cost: negligible).
2. **Anchors**: nearest library entries by W on signatures, if P3 held; else by uniform sampling (the degraded mode is run either way, as baseline).
3. **Candidate stream**: anchor programs first; then W-ordered edits of anchors — grow/shrink moves of G2 are the mutation operators, so the stream walks the W-graph outward from the anchor (G9: ordering is the sole free variable; correctness is untouched). Optional second source: an LLM proposing programs in the DSL, admitted under IiI §3 (an approximate Source; the gate carries all guarantees). Run with and without it; report separately.
4. **Gate with magnitude**: each candidate is compiled against training pairs; loss(g) = Σ W(apply(g, Iₖ), Oₖ) with frontier addresses (G13) steers the next edit — descent proposes, the gate certifies.
5. **Selection inside S**: if multiple candidates pass all training pairs, attempt 1 = argmin ‖·‖ (P7's treatment), attempt 2 = the next distinct member of S — the |S| = 2 case maps exactly onto ARC's two-attempt scoring, converting reported ambiguity into score.
6. **Online crystallization**: every PASS enters L immediately (I3); later eval tasks see a larger library. Report solve rate as a function of position in the stream — the within-eval saturation slope.

**Budgets.** Fixed candidate budget per task (declared in advance, e.g. 10⁴ gate calls), identical across all ordering conditions. P6 is a comparison of distributions of attempts-to-PASS under: (a) anchored W-order, (b) random order over the same candidate set, (c) breadth-first enumeration by program size. Same budget, same gate, same grammar — only the Y-axis differs, which is exactly the theory's claim about where intelligence lives (V=I §5.25; InI S5).

**The ledger.** Every eval task ends in exactly one recorded state: PASS (with proof), AMBIGUOUS (|S| > 1 at budget, members listed), EMPTY (|S| = 0 within grammar and budget — a grammar-gap candidate), or BUDGET (stream exhausted). The ledger is the honest-reporting artifact: no silent failure modes exist by construction (V=I, outcome classification corollary).

**Deliverables 3.** The number (pass@2 on public eval, per condition), the separation (P6 distributions), the Occam result (P7), the saturation slope, and the ledger.

## §5. Phase 4 — Repair and Curriculum (P8, P9)

Stream the training tasks in random order against an initially empty library (no bootstrap), solving by Phase-3 search: the new-class discovery curve tests the coupon-collector profile and its critical-slowing tail (P8; IiI §6).

Then, on the bootstrapped library: locate routing holes (N6) in the anchor graph; acquire tasks directed at hole regions (synthesized by mutating tasks whose rules border the hole, or selected from eval by signature proximity to it) versus randomly acquired tasks, equal counts; compare solve-rate gains (P9; N15–N17). A repaired hole is checked for permanence trivially (I3: the inserted entry cannot leave).

## §6. Phase 5 — Strategies (P10)

For rule classes with ≥ 2 member tasks: extract the trace of the first solve from G, prune redundant steps (InI S3a), and certify the pruned trace as a strategy through the strategy gate (O5) with budget = pruned length. On the class's remaining tasks, compare cost under σ_replay vs random ordering (P10; O20.3). This is the minimal end-to-end demonstration that the path itself — not only its endpoint — functions as a certified, reusable object (O12, O17 rung 6).

## §7. What the End State Is

If the protocol completes, ARC-AGI-1 exists in a new form: a crystal (the certified, reproducible-by-construction library), a map (its measured geometry), a number (eval performance attributable specifically to ordering, the theory's one operational claim), a ledger (every task's honest terminal state), and an ignition (the level-2 signature → anchor-family table, with K₂ measured against K₁ — the first empirical test of the tower's compression premise, M16 via G12). In the series' own terms: the domain saturates, the structural flow at this level ends, and the artifact becomes matter — a fixed object the next level, and other agents, encounter as given. Distribution is then not an appeal but an insertion: the artifact is an anchor placed into the community's library, verifiable by anyone, requiring no trust in its builder — which is the only kind of entry an unknown agent can make.

## §8. Failure Modes, Declared in Advance

- **Flat geometry (P2–P5 fail):** reported as the central result — ARC-under-this-grammar admits memorization only; the boundary of intelligence located by measurement (G12 remark; N18).
- **No working signature lens (P3 fails for all bases tried):** the modulus is lens-relative (G10; IiI §7); the negative is reported per basis, and anchored search degrades to uniform-anchor baseline — which still runs, so P6 still reports.
- **Ordering shows no separation (P6 fails) while geometry clusters:** the most damaging outcome for the theory — structure exists but the agent cannot exploit it; would localize the failure to the edit operators or the loss surface (G13's descent stalling, anticipated in DiC §9), and says so.
- **Engineering ceiling:** budget exhaustion dominating the ledger is reported as BUDGET, never folded into EMPTY; the grammar-gap count and the budget count are kept separate because they refute different things (coverage vs affordability — V=I, Theorem 4 remark).
- **Style confound:** Phase 1's rule trees are one author's DSL solutions; K and the W-matrix may measure the writer's idiom as much as the domain's structure. Control: canonicalize programs before encoding (argument-order normalization, dead-code elimination), report K and N(r) before and after canonicalization; where a second independent solver corpus exists, report its matrix separately.
- **Lens flip:** a fork verdict that differs across canonical encodings is reported as lens-relative; only lens-stable quantities support claims about the domain itself. The search for which quantities are invariant under semantics-preserving re-encoding is an open problem the protocol surfaces rather than settles.

## §9. Dependency

| Phase | Tests | Sources |
|---|---|---|
| 0 | G6, G7 as unit tests | V=I §2, §4.1; DiC G1a, G2a, G7 |
| 1 | P1; bootstrap lemma | Theorem 2; IiI §2–§3; SAT5–6 |
| 2 | P2–P5 | DiC G4a, G10–G12; NiG N2, N7, N9, N14 |
| 3 | P6, P7; ledger | V=I §5.25, outcome corollary; IiI §3 (Source); DiC G9, G13; InI S5 |
| 4 | P8, P9 | IiI §6; NiG N6, N15–N17; I3 |
| 5 | P10 | InI S3a; OiO O5, O12, O17, O20.3 |

The theory papers end in aphorisms; a measurement paper ends in a date and a table. Ten predictions, declared thresholds, symmetric forks: whatever the matrix says, the saying of it is the contribution.
