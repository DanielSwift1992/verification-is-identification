# Interference Is Substitution (Wave)

Waves can cancel. The example checks cancellation of a supplied equal, opposite pair and two axis-aligned slot filters. Extending those checks to all interference or polarization requires a carrier that retains the distinctions needed by later measurements.

## §0. Premises

A declared finite contribution bag and a declared phase grid define the discrete model. Seeing Is Encoding requires an explicit path list or depth restriction, not just a finite scene graph. Light Is a Ruler's modular path coordinate is a discrete encoding. Its relation to physical optical phase requires a propagation model. Neither finite notation nor a cancellation rule derives wave optics by itself.

## §1. The amplitude

### IiS1

**IiS1 (A discrete amplitude representation).** A nonnegative magnitude and a phase residue represent a declared class of contributions. A finite phase grid with integer magnitudes is generally not closed under vector addition. Two unit amplitudes at phases 0 and π/2 sum to magnitude √2 at π/4. The present cancellation rule instead concerns two opposite phases. Even in that restricted class, one must distinguish a bag of contributions from its physical net amplitude.

## §2. Superposition rewrites

### IiS2

**IiS2 (Equal opposites cancel).** Removing two contributions with equal magnitude and opposite phase preserves their signed total. `OppositePair` checks the supplied matching magnitude and phase coordinates. Exhausting this rule is not a complete procedure for summing arbitrary two-phase bags: the bag +1,+1,−2 has zero total but contains no removable equal, opposite pair.

### IiS3

**IiS3 (A normal form depends on the rules).** Each removal reduces a finite bag by two entries. At a fixed magnitude, cancellation leaves the excess count of one phase over its opposite, independently of removal order. This gives a unique residue as an unordered multiset for those rules. Empty residue implies zero total. The converse fails for the preceding bag. If every contribution is first expressed in one common unit, the two counts instead yield a complete signed sum, and equality of those counts is equivalent to zero. That refinement needs an actual construction, not a claim that confluence alone proves detector darkness. Coherent equal in-phase amplitudes double their amplitude, giving four times one contribution's intensity, not twice that intensity.

The common-unit construction is now in `Amplitude.swift`. `StartAmplitudeBlock` keeps an initial unit word and zero magnitude. Each positive or negative increment increases the original contribution's magnitude by one and adds the corresponding unit to that word. `AppendAmplitudeBlock` requires the block's initial word to equal the preceding sum's actual word and reconstructs the appended `Contribution` from the block's computed magnitude and phase. Induction on these constructors proves that the word's positive count minus negative count equals the signed sum of the original contributions. Both counts use the existing finite `Vacuum/In/Out` grammar, interpreted here as signed units, without imposing the ice-vertex constraint.

`ZeroAmplitudeReading` requires equality of those two computed counts and returns zero on the retained original source. In this finite integer two-phase domain, the count equality is necessary and sufficient for zero signed amplitude. Every finite contribution list has an expansion: apply the appropriate unit constructor as many times as its declared unary magnitude, then append the block. The empty list gives zero as well. Arbitrary conformances to the open expansion interfaces do not supply this inductive interpretation. `Checks/Seeing.swift` verifies the full source +1,+1,−2 and its zero reading, and rejects restarting a block at the wrong word, changing its sign, replacing the reconstructed magnitude and asserting zero for a positive residue. The old `OppositePair` accidentally accepted only magnitude `Lit1` despite claiming a generic rule. Its constraints now equate the actual magnitude coordinates, and a generic compiler check covers every supplied magnitude.

When equal opposite magnitudes are already identified, unit expansion is unnecessary. `OppositeAmplitudeReading<M>` retains the actual pair of contributions with common magnitude M and opposed phases, and returns zero directly. The signed interpretation is M−M=0 for every admitted finite M. The type constructor never asks for the numerical magnitude or enumerates its units. The unit expansion supplies the more general finite-list route when cancellation is spread across unequal contributions. These are two levels of evidence for the same zero question, rather than two physical laws.

## §3. The fringe conditions are modular arithmetic

### IiS4

**IiS4 (A conditional fringe relation).** Under a monochromatic coherent propagation model, equal initial phases, equal polarization and equal amplitudes, a path difference of half a wavelength gives destructive interference, while a whole wavelength gives constructive interference. A declared integer grid with an even number of steps per wavelength can encode these cases as congruences. Phase opposition without equal amplitudes does not force darkness. Unequal initial phases, coherence and propagation effects require their own terms. The congruence alone is not a derivation of all fringe intensities.

## §4. Polarization is a pair of slots

### IiS5

**IiS5 (Axis filters on a restricted record).** The existing `PolarizedLight` record contains horizontal and vertical magnitudes. Interpreted as component intensities, an ideal horizontal or vertical polarizer zeroes the other component. The example checks this slot operation. Such a record omits relative phase or, more generally, cross-correlation between the field components.

### IiS6

**IiS6 (A diagonal analyzer exposes the omitted relation).** In the Jones model for fully polarized coherent light, take normalized vectors u₊=(1,1)/√2 and u₋=(1,−1)/√2. Both have component intensities (1/2,1/2). An ideal +45° polarizer has matrix

```
P₊ = (1/2) [[1,1],[1,1]].
P₊u₊ = u₊,   P₊u₋ = 0.
```

Thus the output intensities are one and zero, despite the identical input intensity records. No function of those two recorded intensities alone can compute this analyzer's output for both states, by Seeing Is Encoding SiE3. The missing information is a relation between components. Adding the two complex amplitudes, or their coherency matrix, supplies it for the stated model. This follows the [Jones matrix treatment in MIT's photonics notes](https://www.ocw.mit.edu/courses/6-974-fundamentals-of-photonics-quantum-electronics-spring-2006/bf3bdeb971819ddc9c68719d28bb2745_classnotes.pdf), rather than treating intensity and amplitude as interchangeable.

For a normalized horizontal input (1,0), P₊ gives (1/2,1/2), of total intensity 1/2. A subsequent vertical polarizer leaves (0,1/2), of intensity 1/4. The familiar three-polarizer transmission therefore follows on this specified input. `DiagonalAfterLampH` supplies this one output in the existing Swift example. It is not a general diagonal-polarizer operation on arbitrary `PolarizedLight` inputs.

## §5. What the optical and quantum models share

Derivations: <doc:interference_is_substitution__models_calibration#Detail-5-What-the-optical-and-quantum-models-share>.

## §6. What a calibration must establish

Derivations: <doc:interference_is_substitution__models_calibration#Detail-6-What-a-calibration-must-establish>.

## §7. Why the joint context constrains a local rule

Derivations: <doc:interference_is_substitution__positive_channels#Detail-7-Why-the-joint-context-constrains-a-local-rule>.

## §8. Positivity by a retained factorization

Derivations: <doc:interference_is_substitution__positive_channels#Detail-8-Positivity-by-a-retained-factorization>.

## §9. A matrix certificate for all untouched-reference contexts

Derivations: <doc:interference_is_substitution__positive_channels#Detail-9-A-matrix-certificate-for-all-untouched-reference-contexts>.

## §10. Which questions survive a channel?

Derivations: <doc:interference_is_substitution__positive_channels#Detail-10-Which-questions-survive-a-channel>.

## §11. A stopping certificate for future questions

Derivations: <doc:interference_is_substitution__positive_channels#Detail-11-A-stopping-certificate-for-future-questions>.

## §12. When no internal remainder can complete the proposed change

Derivations: <doc:interference_is_substitution__global_obstructions#Detail-12-When-no-internal-remainder-can-complete-the-proposed-change>.

## §13. A whole obstruction invisible in every proper preparation family

Derivations: <doc:interference_is_substitution__global_obstructions#Detail-13-A-whole-obstruction-invisible-in-every-proper-preparation-family>.

## §14. A finite refusal before an amplitude scale

Derivations: <doc:interference_is_substitution__global_obstructions#Detail-14-A-finite-refusal-before-an-amplitude-scale>.

## §15. An operation can require a larger address domain

Derivations: <doc:interference_is_substitution__global_obstructions#Detail-15-An-operation-can-require-a-larger-address-domain>.

## §16. What local silence and incidence leave undecided

Derivations: <doc:interference_is_substitution__global_obstructions#Detail-16-What-local-silence-and-incidence-leave-undecided>.

## §16a. A finite contact can determine the programmed operation

Derivations: <doc:interference_is_substitution__program_mediator#Detail-16a-A-finite-contact-can-determine-the-programmed-operation>.

## §16b. The retained program determines the next contact

Derivations: <doc:interference_is_substitution__program_mediator#Detail-16b-The-retained-program-determines-the-next-contact>.

## §16c. A returned mediator has different permissions along the word

Derivations: <doc:interference_is_substitution__program_mediator#Detail-16c-A-returned-mediator-has-different-permissions-along-the-word>.

## §16d. An extremal joint comparison forces a cosine profile

Derivations: <doc:interference_is_substitution__comparison_fluctuations#Detail-16d-An-extremal-joint-comparison-forces-a-cosine-profile>.

## §16e. Which acquisition preserves a joint positive comparison?

Derivations: <doc:interference_is_substitution__comparison_fluctuations#Detail-16e-Which-acquisition-preserves-a-joint-positive-comparison>.

## §16f. A positive comparison can exclude every scalar-phase mixture

Derivations: <doc:interference_is_substitution__comparison_fluctuations#Detail-16f-A-positive-comparison-can-exclude-every-scalar-phase-mixture>.

## §16g. A mean comparison forces hidden intensity fluctuations

Derivations: <doc:interference_is_substitution__comparison_fluctuations#Detail-16g-A-mean-comparison-forces-hidden-intensity-fluctuations>.

## §16h. The residual witness has a passive implementation and an acquired calibration

Derivations: <doc:interference_is_substitution__support_calibration#Detail-16h-The-residual-witness-has-a-passive-implementation-and-an-acquired-calibration>.

## §16i. Compiling the refusal needs a smaller interface than compiling Q

Derivations: <doc:interference_is_substitution__support_calibration#Detail-16i-Compiling-the-refusal-needs-a-smaller-interface-than-compiling-Q>.

## §16j. A power certificate and a coherent continuation

Derivations: <doc:interference_is_substitution__support_calibration#Detail-16j-A-power-certificate-and-a-coherent-continuation>.

## §16k. Replacing device admission by acquired support relations

Derivations: <doc:interference_is_substitution__support_calibration#Detail-16k-Replacing-device-admission-by-acquired-support-relations>.

## §16l. Acquiring the relation that the next control needs

Derivations: <doc:interference_is_substitution__acquired_programs#Detail-16l-Acquiring-the-relation-that-the-next-control-needs>.

## §16m. Learn in one program and execute an equivalent shorter one

Derivations: <doc:interference_is_substitution__acquired_programs#Detail-16m-Learn-in-one-program-and-execute-an-equivalent-shorter-one>.

## §16n. Four contacts are necessary for the question itself

Derivations: <doc:interference_is_substitution__acquired_programs#Detail-16n-Four-contacts-are-necessary-for-the-question-itself>.

## §16o. A finite reading of whether classical environmental correction can suffice

Derivations: <doc:interference_is_substitution__support_memory#Detail-16o-A-finite-reading-of-whether-classical-environmental-correction-can-suffice>.

## §16p. Joint acquisition can certify support without identifying the analyzer

Derivations: <doc:interference_is_substitution__support_memory#Detail-16p-Joint-acquisition-can-certify-support-without-identifying-the-analyzer>.

## §16q. Local replacement and private control admit arbitrary correlated memory

Derivations: <doc:interference_is_substitution__support_memory#Detail-16q-Local-replacement-and-private-control-admit-arbitrary-correlated-memory>.

## §16r. A support-preserving test can destroy a recoverable continuation

Derivations: <doc:interference_is_substitution__support_memory#Detail-16r-A-support-preserving-test-can-destroy-a-recoverable-continuation>.

## §16s. Acquired uncertainty can select an optimal repair without identifying the fault

Derivations: <doc:interference_is_substitution__repair_continuation#Detail-16s-Acquired-uncertainty-can-select-an-optimal-repair-without-identifying-the-fault>.

## §16t. A retained control relation can carry and then release a continuation

Derivations: <doc:interference_is_substitution__repair_continuation#Detail-16t-A-retained-control-relation-can-carry-and-then-release-a-continuation>.

## §16u. A history may be compressed only relative to its continuation

Derivations: <doc:interference_is_substitution__repair_continuation#Detail-16u-A-history-may-be-compressed-only-relative-to-its-continuation>.

## §17. Dependency

| Source | Used |
|---|---|
| Dynamics Is Substitution | the rule class, the edge judgement, termination and commutation, the counted chain |
| Light Is a Ruler | the phase as the remainder of a counted path, quotient and remainder as two readings |
| Seeing Is Encoding | the stated scene, its finite paths, and the kill filter |
| Program Is Path | a path has its length, concatenation adds |
| Existence Is Finite | finite description and explicit constructor-domain scope |
| V=I | the one-survivor reading: a settled bag is the identified residue |
| Matter M35, M70 | source recovery, unrestricted remainder and the distinction between a prepared application and reuse |
| Liquid LQ13–LQ16 | specified contact admission, shared witnesses and the obligations of a cut |

The worked instances in Light.swift check a supplied opposite pair, a doubled magnitude, axis-slot extinction and the stated proportions of one diagonal output. The operator calculation above supplies the missing interpretation and its domain. Wave.swift has retired its unbound interface coordinates. The operator interpretation remains the conditional calculation above, rather than a generic protocol conformance.

## Cross-page mentions

Labels mentioned here: <doc:learning_is_liquid__medium_contacts#LQ13>, <doc:learning_is_liquid__reconstructed_sides#LQ16>, <doc:permanence_is_resistance__records_entropy#M35>, <doc:permanence_is_resistance__recovery_remainder#M70>.

Mentions of this page’s labels: <doc:interference_is_substitution__models_calibration> (IiS6).

## Topics

### Parts

- <doc:interference_is_substitution__models_calibration>
- <doc:interference_is_substitution__positive_channels>
- <doc:interference_is_substitution__global_obstructions>
- <doc:interference_is_substitution__program_mediator>
- <doc:interference_is_substitution__comparison_fluctuations>
- <doc:interference_is_substitution__support_calibration>
- <doc:interference_is_substitution__acquired_programs>
- <doc:interference_is_substitution__support_memory>
- <doc:interference_is_substitution__repair_continuation>

### Encoding status

The unbound `InterferenceIsSubstitution`/`Contribution` and `DarknessIsNormalForm`/`Observed` interfaces are retired. The actual finite amplitude and quantum constructors remain in Examples. Their supplied models do not encode every physical intensity or phase sum.
