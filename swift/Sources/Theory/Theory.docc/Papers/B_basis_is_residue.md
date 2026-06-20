# Basis Is Residue (Basis)

Intelligence Is Inevitable proves the library saturates after one task per rule class — K tasks. This document sharpens K. Most rule classes are not new; they are recompositions of structure already certified. The genuinely new entries — those expressing transformation that no recomposition of prior entries reproduces — are the domain's *atoms*, and they are defined exactly as the prime numbers are: by survival of a sieve. A number is prime iff no product of strictly-smaller numbers reaches it; a rule is atomic iff no composition of strictly-smaller certified rules reaches it (B4). The atom set is the residue of running the composition-sieve over the library in norm order — Eratosthenes, lifted from multiplication to rule composition (B1–B3). The atom basis generates the reachable domain (B6); the library saturates at the atom level, and the true generating count is |basis| ≤ K (B7). This yields a decidable criterion for the question the series has circled since Distance Is Cost: a domain is saturable at finite cost iff its atom basis is finite (B8). Numbers under multiplication are the canonical negative — the basis is the primes, which are infinite (Euclid), so the domain never saturates. Whether a domain's rule basis is finite is not a matter of opinion but of running the sieve and reading the residue curve. Atom-ness is not a static property of a rule read in isolation — it is a property of the sieve trajectory, revealed by the process, depth-relative and library-relative (B9). This resolves the static/dynamic tension exactly as it resolves for primes: statically a residue looks structureless; dynamically, in a finite window, every survivor has a witnessed cause and the residue is fully determined (B10). What remains open is not whether the residue is computable — it is — but whether it is *compressible*: predictable more cheaply than the sieve that produces it (B11). That is the prime-distribution question wearing the framework's clothes, and it is named, not solved.

## §0. Derivation

No new postulate. One new operation, already implicit: rules compose. Everything below is derived from the W metric (DiC G1a, G2), the composition of certified rules, the Saturation Theorem (IiI §3), the ball cover (DiC G11), and the navigation graph (NiG N1).

1. A certified rule is a structure in Σ that denotes a function (grid → grid, or the domain's transformation type). *[V=I §4; I1]*
2. Functions compose: R∘Q applies Q then R. Composition is total, associative, has an identity. Certified rules under composition form a monoid. *[from 1]*
3. The composition of two certified rules is itself a candidate rule, gate-checkable on any task. *[V=I §2.2]*
4. The set of compositions of a finite atom set up to bounded depth is finite (|A|^≤d candidates), so "is R reachable by composition from A within depth d" is decidable. *[I1]*
5. A rule has a norm ‖R‖ (cost of existence) and rules have pairwise distance W. *[DiC G1a, G2]*
6. The norm orders the library; "strictly-smaller" is well-defined by norm (ties broken lexicographically). *[DiC G1a; V=I §3.7]*
7. A sieve processing the library in norm order, marking each rule derived-or-atomic by the decidable test of step 4, terminates over a finite library. *[I1]*
8. The residue — rules never marked derived — is the atom basis. Permanent (I3): an atom certified is an atom kept. *[I3]*

Eratosthenes' sieve is the special case where the structures are unary numbers and composition is multiplication. The construction below is that sieve with the operation generalized.

## §1. The Composition Sieve

**B1 (Composition).** For certified rules R, Q denoting functions on the domain, R∘Q is the rule denoting "apply Q, then R," gate-checkable on any task by compiling the composite and COMPARE-ing outputs (V=I §2.2). Composition is total and associative; the identity rule is the no-op. (Certified rules, ∘) is a monoid — the algebraic substrate this document adds to the framework, derived from function composition, not postulated.

**B2 (Wave and closure).** For an atom set A and depth d, the *wave* of A is the set of all rules expressible as a composition of ≤ d elements of A (with repetition). The depth-d *closure* Cl_d(A) is the union of waves up to d. Both are finite (B0.4). A rule R is *derived from A within d* iff R ∈ Cl_d(A) — equivalently, some bounded composition of A-atoms passes R's task gate (V=I §2.2). Reading through the navigation lens: Cl_d(A) is exactly the depth-d ball around A in the composition graph (NiG N1, edges = "compose with one atom"). The sieve and the navigation stack share one graph.

**B3 (The sieve).** Process the certified library L in non-decreasing norm order R₁, R₂, …, R_{|L|} (ties lexicographic, V=I §3.7). Maintain A, initially empty:

```
for each Rᵢ in norm order:
    if Rᵢ ∈ Cl_d(A):  mark Rᵢ DERIVED        # reachable by composing strictly-smaller atoms
    else:             add Rᵢ to A, mark ATOM  # irreducible: no compositional shortcut
return A
```

This is Eratosthenes verbatim with "product of smaller primes" replaced by "composition of smaller atoms." A number survives the number-sieve iff no smaller prime's multiplicative wave struck it; a rule survives this sieve iff no smaller atom's compositional wave reaches it.

## §2. The Atom Characterization

**B4 (Atom = no compositional shortcut).** Define the *compositional norm* of R relative to atoms A at depth d:

```
‖R‖_comp = min { Σ ‖aⱼ‖ : composition of aⱼ ∈ A, depth ≤ d, equals R }   (∞ if none)
```

R is an **atom** iff ‖R‖_comp ≥ ‖R‖ — no description of R as a composition of strictly-smaller certified rules is cheaper than R itself.

*This is the prime characterization, generalized.* For unary numbers under multiplication: ‖n‖_× (cheapest description as a product of strictly-smaller numbers) versus ‖n‖_+ (n's own length). A number is prime iff ‖n‖_× ≥ ‖n‖_+ — iff multiplication offers no shortcut over the bare additive chain. Primality is the equality of the two axial norms (the result derived in conversation, now general): atom-ness is the point where the compositional axis offers no compression over the intrinsic axis.

**B5 (The two axes, made precise).** Every domain with a composition operation has two norms on its structures: the *intrinsic* norm ‖·‖ (DiC G1a, the structure's own size) and the *compositional* norm ‖·‖_comp (cheapest build from atoms). Atoms are the fixed points where the two coincide; composites are where the compositional norm drops strictly below the intrinsic — they have a shortcut, a cheaper name (DiC G2 remark: the path crystallized into a name). The atom basis is the set on which no such name exists. The objectification ladder (OiO O17) bottoms out here: a composite is a path folded into an object; an atom is a path that does not fold — already at the floor of its norm.

## §3. Generation and Saturation

**B6 (The basis generates the reachable domain).** Let A be the sieve residue (B3). Then Cl_d(A) = Cl_d(L): every certified rule is reachable by composing atoms within depth d.

*Proof.* By construction, every Rᵢ marked DERIVED is in Cl_d(A) at the moment it is processed (B3's test), and A only grows (I3), so Rᵢ ∈ Cl_d(A) for the final A. Every Rᵢ marked ATOM is in A ⊆ Cl_d(A). Hence L ⊆ Cl_d(A); the reverse holds since atoms are certified rules. QED

**B7 (Atom-level saturation — sharpening of IiI §3).** The Saturation Theorem certifies the library after one task per rule class (K tasks). B6 sharpens the generating count: once every atom is certified, every further rule in the depth-d-reachable domain is DERIVED — a composition, requiring no new certificate beyond the gate check. The effective generating count is |A| ≤ K, and is strictly smaller whenever any rule class is a nontrivial composition (the common case under a compositional grammar). Atoms are the ultimate anchors of the ball cover (DiC G11): G11 covers the library with balls around anchors; B7 identifies the irreducible anchors — the ones not themselves inside another anchor's compositional ball.

**B8 (Saturability criterion).** A domain is **saturable at finite cost** iff its atom basis A is finite.

*Proof.* (⇐) Finite A: certify each atom (finite work, IiI §6 coupon collector over |A| classes), then every reachable rule is DERIVED by B6 — no further certificates. Saturation in finite total cost. (⇒) Infinite A: the atoms are by B4 mutually non-derivable (no atom is a composition of strictly-smaller atoms — else it would have been marked DERIVED, not added). An infinite set of mutually non-derivable rules cannot be covered by finitely many certificates, since each atom requires its own (it lies in no closure of the others). Not saturable at finite cost. QED

**B8a (The canonical negative).** Numbers under multiplication: the atom basis is the primes. By Euclid the primes are infinite. By B8 the domain is not saturable at finite cost — no finite set of multiplicative atoms generates all numbers. This is not a defect of the framework; it is the framework correctly reporting that arithmetic-by-multiplication is an *open* domain, one where new irreducible structure never stops arriving. The prime numbers are the proof that B8's negative case is real and inhabited.

**B8b (The trichotomy — and the horn between).** By (basis, reach) every composition domain is exactly one of: **CLOSED** (|A| < ∞, behavioral reach N bounded), **HORN** (|A| < ∞, N → ∞), **PRIMES** (|A| = ∞). The fourth cell — infinite basis, bounded reach — is empty: atoms lie in the reach, and infinitely many distinct atoms force unbounded norm (a bounded norm admits finitely many structures, DiC G8), so |A| = ∞ ⇒ N → ∞. ℕ under addition is the canonical horn: one atom (the successor, V=I §4.1), infinite reach (every numeral), all DERIVED (Peano). ℕ under multiplication is the primes (B8a). The same set is a horn under + and a prime-thicket under × — so horn-ness is a property of the **composition operator**, not the domain (the two axes of B5).

**B8c (The painter's paradox is B7, with a sharp cutoff).** A horn has finite basis cost yet infinite reach — finite paint, infinite surface (Torricelli). The resolution is B6–B7: let s₀ = max{‖a‖ : a ∈ A} (finite, since A is finite). Every composite of norm > s₀ is DERIVED (B6) — zero new certificate. So the marginal certification cost is 0 past s₀, and total cost Σ_{a∈A}‖a‖ ≤ |A|·s₀ < ∞. The finite basis "coats" the infinite reach not by thinning paint to zero but by a sharp cutoff at s₀: pay below it, derive above it.

**B8d (The invariant is the reach-growth rate γ; the metaphor understates it).** Define γ = lim sup_s (ln N(s)) / s. CLOSED: N bounded. HORN: N → ∞, graded by γ — γ = 0 *thin* (ℕ-under-+ grows linearly; Torricelli's surface diverges only logarithmically, the thinnest horn), γ > 0 *fat* (a branching grammar, N ~ e^{γs}). The literal horn profile (volume ∫x⁻², surface ∫x⁻¹) does **not** transfer: the framework's reach *grows* rather than decaying-and-marginally-diverging, so Torricelli is the slowest possible horn, not the model. The entropy of the composition monoid, γ, is the quantity — not the 1/x profile.

**B8e (Two residue curves).** The residue curve splits in two: |atoms|(s) [the volume] and N(s) [the behavioral surface]. Both bounded ⇒ CLOSED; |atoms| plateaus while N(s) → ∞ ⇒ HORN (finite priors, unbounded recombination — an evaluation set that defeats r = 0 is, formally, *a horn*); |atoms| grows ⇒ PRIMES (B8a). The log-slope of N(s) measures γ. Sampling caveat for self-play: on an infinite-reach horn no uniform measure over ⟨Π⟩ exists, and any norm-discount β^{‖g‖} normalizes only for β < e^{−γ}, concentrating on small norm — so coverage must be enumerated by norm, never sampled (Play Is Proof PP5c).

## §4. Static and Dynamic

**B9 (Atom-ness is a property of the trajectory, not the rule).** Whether R is an atom is not readable from R alone. It is the outcome of the sieve (B3): R is an atom relative to (the library scanned before it in norm order, the depth bound d). Two relativities, both honest and both measurable:

- *Library-relative:* R atomic against a small library may become derived against a larger one that contains the atoms composing it. (For primes this relativity vanishes — "product of strictly-smaller" is fixed by magnitude — because the number domain's atoms are already all present below n. For a rule domain still under construction, the relativity is real and is measurable.)
- *Depth-relative:* an atom at depth d may be derived at depth d+1. Reported as a curve over d, exactly as encoding-relativity is reported per encoding (IiI §4; DiC §11).

**B10 (The static/dynamic resolution).** Statically — reading rules in isolation — the basis looks structureless: there is no surface predicate on a rule that announces "atom." Dynamically — running the sieve over a finite window — every atom has a witnessed cause: it was added precisely because the gate rejected every bounded composition of its predecessors (B3). In a finite domain the sieve terminates and the residue is fully determined: no randomness, only the determined pattern of which compositional waves failed to cover which rules. This is the framework's account of why primes look random but are not: the residue of a sieve is causally determined yet has no description simpler than the sieve until proven otherwise (B11). The user's move — *statically undecidable-looking, dynamically determined in finite space* — is exact: I1 guarantees the sieve halts, and a halted sieve has named every survivor's reason.

## §5. The Open Question, Named

**B11 (Computable, not yet compressible).** The sieve computes the basis (B3, terminating by I1). This is *constructive* definability: to know the atoms up to norm n, run the sieve to norm n. It is not *compressed* definability: no method is known to predict the residue more cheaply than running the sieve. The two are different (the framework's standing distinction, G12: a path computed is not a path compressed). For primes, this gap is the prime-distribution problem: the sieve computes them, the prime-number theorem compresses their *density* (≈ n/ln n — a found axis for the statistics), but their *exact sequence* has no known compression — the Riemann Hypothesis is the question of whether a deeper regularity axis exists. For a rule domain the identical gap holds: the sieve computes the residue; whether it has a generating formula cheaper than the sieve is open per domain. The framework does not solve this. It *locates* it precisely — as the compressibility of a sieve's residue — and refuses the mysticism: the residue is not random (B10), it is determined-but-possibly-incompressible, which is a sharp and honest status.

**B12 (Why this is the right open question).** Earlier the puzzle was phrased "why are primes irreducible / a void." Both framings were wrong (a prime is not a void — it is an atom, the densest object, not the emptiest; PiR's irreducibility M-property, not NiG's hole). The sieve reframes the live question correctly: not *why* atoms resist composition (they resist by definition — that is what atom means), but *whether the pattern of atoms is compressible*. That question is identical across domains — primes, ARC rules, any compositional structure — and the answer is a measurable property of each domain's residue curve, with one domain (primes) known to be hard and one domain (ARC) the open experimental bet. The framework's contribution is the unification: irreducibility, saturability, and generalization are three readings of one object — the atom basis — and its size and compressibility are measured, not assumed.

## §6. Statement

1. Rules compose; certified rules form a monoid; the composition sieve is Eratosthenes with multiplication replaced by composition (B1–B3).
2. An atom is a rule with no compositional shortcut — the equality of intrinsic and compositional norm, the prime characterization generalized (B4–B5).
3. The atom basis generates the reachable domain and is the true generating count, |A| ≤ K — a sharpening of saturation, the irreducible anchors of the ball cover (B6–B7).
4. A domain is saturable at finite cost iff its atom basis is finite; numbers-under-multiplication are the canonical infinite-basis negative, proven by Euclid (B8–B8a).
5. Atom-ness is a property of the sieve trajectory — library- and depth-relative — which resolves the static/dynamic tension: a residue is structureless statically but causally determined dynamically in finite space (B9–B10).
6. The residue is computable but possibly incompressible; that gap, not the irreducibility itself, is the live open question, identical for primes and for ARC, and measured per domain (B11–B12).
7. Over a domain's certified library, the sieve's residue curve and the train-atom coverage of held-out tasks measure basis size and transfer — the number that subsumes saturation, clustering, and generalization.

> **A prime is what survives the sieve of products; an atom is what survives the sieve of compositions; a basis is the residue, and a domain can be learned to the end exactly when that residue is finite. Running the sieve always finds it. Whether the finding can be foreseen is the one question left — named precisely, and left honest.**

## §7. Dependency

### External

| Source | Used |
|---|---|
| V=I | §2.2 (gate checks any candidate), §3.7 (norm order, tie-break), §4 (rules as structures), I1, I3 |
| IiI | §3 (Saturation Theorem, K — sharpened by B7), §4 (encoding boundary), §6 (coupon collector over the basis) |
| PiR | irreducibility M-property (atom = irreducible entry), I3 (atom permanence) |
| DiC | G1a (intrinsic norm), G2 (W; path-into-name remark), G6 (additive axis carries the metric), G11 (ball cover, anchors), G12 (computable ≠ compressible), §11 (encoding-relativity) |
| NiG | N1 (composition graph = the sieve's graph), N18 (one boundary) |
| OiO | O17 (objectification ladder; atom = unfoldable path) |
| External | Eratosthenes (the sieve, multiplicative case); Euclid (infinitude of primes = B8a); prime number theorem & Riemann Hypothesis (the density-compressible / sequence-open gap, B11) |

### Internal

| Statement | Depends on |
|---|---|
| B1 | V=I §2.2; function composition |
| B2 | B1; I1; NiG N1 |
| B3 | B2; DiC G1a; V=I §3.7; I1, I3 |
| B4 | B3; DiC G1a, G6 |
| B5 | B4; DiC G2; OiO O17 |
| B6 | B3; I3 |
| B7 | B6; IiI §3; DiC G11 |
| B8 | B6, B7; IiI §6 |
| B8a | B8; Euclid |
| B8b | B8, B8a; DiC G8; B5; V=I §4.1 |
| B8c | B6, B7; DiC G1a |
| B8d | B8b; DiC G12 |
| B8e | B8d; PP PP5c |
| B9 | B3; IiI §4; DiC §11 |
| B10 | B9; I1; DiC G12 |
| B11 | B3; DiC G12; PNT/RH |
| B12 | B11; PiR irreducibility; NiG N18 |

Distance Is Cost asked what the magnitude of a comparison is. Intelligence Is Inevitable asked when the library is complete. This document answers both at once: the library is complete when its atoms are certified, the atoms are the residue of a sieve, and the only thing the sieve cannot promise is that its own residue was foreseeable. The prime numbers were the warning that some residues are not — and the same sieve, pointed at a new domain, asks whether it was kinder.

## Topics

### Theorems this paper proves

- ``RulesCompose``
- ``AtomBasis``
- ``AtomnessIsTrajectory``
