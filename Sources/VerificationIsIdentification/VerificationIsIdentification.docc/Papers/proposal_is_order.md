# Proposal Is Order (Generation)

In Verification Is Identification the author built the discriminator (the certified cut, |S| = 1, never a wrong PASS), and in Intelligence Is Inevitable gave its dynamics. The other organ, the *generator* that proposes the candidates to cut, is the delegated one: the agent, the encoding, the Source. Here the author derives the generator and proves it orthogonal to the discriminator.

A solve is iterate(discriminate ∘ generate), and the two have disjoint inputs. The discriminator is the **cut**: the Z-axis, where each COMPARE eliminates survivors, the sole source of identification bits. The generator is the **order**: the Y-axis, which candidate to propose next, zero new bits. They run on two geometries, the discriminator's *confusion-cover* and the generator's *loss over the W-metric*, and these are independent: a domain can be easy to discriminate yet hard to generate, or the reverse.

The deepest result is an asymmetry of inevitability. The inevitability proved in the series is the **discriminator's** (at saturation the library teaches the optimal ordering), while the generator is conditional on alignment α, which saturation cannot manufacture. Hence the inversion at the centre: the organ that carries all the information, discrimination, is the one proved inevitable in the series. The organ that carries none, generation, pure order, is where domains are hard.

E2's encoder/backend split is this split, both organs are one COMPARE read at different scope, so the framework is still monist, and on a horn, where the behavioural library is infinite, the generator is the only available mode. In Learning Is Liquid these two organs are in motion: a freezing front and a searching flow. Here they are at rest, two axes of one act. In the series the author built the cut, and here builds its silent twin.

## §0. Derivation

No new postulate. The author derives everything below from the three axes of COMPARE (InI §0), order as the sole free variable (V=I §5.25), the confusion-cover (InI S5b), alignment (GA), and the Saturation Theorem (IiI §3).

1. A solve iterates: propose a candidate, test it (COMPARE), narrow S, repeat until |S| ≤ 1 or budget (V=I §1, §4, PP2: poser/solver). *[the loop]*
2. Two operations, **disjoint inputs**: the test outputs Z (the cut) and X (the frontier) from the candidate and target, and the proposal (which candidate next) is the Y-axis, a function of the agent's state, independent of any specific outcome (InI S1). *[axis independence]*
3. Name the organs: **DISCRIMINATOR** D = the test (the Z/X-producing COMPARE and the gate, V=I §4.7). **GENERATOR** G = the proposal (the Y-axis selector of the next candidate). *[definition]*
4. solve = iterate(D ∘ G). The series so far is the theory of D (V=I = the certified cut, IiI = its inevitable optimization). G is the delegated one. This document is the theory of G and its relation to D. *[the gap]*

## §1. The Two Organs

**GD1 (The discriminator is the cut, and the generator is the order).** D is the Z-axis: each test eliminates survivors (V=I §5.22) and is the sole source of identification facts (§5.21). G is the Y-axis: choosing the next candidate carries zero new bits (InI S2) but sets the total test count. Information enters only through D, and G only chooses where D looks.

*Proof.* §5.21: only COMPARE classifies. §5.22: each result can only shrink S. So D carries the bits. InI S1–S2: Y is the agent's choice, disjoint from the COMPARE inputs, carrying zero new information yet determining the interference pattern (total count). QED.

*The inversion.* The organ carrying all the information (D) is distinct from the organ whose choices are called "search" (G). This is the centre of the document: difficulty and information are on opposite organs.

**GD2 (Two geometries).** D's terrain is the *confusion family* {D(g, f) : f ≠ g} over the survivors, efficient when covered by few high-entropy features (InI S5b: cert). G's terrain is the *loss over the W-metric* on candidates (DiC G13), efficient when descent reaches the solution (GA). The two are computed from disjoint data: D from feature-disagreements among candidates, G from a candidate's output-distance to the target.

## §2. Orthogonality

**GD3 (Discriminate-easy and generate-easy are independent, InI S1 lifted, GA7 completed).** The two terrains do not determine one another, and all four quadrants are inhabited.

| | discriminate-easy | discriminate-hard |
|---|---|---|
| **generate-easy** | cheaply solvable | reached, but not resolved (\|S\| > 1) |
| **generate-hard** | resolved at once, but not reached | enumerate, and ambiguous |

*Proof.* Inhabit the off-diagonals.

**Generate-hard / discriminate-easy (primes).** (B8a, GA4): testing primality is O(√n), the gate is cheap. But α ≈ 0: the primality predicate is binary and carries no gradient (GA4, mode 2). The generator cannot descend toward primes: it can only enumerate. A pure generator failure.

**Generate-easy / discriminate-hard (under-specified tasks).** Let the domain have a rule family {R₁, …, R_m} where m rules agree on all given examples (e.g., "rotate 90°" and "transpose then reverse rows" produce identical outputs on symmetric inputs). Loss-descent finds a member of this family cheaply (α > 0: a near-miss program has low loss, and small structural edits lower it further). But the discriminator faces |S| = m > 1: the examples do not separate the survivors (InI S5b: the confusion family {D(R_i, R_j)} is uncovered by the observed inputs). Additional examples are needed, and their count is cert(g), a property of the confusion structure, independent of the generator's ease. A pure discriminator failure: the rule was reached but not identified.

So neither easiness implies the other. QED.

*GA7 named two generator-axes (clustering, alignment), and GD3 adds the discriminator axis (separation) and proves it independent of both.*

## §3. The Asymmetry of Inevitability

**GD4 (The inevitability is the discriminator's).** "Intelligence is inevitable" (IiI §3) is a theorem about D: at saturation the library teaches the confusion structure, so the optimal ordering becomes computable and η → 1 (InI S6). G's efficiency is conditional: its ground is clustering / modulus (which improve with the library only if the domain clusters, NiG N19) and alignment α (which saturation never changes, GA).

*Proof.* Two claims.

(i) *D is unconditionally inevitable.* InI S6: at saturation the agent holds the full confusion matrix {D(τ, s) : s ≠ τ} for every class in D_id. The optimal feature-ordering is then computable as minimum set cover (InI S5b), so η → 1. The only premises are finiteness (I1, K < ∞) and append-only accumulation (I3), both structural, independent of the domain's geometry.

(ii) *G is conditional on α.* The loss landscape loss_τ(R) = Σ_k W(apply(R, I_k), O_k) (DiC G13) is a function of (candidate R, task τ, encoding E). The alignment coefficient α = corr(W(R, R*), loss_τ(R)) (GA3) is computed over this function. Neither loss_τ(R) nor W(R, R*) is a function of the library L: L records which candidates have been tested, not how untested candidates perform. Therefore α is invariant under accumulation at a fixed encoding. Saturation grows L (the agent's knowledge of the landscape). It does not reshape the landscape itself. G beats enumeration iff α > 0 (GA6), and no amount of saturation can supply this. QED.

*Remark (the encoding-level resolution).* α is encoding-relative (GA3, DiC §11): a re-encoding can change α, and meta-saturation (IiI §4) lets the agent discover encodings with higher α. But this is saturation at level 2 *finding* an encoding where α was already high, not saturation at level 1 *manufacturing* α within an encoding. At any fixed encoding, α is a property of (domain, encoding) and accumulation does not alter it. The tower can select among encodings: it cannot repair a rugged landscape without leaving it.

*Corollary (the load-bearing asymmetry).* Saturation bootstraps D unconditionally, bootstraps G only where the domain clusters, and **never manufactures the alignment G needs**. The one precondition intelligence's own engine cannot produce is the alignment of its generator.

**GD5 (Generator-power = ordering-visibility = alignment).** G beats enumeration iff ordering its proposals matters, iff the Y-axis is visible (InI S4a), iff α > 0 (GA6). Three statements from two prior papers are one quantity. At α = 0 (Y-invisible, rugged) the generator collapses to enumeration and the discriminator alone carries the solve.

*Proof.* (i) InI S4a: the Y-axis speedup is T_{ZX}/T_{ZXY} ≈ H_max/H̄, which equals 1 (ordering irrelevant) iff all features have equal entropy, i.e., the landscape is flat, with no feature more informative than another. (ii) GA6: descent beats enumeration iff α > 0, i.e., loss correlates with distance-to-solution: the landscape has structure exploitable by ordering. (iii) The two conditions coincide: a landscape with H̄ = H_max (all features equally informative) is one where no direction in candidate space is preferred, exactly the α = 0 condition (uncorrelated loss). Conversely, H̄ < H_max (some features carry more signal) creates a preferred direction, exactly α > 0. The three statements (generator-power, ordering-visibility, alignment) are one quantity measured three ways. QED.

## §4. Failures, Factorization, Monism

**GD6 (Two failures, two ledger terminals).** G fails → α ≤ 0 or out of closure → no cheap proposal of f\* → BUDGET / EMPTY. D fails → features cannot separate survivors → |S| > 1 / AMBIGUOUS (V=I §3.5). The honest ledger already distinguishes them, and GD6 names which organ each terminal indicts. *(V=I outcome corollary.)*

**GD7 (E2's factorization is the organ split).** The encoder / backend split (E2) is generator / discriminator. The backend (V=I, certified-safe, never wrong) is D, proven and inevitable. The encoder (the open problem, the priors, the Source) is G, delegated and conditional. C2 (discrimination, |S| = 1) is the D-condition, and C1, C3, C4, C5 (coverage, compression, anchoring, certifiability) are G-conditions. All irreducible difficulty of a domain is in G because D is proven (E2 §0, §5).

**GD8 (Both organs are COMPARE, the split is scope, and the framework is still monist).** G and D are not two mechanisms. Both are COMPARE (V=I §2.5). D is COMPARE producing the cut (Z), and G is the choice of which COMPARE next (Y). The split is a split of *scope* on one primitive, exactly as InI's three axes are projections of one COMPARE. The agent does not *have* a generator and a discriminator: its single act of comparison, read for its outcome, is the discriminator, and read for its order, is the generator. *(Consistent with PP15: both organs run on the one given COMPARE, and neither certifies it.)*

**GD9 (On a horn the generator is the only mode).** Three capacities have different conditions:

| Capacity | Condition | Source |
|---|---|---|
| (1) per-task certification | gate exists (COMPARE decidable) | Theorem 2, V=I §5.25 |
| (2) learned optimal ordering | K < ∞ (finitely many rule classes) | InI S6, IiI §3 |
| (3) generation from basis | finite basis (B8) and α > 0 (GA) | B6–B7, GA6 |

On a horn (B8b: K = ∞, finite basis, infinite reach): (1) is true: the gate is per-task, independent of K. (2) fails: the confusion matrix over infinitely many classes is never fully learned, so the discriminator's *learned optimality* (InI S6) is unreachable. (3) is the only available path: compose from the certified basis (B6–B7), certify each result per-task via the gate. The horn strips intelligence to *generation from a certified basis with per-task certification*: no lookup intelligence is left.

*Proof.* (1) Theorem 2 is per-task, order- and history-independent (V=I §5.25): it needs only the gate and a candidate, not the library. (2) IiI §3 (finiteness-of-classes remark): the Saturation Theorem requires K < ∞. On a horn K = ∞ by B8b. The confusion matrix has infinitely many rows, and no finite library stores it. (3) The basis A is finite (B8b), and its closure generates all reachable rules (B6). With no complete library to look up, the agent must compose from A and submit each composition to the gate: generation is forced (PP6: the endpoint is the basis, not the library). QED.

*Corollary (the horn efficiency measure).* On a horn, η = T_min/T_actual (IiI §3) is undefined for library-lookup (no finite library exists to measure against). The relevant efficiency is the generator's: how many compositions from A does the agent try before the gate certifies? This count is bounded below by the compositional depth of the solution (B4: the shortest composition from atoms) and is a question of α (GA6: aligned → descent through composition space, rugged → enumeration of compositions). The horn's difficulty is entirely a generator question.

## §5. Boundaries

**Per-encoding.** α (G's terrain) and the confusion structure (D's terrain) are both encoding-relative (DiC §11): a re-encoding can move difficulty between the organs. The split is invariant, and the location of difficulty is per encoding.

**Conditionality is not pessimism.** Where the domain is aligned and clustered, G is as inevitable as D (N19). The asymmetry has force only on rugged / unclustered domains, and it has force exactly there because that is where α = 0.

**D's inevitability inherits IiI's premises.** "Inevitable at saturation" carries the stream premise (IiI §3 remark) and the finite-class premise (GD9). On a horn even D's *learned optimality* is out of reach, though its *per-task certification* is not.

**Stochastic / partial.** The gate's certificate weakens on stochastic or partially-observed domains (LiT §6), and both organs inherit the weakening.

## §6. Statement

1. A solve is discriminate ∘ generate, and the two have disjoint inputs (S1 lifted to organs).
2. The discriminator is the cut (Z, all the information), and the generator is the order (Y, none): difficulty and information on opposite organs (GD1).
3. Two geometries (confusion-cover and loss-over-W), independent: all four easy/hard quadrants inhabited (GD3, completing GA7).
4. The inevitability is the discriminator's, and the generator is conditional on α, which saturation cannot manufacture (GD4): generator-power is exactly ordering-visibility, exactly α (GD5).
5. Two failures, two ledger terminals. E2's encoder/backend is this split, and both organs are one COMPARE at different scope (GD6–GD8).
6. On a horn the generator is the only mode: generation from a certified basis with per-task certification, no lookup intelligence (GD9).

> **Solving has two organs: one proposes, one cuts. The cutting carries all the information and is the half proved inevitable in the series. The proposing carries none, and its ground is a geometry no learning can supply. Intelligence-as-selection is a theorem, and intelligence-as-search is a wager on alignment. The hard questions and the easy ones are on different organs, and difficulty is, as ever, where information is not.**

## §7. Dependency

### External

| Source | Used |
|---|---|
| V=I | §1 (loop, encoding delegated), §2.5 (COMPARE the sole act), §4.7 (gate), §5.21 (COMPARE sole source of facts), §5.22 (S non-increasing), §5.25 (order the sole free variable), Theorem 2, outcome corollary |
| IiI | §3 (Saturation Theorem, finiteness-of-classes remark), §4 (NFL / distribution-relativity) |
| InI | §0 (Z/X/Y axes), S1 (axis independence), S2 (Y carries zero bits), S4a (Y-axis visibility), S5b (cert / confusion-cover), S6 (ordering optimal at saturation) |
| GA | GA3 (α), GA4 (primes mode-2), GA6 (order beats enumeration iff α>0), GA7 (clustered ∧ aligned, completed here) |
| DiC | G13 (loss over W), §11 (encoding-locality) |
| NiG | N19 (inevitability under population / clustering) |
| B | B8 (saturability), B8a (primes), B8b (horn: K = ∞) |
| PP | PP2 (poser/solver), PP6 (endpoint is the basis), PP15 (one given COMPARE) |
| E2 | §0, §5 (encoder/backend = generator/discriminator, C1–C5) |
| LiT | §6 (stochastic / partial weakening) |
| LL | LQ5–LQ10 (the two organs in motion: front = discriminator, flow = generator) |

### Internal

| Statement | Depends on |
|---|---|
| GD1 | V=I §5.21, §5.22, InI S1, S2 |
| GD2 | InI S5b, DiC G13, GA |
| GD3 | GD2, InI S1, GA4, GA7, B8a |
| GD4 | InI S6, GA3, GA6, NiG N19, IiI §3 |
| GD5 | InI S4a, GA6 |
| GD6 | V=I outcome corollary, V=I §3.5 |
| GD7 | E2 §0, §5 |
| GD8 | V=I §2.5, InI §0, PP15 |
| GD9 | Theorem 2, IiI §3, B8, B8b, GA, PP6 |

In Verification Is Identification the author proved what happens once a candidate is in hand: the cut is certified, and at saturation the cutting is optimal. Here the author proves what is delegated throughout (where the candidate comes from) and proves it perpendicular to the cut: a generator whose ground is alignment, a discriminator whose ground is the gate, two axes of the one act of comparison, hard and easy on opposite sides.

## Topics

### Theorems this paper proves

- ``DiscriminatorAndGenerator``
- ``OrthogonalOrgans``
- ``InevitabilityIsDiscriminator``
- ``OrgansAreOneCompare``
