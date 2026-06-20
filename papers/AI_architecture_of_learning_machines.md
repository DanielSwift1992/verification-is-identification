# The Architecture of Learning Machines (Projection)

Permanence Is Resistance §5 projects the framework onto physical systems: what plays the role of Σ, what plays COMPARE, whether I1–I3 hold, what follows. This document is the same move applied to learning machines. The theory derives a machine (V=I), its dynamics (IiI, LL), and its statics (GD). A learning system — any learning system — is an instance of the framework with some coordinates present and others absent: a *gate* (decidable verifier), *I3* (append-only record), a *certified basis* or an uncertified one, the *organ* it runs (generator, discriminator, or both), the *phase* it occupies (liquid, crystal, or a coupled field), and the *alignment* of its domain (α). The framework's theorems are conditional: each guarantee holds exactly when its coordinate is present (AI1). The projection onto a given system reads the coordinates and derives what follows — the same operation PiR §5 performs when it reads I1–I3 on ice and derives that |S| > 1 on hydrogen positions. An LLM is an instance where the gate is absent (Theorem 2 does not apply → no certification), I3 is absent (§5.22 breaks → S can regrow), and the basis is uncertified — yet the domain is aligned (α > 0), so the generator exploits structure (AI4). Reinforcement self-play is an instance where the gate is replaced by a reward signal (the label is an estimate, not f* → PP7 contrast). The instance where all coordinates are present — gate, I3, certified basis — is the framework's own shape: certified self-play, the AlphaProof architecture generalized (AI6). The projection is not a judgment of these systems. It is the framework's own vocabulary applied to them, and what follows is derived, not assessed.

## §0. The Projection Basis

No new postulate. The coordinates are read off the theory:

| Coordinate | Source | What it grants |
|---|---|---|
| **gate** (decidable verifier) | V=I §3.7 | certified output; honest |S|>1 / EMPTY |
| **I3** (append-only record) | V=I §2.4 | non-forgetting; monotone S (§5.22) |
| **basis** (certified atoms vs pseudo-features) | B; IiI §3 | reproducible, irreducible knowledge |
| **organ** (generator / discriminator) | GD (Proposal Is Order) | which half runs; where difficulty sits |
| **phase** (liquid / crystal / field) | LL (Learning Is Liquid) | flow vs lookup; partial vs complete |
| **α** (alignment) | GA | whether the search is laminar or turbulent |

A learning system is an instance of the framework, located by which coordinates are present and which are absent. The framework's theorems then apply conditionally: each guarantee holds exactly when its coordinate is present. Projection is reading the coordinates and deriving what follows — the same operation PiR §5 performs on physical systems.

## §1. The Configuration Space

**AI1 (Guarantees are coordinates).** For any learning system: it can *certify* an output iff it has a gate (Theorem 2); it does *not forget* iff it has I3 (else §5.22 breaks — catastrophic forgetting, IiI §3); it is *reproducible* iff it has gate and I3 (SAT5/6); it can *honestly abstain* iff it has a gate (the |S|>1 / EMPTY outcome); its knowledge is *irreducible / transferable* iff its basis is certified, not a pseudo-basis. Each property is present exactly when its coordinate is.

*Proof.* Each clause is a prior theorem with its precondition named: Theorem 2 (gate → PASS = f\*); IiI §3 (no I3 → mutable accumulation → forgetting); SAT5/6 (gate + I3 → domain-determined endpoint); V=I outcome corollary (gate → the three honest terminals); B / IiI §3 (certified basis → reproducible irreducible entries). A missing coordinate removes exactly its guarantee. QED. **[solid]**

## §2. Projection onto Existing Systems

The same move PiR §5 makes for ice and hydrogen: map the vocabulary, check which coordinates are present, derive what follows.

| system | gate | I3 | basis | organ | phase | consequence |
|---|---|---|---|---|---|---|
| **endgame tablebase / exact solver** | yes | yes | certified (r=0) | discriminator | crystal | Theorem 2 applies → exact, never wrong, reproducible. Does **not** scale (stores the reach, not the basis) |
| **LLM** | no | no | pseudo | generator | pure liquid | Theorem 2 does not apply → no certification. §5.22 broken → S regrows. Strong where α>0 (AI4); **hallucinates, forgets, irreproducible** (AI2) |
| **reinforcement / AlphaZero** | reward ≠ gate | partial | pseudo | both, estimated | liquid (value field) | Gate absent → label is estimate, not f* (PP7 contrast). **Blunders, seed-dependent, no proof** (AI3) |
| **diffusion / generative** | no | no | pseudo | generator | liquid | No gate, no I3 → flow without a front; samples, cannot certify |
| **retrieval / RAG** | partial | yes (store) | stored facts | discriminator + liquid generator | crystal patches in liquid | Gate partial → facts solid at retrieval boundary, synthesis liquid |
| **theorem prover + LLM (AlphaProof)** | yes (checker) | — | — | generator + gate | freezing | **All coordinates present** at the output → the framework's own shape |
| **certified self-play (this series)** | yes | yes | certified | both | freezing, honest | Full projection: exact where gated, honest silence where not |

**AI2 (Projection onto an LLM: pure liquid).** The framework's coordinates applied to a large language model: gate — absent (the system cannot force |S| = 1 → it emits the generator's guess as if certified = hallucination). I3 — absent (mutable weights overwrite → catastrophic forgetting, IiI §3). Basis — uncertified (entangled, polysemantic features, not certified irreducible atoms). Organ — generator only (flow, no discriminating front). Each consequence is the absent coordinate (AI1): hallucination ↔ no gate, forgetting ↔ no I3, irreproducibility ↔ no gate+I3, confident error ↔ no honest |S|>1.
*Tags:* no-gate / no-I3 / generator-only — **solid** (architectural facts). "Pseudo-basis" — **interpretive** (mechanistic-interpretability evidence of superposition/polysemanticity, not proven).

**AI3 (Projection onto reinforcement self-play: the proof is traded for an estimate).** The framework's gate coordinate is replaced by a *reward*: the label becomes an outcome estimate, not f\*. The value field is noisy, the endpoint seed-dependent (no SAT5/6), and the play can blunder (no gate) — exactly the PP7 contrast, measured in `selfplay_demo.py` / `alphazero_pure.py`. **[solid]**

## §3. What the Projection Derives

**AI4 (A generator without gate or I3: success conditional, certification absent).** A statistical learner succeeds *beyond enumeration* on a domain iff α > 0 (GA6) — the domain's loss landscape has exploitable structure, so approximate compression generalizes. The absent coordinates (gate, I3, certified basis) remove their guarantees (AI1): no certification, no permanence, no reproducibility. The projection derives both the success and the failure from the same reading: strong where aligned (α > 0 → GA6), fragile where any coordinate is missing (AI1).

*Proof.* (i) *Success condition.* GA6: descent beats enumeration iff α > 0 — if loss correlates with distance-to-solution, the generator can exploit gradient structure; if not, proposal order is irrelevant and the system must enumerate. "Succeeds" here means strictly: the generator's ordering lowers expected test count below the uniform baseline T_{enum}. (ii) *Failure modes.* AI1: each missing coordinate removes exactly its guarantee — no gate → hallucination, no I3 → forgetting, no certified basis → irreproducibility. (iii) *Independence.* GD3/GA7: alignment (α) and certification (gate/I3) are orthogonal axes — a system can have α > 0 (the domain is kind) without gate/I3 (the system cannot certify). An LLM is exactly this configuration: strong structure-exploitation, zero certification. QED. *Tag:* the structural projection is **solid**; the per-domain value of α is **open** (the horn bet).

## §4. The Two Dynamics Projected

**AI5 (Every system sits in the liquid/crystal field with a front and a flow).** Learning Is Liquid gives two coupled dynamics — a crystallization **front** (the discriminator, monotone by I3, LQ3) and a search **flow** (the generator, laminar where α>0, turbulent where rugged, LQ5). Each system is a configuration of these: a tablebase is all-crystal (front complete, no flow needed); an LLM is all-flow with no front (no I3 → nothing freezes) in a possibly-turbulent landscape; certified self-play is a freezing flow (both). The LLM's power (flows anywhere) and fragility (solidifies nowhere) are the same fact: flow without a front. **[solid given LL; LL's physics-tools flagged in LL §6].**

## §5. The Completion

**AI6 (The gate+I3 wrapper preserves coverage and adds certification).** Let G be any generator (statistical, neural, heuristic) with coverage C_G(τ) = Pr[G proposes f* for task τ]. Wrap it: pass every proposal through a decidable gate; store certified results (I3); emit silence where uncertified (PP7).

*Theorem.* The wrapper (i) never emits a wrong answer (0 false positives), (ii) preserves the generator's coverage: the probability of eventually certifying f* is at least C_G(τ) (given enough proposals), and (iii) monotonically accumulates: every certified result is permanent (I3), so the crystal only grows (LQ9).

*Proof.* (i) The gate emits PASS only when |S| = 1 (Theorem 2, V=I §5.25). A wrong answer requires PASS on f ≠ f*, which the gate rejects. So false positives = 0, independent of G's quality. (ii) If G proposes f* with probability C_G(τ) per trial, then after n trials the probability of having proposed f* at least once is 1 − (1 − C_G(τ))^n → 1. The gate certifies f* whenever proposed (Theorem 2: f* passes). So the wrapper's eventual coverage ≥ C_G(τ) — the generator's reach is not reduced, only its errors are filtered. (iii) I3: certified entries are append-only (V=I §2.4); no update, retraining, or weight change can erase them (LQ9: the front never recedes). QED.

*Corollary (the quality–silence tradeoff).* A better generator (higher C_G) shifts the answer/silence boundary outward — more answers, fewer silences — but never introduces error. Quality moves coverage; the gate moves correctness. The two axes are orthogonal (GD3). This is the `answer_or_silence.py` result measured: 0 wrong at any generator quality, with coverage tracking C_G.

The completion is not a new learner but a *wrapper*: keep the generator's flow, add the gate as the output membrane, I3 as permanence, honesty where still liquid. This is the AlphaProof shape (generator + checker), generalized.
*Tag:* the architecture is **solid** (demonstrated, `answer_or_silence.py`: 0 wrong at any generator quality); whether it reaches a rich domain's *coverage* is the **open** horn bet.

## §6. Measurement — the Saturation Map

**AI7 (A gate maps any system's crystal against its liquid).** Given a decidable gate for a domain D, run any system M's outputs through it. Define: M's *crystal* on D = {τ ∈ D : M(τ) passes the gate} and M's *liquid* on D = D \ crystal.

*Proof that the map is well-defined and informative.* (i) The gate is decidable (V=I §3.7), so membership in crystal/liquid is computable per task — no oracle needed. (ii) In the crystal, the output is certified (Theorem 2): the gate guarantees |S| = 1, so M's answer is f*. (iii) In the liquid, the output either fails the gate or M abstains; the only information is that M has not solved the task certifiably. (iv) The crystal fraction |crystal|/|D| is a measurable scalar — the system's *effective saturation* on D — directly comparable across systems and monotone under improvement (any new solve grows the crystal, none shrinks it by I3). QED.

*The saturation map as instrument.* Applied to any instance (an LLM, a reinforcement agent, any black box), the projection converts a uniform confidence signal into a two-tone map: certified here, uncertain there. The system need not be modified — the gate is external. Measurable today wherever a gate exists (code compilation + test suites, mathematical proof checkers, structured-output validators). **[solid; it is the C4a / ledger machinery (E2) projected onto an arbitrary system.]**

## §7. Boundaries

**Tags, not assertions.** Each projection carries a confidence tag (solid / interpretive / open). Coordinate readings for real systems — "pseudo-basis," "diffusion = generator," "RAG = patches" — are **interpretive** (defensible but not proven); the consequences derived from present/absent coordinates are **solid**.

**The open coordinate is α (and the basis).** Why a given domain is learnable at all — its α, its basis size — is not decided here; it is the horn bet (B8, GA), measurable but unmeasured for rich domains.

**Physics tools stay tools.** AI5 inherits Learning Is Liquid's discipline (LL §6): the liquid/front/turbulence vocabulary is borrowed analysis, and no equation of physics is claimed.

## §8. Statement

1. The framework projects onto any learning system via six coordinates — gate, I3, basis, organ, phase, α — and each guarantee holds exactly when its coordinate is present (AI1).
2. Projected onto an LLM: pure liquid, no gate, no I3, uncertified basis — hallucination, forgetting, and irreproducibility are the absent coordinates (AI2).
3. Projected onto reinforcement self-play: gate replaced by reward — a proof becomes a noisy, seed-dependent estimate (AI3).
4. A generator without certification coordinates succeeds where α > 0 and fails where any coordinate is absent — the projection derives both from the same reading (AI4).
5. Each system is a front-and-flow configuration; the LLM is flow without a front — power and fragility, one fact (AI5).
6. The instance where all coordinates are present — gate, I3, certified basis — is the framework's own shape: certified self-play, the AlphaProof architecture generalized (AI6).
7. A gate maps any system's crystal against its liquid — a saturation map, measurable today (AI7).

> **This document is a projection — the same move the framework makes on every domain it touches. Old AI built the table and could not scale it; new AI dropped the table and cannot certify. The framework is the coordinate system: project it onto a system, read which coordinates are present, and the guarantees and the failures are derived, not assessed. An LLM is liquid that never freezes and a basis that was never certified; it astonishes because the world is aligned, and it fails because it cannot tell a proof from a guess. Give it a gate, give it I3, and the same flow becomes a machine that answers or stays silent — never a confident lie.**

## §9. Dependency

### External

| Source | Used |
|---|---|
| V=I | §2.4 (I3), §3.7 (gate), §5.21/§5.22 (COMPARE), Theorem 2, outcome corollary, SAT5/6 |
| IiI | §3 (mutable-state = no I3, forgetting; Saturation Theorem) |
| GD | the generator/discriminator coordinate; GD3 (orthogonality), GD4 (inevitability asymmetry), GD7 (encoder/backend) |
| LL | the liquid/crystal/front/flow dynamics (LQ3, LQ5, LQ10); §6 (tool discipline) |
| GA | GA6 (α = success condition), GA7 (orthogonal axes) |
| B | B8 (saturability / basis), B8b (horn) |
| PP | PP7 (the certified/statistical contrast), PP15 (one given COMPARE), the answer-or-silence membrane |
| DiC | G12 (clustering) |
| PiR | §5 (projection onto physical systems — the structural precedent for this document) |
| E2 | encoder/backend factorization; C4a / ledger (the measurement, AI7) |
| External | mechanistic interpretability (superposition / polysemanticity, for "pseudo-basis"); AlphaProof / AlphaZero / diffusion / RAG (instances the framework projects onto, not derived) |

### Internal

| Statement | Depends on |
|---|---|
| AI1 | V=I Theorem 2, §5.22, SAT5/6, outcome corollary; IiI §3; B |
| AI2 | AI1; IiI §3 |
| AI3 | PP7; AI1 |
| AI4 | GA6; GD3 / GA7; AI1 |
| AI5 | LL LQ3, LQ5, LQ10 |
| AI6 | V=I Theorem 2, §2.4 (I3), §5.25; PP7; GD3; LQ9; AI1 |
| AI7 | V=I §3.7, Theorem 2; I3; E2 C4a / ledger; LL (crystal/liquid) |

The series derived a machine and proved its guarantees. This document projects those guarantees onto the field's machines: where the gate is present the output is certified, where I3 is present the library never shrinks, where α > 0 the generator exploits structure — and where a coordinate is absent, the corresponding guarantee is absent, derived from the same reading. The contribution is a projection — the framework's own vocabulary applied to every learner, with consequences that follow from coordinates, not from assessment.
