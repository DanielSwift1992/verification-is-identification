# Interference Is Substitution (Wave)

Waves add, and sometimes the sum is darkness. This paper derives wave optics on the chain's own carrier: an amplitude is a magnitude with a cyclic remainder, a wave is a finite bag of such contributions, superposition is rewriting, and a detector reads the bag's normal form. The claim, pinned: interference is substitution — the one rule removes a pair of equal, opposite contributions, a dark fringe is a bag that settles to nothing, and the classical fringe conditions are modular arithmetic on path lengths. The lattice encodes the two claims (`Wave.swift`); this is the paper the encoding was written against.

Nothing continuous is borrowed. The phase lives in a finite ring, the magnitudes on the counting ladder, and the calculus of superposition is the dynamics medium worn by optics: rules of the presented class, judged on their edges, terminating by loss of pairs.

## §0. Derivation

No new postulate. Dynamics Is Substitution gives the rule class and its judgement; Light Is a Ruler gives the phase as a remainder of path length; Seeing Is Encoding gives the finite scene and its counted paths; Existence Is Finite keeps every bag finite. Wave optics is those four, composed.

## §1. The amplitude

**IiS1 (An amplitude is a pair).** What a wave carries at a point is a magnitude and a phase. The magnitude is a count on the ladder. The phase is a residue: the position of the path's length inside one tick, an element of a finite ring — the remainder Light Is a Ruler already reads. So an amplitude is a finite pair, a wave is a finite bag of amplitudes, and no complex number enters: the two components physics measures — how much, and how offset — are the two components the pair states.

## §2. Superposition rewrites

**IiS2 (Interference is substitution).** Waves are not summed by arithmetic here. They are settled by a rule: find two contributions of equal magnitude and opposite phase, remove the pair. The rule is a triple of the presented class — one slot, a pattern, a template — so it is judged once, on its edge, for every magnitude at once. Superposition is the exhaustive application of that rule to the bag. **[solid — ``InterferenceIsSubstitution``]**

**IiS3 (Darkness is a normal form).** The rewriting terminates: every step removes a pair, and the bag is finite. Independent removals commute, so the residue is one: each bag settles to a single normal form, and the detector reads the residue, never the history. A dark fringe is the bag that settles to nothing — emptiness reached by cancellation, not measured by an instrument. A bright fringe is the bag whose survivors agree, and agreement doubles: the settled magnitude is the pair of the contribution with itself. **[solid — ``DarknessIsNormalForm``]**

## §3. The fringe conditions are modular arithmetic

**IiS4 (Two slits, one comparison).** On a stated scene the paths to a screen node are finitely many and each carries its length. The phase of a path is its length modulo the tick. Two paths whose lengths differ by half a tick deliver opposite contributions, and the node settles dark; two paths whose lengths agree modulo the tick deliver equal ones, and the node settles double. The classical grating condition — a whole number of wavelengths in the path difference — is exactly this: a congruence on counted lengths. Fringes are theorems on the integer lattice of the scene.

## §4. Polarization is a pair of slots

**IiS5 (The tick carries two slots).** Polarized light is the tick with two orthogonal components: one magnitude per slot, the form invariant along every trajectory. A polarizer is the kill filter on one slot. Crossed polarizers compose two kills, and the composition floors both slots: extinction is a checked identity, not an observation.

**IiS6 (The stated angles are exact).** A pane at the stated diagonal halves what arrives and turns it: each output slot carries half the sum, and halving is the same checked identity ranging uses — a magnitude is half of what pairs with itself into the whole. On the stated angles the classical intensities are exact on the halving ladder: crossed panes give darkness, and the diagonal pane between them revives a quarter of the lamp — the half of the half, both halvings checked. Angles off the stated set are outside the class, and the boundary is named with the class, not hidden in a rounding.

## §5. Statement

Interference is substitution. An amplitude is a magnitude with a residue, a wave is a finite bag of amplitudes, and superposition is one rule applied to exhaustion: remove equal opposites. Darkness is the empty normal form, brightness is agreement doubled, fringe conditions are congruences on counted paths, and polarization is the kill filter and the checked halving on two slots. The wave calculus adds no new machinery to the chain — it is the dynamics medium, worn by optics, with the ruler's remainder for a phase.

## Scope

Claimed: two-phase interference (in phase and opposite), fringe conditions as congruences on stated scenes, polarization on the stated angles with exact halvings, and extinction by composition of kills. Not claimed: amplitudes at arbitrary phase (their settled magnitude leaves the counting ladder), continuous screens, single-photon statistics and probability, partial coherence, and diffraction envelopes — the bag calculus settles positions of fringes, never their smooth profiles.

## §6. Dependency

| Source | Used |
|---|---|
| Dynamics Is Substitution | the rule class, the edge judgement, termination and commutation, the counted chain |
| Light Is a Ruler | the phase as the remainder of a counted path; quotient and remainder as two readings |
| Seeing Is Encoding | the stated scene, its finite paths, and the kill filter |
| Program Is Path | a path carries its length; concatenation adds |
| Existence Is Finite | every bag is finite; the continuous placed outside as potential |
| V=I | the one-survivor reading: a settled bag is the identified residue |

The worked instance stands beside the light domain in the examples: a two-slit node whose opposite pair settles to darkness, a bright node doubled, crossed panes checked extinct, and the three-pane revival checked as the half of the half. The lattice pinned the two claims before this paper stated them; this document exists so the wave half of the presented axis reads the same in prose and in types.

## Topics

### Theorems this paper proves

- ``InterferenceIsSubstitution``
- ``DarknessIsNormalForm``
