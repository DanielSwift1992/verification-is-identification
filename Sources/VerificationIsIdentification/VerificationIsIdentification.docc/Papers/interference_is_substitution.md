# Interference Is Substitution (Wave)

Waves can cancel. The example checks cancellation of a supplied equal, opposite pair and two axis-aligned slot filters. Extending those checks to all interference or polarization requires a carrier that retains the distinctions needed by later measurements.

## §0. Premises

A declared finite contribution bag and a declared phase grid define the discrete model. Seeing Is Encoding requires an explicit path list or depth restriction, not just a finite scene graph. Light Is a Ruler's modular path coordinate is a discrete encoding. Its relation to physical optical phase requires a propagation model. Neither finite notation nor a cancellation rule derives wave optics by itself.

## §1. The amplitude

**IiS1 (A discrete amplitude representation).** A nonnegative magnitude and a phase residue represent a declared class of contributions. A finite phase grid with integer magnitudes is generally not closed under vector addition. Two unit amplitudes at phases 0 and π/2 sum to magnitude √2 at π/4. The present cancellation rule instead concerns two opposite phases. Even in that restricted class, one must distinguish a bag of contributions from its physical net amplitude.

## §2. Superposition rewrites

**IiS2 (Equal opposites cancel).** Removing two contributions with equal magnitude and opposite phase preserves their signed total. `OppositePair` checks the supplied matching magnitude and phase coordinates. Exhausting this rule is not a complete procedure for summing arbitrary two-phase bags: the bag +1,+1,−2 has zero total but contains no removable equal, opposite pair.

**IiS3 (A normal form depends on the rules).** Each removal reduces a finite bag by two entries. At a fixed magnitude, cancellation leaves the excess count of one phase over its opposite, independently of removal order. This gives a unique residue as an unordered multiset for those rules. Empty residue implies zero total. The converse fails for the preceding bag. If every contribution is first expressed in one common unit, the two counts instead yield a complete signed sum, and equality of those counts is equivalent to zero. That refinement needs an actual construction, not a claim that confluence alone proves detector darkness. Coherent equal in-phase amplitudes double their amplitude, giving four times one contribution's intensity, not twice that intensity.

The common-unit construction is now in `Amplitude.swift`. `StartAmplitudeBlock` keeps an initial unit word and zero magnitude. Each positive or negative increment increases the original contribution's magnitude by one and adds the corresponding unit to that word. `AppendAmplitudeBlock` requires the block's initial word to equal the preceding sum's actual word and reconstructs the appended `Contribution` from the block's computed magnitude and phase. Induction on these constructors proves that the word's positive count minus negative count equals the signed sum of the original contributions. Both counts use the existing finite `Vacuum/In/Out` grammar, interpreted here as signed units, without imposing the ice-vertex constraint.

`ZeroAmplitudeReading` requires equality of those two computed counts and returns zero on the retained original source. In this finite integer two-phase domain, the count equality is necessary and sufficient for zero signed amplitude. Every finite contribution list has an expansion: apply the appropriate unit constructor as many times as its declared unary magnitude, then append the block. The empty list gives zero as well. Arbitrary conformances to the open expansion interfaces do not supply this inductive interpretation. `Checks/Seeing.swift` verifies the full source +1,+1,−2 and its zero reading, and rejects restarting a block at the wrong word, changing its sign, replacing the reconstructed magnitude and asserting zero for a positive residue. The old `OppositePair` accidentally accepted only magnitude `Lit1` despite claiming a generic rule. Its constraints now equate the actual magnitude coordinates, and a generic compiler check covers every supplied magnitude.

When equal opposite magnitudes are already identified, unit expansion is unnecessary. `OppositeAmplitudeReading<M>` retains the actual pair of contributions with common magnitude M and opposed phases, and returns zero directly. The signed interpretation is M−M=0 for every admitted finite M. The type constructor never asks for the numerical magnitude or enumerates its units. The unit expansion supplies the more general finite-list route when cancellation is spread across unequal contributions. These are two levels of evidence for the same zero question, rather than two physical laws.

## §3. The fringe conditions are modular arithmetic

**IiS4 (A conditional fringe relation).** Under a monochromatic coherent propagation model, equal initial phases, equal polarization and equal amplitudes, a path difference of half a wavelength gives destructive interference, while a whole wavelength gives constructive interference. A declared integer grid with an even number of steps per wavelength can encode these cases as congruences. Phase opposition without equal amplitudes does not force darkness. Unequal initial phases, coherence and propagation effects require their own terms. The congruence alone is not a derivation of all fringe intensities.

## §4. Polarization is a pair of slots

**IiS5 (Axis filters on a restricted record).** The existing `PolarizedLight` record contains horizontal and vertical magnitudes. Interpreted as component intensities, an ideal horizontal or vertical polarizer zeroes the other component. The example checks this slot operation. Such a record omits relative phase or, more generally, cross-correlation between the field components.

**IiS6 (A diagonal analyzer exposes the omitted relation).** In the Jones model for fully polarized coherent light, take normalized vectors u₊=(1,1)/√2 and u₋=(1,−1)/√2. Both have component intensities (1/2,1/2). An ideal +45° polarizer has matrix

```
P₊ = (1/2) [[1,1],[1,1]].
P₊u₊ = u₊,   P₊u₋ = 0.
```

Thus the output intensities are one and zero, despite the identical input intensity records. No function of those two recorded intensities alone can compute this analyzer's output for both states, by Seeing Is Encoding SiE3. The missing information is a relation between components. Adding the two complex amplitudes, or their coherency matrix, supplies it for the stated model. This follows the [Jones matrix treatment in MIT's photonics notes](https://www.ocw.mit.edu/courses/6-974-fundamentals-of-photonics-quantum-electronics-spring-2006/bf3bdeb971819ddc9c68719d28bb2745_classnotes.pdf), rather than treating intensity and amplitude as interchangeable.

For a normalized horizontal input (1,0), P₊ gives (1/2,1/2), of total intensity 1/2. A subsequent vertical polarizer leaves (0,1/2), of intensity 1/4. The familiar three-polarizer transmission therefore follows on this specified input. `DiagonalAfterLampH` supplies this one output in the existing Swift example. It is not a general diagonal-polarizer operation on arbitrary `PolarizedLight` inputs.

## §5. What the optical and quantum models share

The same two-dimensional projector describes the transmitted classical Jones amplitude and the transmitted branch of an ideal single-photon polarization measurement. A classical normalized intensity fraction and a single-photon transmission probability agree in this model. A classical beam intensity is not a certain one-photon outcome. Matter §5 distinguishes the response law, individual record and conditional state.

This provides a concrete VI test: an encoding that suffices for axis intensity questions need not suffice for a later diagonal question. A retained optical state can carry the missing relation within the same whole. If only its coarse intensity record is available, the added analyzer cannot be simulated as a decoder of that record. The current static examples check special supplied pairs and slots. They do not implement general Jones operators or derive the correspondence to an actual device.

**IiS7 (The analyzer family determines the required record).** The preceding counterexample instantiates Verdict Is Invariant VC15 and VC45: retain what the admitted future questions can distinguish. The general factorization principle is already present there. Its optical content can be derived before selecting a new Swift carrier.

For a two-component field with coherency matrix J and real coordinates I,Q,U,V, fix the convention

```
J = (1/2) [[I+Q, U−iV],[U+iV, I−Q]],
I ≥ sqrt(Q²+U²+V²).
```

The inequality is exactly positive semidefiniteness, since the eigenvalues are (I±sqrt(Q²+U²+V²))/2. Fully polarized light has equality. A normalized qubit density operator has the same matrix form with I=1. This correspondence concerns local intensity fractions or outcome laws under the specified analyzer, not identification from a single stochastic result.

An ideal linear analyzer at angle θ transmits w†Jw for w=(cos θ,sin θ). Direct multiplication gives

```
Iθ = (I + Q cos(2θ) + U sin(2θ))/2.
```

Consequently (I,Q) suffices for horizontal and vertical analyzers, and (I,Q,U) suffices for all real-angle linear analyzers. Three readings at 0°,90°,45° reconstruct that latter record: I=I₀+I₉₀, Q=I₀−I₉₀ and U=2I₄₅−I. They do not determine V. The two circular states (1,i)/√2 and (1,−i)/√2 have identical I,Q,U but opposite V, and every linear analyzer gives the same response for both. A circular analyzer separates them. Adding its + circular reading I_c=(I+V)/2 recovers V=2I_c−I. Thus (I,Q,U,V) suffices for all normalized Jones analyzer directions, whose rank-one projectors span the Hermitian 2×2 matrices.

The necessity of the added coordinates has concrete witnesses. The horizontal and vertical unit states require Q. The diagonal states in IiS6 require U. The circular pair requires V. When total intensity is not fixed, sources J=I·identity/2 with different I require the intensity coordinate itself. These examples establish the failure of each indicated deletion on the stated positive-matrix domain. More generally, the required linear information is the span of the permitted measurement functionals, the same mechanism as Seeing Is Encoding SiE11's row-space criterion. This is minimality of the linear information, not a claim that arbitrary encodings need a specified number of scalar fields.

The admitted operations are part of that family. If quarter-wave plates can precede an otherwise linear analyzer, an initial circular distinction can become a linear intensity distinction: diag(1,−i) sends (1,±i)/√2 to (1,±1)/√2. The record (I,Q,U) then fails to support every permitted continuation. Real rotations and real linear polarizers alone do not expose V through final intensity: a complete such sequence has a real matrix A, and its intensity functional has a real symmetric effect, insensitive to the imaginary off-diagonal part of J. This gives a sufficient domain for the smaller record as well as a counterexample when the operation vocabulary grows.

Even the full local J is scoped. Coherent recombination with another field can depend on cross-correlations with that field that J does not contain. A quantum joint measurement can likewise require the joint state, not only a subsystem density operator. The other field, apparatus or preparation record is inside the same whole. Enlarging the interaction vocabulary changes which internal relations must be retained. The matrix calculations here derive those requirements. The static sensor construction does not yet implement their general operator algebra.

**IiS8 (Two amplitude components and their relation).** Angles are coordinates for a particular analyzer family. The underlying two-component calculation can be stated without angles. For amplitudes α and β in named modes A and B, a coherent analyzer with coefficients u,v reads

```
|conj(u)α + conj(v)β|²
  = |u|² a + |v|² b + 2 Re(conj(u) v c),
a = |α|²,  b = |β|²,  c = α conj(β).
```

The cross term is the information missing from separate component intensities. For a general coherency record J=[[a,c],[conj(c),b]], positivity is equivalent to a≥0, b≥0 and |c|²≤ab. Necessity follows from nonnegative diagonal expectations and determinant. For sufficiency when a>0, completing the square gives z†Jz=a|z₁+(c/a)z₂|²+(b−|c|²/a)|z₂|²≥0. If a=0, the bound forces c=0, leaving the nonnegative second diagonal term. A pure amplitude pair saturates the bound |c|²=ab. This constrains the relation but does not select its phase from a and b.

The receiver of this joint reading can be a photosensitive medium. If its material response distinguishes two such combined intensities, omitting their cross relation can omit a change in the propagation law encountered by a later probe. LiR §6b connects that conditional statement to an optically induced lattice experiment. The reference, material response and polarization scope remain part of the contact. A medium's role as a receiver does not require an additional observer outside the system.

There is an exact condition for a possible dark output under balanced mixing. For a+b>0, let the analyzer be (1,z)/√2 with |z|=1. Its output is (a+b)/2+Re(zc), with minimum (a+b)/2−|c|. Positivity and the arithmetic-geometric mean inequality give

```
|c| ≤ sqrt(ab) ≤ (a+b)/2.
```

The minimum is zero exactly when both inequalities saturate: a=b and |c|²=ab. A specific analyzer also needs zc=−|c|, the opposed relative phase. Thus exact darkness in this family needs balanced intensities, full coherence and the appropriate relation to the analyzer. For scalar amplitudes in one common coherent mode these reduce to the equal-opposite cancellation checked above. Contributions in unrelated modes or phase references do not acquire that physical interpretation just by receiving opposite labels.

The same calculation gives fringe visibility 2|c|/(a+b) when the analyzer's relative phase is varied. This is a property of that reading family, not a measure of all uncertainty in the state. For example, J=diag(1,0) and J=identity/2 both have c=0 and zero visibility in this experiment, but the first has rank one and the second rank two. A unitary change of the physical input can also change this visibility without changing the eigenvalues of J. The diagonal relation to a particular mode split and basis-invariant mixedness must therefore remain distinct.

An exact rational example separates intensity, phase and binary outcome. Let ψ₊=(3/5,4/5) and ψ₋=(3/5,−4/5). Both have unit norm and component intensities (9/25,16/25). A balanced sum analyzer (1,1)/√2 gives output intensity fractions 49/50 and 1/50. Nothing in those fractions is an approximation within the stated model. In the corresponding qubit measurement they are probabilities, and both inputs can produce either binary outcome. Their inner product is −7/25, so Matter §5's nonorthogonality proof excludes certain discrimination from one copy by any measurement. Equal and opposite amplitudes give exact cancellation. A relative sign alone does not, when magnitudes differ.

For equal prior probabilities this analyzer is also optimal for guessing which of those two states was prepared, and its unavoidable error is exactly 1/50. To prove the bound directly, let E be the effect for guessing ψ₊ and I−E the effect for guessing ψ₋. Their density-matrix difference has off-diagonal entries 24/25 and zero diagonal. The success probability is therefore 1/2+(24/25)Re(E₁₂). Since 0≤E≤I, its expectations on (1,1)/√2 and (1,−1)/√2 both lie between zero and one. Their difference is 2Re(E₁₂), so Re(E₁₂)≤1/2. Success is at most 49/50, attained by the balanced sum projector. This exact bound distinguishes optimal guessing from a certificate that one alternative is impossible. It is a special case of the discrimination problem formulated in Matter §5's IBM reference.

The two outcome labels A and B therefore do not imply that the state has only two alternatives, nor that its two intensities specify every future answer. A binary structural grammar can also represent three alternatives as A versus (B versus C). Binary notation alone selects neither a two-dimensional Hilbert space nor its probability law. The current signed-unit construction expresses the two-phase integer fragment. It does not replace complex amplitude relations with a Boolean state.

Even c is a coordinate of a relation in a chosen mode frame, not a basis-independent scalar substance. The observable pairing is Tr(JE), where E is the analyzer effect. Under a common unitary change of coordinates J′=TJT† and E′=TET†, cyclicity of trace and T†T=I give Tr(J′E′)=Tr(JE). Changing J alone while keeping the apparatus fixed can change the result. This is the optical instance of Matter M59's common-frame requirement. The invariance applies to the jointly represented source and question, not to an isolated state label. The source, mode reference and analyzer remain internal to the same whole.

**IiS9 (Operator order from actual signed coordinates).** `ModePhase.swift` represents two amplitudes by four formal terms: (a₊,a₋,b₊,b₋), interpreted as α=a₊−a₋ and β=b₊−b₋ in an additive group. The signs describe formal terms, not a positivity assertion about complex numbers. Define three actual readings:

```
X(α,β) = (β,α),
Z(α,β) = (α,−β),
N(α,β) = (−α,−β).
```

`ExchangeModes` swaps the outer coordinates, `ReverseSecondPhase` swaps the two terms of the second mode, and `ReverseBothPhases` swaps both pairs. For complex amplitudes, X and Z are the standard Pauli matrices listed in [IBM's circuit library](https://quantum.cloud.ibm.com/docs/en/api/qiskit/circuit_library). Their algebra follows here from the coordinates:

```
X² = Z² = identity,
XZ(α,β) = (−β,α) = N ZX(α,β),
NX = XN,   NZ = ZN.
```

`SignedModeAlgebra` and `CommonPhaseCommutes` derive these identities generically over all four terms. `SequentialReading` binds each operation to the actual preceding output. No operator identity or answer equality is supplied as a premise. The finite coordinate representation is not a complete normalizer of all equivalent amplitude expressions. Equality of its output terms implies equality under any common additive interpretation, while failure of syntactic equality alone does not prove unequal physical amplitudes. The concrete noncommutation refusal uses an explicitly nonzero unit mode.

**IiS10 (A phase quotient depends on the admitted context).** For a standalone quantum operation, U and −U induce the same channel: UρU†=(−U)ρ(−U)† for every ρ. Thus the two orders U=XZ and V=ZX are identical at that channel interface. Their signed-coordinate distinction should not be mistaken for a distinction in standalone measurement probabilities.

Coherent control is a different interface. Specify the controlled implementations C_U=diag(I,U) and C_V=diag(I,V), where the first block is an internal reference branch. Then C_V differs from C_U by a sign on the second block only. Start with |+⟩⊗|ψ⟩ for normalized ψ and apply the same known recovery C_U† after either implementation. Direct multiplication gives

```
C_U† C_U (|+⟩⊗|ψ⟩) = |+⟩⊗|ψ⟩,
C_U† C_V (|+⟩⊗|ψ⟩) = |−⟩⊗|ψ⟩.
```

Measuring the control in its plus/minus basis therefore distinguishes the two specified implementations with certainty in this ideal model. The reference is inside the same whole. The repeated ψ coefficients in its two amplitude blocks describe a control superposition, not two copies of an unknown state.

This does not make the global phase of an isolated state observable by adding an ancilla later. Tensoring the same ancilla with ψ and −ψ still gives states differing only by one global sign, so no subsequent quantum operation distinguishes them. The controlled implementations above already differ in their relation to the reference branch. Their full processes are different even though the restricted standalone channels coincide. No lost global-state phase is reconstructed.

The structural part of this proof uses existing `PairedApplication` to retain one branch while applying the actual operation to the other. `ControlledPhaseRecovery` derives the two recovered outputs (S,S) and (S,N(S)) for arbitrary signed-mode S. `CancelOppositeBranches` sums corresponding opposed modes to zero without evaluating the four terms. Its zero reading composes with the second recovery through the actual intermediate source, with no added opposite-branch premise. Refusals reject equating the recovered outputs, changing the retained reference and cancelling two identical nonzero branches. The normalization and measurement-probability interpretation are supplied by the explicit quantum calculation, not by the type names.

Consequently the map from a standalone unitary channel to its coherently controlled implementation is not well-defined without additional information: the identical input channel of U and −U would require different outputs. This is the phase obstruction in [Araújo, Feix, Costa and Brukner, Quantum circuits cannot control unknown operations](https://arxiv.org/abs/1309.7976). Their circuit restriction does not prohibit implementations with additional physical structure. Here both controlled implementations are specified, rather than obtained from an unspecified black box.

This is an instance of VC15's requirement that an equivalence survive the admitted continuations. Discarding a common phase is valid for the standalone channel questions, but does not define the particular map U↦diag(I,U). A common phase on the entire larger state still changes no quantum measurement probability. A distinction in notation, a local phase relative to an internal reference and a global change of spelling must therefore remain separate. Closure of the whole supplies no missing reference automatically, and introduces no exterior reference in this calculation.

**Balanced use removes a specific ambiguity.** Controlling the order of the same two operations has a different contract from controlling whether one operation occurs. Suppose each invertible primitive Uᵢ may be represented as Uᵢ′=zᵢUᵢ, where the zᵢ are central invertible factors. A word w in the primitives and their inverses acquires the product of those factors raised to their signed occurrence counts. Move the central factors through the word to obtain this expression. For two words u,v with equal counts for every primitive, their relative operation is unchanged:

```
u(U′) = c u(U),  v(U′) = c v(U),
u(U′)⁻¹ v(U′) = u(U)⁻¹ v(U).
```

For two forward orders AB and BA, each primitive occurs once and the common factor is z_A z_B. No physical inverse is needed to compare these output branches coherently. With phase factors, the entire paired state changes only by a global phase. For XZ=−ZX, the outputs remain opposed for every pair of primitive phases. Their coherence can be read without learning those phases separately. The joint reading itself remains specified. IiS12 tests replacing a calibrated analyzer with a finite reference input. The inverse notation above expresses a relation between invertible operations. The argument neither derives invertibility from closure nor requires all ambiguities to be phases.

`BalancedOrderRephasing` establishes the sign fragment directly on arbitrary signed-mode fields. Its four actual compositions, with neither, either or both primitives reversed, give the original output pair, its common reversal, its common reversal and the original pair. All four admit the derived opposite-branch cancellation. `OneRouteRephasingMakesOrdersAgree` instead reverses only one output route and derives equal branches. Two refusals prevent cancelling this equal nonzero pair or identifying this change with a common primitive rephasing. These are constructions from the existing operations, without an assumed invariance protocol. General central-factor cancellation is the argument above. Arbitrary complex phases are not encoded by these four static cases.

**The exact balance depends on the admitted phase freedom.** For two words u,v, let nᵢ be the signed occurrence count of primitive i in v minus its count in u. Specify the allowed joint phase changes Γ⊆U(1)ᵏ. Their relative operation changes by χ_n(z)=∏ᵢ zᵢ^(nᵢ). It remains exactly the same for every admitted rephasing if and only if χ_n(z)=1 throughout Γ. Necessity follows by cancelling the invertible original relative operation, and sufficiency follows by substitution. With independently free U(1) phases this requires every nᵢ=0: if one is nonzero, varying just that phase changes χ_n. With independently free signs, it requires only that every nᵢ be even. With one common free phase on all primitives, it requires Σᵢnᵢ=0. These are different joint correspondence premises, not independence inferred from closure. A particular detector can ignore a change of the relative operation, so detecting it remains a separate response question.

This matters for a return probe comparing U² with a bypass. Its count difference is two, so it survives sign changes but can change under a quarter phase: (iU)²=−U². By contrast, comparing UV with VU has zero difference for each primitive and survives every such common-use rephasing. The former probe needs the implemented phase relation to the bypass, or an equivalent calibrated reference. Changing only one route is not a change of primitive convention applied equally in both uses. LQ13's two-element central square law has exactly this restricted scope. Its D₈ and Q₈ contacts cannot be selected from standalone phase-blind channels alone.

The quantum switch extends this distinction to channels. For channels with Kraus lists Aᵢ,Bⱼ on the same finite space and complementary orthogonal control projectors P₀,P₁, its Kraus operators are Wᵢⱼ=P₀⊗BⱼAᵢ+P₁⊗AᵢBⱼ. This is a fixed higher-order connection of two channel inputs, as developed by [Chiribella et al.](https://arxiv.org/abs/0912.0195).

Complete positivity follows from the Kraus form. Orthogonal control blocks and ΣAᵢ†Aᵢ=ΣBⱼ†Bⱼ=I give ΣWᵢⱼ†Wᵢⱼ=I. Under Kraus changes A′ₐ=ΣᵢuₐᵢAᵢ and B′ᵦ=ΣⱼvᵦⱼBⱼ, one gets W′ₐᵦ=ΣᵢⱼuₐᵢvᵦⱼWᵢⱼ. The isometry identities u†u=v†v=I cancel those coefficients in the output channel. Equivalent finite Kraus lists can be related after zero padding. Thus the result depends on the two primitive channels, not their Kraus representatives. [Abbott et al., Appendix A3](https://arxiv.org/html/1810.09826v2), establish this implementation independence and distinguish it from coherent selection between channels. Realizing this particular connection remains a physical premise. Equal usage counts alone do not establish it for arbitrary noisy devices.

The two already-composed channels are a weaker input. The primitive pairs (X,Z) and (I,XZ) have identical standalone channels in both orders: every composite is XZ or −XZ. Yet their coherent order comparisons give opposed and equal branches respectively. Forgetting the primitive factorization loses the question needed by the switch. Keeping the two primitive channels and the specified connection suffices in this quantum model. No contradiction with the Choi certificate in IiS17 results.

The Cut Step 3 explicitly treats distinctions that no possible process could register under its jurisdiction commitment. A chosen local interface quantifies over a smaller declared question family. Its indistinguishability result alone does not satisfy that universal condition. The quantum example illustrates the difference in scope rather than deriving the quantum formalism from the book or disproving its commitment.

**A proposed experiment should isolate the omitted relation.** In the ideal Jones model, suitable half-wave plates implement X and Z up to phase factors. Compare coherent routes through the same two elements in opposite orders. Their output fields are opposed, while their standalone polarization and intensity agree. The balance argument removes the need to determine each element's common phase. It retains requirements on relative route phase, polarization alignment, coherence, loss and detector response. A branch-dependent action or a retained route label in the environment changes the contract. IiS8 explains why imperfect balance or coherence prevents exact darkness. This mechanism can be demonstrated with classical coherent fields. It does not alone establish uniquely quantum behavior. Coherent order comparison is also the established setting of [Procopio et al.](https://arxiv.org/abs/1412.4006). No new experiment is claimed here.

The internal reference is now the other order, with no bypass recovery required. Test a common primitive phase change, which should preserve the recombination distribution, and a sign reversal confined to one route, which should exchange the ideal bright and dark ports. Blocking one route removes that comparison. The primitive change must act equally in both uses. Changing only one occurrence is the second test, not the first. Local characterization and recombination require separate trials, since detecting the arms changes the contact. The apparatus and its reference remain inside the whole.

Retain the actual operation order, preparation and calibration identifiers, both output readings, exposure or trigger counts, backgrounds, and the declared detector-event rule before aggregation. Alternate the phase-control settings throughout acquisition to test drift. The decisive data are matched local responses with separated joint responses under the common continuation, not a fitted sinusoid or a single dark event. All runs must be accounted for, with any exclusions and conditional selections explicitly tied to their source records. This is a proposed contact test, not an experiment performed here.

For the ideal equality E(x)=E(y), different continuation answers directly refute their factorization through E by VC15. Finite-precision agreement of continuous readings is weaker: a discontinuous decoder can amplify an arbitrarily small omitted difference. A real test therefore rejects a specified finite-resolution interface or a stated stable response family at its measured uncertainty. If the proposed model predicts an output gap at most ω(ε) for input differences at most ε, a larger output gap after accounting for output errors rejects that model. Choosing ω without grounds would insert the desired refusal. No general exact identification follows from nearly equal measured numbers alone.

The same empirical discipline applies to existing data. [Schwindt, Kwiat and Englert](https://arxiv.org/abs/quant-ph/9908072) report conditional fringes and opposite fringes even for a preparation with no available which-path information to erase. Their Fig. 4 separates subensembles through the polarization analysis. It does not report an unconditional restoration by relabelling old records. This tests an overly narrow account in which every lost fringe is explained solely by a path label. [Liu et al.](https://pmc.ncbi.nlm.nih.gov/articles/PMC3646274/) report polarization dynamics influenced by correlations between the frequency environments and compare different interaction orderings with the same final state. Their plotted trace distances and inferred correlation parameters already use a reconstruction model. These are sources for contact-level tests, not assumption-free numeric inputs or raw data reanalysed here.

This experiment would establish the insufficiency of the chosen local description and calibrate a richer relational one. Its ideal optical behavior is already accounted for by the stated optical model. A distinct prediction from VI would require an additional relation derived inside VI that selects among experimentally different continuations. IiS10 alone does not supply such a departure.

**A measured period ratio supplies a more specific contact.** [Kraan, Grigoriev and Rekveldt, Figs. 3–4](https://oiks.pnpi.spb.ru/archive/media/nri/epl_8114.pdf) calibrated spin-flip probabilities and compared three settings of a neutron resonance spin-echo apparatus. They scanned one flipper's gradient amplitude or static field while keeping the other flippers unchanged. The mixed setting produced a period twice that of the corresponding full-precession setting, reported within 2%, while the absolute-period calculation agreed only to about 20%. The plotted polarizations are derived from analyzer counts, not direct records of a wave-function sign. Input polarization and analyzer settings change between comparison modes. The nominal full-flip calibration exceeds 0.85 rather than establishing exact unity. Fig. 4e has a slow residual, and the authors neglect a second-order field contribution in their approximation. These controls support a scoped comparison, not an exact universal return law.

The relevant algebra can be stated without fitting a cosine or assigning an angle to a type. Let z be a common unit-modulus phase contact. Compare the specified two-branch actions

    A_z = diag(z,z⁻¹),    B_z = diag(z,1).

They satisfy A_z=z⁻¹B_(z²). Hence their standalone channels agree after the declared squared change of the control, since the common factor z⁻¹ cancels from the density-matrix question. At z=−1, A_z is a common sign while B_z changes one branch relative to the other. At z=1 both return. This is the same distinction already constructed by `ReverseBothPhases`, `ReverseSecondPhase` and `ControlledPhaseRecovery`. The continuous phase law is the stated mathematical premise, and the existing sign constructions cover its finite contrast. No extra marker of experimental proof is needed.

The squared comparison follows from the supplied opposite and single-branch actions. Two branches alone do not force those actions: diag(zᵖ,zᑫ) changes their relative phase by z^(p−q). Selecting the exponents and connecting z to a magnetic or spatial control are additional physical relations. Nor does the algebra alone force a detector to distinguish every relative phase. Its allowed response and calibration belong to the contact. Thus the neutron comparison is useful evidence for a richer process description and a concrete target for VI's comparison contract. It does not derive the spin representation, the Born rule or a cosine from the existence of a pair. These precession controls are also different operations from the time reversals examined in Space §5k and Matter M39. The raw count records have not been reanalyzed here.

**An actual joint contact: chiral microwave response.** [Patterson and Doyle, Figs. 2–4](https://arxiv.org/pdf/1305.5223v2), report two resonant orthogonal drives and a third polarized response. The recorded waveforms for opposite enantiomers have opposite phase; repeated readings distinguish a prepared small excess from a racemic sample. Fig. 1C is a simulation, unlike those measured records. Free-running oscillators also supply the mixing references, producing a repeatable detected phase. Their weak-pulse model contains the signed product of three transition couplings, absent from isolated transition strengths. Population imbalance and spatial phase matching affect the response. Fig. 4's racemic readings have a small offset, attributed tentatively to contamination. Thus the displayed data do not establish an exactly zero experimental background. This is the two-resonant-drive experiment, distinct from the earlier DC-field method, and no raw data have been reanalysed here.

A later experimental application makes the relative/absolute boundary concrete. [Shubert et al., Sections IV D–F](https://doi.org/10.1063/1.4921833), distinguish two conformers through their separate resonances and compare a prepared mixture with a known sample using recorded phases. Their absolute assignment instead uses measured path delays and calculated transition matrix elements. They use a separate drive reading to normalize signal fluctuations. They also report no detectable three-wave signal for a third conformer, attributing this tentatively to a small coupling. Their pulse-duration tests establish phase stability only over a specified range. Thus neither an absent signal nor a phase sign has a preparation-independent chemical meaning. These observations support the need for an explicit measurement correspondence; they do not verify every contact in the following model.

The following calculations specify what can be learned under a declared contact model; they do not reconstruct an unknown Hamiltonian from these plots. For nonzero complex couplings on a three-state loop, put L=d₁₂d₂₃d₃₁. A change of state phases sends dᵢⱼ to exp(i(θⱼ−θᵢ))dᵢⱼ, so L is unchanged by cancellation at each intermediate state. Holding all three magnitudes fixed while reversing one coupling changes L. This reuses the cycle calculation of IiS21. Internal state-phase freedom and a spatial reflection are different transformations: a pseudoscalar's sign is specified relative to an oriented spatial frame, not invariant under reflecting the source alone. Neither this loop nor the experiment identifies the molecular state space with Matter M64n's four-position permutation carrier.

For the sum-frequency case, write the complex drives as a=A exp(iα), c=C exp(iγ), and a weak response as z=κLac. Mixing against the same phase sources removes exp(i(α+γ)); fixed propagation and receiver factors remain in the gain. Difference-frequency mixing has the corresponding conjugated factor. This is precisely IiS10's signed-count balance applied to the generating and reference paths. The phases need not be known separately and may change together in generation and readout. Independent replacement references leave an unknown relative factor, which can reverse the recorded sign. A record cannot recover a coupling sign after that distinction has been omitted.

This also separates two interventions that the phrase “reverse the drive” leaves ambiguous. Reversing a generator before it supplies both the excitation and its mixing reference leaves the balanced detected response unchanged. Reversing only the excitation branch after that split, while retaining the reference, reverses the response in this model. Only the second is a candidate signal-reversing control. Its physical availability and the behavior of other response terms must be established. The cited experiment is not being claimed to have performed the next protocol.

**Four acquired readings determine a relative response without calibrating the complex gain.** Consider two preparations s,r and one stable signed response hⱼ∈ℝ for each. Let G≠0 be a common unknown complex gain. Each preparation has its own unknown complex background Bⱼ, fixed between two selectable contacts ε=+1 and ε=−1. The actual access law is

    yⱼ,ε = Bⱼ + ε G hⱼ,       j ∈ {s,r}.

The experimenter can choose j and ε and acquire that complex reading, with no other source-dependent access. Assume hᵣ≠0. The question is whether hₛ and hᵣ have the same sign, opposite signs, or hₛ=0. This is a question about relative signed response, not an absolute R/S chemical label or an enantiomeric fraction. Identifying either of those quantities needs its own correspondence to preparation, population and scale.

Acquire both signs for each preparation and form Δⱼ=yⱼ,+−yⱼ,−=2Ghⱼ. Then

    Δₛ conjugate(Δᵣ) = 4|G|² hₛhᵣ.

Its real sign answers the question exactly in this model. The ratio Δₛ/Δᵣ=hₛ/hᵣ is also determined. Neither background, absolute phase, gain magnitude nor the absolute sign of the reference response has to be acquired. The common nonzero G is essential, but it is not an extra measured standard: it is a relation between the contacts whose applicability must be grounded in the apparatus. In particular, interleaving trials alone does not establish it.

Four acquired scalar complex readings are necessary in the worst case under this access law, even with adaptive selection. After at most three readings, one preparation has been queried at at most one sign. If its sole sign is ε₀, replace its nonzero hⱼ by −hⱼ and its background by Bⱼ+2ε₀Ghⱼ. Its recorded value is unchanged. If it was never queried, no background adjustment is needed. Leave the other preparation and G fixed. Taking both original responses nonzero, the two sources now answer the target question oppositely while producing the same complete acquired history. Every adaptive choice along that history is consequently the same. Repeated calls at one sign add no information in the deterministic model. The four-call construction attains the bound. A device that directly returns a contrast has a different contact price.

The absolute response sign still does not factor through even the full table: (hₛ,hᵣ,G) and (−hₛ,−hᵣ,−G) produce identical readings. An unlabelled reference suffices for a relative orientation but cannot select an absolute label. If gains may differ arbitrarily between preparations, changing hₛ→−hₛ and Gₛ→−Gₛ defeats the relative question as well. If backgrounds may change independently with ε, they can absorb every signal difference. These are compatible competing realizations, not a claim that real experiments always suffer these changes.

Exactness has an explicit finite-error version. Suppose the two acquired differences are dₛ=Δₛ+eₛ and dᵣ=Δᵣ+eᵣ, with separately justified bounds |eⱼ|≤ηⱼ. Expanding (dₛ−eₛ)conjugate(dᵣ−eᵣ) and applying the triangle inequality gives

    |Re(dₛ conjugate(dᵣ)) − 4|G|²hₛhᵣ|
        ≤ ηₛ|dᵣ| + ηᵣ|dₛ| + ηₛηᵣ = R.

Thus Re(dₛ conjugate(dᵣ))>R certifies the same sign, and a value below −R certifies opposite signs. The remaining interval yields no such verdict from this bound. The imaginary part must also have magnitude at most R; a larger value rejects the specified common-real-response model or the proposed error bounds. This is a sufficient robust certificate, not a claimed sharp uncertainty bound. A measured small value never by itself certifies an exact zero response.

The outcome is a positive acquisition construction and a matching access lower bound. The experimental paper motivates the contact; the proof works on its explicitly narrower affine response law. Applicability requires a selective reversal, stable paired backgrounds and a shared nonzero gain in the chosen scope. Existing balanced-phase and cycle proofs carry the algebraic connection. No new trust protocol or duplicate Swift phase marker supplies those physical premises.

**Selective phase contacts determine a response class before identifying a mechanism.** [Schmitz, Section 7.5 and Fig. 7.8](https://www2.physnet.uni-hamburg.de/services/biblio/dissertation/dissfbPhysik/___Volltexte/David___Schmitz/David___Schmitz.pdf), presents measured carvone responses under two RF excitation phases separated by π. For each of two conformers, changing the RF setting reverses the relative phase; exchanging the enantiomer also reverses it. The plotted time traces are filtered records. This establishes a concrete selective excitation control, unlike a common change of excitation and mixing reference. The text uses this control to distinguish three-wave excitation from direct excitation. The logical reach is the specified contrast between mechanisms: any other contribution with the same admitted phase response would survive that control too. The source does not supply a test against every such possible contribution.

There is an exact construction without an assumed bound on harmonics. Let f(α,β) be an arbitrary complex response on one fixed, repeatable two-phase contact family. The two available controls translate α or β by π. As operations on this family they commute and square to the identity. These are relations of the admitted access, not consequences of having two knob names. Fix a base setting and acquire the four corner readings. Define

    P₁₁f(α,β) = [f(α,β) − f(α+π,β)
                         − f(α,β+π) + f(α+π,β+π)] / 4.

This component changes sign under either translation. It annihilates every response invariant under at least one of them and retains every response that reverses under both. To prove this, denote the two translations by U,V. Their defining relations give (1−U)²=2(1−U) and UV=VU. Thus P₁₁=(1−U)(1−V)/4 satisfies P₁₁²=P₁₁. Directly translating the four acquired terms proves UP₁₁=VP₁₁=−P₁₁. No frequency expansion, molecular dimension or full detector calibration occurs in this argument.

More generally the four operators (1+sU)(1+tV)/4, s,t∈{+1,−1}, sum to the identity. Two different ones multiply to zero since (1−U)(1+U)=0 or its V counterpart. Consequently any response in this contact family splits uniquely into its four sign behaviors. This is completeness for the specified control action, not completeness of the physical source. Several distinct mechanisms may contribute to one behavior.

Four scalar complex readings are necessary for P₁₁f at a base setting in this unrestricted response family when its four phase corners are distinct and a call returns just one corner value. If a corner is unqueried, change f there while preserving the other three values. Its nonzero contrast weight changes the target. The same lower bound applies adaptively by retaining every response on the reached history. It also holds within trigonometric polynomials: a suitable product of 1±cos(α−α₀) and 1±cos(β−β₀), divided by four, equals one at any selected corner and zero at the other three. Thus continuity or existence of a finite but unspecified Fourier expansion does not defeat this counterexample.

At one four-corner orbit, write the arbitrary response table as

    y(ε,δ) = B + εH + δK + εδC.

This is not a new restriction on those four values over ℂ: the four preceding projections construct the four coefficients. The acquired contrast returns C. It does not thereby identify C with one desired molecular pathway. `PhaseSelectiveContrast.swift` checks the finite signed-coordinate construction: actual U,V reverse the appropriate coefficient fields; the weights +,−,−,+ give three pairs of opposite branches and four unchanged copies of C. Existing `CancelOppositeBranches` discharges the nuisance contributions. There is no caller-supplied cancellation equality. The complex additive interpretation and division by four belong to the argument above. The decoder uses the four acquired sums; the individual coefficient fields are only the verifier's generic representation of their source, not hidden inputs furnished to the decoder. Refusals reject cancelling the selected nonzero contribution and substituting a single-control corner for the double-control corner.

The two independent controls matter. If only ε=δ can be reached in this table, the response is B+C+ε(H+K). Replacing (B,C) by (B−a,C+a) leaves every accessible reading unchanged while changing C. Acquiring the off-diagonal settings supplies the missing relation. This is a failure of the tied **sign** interface; arbitrary continuous equal-phase changes form a different family and need their own analysis.

Individual returns alone are also insufficient. Let U exchange the first two coordinates of ℂ³ and V the last two. Both square to the identity. A vector odd under U has its third coordinate zero, while one odd under V has its first coordinate zero; satisfying both forces the whole vector to zero. Nevertheless, for f=(0,1,0), the four-term operator P=(1−U)(1−V)/4 gives (−1,1,0)/4. Applying it again gives (−1,1,0)/16, so P is not a projection. A nonzero four-term contrast can therefore occur even when there is no nonzero jointly odd response in this representation. Its interpretation needs the joint contact relation, not only the two individual return tests. In the actual finite constructor above, both returns and commutation are derived from the declared field operations.

**A selected response is not necessarily a selected cause.** Suppose a desired contribution C and an unclassified contribution D have exactly the same dependence χ on every available control. Then (C,D) and (C+a,D−a) give the same complete response (C+D)χ. Repetition, adaptation, precision and acquisition of every control value cannot identify C separately. To do that one needs a contact that acts differently on the two contributions, or an independently established relation restricting them. A nonzero P₁₁ therefore establishes a jointly odd response, not by itself a unique microscopic origin. A zero P₁₁ can also hide cancellation between nonzero jointly odd contributions.

Finite phase grids have a further, precisely different boundary. For a declared finite family f(z)=Σₙcₙzⁿ on |z|=1, readings at the N-th roots of unity give

    (1/N) Σⱼ zⱼ^(−m) f(zⱼ) = Σₙ: n≡m (mod N) cₙ.

The geometric sum is one when N divides n−m and zero otherwise. The reading therefore determines the sum in that congruence class. It determines the particular cₘ for all freely varying coefficients in the admitted family exactly when no other admitted exponent has that residue. With free coefficients, another exponent in the class gives an immediate compensating counterexample. Choosing N larger than the declared exponent width is sufficient; no claim of a generally minimal grid follows.

Without an established exponent bound, no finite set of exact point readings identifies one Fourier coefficient of an arbitrary finite Laurent polynomial. For queried phases z₁,…,zₖ, the polynomial p(z)=zᵐ∏ⱼ(z−zⱼ) vanishes at every queried point but has nonzero zᵐ coefficient (−1)ᵏ∏ⱼzⱼ. Comparing zero response with p also defeats an adaptive procedure along its zero-response history. Its degree is finite; its size was not bounded in advance. This is not the stronger same-character impossibility above: here additional suitable phase contacts can distinguish the two functions, whereas equal full control dependence cannot.

The positive answer survives both limits. A finite contrast can exactly acquire the component defined by the actual finite control action even when it cannot name a unique pathway or a particular harmonic. For the real instrument, the repeatable common response and independently selectable translations must be grounded in acquisition. Agreement at four historical readings alone does not prove their applicability after drift. The invariant is relative to the demonstrated action; it does not require an external reference for the whole.


**The reading can create the selected interaction.** Keep the four-corner question, but distinguish a response x from its reading φ(x). Take real x(ε,δ)=B+εH+δK, with no εδ term. Squaring gives an εδ coefficient 2HK. Thus the acquired joint contrast can originate in the reading rather than in a joint term of the original response. This is the same cross-term mechanism already explicit in IiS8, now applied to the attribution question.

No loss of pointwise information is needed. For B=1 and H=K=1/2, the corner values are (2,1,1,0). Their diagonal and off-diagonal sums are both two. The squared values (4,1,1,0) have sums four and two. Squaring is injective on the nonnegative source domain. If it is known, taking the nonnegative square root before comparing restores the original question. What fails is reuse of the unchanged arithmetic contrast on transformed values, not the existence of a decoder from that injective record. `DetectorContrast.swift` constructs the square readings and both comparisons from complete `AddZero`/`ProductZero` expressions. Its refusal retains the resulting distinction after two common predecessor projections. No arithmetic answer is inserted through an arbitrary protocol conformance.

**Preserving all null contrasts forces a shared additive part, even for different readers.** Let G,H be abelian groups, with four total maps φ₀,φ₁,φ₂,φ₃:G→H, one for each application role. Then

    a−b−c+d=0  implies  φ₀(a)−φ₁(b)−φ₂(c)+φ₃(d)=0

for all a,b,c,d exactly when there are an additive homomorphism A:G→H and offsets bᵢ∈H such that

    φᵢ(x)=A(x)+bᵢ,       b₀−b₁−b₂+b₃=0.

*Proof.* Put bᵢ=φᵢ(0). The all-zero comparison gives the offset equation. Write Aᵢ(x)=φᵢ(x)−bᵢ. The retained comparisons (x,x,0,0), (x,0,x,0) and (0,x,0,x) force A₀=A₁=A₂=A₃. Call this map A. The comparison (x+y,x,y,0) gives A(x+y)=A(x)+A(y). Conversely, substitution gives the image contrast A(a−b−c+d), proving sufficiency. QED

The null equivalence holds in both directions exactly when A is injective. If A has a nonzero kernel element x, the input (x,0,0,0) has nonzero contrast but zero output contrast. An injective A reflects zero immediately. This proof uses subtraction in the stated groups, not a norm, an ordered real scale, continuity or division by four. Its condition is invariant under changing an internal origin; the zero used in the proof is not an external physical calibration.

The four readers need not be the same. Offsets (1,0,2,1) satisfy the required relation. On the preceding source table they give (3,1,3,1), whose compared sums are both four. The static constructor computes those four actual shifted readings and their equality. A second refusal rejects inferring identical offsets from this valid common contrast. The general theorem derives the necessary shared law from preservation of the question, rather than postulating one identical device at all four roles.

The quantifier over comparisons is essential. It supplies a structural transport law, not a certificate obtained from one passing table. The source groups and full application domain are also part of the premises; arbitrary partially available readings need their own extension criterion. Space S27/S28 already derive affine transports from retained divisions and order. Here the extension is to four independently named readings and the exact offset compatibility required by one joint question, with no order assumption. The underlying additive functional equation is not being claimed as a new mathematical discovery.

For finite-dimensional real value spaces, continuity at one point makes A real-linear. Additivity first gives rational homogeneity, then continuity extends it along converging rational scalars. Preserving null contrasts alone does not give this regularity or preserve order. On the ordered additive subgroup ℚ(√2) of ℝ, the bijection a+b√2↦a−b√2 preserves every additive comparison while sending the positive pair 1,√2 to opposite signs. An ordered relative-answer claim therefore needs an order or regularity relation in addition to the null-contrast law. LiR8 addresses the corresponding obligation for ordered repeated readings.

**For a particular response direction, even global injectivity is unnecessary.** Return to two preparations with real responses hₛ,hᵣ and hᵣ≠0. Allow a common unknown real-linear map T from the complex response plane into ℝᵐ, separate paired backgrounds Bⱼ, and separate fixed output offsets bⱼ:

    yⱼ,ε = T(Bⱼ + ε G hⱼ) + bⱼ,       ε=±1.

The two differences are Δⱼ=2hⱼT(G). If T(G)≠0, a nonzero coordinate of Δᵣ gives Δₛ,k/Δᵣ,k=hₛ/hᵣ. Equivalently, their ordinary real inner product has sign hₛhᵣ. Neither T, G nor the unused directions need reconstruction. T can have a kernel; it must retain this direction. For example, one real quadrature suffices when the response direction has a nonzero projection onto it. If T(G)=0, all hⱼ give the same paired readings and the question is unavailable. This weakens the earlier complex-gain premise for this particular answer, without claiming that arbitrary nonlinearity preserves it. The paired stability of the backgrounds and the shared T remain distinct contact conditions.

**Two nonlinear readings can construct a linear relative one.** In the coherent intensity model of IiS8, a nonzero internal reference L and a field S give

    D_L(S)=|L+S|²−|L−S|²=4 Re(conjugate(L)S).

The squared source and reference terms cancel by expansion. Using iL instead gives 4 Im(conjugate(L)S). Together the two differences retain the whole complex value conjugate(L)S, which is faithful for L≠0. A single difference retains only the selected real component. This is a construction of the reading relation from the joint detector contact; individual intensity readings remain nonlinear. It is not a new experiment or a proof that a physical apparatus has ideal equal response channels.

Indeed, with actual output readings g₊|L+S|²+b₊ and g₋|L−S|²+b₋, their difference is

    (g₊−g₋)(|L|²+|S|²)
      + 2(g₊+g₋)Re(conjugate(L)S) + b₊−b₋.

Unequal gains retain the nonlinear own-intensity term. Equal gains remove it, and the offset difference still needs handling for the intended question. A name such as “balanced detector” supplies none of these equalities. Conversely, complete separate calibration is stronger than necessary when the required common relations have already been established.

The resulting boundary is between three questions: which component exists in the acquired response, which existed before a specified reading, and which physical mechanism produced it. The first has the finite construction above; the second needs a valid transport or a corrected decoder; the third needs a contact that separates competing mechanisms. All stages belong to the same reality. Distinguishing them prevents a property born in a joint reading from being silently assigned to an isolated source.


**Phase composition is not additive amplitude balance.** The preceding reading theorem assumes an established additive contrast on the source. That is not automatically the composition of a phase control. S30 reconstructs an origin-free balance from a specified ternary transport, but different carriers can have different such transports.

There is a finite obstruction. Suppose the source transport has a reference o and a distinct form a with T(a,o,a)=o. Let a proposed reading F into an abelian group H preserve that transport as the additive contact u−v+w. It must satisfy

    F(o)=2F(a)−F(o),    2(F(a)−F(o))=0.

If H has no nonzero element killed by doubling, F(a)=F(o). Therefore no faithful reading of this source relation into such an additive H exists. More generally, if a−o has order n in the reconstructed source group, its image displacement is killed by n. A torsion-free additive target must merge every such finite-order difference. This concerns a translation in that contact, not an arbitrary periodic operator acting on a different space. No continuity or full enumeration of the source is used.

For a concrete phase application, use the relative phase carrier |z|=1 and its multiplicative transport T(x,y,z)=xy⁻¹z. The phases o=1 and a=−1 have the stated relation. The ordinary amplitude reading F(z)=z in the complex plane distinguishes them, and correctly so: it preserves the multiplicative transport on its nonzero image, not the plane's additive ternary contact. On these three addressed phases, the source answer is T(−1,1,−1)=1, whereas the additive image expression is −1−1−1=−3. Requiring those two expressions to agree would reject a valid phase representation for answering the wrong question.

The phase-control action can still be exactly linear **on amplitudes**: multiplication v↦zv preserves amplitude addition, and successive controls multiply their z values. Thus linearity of each acting operator does not make its phase parameter an additive coordinate in the same vector space. The output contrasts used by the four-control projection are formed in the amplitude-reading space. They do not average phase positions on the circle or require a unique phase midpoint. An actual reference is still needed for the phase distinction to be observable; IiS10's standalone-channel quotient remains unchanged.

An arbitrary faithful relabeling is likewise insufficient to preserve a specified balance. In the additive integer carrier, (a,b,c,d)=(3,1,2,0) is balanced and its four entries are distinct. The common bijection exchanging 3 and 4 while fixing all other integers gives (4,1,2,0), also with four distinct entries and now unbalanced. Both records preserve all equality and inequality relations among their entries. Thus those relations alone do not determine the balance question. Transporting T along the same bijection restores the original answer, but certifying that transported contact is a different obligation from using an independently fixed arithmetic formula. This is the same issue as moving the cut in LQ18, now applied to the meaning of a measured contrast.

## §6. What a calibration must establish

**IiS11 (Exact probes can force the channel family).** Fix a finite-dimensional complex space H, a target unitary U and a nonempty finite list of normalized pure probes ψᵢ. Join two probes when their inner product is nonzero. If their span is H and this graph is connected, every completely positive trace-preserving channel E satisfying E(ψᵢψᵢ†)=Uψᵢψᵢ†U† for all probes is the target channel on all states. These two conditions are also necessary for this universal certification property when dim H≥2. The unknown channel need not be assumed unitary. This is the exact-identification criterion in [Mayer and Knill, Theorem 1](https://arxiv.org/pdf/1805.04491), related to the probe constructions in [Baldwin, Kalev and Deutsch](https://arxiv.org/abs/1404.2877).

Here is a finite Kraus-operator derivation. Compose the output with U† so that the target is the identity, and write E(ρ)=ΣₐKₐρKₐ† with ΣₐKₐ†Kₐ=I. A pure output equal to ψᵢψᵢ† forces Kₐψᵢ=cₐᵢψᵢ for every a: the expectation on any vector orthogonal to ψᵢ is a sum of nonnegative squared terms, all of which must vanish. The coefficient vector eᵢ=(cₐᵢ)ₐ has norm one. Trace preservation gives

```
⟨ψᵢ,ψⱼ⟩ = ⟨ψᵢ,ψⱼ⟩ ⟨eᵢ,eⱼ⟩.
```

On every graph edge, the nonzero factor cancels and ⟨eᵢ,eⱼ⟩=1. Since both vectors have norm one, ||eᵢ−eⱼ||²=0. Connectivity makes all eᵢ equal. Spanning then implies Kₐ=cₐI for every a, so E(ρ)=ρ. This uses linearity, complete positivity, trace preservation and exact probe-output equations. Those conditions carry the conclusion, rather than the name of the calibration.

For necessity, different graph components span orthogonal subspaces. If there is more than one component, or if the probe span has a nonzero orthogonal complement, dephase between those subspaces: D(ρ)=ΣⱼPⱼρPⱼ, with projectors summing to I. This is a CPTP channel that preserves every probe but removes cross terms of a superposition between two blocks. It is different from identity, and U∘D gives an alternative to the target U. Thus the omitted relation is exhibited by an admitted process, not inferred from a failed search.

For a qubit, two distinct nonorthogonal pure probes span H and form a connected graph. Two orthogonal basis probes permit dephasing. A probe such as (A+B)/√2 connects their phases, and the pair consisting of A and that probe already suffices. Nonorthogonality obstructs certain discrimination of an unknown specimen, yet helps certify preservation by an unknown channel. These are different questions. Exact output states or exact survival probabilities are premises here, not conclusions from observing finitely many successful trials.

**IiS12 (What an undisturbing environment can retain).** The coefficient vectors in the proof also determine the unresolved freedom when the graph has several components. Let Hⱼ be their mutually orthogonal spans and W their direct sum. On W, a dilation of a channel fixing all probes has the form

```
Vx = x ⊗ eⱼ  for x ∈ Hⱼ,
E(|xⱼ⟩⟨yₖ|) = ⟨eₖ,eⱼ⟩ |xⱼ⟩⟨yₖ|.
```

Linearity extends the common coefficient vector from each component's probes to its whole span. Conversely, any choice of unit vectors eⱼ defines an isometry on W, since the Hⱼ are orthogonal. Its reduced channel preserves every probe and has exactly the displayed cross-block factors. Equal environment vectors preserve all cross terms. Orthogonal environment vectors give the dephasing alternative. An environment may therefore retain a component label without disturbing the supplied probes, but it cannot retain different records of probes within one connected component while preserving them exactly.

In this dilation model, the environment can be treated as another part of the same whole. The reduced channel omits its record, while the isometric joint description retains it. Existence of that representation does not establish which physical environment realizes it or derive a law of global dynamics from closure alone. Connected spanning probes force the dilation's environment record to be input-independent on the calibrated input space. They do not determine the apparatus's entire internal history, the common environment state or the coherent-control extension of its channel. IiS10's distinction between a channel and its full implementation survives this stronger calibration result.

This also identifies the missing calibration of a reference branch. Suppose, after a specified target recovery, one common channel acts as identity separately on every state of two orthogonal arm spaces H₀ and H₁. IiS12 leaves two environment vectors e₀,e₁. Choose normalized r∈H₀ and t∈H₁. Preserving the single joint probe (r+t)/√2 forces their cross-block factor ⟨e₁,e₀⟩ to equal one, so e₀=e₁ and the channel is identity on H₀⊕H₁. The two within-arm calibrations alone allow an arbitrary relative phase or dephasing. The joint probe supplies the omitted relation. This conclusion requires the same channel and preparation context throughout; it does not turn an old successful probe into evidence about a later changed apparatus.

Phase error and local entropy have different coordinates in this same construction. Put g=⟨e₁,e₀⟩. On the balanced probe, the reduced state in the r,t basis is one half of the matrix with rows (1,g) and (g*,1). Its eigenvalues are (1±|g|)/2, obtained from its quadratic characteristic equation. Its von Neumann entropy in bits is therefore h₂((1+|g|)/2), whereas its probability of returning to that same probe is (1+Re g)/2. A unit-modulus g can change this return probability from one to zero while the local entropy remains zero. At g=0 the environment records the two arms orthogonally and the local entropy is one bit. For the pure joint dilation state, the joint entropy remains zero and each reduced subsystem has the displayed entropy. This is a precise model of information in correlations within one whole; it also shows why failed interference alignment alone does not establish decoherence or entropy production. The entropy here is von Neumann entropy of the stated subsystem, without an asserted thermodynamic heat or time-arrow law.

**Complete local silence forces recovery in the complement.** Let V:H→A⊗B be a finite-dimensional isometry with Tr_B(VρV†)=σ for every input state ρ. The [no-hiding theorem of Braunstein and Pati](https://arxiv.org/pdf/gr-qc/0603046) then supplies recovery from B alone. Diagonalize σ=Σₖλₖ|k⟩⟨k| with λₖ>0 and write

```
V|i⟩ = Σₖ√λₖ |k⟩⊗|eₖᵢ⟩.
```

Constancy on all input superpositions gives Tr_B(V|i⟩⟨j|V†)=δᵢⱼσ. Comparing entries yields ⟨eₗⱼ,eₖᵢ⟩=δₖₗδᵢⱼ. A fixed isometry on their span therefore maps eₖᵢ to |k⟩⊗|i⟩. For every ψ, this changes Vψ into (Σₖ√λₖ|k,k⟩)⊗ψ. Tracing out B's k-register recovers the input. In particular dim B≥rank(σ)·dim H. Both complete complementary marginals cannot be input-independent when dim H>1. Correlations between subparts of B can still be necessary for that recovery. The argument assumes a common linear isometric encoding of the whole input space and accounts for every omitted purifying part in B. It neither derives that encoding from closure nor supplies a physically available decoder.

**Silence on a spanning list of vectors is weaker.** IiS16 already constructs V|0⟩=|00⟩ and V|1⟩=|11⟩. For ψ_z=(|0⟩+z|1⟩)/√2, |z|=1, both reduced outputs are I/2, while the joint retains z and V† recovers ψ_z. This is a restricted maskable family in [Modi, Pati, Sen(De) and Sen](https://repository.ias.ac.in/125734/1/1608.01695.pdf). Its vectors span H and its overlap graph is connected. Nevertheless its projector span omits the population contrast Z. Adding |0⟩ makes either marginal |0⟩⟨0| instead of I/2. Thus IiS11's connected spanning criterion for preserving pure probes cannot be reused to certify constant mixed output. Constancy on a spanning family of density operators is sufficient by linearity. Basis states and the normalized bridges |i⟩+|j⟩ and |i⟩+i|j⟩ supply one such finite family. Exact output equations remain premises, rather than conclusions of finitely many successful trials. The compiler's existing arbitrary-entry recovery and local-diagonal calculation in IiS16 cover this construction. The second marginal is equal by exchange of its two output factors.

The purity of the common output can reduce that obligation. If spanning input vectors ψᵢ all give the same pure marginal |s⟩⟨s|, each joint Vψᵢ is s⊗eᵢ. Linearity puts the entire image of V in s⊗B, so Vx=s⊗Wx for one linear W, and V†V=I gives W†W=I. B then recovers every input. No connected overlap graph or full operator span is needed for this case. The pure-output premise supplies the missing support restriction. This is the same positive-output mechanism used in IiS11, applied to a different question.

Recovery can also be calibrated without first establishing local silence. Let Φ:H→B and D:B→H be fixed CPTP encoding and decoding channels. If D∘Φ returns a connected spanning family of pure probes exactly, IiS11 makes D∘Φ the identity channel. For a qubit, two distinct nonorthogonal probes suffice. This also preserves every allowed joint state with an untouched internal reference, because the composed channel is identity. No assumed isometry of Φ or global permanence law is needed for this endpoint conclusion. M72 then constrains each complete boundary through which this same recovery factors. A decoder changed to suit each known probe would violate the common-channel premise. Approximate observations require a quantitative calibration bound such as IiS13, rather than substitution into an exact equation.

**An experimental contact needs the preparation and reading too.** [Samal, Pati and Kumar's NMR experiment](https://www.hri.res.in/~akpati/prl11.pdf) uses three nuclear spins, a pseudopure preparation, controlled randomization and a fixed ancilla decoder. They scan 325 preparation settings and compare integrated signals, with tomography for selected outputs. Partial traces are reconstructed by adding measured signal intensities. Reported mean and maximum matrix-entry deviations for three settings are about 2% and 5%, with 5% and 7% for the two-spin output. These are not worst-case channel errors. The decoder sequence is fixed while the preparation varies. The source, controls and tomography specify the contact. Raw signals and implementation were not reanalysed here.

Version details matter: the [preprint](https://arxiv.org/pdf/1004.5073) puts H on spin 3 in Eq. (7), while its diagram and the published formula put it on spin 2. Its explicit Eq. (10) also fixes the controlled branch operators as (I,X,iY,Z), with conventional Hermitian Y. A replacement by (I,X,Y,Z) keeps the reduced randomizing channel but requires a corresponding change to the ancilla decoder. IiS10 explains why the branch phase cannot be dropped from that composition.

The pseudopure representation is described by [Cory, Fahmy and Havel](https://web.mit.edu/tfhavel/www/nmr-qip.html). In normalized coordinates, write C_ε(ρ)=(1−ε)I_d/d+ερ, with a fixed polarization 0<ε≤1. It commutes with every unitary conjugation, and for traceless M, Tr[M C_ε(ρ)]=ε Tr(Mρ). Thus a calibrated ensemble signal can track the represented state. Removing the identity background and rescaling describes that correspondence. It is not automatically a physical channel producing ρ from one system, as IiS18's depolarizing inverse already shows.

This correspondence also need not preserve composition. Compare C_ε applied to |00⟩⟨00| on two spins with C_ε(|0⟩⟨0|)⊗C_ε(|0⟩⟨0|). Both have the same one-spin marginals. Their Z⊗Z expectations are ε and ε², respectively, so they differ for 0<ε<1. A representation that transports all unitary operations of a fixed carrier can therefore change the relation between independently prepared parts. The three-spin logical preparation cannot be replaced by a product of its reduced physical preparations. Likewise a represented Bell projector does not make the complete ensemble state pure. No polarization value or entanglement of that actual ensemble is inferred here. The established contact is recovery in the stated preparation and signal model, with its errors, rather than a measurement of universal information conservation. M32's joint-state obligation survives the exact representation of the chosen dynamics.

**Joint transport can remove the freedom without assuming linearity of the representation.** Fix d≥2 and maps F_d and F_(d²) from density operators to density operators on the same respective carriers. Require covariance under every unitary on each carrier, agreement with the retained first-factor reading, and agreement with independent preparation:

```
F_n(UρU†) = U F_n(ρ) U†                  for n=d,d²,
Tr_B F_(d²)(ω) = F_d(Tr_B ω),
F_(d²)(ρ⊗σ) = F_d(ρ)⊗F_d(σ).
```

These conditions force F_d to be either identity on every state or replacement of every state by I_d/d. Thus one retained input contrast excludes the latter. No affinity, continuity or complete positivity of F was assumed.

*Proof.* For a rank-one projector P, every unitary fixing P also fixes F_d(P). Phase changes remove the off-diagonal blocks, and arbitrary unitaries on the orthogonal complement make its block scalar. Hence F_d(P)=aP+b(I−P), with a,b≥0 and a+(d−1)b=1. Unitary covariance makes a,b the same for every P. The analogous symmetry of the pure input P⊗P requires every direction orthogonal to it to have the same output weight. Product preservation assigns weights ab to p⊗q and b² to q⊗q, for unit vectors p in P and q orthogonal to P. Therefore b(a−b)=0. Either b=0 and a=1, or a=b=1/d. In the first case F_(d²) fixes P⊗P, and in the second it sends it to I_(d²)/d². Unitary covariance extends that conclusion to every pure state of the joint carrier. Every ρ on the d-dimensional carrier has a pure purification there. Applying the retained partial trace gives F_d(ρ)=ρ or I_d/d, respectively. ∎

**For a qubit, three fixed operations suffice.** The preceding all-unitary condition can be weakened without assuming continuity. Let F^(1) and F^(2) map all one-qubit and two-qubit density operators, respectively, to density operators on the same carriers. Require F^(1) to commute with H=(X+Z)/√2 and T=diag(1,e^(iπ/4)), F^(2) to commute with controlled-NOT (first qubit controls the second), preservation of products, and consistency with **both** partial traces. Then F^(1) is identity or the constant I/2 map. This statement does not determine F^(2) on arbitrary mixed joint states.

*Proof.* Covariance under H and T includes covariance under their finite words: S=T², Z=T⁴ and X=HZH, and their inverses. Since P₀=|0⟩⟨0| is fixed by Z, τ₀=F^(1)(P₀) is diagonal, so Tr(Xτ₀)=0. Write D_Z for removal of the off-diagonal entries. The first marginal of CNOT(ρ⊗P₀)CNOT† is D_Zρ. The first marginal of CNOT(F^(1)(ρ)⊗τ₀)CNOT† is D_Z(F^(1)ρ), since the control's off-diagonal entries are multiplied by Tr(Xτ₀)=0. Product preservation, CNOT covariance and first-marginal consistency therefore give F^(1)D_Z=D_ZF^(1). No linearity of F was used.

For ρ_z=(I+zZ)/2 define F^(1)(ρ_z)=(I+f(z)Z)/2. Its diagonal form follows from Z covariance. Positivity gives |f(z)|≤1, and X covariance makes f odd. Commutation with D_Z makes the z coordinate of F^(1)ρ depend only on the input's z coordinate, through f. Conjugation by H and SH gives the corresponding X and Y statements, with the same f. Thus, writing ρ_(x,y,z)=(I+xX+yY+zZ)/2,

```
F^(1)(ρ_(x,y,z)) = ρ_(f(x),f(y),f(z)).
```

The second marginal of CNOT(ρ_z⊗ρ_w)CNOT† is ρ_(zw). Applying product preservation, CNOT covariance and **second**-marginal consistency gives f(zw)=f(z)f(w). In particular f(1) is 0 or 1. If it is 0, f(z)=f(z)f(1)=0 for every z, yielding I/2.

If f(1)=1, the X-positive pure state is fixed. T sends its Bloch vector to (t,t,0), with t=1/√2, so T covariance gives f(t)=t. For x≥0, multiplicativity gives f(x)=f(√x)²≥0. If 0≤x≤y≤1 and y>0, then f(x)=f(x/y)f(y)≤f(y). Thus f is monotone, as a consequence of positivity and the relations already obtained. Multiplicativity and positivity give f(t^q)=t^q for every nonnegative rational q. These points are dense in (0,1], so monotonicity forces f(x)=x there. Oddness supplies the rest. Therefore F^(1) is identity. ∎

This is a finite vocabulary of operations with equations on **all** the stated inputs, not a finite experimental certificate. The argument derives the needed order regularity within the ordinary real scalar order of the supplied state model. Density of a gate family alone would not supply covariance under every unitary. Both marginal readings matter in this proof. The quantum carriers, their positive state cones, the exact H, T and CNOT actions, and the common product-preparation contract remain supplied relations. No new physical necessity follows from naming those operations. Within that contract a retained contrast again selects the unique representation. The proof does not assume that the representation is a physical channel, and its general scalar steps are not certified by the finite Swift counterexample below.

Removing T leaves a nonconstant, nonidentity alternative even if all Clifford operations are retained. For each n-qubit Hermitian Pauli basis element P define a map by

```
Tr[P G_n(ρ)] = (Tr[Pρ])⁵.
```

These coefficients do define a density operator. To see positivity, extend J(P)=P⊗P⊗P⊗P⊗P linearly on the Pauli basis. If PQ=ωR, where ω is a fourth root of unity, then J(P)J(Q)=ω⁵J(R)=ωJ(R)=J(PQ). Also J preserves adjoints and identity. Hence J(A†A)=J(A)†J(A)≥0, and the normalized positive functional A↦Tr[ρ^⊗5 J(A)] supplies G_n(ρ). This construction establishes mathematical positivity. It does not make G_n a channel acting on one unknown input.

Products and partial traces are preserved, as follows by evaluating their Pauli coefficients. A Clifford operation sends each P to a signed Pauli, and the fifth power preserves that sign, so G_n commutes with every such operation, including H, S and CNOT. For one qubit it acts as (x,y,z)↦(x⁵,y⁵,z⁵), which is neither identity nor constant. It fixes the X-positive state but changes its T-rotated vector (t,t,0) to (t⁵,t⁵,0). Thus its T covariance fails. This supplies an actual alternative to the weakened contact family. The Pauli expectations change by the displayed fifth power, so covariance alone does not certify unchanged measurement probabilities. No minimality among all possible operation families is claimed.

The conditions of the preceding all-unitary version have different work to do:

| Omitted relation | Surviving alternative |
|---|---|
| Independent preparation | C_ε with 0<ε<1 commutes with all unitaries and partial traces, while changing product preparations. |
| Partial trace | F(ρ)=ρ²/Tr(ρ²) commutes with all unitaries and preserves tensor products. It fixes pure joint states but changes diag(3/4,1/4) to diag(9/10,1/10), so it fails on a purification of that marginal. |
| Joint unitary covariance | F₂=C_ε and F₄=C_ε⊗C_ε preserve products and partial traces and commute with local unitaries. For |00⟩, controlled-NOT fixes the source but changes its independently encoded output when 0<ε<1. |

For the last row put p=(1+ε)/2 and q=(1−ε)/2. The encoded diagonal weights are (p²,pq,pq,q²). Controlled-NOT exchanges the last two. Equality would require pq=q², or ε(1−ε)=0. Thus one joint operation already detects the failed transport in this family. These alternatives test the sufficiency of the listed relations, not the existence of alternative physical worlds.

At ε=1/2, `JointTransportProduct` computes the four product weights (9,3,3,1) from (3,1), using the existing natural-product and Gram constructors. Their sum 16 supplies the probability normalization here. `ControlledWeightExchange` composes identity on the first row with exchange on the second. It fixes the original |00⟩ weight table and sends the independently encoded table to (9,3,1,3). A positive distinction of the moved weights and an explicit refusal exclude unchanged joint transport. These static source and output relations certify the finite counterexample. The general rigidity argument above uses the stated quantum state and operation family.

The conclusion concerns a representation with already matched operations and factor readings. VI1 still permits changing those addresses together. The general d-dimensional proof uses arbitrary joint unitaries and purifications. The qubit proof replaces those requirements with the stated operations and both factor readings. Both use the quantum state carriers and common product preparation as explicit premises. Their mathematical existence does not establish physical access to every required preparation or contact. LQ15's free splicing, G14b's disjoint operation inputs and AC7's factorized weights are distinct independence requirements. None follows from the absence of an outside. Within either stated contract, preservation of a single contrast excludes the constant representation, and the remaining answer is unique.

M31's classical key and ciphertext and M32's selected Bell preparations therefore retain their stated conclusions. Neither family asserts silence on every coherent input of a common isometry. M72 likewise asks about one specified recovered distinction at a complete boundary. Enlarging that question to recovery of an entire quantum input changes the required relations. Returning a known preparation can also be accomplished by preparing it again, so it does not establish recovery of an unknown input or its earlier correlations. The roles agent and environment do not change these obligations: the relevant boundary, preparation family and available joint decoder do.

**An internal reference has a preparation contract.** IiS10 removes primitive phase factors from an order comparison. It does not establish a universal reader for every representation of the resulting relation. Consider replacing a calibrated phase analyzer with one reference qubit. The available joint input is one copy of r_z⊗r_sz, where r_z=(|0⟩+z|1⟩)/√2, |z|=1 and s is either +1 or −1. Both systems share z. The task is to report s with one fixed instrument, without another input correlated with z or s. In the ordered basis 00,01,10,11 the two families are

```
v_s(z) = (1, s z, z, s z²)/2.
```

For each fixed z, v₊(z) and v₋(z) are orthogonal. Nevertheless no instrument answers correctly with certainty for every z: v₊(1) and v₋(i) have inner product (1−i+i+1)/4=1/2. Matter §5's positive-effect argument excludes their certain discrimination, even with an arbitrary independent ready apparatus. The apparatus would have to return different labels on this nonorthogonal pair. For any fixed number k of independent copies of the whole pair, that overlap remains 2⁻ᵏ, so exact universal identification still fails. This does not bound approximate identification with increasing k.

The phase domain matters. If z is restricted to +1 and −1, measuring X on both qubits and multiplying the outcomes answers s with certainty. Extending a sign-only proof to all phases would therefore change a successful classifier into an impossible one. The i instance supplies the missing counterexample. This leaves IiS10's central-factor proof intact, since that proof covers arbitrary primitive phases for its different comparison contract.

`RelativePhasePreparation` constructs the four coefficients of v₋(i) using the actual XZ and ZX compositions. For this calculation their two signed coordinates mean the real and imaginary parts of one scalar, so those actions represent multiplication by i and −i. Their composed last coefficient returns to the unit. The middle coefficients cancel, leaving two equal positive real units. `QuarterPhaseOverlapNumerator` adds the actual remaining coordinates and derives 2, with a positive zero/successor distinction. Refusals reject zero overlap, preservation of the old corner-sign rule at i, and identifying the selected middle sector with the whole input. Normalization, positive effects and the general discrimination conclusion are proved here, rather than supplied by these type names.

**A partial answer has a sharp optimum.** Put ψ₊=(|01⟩+|10⟩)/√2 and ψ₋=(|01⟩−|10⟩)/√2. The fixed measurement with effects E₊=|ψ₊⟩⟨ψ₊|, E₋=|ψ₋⟩⟨ψ₋| and E?=|00⟩⟨00|+|11⟩⟨11| reports the correct s with probability 1/2, never reports the wrong s, and otherwise remains inconclusive. These probabilities are the same for every z. This is optimal for error-free answers: the minus family spans {00,11,ψ₋}, so a positive effect that never labels it plus must be supported on ψ₊ alone. Since the effect is at most I, its probability on any plus input is at most 1/2. The other outcome has the same argument. Three distinct phase values already establish those spans.

**A false reader can pass every promised input.** The candidate M=2E₊ satisfies ⟨v₊(z)|M|v₊(z)⟩=1 and ⟨v₋(z)|M|v₋(z)⟩=0 for every z. It is positive, with a rank-one Gram factor. Nevertheless it is not an effect: its response on ψ₊ is 2, and the complementary response is −1. This probe is available by selecting the middle sector of a plus input, with nonzero probability. The contradiction therefore uses a continuation of the supplied preparations. It does not require assigning the old same-or-opposite label to the new probe: a negative outcome probability is inadmissible either way. Successful calibration on the whole promised family is still insufficient to validate an arbitrary proposed instrument.

The static instance uses `ComparisonCandidateGram`, constructed from the factor (1,1). `ComparisonProbeNorm` derives its squared norm 2, and `ComparisonCandidateWeight` derives weight 4 on that same factor. The complement's actual terms are +2 and −4. Their unit expansion gives two more negative units than positive units, and a refusal rejects replacing this weight by zero. After normalization the weights are 2 and −1 as above. This is an explicit counterexample to treating a positive Gram as a normalized measurement effect. A type that reads s from a preparation's declared name would answer a different question from the physical instrument considered here.

If the instrument must always give a binary answer, the optimal worst-case success probability is **3/4**. For the upper bound, average each family over the four test phases 1,i,−1,−i. The resulting density matrices are

```
ρ₊ = (|00⟩⟨00| + |11⟩⟨11|)/4 + |ψ₊⟩⟨ψ₊|/2,
ρ₋ = (|00⟩⟨00| + |11⟩⟨11|)/4 + |ψ₋⟩⟨ψ₋|/2.
```

These four controls remove every nonzero phase power present here. The joint coefficients contain powers 0,1,1,2 of z, and a density entry contains their difference. For powers ±1 and ±2 the four contributions sum to zero, while power zero remains. `PhaseCycleCancellation` derives the cancelling pairs from actual successive quarter turns on arbitrary coefficient fields. It also derives the fourth return. Consequently a fourth-harmonic coefficient would survive this finite cycle, and a refusal rejects erasing its nonzero unit. The bound on these two-qubit exponents supplies the coverage. Four successful phase controls alone would not supply it for an unrestricted carrier.

Both preparations contain the same mixture component τ=(|00⟩⟨00|+|11⟩⟨11|)/2 with weight 1/2. A fixed reader must respond to that component in the same way. If its probability of answering plus on τ is b, the two success probabilities are at most (1+b)/2 and (2−b)/2. Their mean is at most 3/4. A guarantee for every input cannot exceed that mean. This finite average is a certificate against a uniform guarantee, not an assumption that reality samples z uniformly. For attainment, use M=E₊+E?/2. It gives success 3/4 for either s at every z. The unambiguous and always-answering tasks have different optima because their permitted records differ.

This last obstruction uses only the established mixture relations and one reader. Whenever two preparation laws each contain the same available input component with weight λ, their equal-weight mean classification success is at most 1−λ/2. An error-free reader must leave that common component unresolved, so its conclusive probability on either law is at most 1−λ. Nonnegative response probabilities and preservation of the actual mixing relation prove these bounds. Quantum geometry supplies the mixture identities here, but is not needed again for this consequence. The identity concerns the declared incoming interface. The preparation records elsewhere in the whole need not coincide. This is M71's shared-input obstruction applied to a physically specified mixture, not a claim that the histories have become identical.

The two optima belong to one exact tradeoff. For 0≤u≤1, if the reader may remain inconclusive with probability at most u on every phase-family input, its worst-case error is at least max(0,1/4−u/2). On the shared half of the mixture, at most u can remain unresolved. Any remaining answers give equal mean weight to the two competing labels. For 0≤u≤1/2 the effects

```
M₊ = E₊ + (1/2−u)E?,
M₋ = E₋ + (1/2−u)E?,
M? = 2u E?
```

sum to I and attain inconclusive probability u and error 1/4−u/2 on every input. For u≥1/2 the error-free rule already meets the budget. The error probabilities here include all trials. Conditioning on the answered trials divides the error by their actual total probability. Treating an inconclusive record as a successful answer would change the proved contract.

**Changing the joint preparation can remove the obstruction.** The same two-qubit carrier admits the directly encoded states ψ₊ and ψ₋. Under the common phase change diag(1,z) on each qubit, each becomes zψ₊ or zψ₋, which is the same ray. Their individual reduced states are both I/2, while the fixed E₊/E₋ reading distinguishes the joint states with certainty. In the product preparation v_s(z), selecting the middle sector produces this code up to a phase, but only with probability 1/2. Keep the selection record. No deterministic channel on the stated product family can always produce the corresponding ψ_s: its composition with their exact reading would violate the proved discrimination obstruction. An additional correlated preparation changes that input contract.

**Removing the shared axis changes the answer again.** Enlarge the product preparation promise to |ψ⟩|ψ⟩ or |ψ⟩|ψ⊥⟩ for every qubit direction ψ. The second family spans all four joint directions. For example |01⟩, |10⟩, |+⟩|−⟩ and |+i⟩|−i⟩ are linearly independent. Therefore an error-free effect for the answer “same” is zero. The first family spans the symmetric subspace, so the optimal error-free “opposite” effect is the antisymmetric projector P_a, which clicks with probability 1/2 on every orthogonal product. In particular the old E₊ clicks on |01⟩ with probability 1/2 and would mislabel that newly admitted source. The preparation promise carried its validity.

For this larger domain, the optimal worst-case binary success is **2/3**. A finite certificate suffices. Average each family over the six directions ±x, ±y, ±z to get σ_same=P_s/3 and σ_opposite=P_s/6+P_a/2, with P_s the symmetric projector. These identities follow by expanding (I+n·σ)/2 and using the six directions' first moment zero and second moment δᵢⱼ/3. For a binary effect M reporting “same”, put a=Tr(MP_s)/3 and b=Tr(MP_a). The two mean success probabilities are a and 1−a/2−b/2. A uniform guarantee t thus requires t≤a and t≤1−a/2, which imply t≤2/3. The effect M=2P_s/3 attains 2/3 on every promised input. No distribution over unknown physical orientations has been assumed by this finite upper-bound argument.

The directly encoded ψ₊ and ψ₋ still admit a certain joint answer without an aligned axis: exchanging the two systems has eigenvalues +1 and −1 on them. This exchange commutes with U⊗U for every common unitary U, as its action on each product vector verifies. The fixed measurement P_s/P_a therefore distinguishes the two encoded classes after any such common change. `ExchangeParityEncoding` derives the two exchange relations from the actual coefficient transpose and common sign reversal. The common-unitary statement uses the tensor argument just given. Applying the exchange alone need not change either ray. The discrimination is by its two projectors, not by mistaking the minus eigenvalue for an observable global phase. Independently changing the two systems has a different contract.

This full-orientation construction preserves a binary label. It does not preserve every superposition of those labels. For example (ψ₊+ψ₋)/√2=|01⟩ changes to |10⟩ under the common X⊗X action, although each parity class remains the same. Under the smaller common-phase family the whole span of ψ₊,ψ₋ instead acquires one common factor z, so arbitrary superpositions within that span survive. The scope of preserved questions determines whether the construction carries this one classical answer or a coherent two-dimensional state.

The background is the standard quantum-state comparison problem studied by [Barnett, Chefles and Jex](https://arxiv.org/abs/quant-ph/0202087), and the relational encodings reviewed by [Bartlett, Rudolph and Spekkens](https://arxiv.org/abs/quant-ph/0610030). The bounds depend on the promised preparation family and on whether inconclusive records are permitted. Here the unknown phase or orientation describes a shared offset relative to the retained instrument. Conjugating the whole preparation and instrument together changes no prediction. Neither the no-go results nor their attaining constructions require an observer outside the whole. The offset, the available joint preparation and the admitted instrument are distinct parts of the contact.

**The probability gap and exact silence have different stability.** Suppose every actual preparation is within trace distance ε of its named ideal input. Any outcome probability then changes by at most ε: the difference of the states has positive and negative parts of equal trace at most ε, and an effect lies between zero and I. The optimal uniform binary success consequently lies between 3/4−ε and 3/4+ε for the phase family, or between 2/3−ε and 2/3+ε for the full-orientation family, with probabilities clipped to [0,1]. These bounds use one common instrument and controlled preparation errors.

Exact error-free classification is more fragile. Any positive admixture of I/4 makes every prepared state full rank. Every nonzero positive effect then has nonzero probability on both labels. Requiring zero error forces both conclusive effects to vanish, even if that admixture is arbitrarily small. The ideal probability-1/2 conclusive rule is therefore an exact boundary result. The binary performance gaps supply the separate finite-error comparison.

The four effects E₊, E₋, |00⟩⟨00| and |11⟩⟨11| already have a [photonic implementation reported by Zhan et al.](https://arxiv.org/html/2406.06810v2): path and polarization encode the pair, and four detector channels record these projections. This identifies an existing experimental contact for the comparison, without claiming its finite data establish the ideal equalities exactly.

**IiS13 (Finite error bounds need overlap and conditioning).** Exact connectivity alone gives no numerical guarantee from imperfect observations. An elementary bound for the same CPTP model can be obtained without reconstructing its Kraus operators. Again reduce to the identity target. Suppose each probe has output survival probability at least 1−εᵢ, with 0≤εᵢ≤1. For an isometric dilation V, choose a unit eᵢ so that

```
||Vψᵢ − ψᵢ⊗eᵢ|| ≤ δᵢ,
δᵢ = sqrt(2 − 2 sqrt(1−εᵢ)).
```

To obtain this bound, project Vψᵢ onto ψᵢ in the output system. The resulting environment vector has norm at least sqrt(1−εᵢ). Normalize it to define eᵢ. The squared distance is twice one minus that norm. If the projection is zero, εᵢ=1 and any unit eᵢ gives the same bound.

The inner products of Vψᵢ,Vψⱼ and of ψᵢ⊗eᵢ,ψⱼ⊗eⱼ differ by at most δᵢ+δⱼ, by inserting one intermediate inner product and using unit norms. On an edge with γᵢⱼ=|⟨ψᵢ,ψⱼ⟩|>0 this yields

```
||eᵢ−eⱼ|| ≤ wᵢⱼ,
wᵢⱼ = min(2, sqrt(2(δᵢ+δⱼ)/γᵢⱼ)).
```

Choose a root probe r and a path from r to each probe i. Let Lᵢ be the sum of edge bounds on that path, capped at two, with Lᵣ=0. Then ||Vψᵢ−ψᵢ⊗eᵣ||≤δᵢ+Lᵢ. Choose d linearly independent probes and let B be the matrix whose columns are those vectors. Its smallest singular value s is positive. For V₀x=x⊗eᵣ, multiplication by B and the bound of operator norm by Frobenius norm give

```
||V−V₀|| ≤ K,
K = sqrt(Σᵢ∈basis (δᵢ+Lᵢ)²) / s.
```

For every input density operator ρ, half the trace norm of E(ρ)−ρ is at most min(1,K). Indeed, expand VρV†−V₀ρV₀† into two terms containing V−V₀, apply the trace-norm bound for multiplication by bounded operators, and trace out the environment. The same argument permits an untouched reference system, because tensoring the two isometries with its identity preserves their operator norms. This is a sufficient nonasymptotic bound, not an optimal fidelity estimate. Mayer and Knill analyze sharper process-fidelity bounds for this calibration problem.

The formula makes two independent weaknesses explicit: small edge overlaps make record agreement hard to infer, while nearly dependent probes make s small. For two normalized qubit probes with overlap magnitude t between zero and one, s=sqrt(1−t), from the eigenvalues 1±t of B†B. Exact spanning and connectedness therefore do not justify an arbitrary robustness claim. The εᵢ, actual probe states, common process and subsequent reuse relation still need evidence. M64 handles that last distinction: an intact earlier record alone does not certify a later process. VC74's unrestricted-mechanism boundary is unchanged, since this result explicitly uses the CPTP model and its exact or bounded response premises. No experimental calibration or general Swift positivity certificate is supplied here.

For the two-arm case there is a sharper bound under the stronger premise that both within-arm channels are already exactly identity. Write g=⟨e₁,e₀⟩, with |g|≤1. The balanced joint probe has survival probability F=(1+Re g)/2. If F≥1−ε, then |1−g|²≤2(1−Re g)≤4ε. For a normalized pure input x+y, with x and y in the two orthogonal arm spaces, the channel difference contains only the two adjoint cross terms. Its half trace norm is |1−g| ||x|| ||y||≤|1−g|/2. The same calculation applies with an untouched reference, and convexity extends it to mixed inputs. Consequently every input, including an entangled one, has output trace distance from the target at most sqrt(ε). This bound is sharp within the stated family: a unit-modulus g with Re g=1−2ε attains it on a balanced input. This is a consequence of the block classification, not a replacement for its exact within-arm premises. Approximate within-arm calibration instead needs error terms such as those above.

## §7. Why the joint context constrains a local rule

**IiS14 (Ordinary positivity does not support the probe criterion).** In IiS11, complete positivity cannot be replaced by positivity of the isolated system's output. Transposition T(ρ)=ρᵀ is linear and trace preserving. It preserves positive semidefinite matrices: if ρ=Σᵢλᵢ|uᵢ⟩⟨uᵢ| with λᵢ≥0, then ρᵀ=Σᵢλᵢ|uᵢ*⟩⟨uᵢ*|. It fixes the pure states A and (A+B)/√2, which span the qubit space and have nonzero overlap. Yet it changes the projector of (A+iB)/√2 to that of (A−iB)/√2. Indeed it fixes every real symmetric density matrix, so collecting further real-state probes cannot exclude it.

The obstruction appears on a joint input. In the basis 00,01,10,11, put |Φ⟩=(|00⟩+|11⟩)/√2. Applying transposition to the second factor of its projector gives

```
(id ⊗ T)(|Φ⟩⟨Φ|) = (1/2) [ 1  0  0  0
                                      0  0  1  0
                                      0  1  0  0
                                      0  0  0  1 ].
```

The normalized antisymmetric vector |ψ⁻⟩=(|01⟩−|10⟩)/√2 has expectation −1/2 on this output. A positive measurement projector cannot have negative weight in a density operator. Thus the proposed local rule fails on an admitted joint state. This is the standard transposition obstruction underlying complete positivity and the [partial-transpose separability criterion of Peres](https://arxiv.org/abs/quant-ph/9604005). Complete positivity requires positivity after tensoring the proposed map with an identity on any reference space. In this counterexample one internal qubit reference already suffices. The [Kraus and Choi representations](https://quantum.cloud.ibm.com/learning/en/courses/general-formulation-of-quantum-information/quantum-channels/representations-of-channels) give the corresponding general finite-dimensional channel framework.

`TransposeEntries` in Quantum.swift implements the entry permutation. Existing `PairedApplication` applies it separately to the four actual blocks, producing the partial transpose from the original integer matrix 2|Φ⟩⟨Φ|. `AntisymmetricWeightTerms` reads the four entries of v*Mv for v=(0,1,−1,0), retaining their signs. The existing amplitude constructors expand its actual recorded terms as 0+0−1−1. The compiler derives zero positive units and two negative units, and refuses a zero total or a composition using the original matrix in place of the computed output. Normalizing both the input matrix and the test vector contributes a factor 1/4, giving −1/2. This normalization and the positive-measurement interpretation are mathematical steps. No generic positivity protocol or runtime eigensolver is introduced.

This supplies a concrete obligation behind IiS11's model premise. The isolated response rule must remain admissible on the declared joint states, while the reference's operation remains identity. Applying transposition to both factors instead gives the full transpose and removes this particular negative output, but it changes the proposed operation on the retained reference. Likewise, changing a global complex-coordinate convention together with all states and effects is a different question from applying T to one physical part. The other factor is internal to the same whole throughout. Quantum tensor composition and positivity are explicit assumptions of this account, rather than conclusions from binary syntax or closure alone.

The result also specifies a limit of the calibration model. A common channel describes one input-output rule on its stated domain. If preparation changes correlations with an environment, the same reduced input can conceal different whole preparations and need not determine the same later reduced output. Their identification would need a sufficiency or transport relation such as M64. An arbitrary internal history does not become a single reusable CPTP map on the basis of an internal partition alone.

For comparison, a classical stochastic matrix S acts on a joint probability table by p′(i,r)=ΣⱼS(i|j)p(j,r). The map preserves nonnegativity, and column normalization preserves the total probability. This remains true for every classical reference alphabet and correlated input table. Thus the same requirement of admissibility in a joint context is automatic for a classical stochastic map, while the quantum tensor-state family makes it a stronger constraint than isolated positivity. VI can state the shared compositional obligation without identifying these different state spaces. Transposition also preserves every isolated density operator's spectrum and von Neumann entropy, so an entropy-preservation test would not reveal the joint failure above.

## §8. Positivity by a retained factorization

**IiS15 (A Gram construction supplies a positive matrix).** Choose the finite numeral grammar N₀=Never and Nₙ₊₁=Examples.Succ<Nₙ>. The Examples constructor is nominally distinct from VerificationIsIdentification.Succ, so the checks name it explicitly when both modules are imported. The following arithmetic derivations in Amplitude.swift compute canonical output types without invoking `Structure.count`:

- `AddZero<B>` has operands (0,b) and answer b. `AddSuccessor<P>` has operands (a+1,b) and answer c+1 when P has operands (a,b) and answer c.
- `ProductZero<B>` has operands (0,b) and answer 0. `ProductSuccessor<P,A>` has operands (a+1,b) and answer d when P derives (a,b)↦c and A derives (c,b)↦d. The two operand equalities are actual type constraints.

Induction on a proves that every finite sum derivation beginning at its zero constructor has answer Nₐ₊ᵦ, provided B=Nᵦ. The same induction for products uses the already proved sum case: if c=ab, the required addition gives d=ab+b=(a+1)b. Conversely, these constructors build a derivation for every finite a,b. At a fixed operand pair the answer is therefore unique within this constructor grammar. The open `NaturalSum` and `NaturalProduct` interfaces expose operand and answer addresses, and do not assert this theorem for arbitrary external conformances or cyclic `IntegerValued` types. The constructor interpretation is the proof domain. Existing `Plus` and `Times` supply structural count readings, which do not normalize their type identities to these successor expressions.

A fixed finite first operand does not require accepting an arithmetic derivation from the caller. The schema with a successor steps applied to `AddZero<B>` has operands (Nₐ,B) and answer Succᵃ(B) for every `B: IntegerValued`. This structural identity needs no finite interpretation of B. The numerical reading a+b additionally requires B=Nᵦ. In contrast, a successor chain applied to an arbitrary `P: NaturalSum` preserves P's answer, including an incorrectly asserted base. [S28](difference_is_distance#§5g-when-the-interval-relations-belong-to-one-reading) uses anchored schemas to construct its finite counterexample and checks their operand addresses against the shared source.

`NaturalGram<AA,AB,BB>` requires its three actual product sources to be (a,a), (a,b) and (b,b). Its input is the same (a,b) pair and its output is the matrix of their computed answers:

```
G = [ a²  ab
      ab  b² ].
```

For every complex test vector z=(z₀,z₁), z†Gz=|az₀+bz₁|²≥0. Thus the constructed matrix is positive semidefinite. Its trace is a²+b². When at least one source coefficient is nonzero, dividing by that trace gives the pure-state projector of (a,b)/sqrt(a²+b²). If both are zero, the output is the valid zero positive matrix and cannot be normalized to a state. Positivity of an unnormalized matrix, nonzero trace and a trace-one state are separate properties of this construction.

The static witness uses derivations of 2·2, 2·3 and 3·3. It computes G with rows (4,6) and (6,9), and `AcquireAnswer` retains the computed matrix beside its original factors. No entry 4,6 or 9 is supplied to the Gram constructor as a target answer. Refusals break the preceding product, the retained multiplier, either shared square factor and one computed matrix entry. The generic one-by-n case derives the repeated n coordinate from the same product source for every admitted square derivation. These are source and output equalities checked by Swift, with positivity following from the proved scalar interpretation and displayed factorization.

`AddNaturalMatrices` extends this construction by four source-bound addition derivations. Its source is both matrices reconstructed from the additions' operands, and its output consists of their computed sums. Composing it with `PairedApplication` of two Gram readings retains both original vectors as the source of the resulting matrix. For any finite list of such factors, induction on the additions gives z†Gz=Σⱼ|aⱼz₀+bⱼz₁|²≥0. The code supplies the local composition step, and finite iteration yields the stated family of certificates. It does not enumerate all positive matrices with arbitrary complex entries.

The second static chain adds the factors (1,0) and (2,3), computing rows (5,6) and (6,9). Its quadratic form is |z₀|²+|2z₀+3z₁|². If this vanishes, z₀=0 and then z₁=0, so the matrix is positive definite. Its trace is 14 and its determinant is 9. Dividing by 14 produces a rank-two density operator, unlike either rank-one summand after normalization. The compiler verifies the computed entries and their link to the two acquired factors. The quadratic-form, rank and normalization conclusions use the displayed mathematical interpretation.

This matrix also gives an explicit relation to M32's internal entropy question. Let e₀,e₁ be orthonormal states of an internal record part. The normalized joint vector

```
|Ψ⟩ = ( |0⟩⊗e₀ + (2|0⟩+3|1⟩)⊗e₁ ) / sqrt(14)
```

has the computed local density matrix after tracing out that part. Its joint von Neumann entropy is zero. Its local entropy is positive because both local eigenvalues are strictly between zero and one. No exterior random source is required in this representation. The type-level acquired record retains the description of both factor vectors, while an actual quantum preparation additionally needs the specified orthogonality and preparation relations. A source description and its physical realization must not be silently interchanged.

This gives a constructive certificate within a specified arithmetic family, rather than an arbitrary matrix tagged positive. It is not yet a general complex Gram calculus or a complete-positivity certificate for a map. The relation to IiS14 is precise: a source-bound sum of squared absolute values cannot produce that negative witness. Merely preserving isolated matrix spectra does not supply such a joint factorization. An extension to channel operators must retain the same connection between actual source coefficients, operations and output.

**IiS16 (The same operator source normalizes, records and reduces).** Let K₀=|0⟩⟨0| and K₁=|1⟩⟨1|. Their actual rows, grouped as the two operator matrices, feed IiS15's Gram and addition constructors. The resulting source is the same ordered pair used by `BasisRecordMatrix`, and its computed answer is K₀†K₀+K₁†K₁=I. The checks derive this identity and equality of the operator sources. Supplying K₀ twice instead produces diag(2,0) and fails the identity comparison.

For ρ with rows (a,b) and (c,d), the joint record is VρV†, where V=|0⟩ₑ⊗K₀+|1⟩ₑ⊗K₁. Its block at (j,k) is KⱼρKₖ†. Direct multiplication yields

```
VρV† = [ a  0  0  b
         0  0  0  0
         0  0  0  0
         c  0  0  d ].
```

`BasisRecordMatrix` constructs exactly these blocks for arbitrary entry descriptions, without numerically evaluating them. Its source contains the operator pair, the prepared record density matrix |0⟩⟨0| and the original ρ. `RecoverBasisMatrix` selects the four addressed entries of V†(VρV†)V and restores ρ. The recovery equality is derived generically from the actual output. The shared operator identity supplies V†V=I in the mathematical interpretation.

Tracing out the record adds the two diagonal blocks. Existing evidence projections select those blocks from the same joint output, and `SumDisjointDiagonalEntries` computes their sum because their supports are disjoint. The resulting channel is Φ(ρ)=K₀ρK₀†+K₁ρK₁†=diag(a,d). `BasisRecordCalculus` checks this local answer and its acquisition alongside full recovery and the shared normalization source. An altered operator pair, an altered prepared record, erased joint cross terms and attempted recovery from the local answer all have explicit refusal cases. The local answer fixes both basis projectors but changes the nonorthogonal bridge probe, supplying a constructed instance of IiS11's dephasing alternative.

`ExchangeBasisRecordFactors` regroups all sixteen actual joint entries to exchange the two output factors. `BothBasisRecordMarginals` derives invariance of this joint matrix under that exchange and reuses the local reading on its computed output. Both marginals are diag(a,d). They remain equal for arbitrary changes to b,c, while the joint retains those entries. The normalized inputs I/2 and |+⟩⟨+| give the same two marginals and positively distinct joint outputs. A refusal rejects their joint identification. The phase family in IiS12 is the pure-input specialization a=d=1/2, with b,c conjugate and variable. These are entry and transport checks, not a Swift proof of the general no-hiding theorem.

The [Kraus criterion](https://quantum.cloud.ibm.com/learning/en/courses/general-formulation-of-quantum-information/quantum-channels/representations-of-channels) now applies to these same operators and this actual entry formula. For any reference R, any positive joint input Ω and any vector z,

```
⟨z, (idᵣ⊗Φ)(Ω) z⟩
  = Σⱼ ⟨(Iᵣ⊗Kⱼ†)z, Ω (Iᵣ⊗Kⱼ†)z⟩ ≥ 0.
```

Thus Φ is completely positive. Cyclicity of trace and the computed normalization give Tr Φ(ρ)=Tr(ρ ΣⱼKⱼ†Kⱼ)=Tr ρ. This is a CPTP construction with the normalization and action tied to one operator source. Swift supplies the finite arithmetic and generic entry equalities. The proof for every complex positive input and every reference uses the displayed linear-algebra interpretation, without claiming a general Swift positivity decision procedure. IiS14's transposition fails precisely this joint positivity test.

The prepared record is internal to a fixed larger system. V describes the slice |0⟩ₑ⊗H, rather than creation of an exterior memory. A controlled-NOT with the original system controlling the record permutes the four joint basis vectors and implements V on that slice. Its inverse restores the prepared record and the input. For a pure input α|0⟩+β|1⟩, the result is α|00⟩+β|11⟩, not two copies of that unknown input state. The joint state remains pure, while either marginal has entropy h₂(|β|²). For a mixed input, the joint nonzero spectrum equals the input spectrum. Local loss of coherence and unchanged joint entropy are therefore consequences of one specified preparation and reversible joint operation. They do not require an external sink or establish a universal temporal arrow.

## §9. A matrix certificate for all untouched-reference contexts

**IiS17 (Choi identification and admissibility).** Fix input and output complex spaces of finite dimensions n and m, an input basis and a complex-linear map Φ between their matrix spaces. Let Eᵢⱼ=|i⟩⟨j| and define

```
J(Φ) = Σᵢⱼ Eᵢⱼ ⊗ Φ(Eᵢⱼ).
```

This is the standard [Choi representation and criterion](https://quantum.cloud.ibm.com/learning/en/courses/general-formulation-of-quantum-information/quantum-channels/representations-of-channels): J determines Φ uniquely, and Φ is CPTP exactly when J is positive semidefinite and Tr_output J=I_input. It replaces quantification over all untouched-reference extensions with a finite matrix certificate, under the stated linear and tensor model. It is not a theorem derived from binary syntax or a new result of VI.

Here finite refers to the matrix dimensions. An exact finite description additionally needs representations of its coefficients and factorization. EF5's finite constructor strings form a countable set. The qubit phase channels Uλ=diag(1,λ), for all unit-modulus complex λ, form an uncountable family: their actions on E₀₁ are λ*E₀₁, so distinct λ give distinct channels. No fixed interpretation of finite strings over a finite or countable alphabet can therefore identify every such channel exactly. Treating an arbitrary λ as one primitive token would move the missing information into that token's interpretation.

A finite formula can describe this entire parameter family and prove a property uniformly without identifying a particular λ. A particular channel can also have an exact finite description when its coefficients admit one, as in the integer constructions here. Approximate coefficients instead require error bounds for the intended question. Matrix dimension, exact description and an available physical record are separate requirements. The Choi theorem does not establish that every idealized complex channel has a finite bare Swift encoding.

The reconstruction is explicit. Every input matrix is X=ΣᵢⱼXᵢⱼEᵢⱼ, so Φ(X)=ΣᵢⱼXᵢⱼJᵢⱼ, where Jᵢⱼ are the actual output blocks. Equivalently,

```
Φ(X) = Tr_input [ (Xᵀ ⊗ I_output) J ].
```

Therefore equal J matrices give equal maps on every input. The transpose in this expression fixes the index pairing, rather than implementing the inadmissible physical transposition of IiS14.

Here is the positivity argument in the same convention. Put |Ω⟩=Σᵢ|i⟩⊗|i⟩. Complete positivity implies J=(id⊗Φ)(|Ω⟩⟨Ω|)≥0. Conversely, factor any positive J as Σₐwₐwₐ† and define the columns of Kₐ by wₐ=Σᵢ|i⟩⊗Kₐ|i⟩. Comparing blocks gives Jᵢⱼ=ΣₐKₐEᵢⱼKₐ†. Linearity reconstructs the Kraus action on every X, and IiS16's quadratic-form argument proves positivity with every reference. In this ordering,

```
Tr_output J = (Σₐ Kₐ†Kₐ)ᵀ.
```

Thus its equality to identity is exactly Kraus normalization. The transpose disappears from the identity condition, but must not be dropped from the general formula. This proves the stated criterion and explains why a positive factorization can serve as a certificate without a runtime search over joint inputs.

For the existing dephasing construction, `DephasingChoiApplications` assembles the four actual outputs on E₀₀,E₀₁,E₁₀,E₁₁ using the same generic `BasisRecordCalculus`. It computes J=diag(1,0,0,1). The matrix equals the output of `BasisRecordMatrix` on the positive unnormalized input I, which supplies its existing positive construction. `TraceNaturalEntries` ties each block trace to an actual addition of its diagonal entries. Applying it to the computed blocks yields I, with no supplied normalization answer. The old `BellPartialTranspose` is also the Choi matrix of T, since its four blocks are precisely T(Eᵢⱼ). It has the same identity partial trace and the already derived negative antisymmetric weight. The new checks reject identifying these two matrices from equal partial traces, replacing a computed off-diagonal block, or applying a trace derivation to a different block source. No `ChoiIsPositive` declaration is introduced.

The matrix units E₀₁ and E₁₀ are linear coordinates, not physical density operators prepared in four independent experiments. On a normalized maximally entangled input, the joint output of a channel is J/n. Knowing that complete output density operator would identify the channel in this model. A single observed outcome, or a finite sequence of successful trials, does not supply that complete exact matrix. Empirical reconstruction and its error bounds remain acquisition questions. A finite certificate and finitely many raw observations are different objects.

The Choi matrix determines id_R⊗Φ for every untouched reference R. It does not determine an implementation-dependent coherent-control extension: IiS10's two operator orders have the same J while their specified controlled implementations differ. However, the two primitive Choi descriptions do determine their output through the fixed quantum switch. The descriptions of the two composites alone can omit that primitive factorization, as the (X,Z) versus (I,XZ) construction shows. Which operation receives which inputs matters. Coherent composition is not uniformly excluded by the channel interface.

This also sharpens the comparison with classical models. A stochastic table supplies the response to classical basis alternatives. Those responses determine a map on diagonal matrices, while the off-diagonal Choi blocks describe additional quantum relations. The classical identity table is compatible with both quantum identity and dephasing: they agree on the two basis projectors and disagree on E₀₁,E₁₀. The two models share the demand for consistent composition, but the classical table alone does not identify a quantum extension. The state and question family specify what a complete record must contain.

## §10. Which questions survive a channel?

**IiS18 (recovering a question through an admissible measurement).** Let Φ be a channel between fixed finite-dimensional quantum systems. An input effect A, with 0≤A≤I, specifies the binary outcome probability Tr(Aρ). Allow any binary measurement on the output, with no additional input-dependent record. Its effect B reproduces this probability for every input state exactly when

```
0 ≤ B ≤ I,       Φ*(B) = A.
```

Here Φ* is the trace adjoint: Tr[BΦ(ρ)]=Tr[Φ*(B)ρ]. These are the standard channel and measurement objects of [Watrous, Chapter 2](https://cs.uwaterloo.ca/~watrous/TQI/TQI.2.pdf). The criterion follows directly: equality of probabilities makes the expectation of the Hermitian difference Φ*(B)−A zero in every pure state, hence that difference is zero. Conversely the operator equality gives the required probability equality. The same effect is preserved on a common input/output space precisely when Φ*(A)=A. This states equality of outcome distributions, not the prediction of one future outcome or recovery of an earlier realized outcome.

For IiS16's dephasing Δ, the adjoint is Δ itself: cyclicity of trace gives Δ*(B)=K₀BK₀+K₁BK₁. Its image consists exactly of diagonal matrices. Therefore an input binary measurement can be reproduced after Δ for every input precisely when its effect is diagonal. Sufficiency uses B=A, which is already an effect. Necessity follows from the displayed image. In particular, Δ preserves every basis-population question while omitting the distinctions needed by an X-basis measurement. Full input-state recovery is unnecessary for the former family and impossible for the latter on unrestricted inputs.

The coefficient construction now factors through its actual diagonal. `ReadMatrixDiagonal<M>` extracts (M₀₀,M₁₁), and `ExpandMatrixDiagonal` reconstructs diag(M₀₀,M₁₁). `DiagonalDeterminesLocalState` composes the input projection from the same operator/preparation/source record used in IiS16 and conforms to the existing `ReadingFactors`. Its independently computed local answer equals the decoder's answer. `AnswerFromAcquiredObservation` then reads the acquired diagonal fact. Changing either coherence entry leaves that fact's type unchanged. Wrong-field and wrong-memory substitutions fail the actual input/output equalities. This is a uniform coefficient relation, requiring no enumeration of coherence values. For normalized qubits one population already determines the other, whereas these generic matrix constructors also admit unnormalized inputs and retain both entries.

The acquired coefficient fact is a represented description. It is not supplied by measuring an unknown quantum system once. This distinction matters even when a channel has no equal-output collisions. Consider the qubit channel

```
Dη(ρ) = ηρ + (1−η)I/2,       0 < η < 1.
```

It is a convex mixture of identity and replacement by I/2. Its exact output density matrix determines ρ by affine inversion. Yet no binary measurement on that output reproduces the sharp input question A=(I+Z)/2 for every ρ. Writing B=b₀I+b·σ gives Dη*(B)=b₀I+ηb·σ, so the unique solution is B=(I+Z/η)/2. Its eigenvalues (1±1/η)/2 lie outside [0,1]. It is not an effect. Thus injectivity on state descriptions does not imply physically available recovery of every question from a single output system. Repeated calibrated preparations can support estimation, which is a different acquisition task.

The best uniform error in this binary probability is exactly (1−η)/2. Choosing B=A attains this bound, since the probability changes from p to ηp+(1−η)/2. For necessity, use the two Z eigenstates. Their target probabilities differ by one. Their output probabilities under any effect B differ by η(B₀₀−B₁₁), which is at most η because both diagonal entries lie in [0,1]. If both errors were at most ε, that difference would have to be at least 1−2ε. Thus ε≥(1−η)/2. This supplies an optimal approximation criterion even though exact description inversion exists.

This exposes an additional obligation when applying VI to quantum systems. A set-theoretic factorization through an exact state description requires constancy on the observation's fibers. A physical decoder must also belong to the admitted operation family. IiS18 checks that second requirement for binary measurements. Neither restriction requires an exterior observer: source, channel, apparatus and retained records can all be internal parts. The missing distinction is between an abstractly determined answer and an admissible internal operation that supplies it.

## §11. A stopping certificate for future questions

**IiS19 (finite-dimensional closure of future effects).** Fix an n-dimensional quantum carrier, a finite set Q of terminal effects and a finite vocabulary O of completely positive trace-nonincreasing maps on its matrix space. A map may describe an unconditional channel or one specified outcome branch of an instrument. Use unnormalized branch outputs, so their traces retain occurrence probabilities. All finite words over this fixed vocabulary are admitted. Define real subspaces of Hermitian matrices by

```
V₀ = span_R({I} ∪ Q)
Vₖ₊₁ = span_R(Vₖ ∪ { T*(B) : T ∈ O, B ∈ Vₖ }).
```

If d₀=dim V₀, this sequence reaches its least invariant space V∞ after at most n²−d₀ strict expansions. Two initial states give the same probabilities for every permitted finite branch history and terminal question exactly when their expectations agree on V∞. Consequently agreement on words of length at most n²−d₀ already implies agreement on all words, under the declared model.

*Proof.* The real Hermitian space has dimension n². The Vₖ are nested. If Vₖ₊₁=Vₖ, every T* preserves Vₖ, so every later space equals it. Otherwise dimension increases. This proves the bound. Induction identifies Vₖ with the span of all pullbacks of I and Q along words of length at most k. Trace duality identifies their initial expectations with the corresponding branch and terminal probabilities. Agreement on the span is equivalent to agreement on those generating probabilities. Every invariant space containing I and Q contains each Vₖ by induction, which proves leastness.

Each strict expansion also has a state-pair witness, as in VC38. Choose a generated future effect A outside Vₖ and let H=A−P_VₖA, where P_Vₖ is the orthogonal projection for the real trace inner product. Then H≠0, Tr H=0 because I∈Vₖ, and Tr(AH)=Tr(H²)>0. For sufficiently small t>0 the matrices ρ±=I/n±tH are density operators. They agree on every current question in Vₖ and disagree on A. Thus the added distinction is required on the full input-state domain. A restricted preparation family can identify these distinctions already and needs its own sufficiency analysis. QED

This is VC15's behavioral quotient in a finite-dimensional linear model, with a dimension bound replacing VC38's finite-state cardinality bound. Related finite-span stabilization is established in [Wang, Liu and Ying, *Equivalence Checking of Quantum Finite-State Machines*, §5 and Appendix A](https://www.pure.ed.ac.uk/ws/portalfiles/portal/481368382/WangEtalJCSS2021EquivalenceCheckingOfQuantum.pdf). The argument here uses backward effects to identify the questions a VI record must answer. It does not introduce a new physical law or claim a new automata minimization theorem.

The stopping certificate is finite in matrix coordinates. Supply a basis B₁,…,B_d of V∞, its expansion into actual future effects, expansions of I and Q in that basis, and identities

```
T*(Bⱼ) = Σᵢ c[T,j,i] Bᵢ       for every T and j.
```

The future-effect expansions justify the retained distinctions. The last identities establish closure, and imply the update x′ⱼ=Σᵢc[T,j,i]xᵢ for xᵢ=Tr(Bᵢρ). Induction then covers every finite continuation. A fixed basis need not identify all entries of ρ. These are source-bound matrix identities to prove, not supplied names of invariance. The existing `CommutingTransition` and `JoinedTransition` express the same composition obligation. IiS18's diagonal factorization supplies one current-state reduction. A generic Swift certificate for these arbitrary linear expansions has not been constructed.

Keeping the instrument branches matters. Summing their maps gives the unconditional channel and can discard precisely the outcome record needed by a later policy. Including each branch makes its complete-history probability a pullback of I. Every finite adaptive policy assembled from the admitted instruments then has leaf probabilities among these words. Conditional predictions follow by division only for histories of nonzero probability. This covers outcome-dependent choices without treating a normalized conditional update as linear. The carrier must include whatever retained state makes the declared step maps valid. An operation that later couples to an omitted internal record can enlarge the required carrier or vocabulary.

**An exact zero profile still omits preparation weights.** For a density operator ρ and a positive effect E,

```
Tr(Eρ)=0  iff  E annihilates supp(ρ).
```

Indeed Tr(Eρ)=||E^(1/2)ρ^(1/2)||²_HS. Thus two states have the same zero/nonzero answers for every effect exactly when their supports agree. If the supports differ, a projector onto a vector in one kernel but not the other separates these answers. For the restricted vocabulary above, the zero profiles can agree even when the supports differ.

A rank-one support fixes the normalized state. In particular, for a specified pure projector P, the exact relation Tr[(I−P)ρ]=0 forces ρ=P by the same criterion. Thus an impossibility can determine all the weights once the state space and effect geometry are retained. An outcome missing in one trial does not establish this zero relation. The effect I−P and its applicable comparison context also belong to the premise.

This equivalence survives every common finite instrument protocol. Each leaf already gives one positive input effect. Equivalently, for T(ρ)=ΣₐKₐρKₐ†,

```
supp T(ρ) = spanₐ Kₐ supp(ρ).
```

The support depends only on the input support, and the formula composes through successive branches. An independent ready apparatus adds the same support factor to both inputs. Any fixed finite number of product copies also preserves equality of supports, even under a collective measurement. Correlated repeated preparations or an additional source-related reference are different inputs and need their actual joint supports. M32's equal local marginals do not establish the required equality for those joints.

In particular, distinct full-rank states admit no nonzero conclusive effect that is error-free between them. More generally, on a shared finite-dimensional support there are constants 0<c≤C<∞ with cσ≤ρ≤Cσ. Every leaf probability then satisfies c p_σ≤p_ρ≤C p_σ. For k product copies the constants can be replaced by c^k,C^k. No positive-probability finite leaf of one preparation has zero probability for the other. This extends IiS12's noisy-comparison boundary to the whole finite continuation family.

Different probabilities remain detectable statistically. For ρ=diag(3/4,1/4) and σ=I/2, the first basis outcome has probabilities 3/4 and 1/2, although all nonzero effects have positive weight on both inputs. The zero-profile quotient is sufficient for that narrower question family and insufficient for probability questions. In these paragraphs, zero/nonzero means the model's assigned weight. It does not turn absence in a finite sample into a zero, or identify every probability-zero event of an infinite sample space with a logically absent event. PP22 separately states the preparation and capacity needed for repeated sampling.

VI can retain the missing weights or relations that determine them in its source-bound claims. They need not be stored as outcomes of a runtime calculation. But a claim to learn the complete preparation from only this zero profile has discarded distinctions before saturation begins. The obstruction is relative to the stated carrier and contacts. It neither identifies the full whole with a mixed local state nor forbids an additional internal contact from exposing an omitted relation.

The bound counts independent question directions and word depth. It counts neither distinguishable states nor experiments needed to estimate their probabilities. The exact coefficient and acquisition requirements of IiS17–IiS18 still apply. Its practical use is to stop symbolic saturation once every generator carries the retained question space into itself, with a distinguishing continuation for every earlier expansion. For a supplied model, unbounded future depth can therefore have a finite proof obligation.

**Reversible dynamics on a closed question space.** If an admitted step is T(ρ)=UρU† with unitary U, its adjoint preserves the trace inner product. On a finite-dimensional invariant V∞ its restriction is injective, hence onto, and therefore orthogonal. Choose an orthonormal basis of V∞. The statistics vector x then updates by an orthogonal matrix C: x′=Cx, with inverse x=Cᵀx′. Two input statistics vectors cannot merge under this step, and their Euclidean distance is preserved. This remains true when V∞ is smaller than the full Hermitian space and the set of possible states is infinite.

The inverse here is an update of the exact description. It does not add a physically available inverse control to O. Nor does the statistics vector generally form a probability distribution or density operator to which an entropy can be assigned without another definition. The consequence for M32 is narrower and exact: a reading closed under these unitary continuations cannot lose its own distinctions. A current reading that later exposes an omitted distinction has not met that closure condition. Local entropy changes concern the chosen local state and its correlations, rather than contradicting this result about the sufficient question space.

**Physical encoding can require a finer distinction.** Consider a qubit with terminal effects (I+X)/2 and (I+Z)/2, and unitary continuations given by conjugation with X and Z. IiS19 stops at V∞=span_R(I,X,Z): conjugation changes only the signs of X and Z. The exact statistics (x,z) suffice for every declared future question. States (I+Y)/2 and (I−Y)/2 agree on that entire family.

Suppose a single CPTP encoding E into a finite-dimensional memory, applied before the question is chosen, permits either sharp input measurement to be reproduced exactly for every input. Permit different output effects B_X and B_Z and no additional input-dependent record. IiS18 gives E*(B_X)=(I+X)/2 and E*(B_Z)=(I+Z)/2. This already forces an output effect that reproduces the Y measurement. Thus the physical encoding cannot identify the two Y states, although the sufficient description does.

The proof reuses IiS11's positive-sum reasoning. Write E(ρ)=ΣₐKₐρKₐ† and put D_X=2B_X−I, a Hermitian contraction with E*(D_X)=X. Then

```
Σₐ (D_X Kₐ − Kₐ X)†(D_X Kₐ − Kₐ X)
    = E*(D_X²) − I ≤ 0.
```

The left side is positive semidefinite, so each summand vanishes: D_XKₐ=KₐX. Likewise D_ZKₐ=KₐZ. Define

```
D_Y = (D_Z D_X − D_X D_Z)/(2i).
```

This is Hermitian with norm at most one, and D_YKₐ=KₐY because Y=(ZX−XZ)/(2i). Summing Kₐ†D_YKₐ gives E*(D_Y)=Y. Hence B_Y=(I+D_Y)/2 is the required effect. In a purely classical memory the two output functions D_X and D_Z commute, which would make D_Y=0. Such a memory cannot satisfy both sharp recovery requirements from one unknown input specimen. The two measurements are alternative later choices, not simultaneous measurements asserted to have sharp joint outcomes.

For an encoding and a common CPTP decoder back to the qubit, a shorter route is already available: preserving the sharp X and Z probabilities fixes the pure outputs |+⟩ and |0⟩, since each has probability one under a rank-one effect. IiS11 then forces the composed channel to be identity. The calculation above removes the common-decoder premise and constructs the additional recoverable question directly. It is a case of the established operator-algebra account of recoverable observables developed by [Bény, Kempf and Kribs](https://arxiv.org/pdf/0705.1574).

This locates a precise constraint on compression. A quotient of known state descriptions may omit y when the requested statistics depend only on x and z. A physical encoding that retains exact sharp access to both questions must retain distinctions sufficient for y as well. The obligation comes from the relations among admissible effects and the same encoding, without enlarging the requested continuation family. Exact preservation, the full input-state domain and the single encoding are essential here. Approximate or restricted preparation tasks require their own bounds. No arbitrary operator-algebra proof is claimed from the current Swift coordinate constructors.

## §12. When no internal remainder can complete the proposed change

M70 completes every finite local deterministic table when the source's label identity is what must be recovered and the internal remainder can be supplied freely. A specified medium can constrain more than those identities. Here the already declared complex inner-product and tensor model supplies that constraint. No probability distribution over preparations, external reader or finite bound on the remainder enters the following question.

Let ψ₁,…,ψₙ be normalized vectors describing a fixed family of complete prepared inputs to an isometry. They may already include the preparer and its resident record. Let φ₁,…,φₙ be the proposed normalized pure local outputs. Write Aᵢⱼ=⟨ψᵢ,ψⱼ⟩ and Bᵢⱼ=⟨φᵢ,φⱼ⟩. The indices connect each specified preparation to its requested output. They are not an extra readable label supplied to the transformation.

**IiS20 (a complete residual relation decides pure-output completion).** An isometry on the prepared span with outputs φᵢ⊗eᵢ exists exactly when

    A = B ⊙ C,       C ≥ 0,       Cᵢᵢ = 1,

where ⊙ multiplies corresponding entries. This is the established pure-state transformation criterion of [Chefles, Jozsa and Winter, Theorem 2](https://arxiv.org/pdf/quant-ph/0307227), stated here with the remainder inside the whole.

*Proof.* An isometry preserves inner products, so Cᵢⱼ=⟨eᵢ,eⱼ⟩ supplies necessity. Conversely, factor C=E†E and take its unit columns eᵢ. Define V(Σᵢaᵢψᵢ)=Σᵢaᵢφᵢ⊗eᵢ. The Gram equation makes both squared norms equal. Consequently every zero input combination has zero output, V is well-defined even for dependent preparations, and V preserves the inner product. This constructs the required isometry on their span. QED

For an operation on a larger declared input space, extend that isometry on its orthogonal complement with enough output room. A common initially uncorrelated apparatus gives the usual channel interpretation. If an additional input-dependent record is allowed instead, its relations belong in A. Replacing A by the local Gram matrix while omitting that record would change the question. Likewise, an isometry in this model is not derived from the statement that nothing is outside the whole.

The unknown C is **one** matrix for all preparations, already allowing an arbitrary environment. For n preparations its rank is at most n, so infinite dimension adds no extra residual Gram matrices. When completion exists, the least residual dimension on this prepared family is the minimum rank of an admissible C. Necessity follows from the span of its vectors. Its factorization attains that rank. This does not count the room needed to extend the process outside the prepared span or to reuse its apparatus.

Three boundaries follow directly:

- If Bᵢⱼ=0, then Aᵢⱼ must be zero. Where Bᵢⱼ≠0 the residual entry is fixed as Aᵢⱼ/Bᵢⱼ. Pairwise bounds |Aᵢⱼ|≤|Bᵢⱼ| are necessary, but their separately valid two-vector residuals need not fit into one positive C.
- For orthogonal input labels, A=I and C=I completes any proposed pure outputs. If the outputs are the orthogonal labels f(i), residual vectors must be orthogonal within each fiber of f. They can reuse the same orthonormal list in different fibers. Thus the least dimension is max_y |f⁻¹(y)|, recovering M35's one-use classical capacity inside this model.
- For a constant pure local output, choose the same φ at every index. Then B is the all-one matrix and C=A. The remainder must retain the input preparation geometry itself. Nonorthogonal inputs cannot be replaced there by mutually orthogonal name records. The reset is possible, but its retained information is not thereby a perfectly distinguishable classical label.

Thus a missing residue can sometimes be supplied, sometimes needs a particular relational form, and sometimes cannot exist at any size. Source recovery alone cannot decide which case applies.

## §13. A whole obstruction invisible in every proper preparation family

**IiS21 (equal overlap magnitudes leave a cycle obstruction).** Suppose |Aᵢⱼ|=|Bᵢⱼ| for all i,j. Form the graph of their common nonzero off-diagonal entries and orient each edge when using hᵢⱼ=Aᵢⱼ/Bᵢⱼ. Then completion in IiS20 exists exactly when the product of h around every directed cycle is one. Reversing an edge conjugates h. These cycle products are the projective invariants studied by [Chien and Waldron](https://arxiv.org/pdf/1312.5393).

*Proof.* On an edge, the unit residual vectors satisfy |⟨eᵢ,eⱼ⟩|=1, hence eⱼ=hᵢⱼeᵢ. Following a cycle forces its product to be one. Conversely, choose a root and propagate unit scalars along a spanning tree in each component. The cycle equations make every remaining edge agree. Those scalars, used as one-dimensional residual vectors, give C and the Gram equation. QED

This criterion needs only one cycle check for each edge outside a spanning forest. In a graph with m edges, n vertices and c components, that gives m−n+c checks. It covers the fixed supplied graph. Acquiring its relevant overlaps is a separate task. The root phase is arbitrary and cancels from each check. Different connected components can have different environment records, as in IiS12. Within a connected component all residual vectors lie on one ray, so the environment cannot repair a failed cycle by storing which preparation occurred.

The modulus-equality premise carries this rigidity. If the output overlaps become larger, residual overlaps can have modulus below one and the full positive-matrix condition must replace the cycle test. A zero overlap also removes an edge, rather than supplying a phase through division by zero. These are different regimes of the specified relation, not universal phases inferred from a name or from entropy.

**There is no fixed bound on the size of the obstructing family.** For every n≥3 construct two normalized pure families as follows. Take a simple n-cycle. Give each vertex two private orthonormal coordinates and each edge one more coordinate, all in one common 3n-dimensional space. Initially put amplitude 1/2 at a vertex's two private coordinates and its two incident edge coordinates, and zero elsewhere. At one endpoint on one chosen edge, replace that amplitude by i/2 for the input family ψᵢ and by −i/2 for the target family φᵢ. All other entries remain real. Thus φᵢ=ψᵢ* in this common basis.

Each vector has norm one. Adjacent overlaps are 1/4 except for i/4 and −i/4 respectively on the changed oriented edge. Reversing the orientation conjugates them. Nonadjacent overlaps vanish. Their ratio is −1 on just the changed edge. The construction supplies the Gram factorizations directly. Equivalently, for the unit edge coefficients σₑ, with the orientation fixed by the displayed factor,

    4 z†Gσ z = 2 Σᵢ |zᵢ|² + Σ_{e={i,j}} |zᵢ + σₑ zⱼ|² ≥ 2 Σᵢ |zᵢ|².

Both Gram matrices are strictly positive. The families consist of independent vectors, so the failure cannot be blamed on an inconsistent description or a hidden linear dependence. Their pairwise transition probabilities are identical.

**Even every mixture entropy agrees.** For every probability vector p over these matched preparations, their mean states satisfy

    Σᵢ pᵢ |φᵢ⟩⟨φᵢ| = (Σᵢ pᵢ |ψᵢ⟩⟨ψᵢ|)*.

They have the same eigenvalues: conjugating an eigenvector of a Hermitian matrix retains its real eigenvalue. Hence all spectral moments and von Neumann entropies agree, for every such p, including mixtures supported on proper subsets. This is stronger than equality of entropy for one preparation law. Nevertheless the cycle obstruction below excludes transformation in either direction. Entropy, even as this entire function of the mixture weights, omits the oriented relation that the common transformation must preserve. Coordinatewise conjugation is an anti-linear correspondence between the two families. The required completion is complex-linear. IiS14 already locates this distinction at a joint input. This construction locates it in a whole preparation family whose smaller fragments all admit unitary transformations.

Their complete cycle has ratio product −1. IiS21 therefore excludes a common isometric completion and, for the common-apparatus interpretation, every CPTP map realizing all requested outputs. This includes maps with arbitrarily large internal environments. Yet every proper subset of vertices induces a forest. Propagating signs on that forest makes the two restricted Grams equal, so each such subfamily has a unitary realization on the common ambient space. Its unitary may differ from the one for another subfamily. The claim is

    for every proper J, some U_J realizes the requests in J,
    no single channel realizes all requests together.

This is a constructive obstruction at arbitrary arity, not a proposal to infer inconsistency from an incomplete search. For n=3 the residual matrix is already fixed completely. Choosing the negative edge {1,3} gives

    C = [[1, 1, −1], [1, 1, 1], [−1, 1, 1]],
    (1,−1,1) C (1,−1,1)ᵀ = −3.

Every two-index principal matrix is a valid unit-vector Gram matrix. The negative three-index weight rules out their common realization. The n-cycle construction shows why replacing pair checks by an arbitrary fixed larger fragment size still does not solve the general task. A fixed dimension or a complete context-generating certificate can supply a different bound. In particular this does not contradict IiS17: a Choi certificate is one common map with all its linked blocks, whereas the subfamily tests here are allowed different maps.

**An already prepared internal relation can change the answer.** The exclusion permits arbitrary output memory and a common ready apparatus. It does not permit silently changing the input preparation. If the actual inputs also contain unit records rᵢ with Gram matrix D, the completion equation becomes

    A ⊙ D = B ⊙ C.

For an orthogonal prepared label, D=I and C=I always works. In that setting a common operation can use the resident label to realize the requested family. The label has not been learned from an unknown nonorthogonal input. It is additional information already present at the operation's input. All of it can remain within the same closed whole.

For the n-cycle above the least span dimension of an additional pure input-record family is exactly **two**, with other commonly prepared apparatus space still unrestricted. A one-dimensional record only supplies individual phases. Its cycle ratio telescopes to one and cannot cancel the negative ratio of A/B.

One attaining record distinguishes just the vertex whose amplitude was changed from all the others: use two orthogonal record vectors for those two classes. Its Gram D vanishes between the classes. A and B differ only on the changed edge, whose endpoints are now in different classes, so A⊙D=B⊙D. Taking C=D realizes the transformation while retaining that same binary record. It needs neither a separate label for every preparation nor a fresh record on output. With uniform preparation weights, this record's entropy is h₂(1/n), which tends to zero while its carrier still has two orthogonal record forms.

Two dimensions also suffice with a family of nonorthogonal records. Set c=cos(π/n) and prepare

    rᵢ = (cos((i−1)π/n), sin((i−1)π/n)),
    C = (1−c)I + c J,

where J is the all-one matrix. The record overlaps are c on the successive edges and −c on the closing edge. The required residual C has value c on every off-diagonal entry and is positive, since 0<c<1. On each cycle edge, multiplying D by the ratio A/B gives exactly C. On all other off-diagonal entries both A and B vanish. Diagonal entries equal one. This proves the completion equation everywhere, and IiS20 constructs its isometry. The input records span two dimensions and need not perfectly identify any of the n labels.

Those records cannot be appended while leaving the original preparations unchanged by a common channel acting on those preparations alone. IiS12 forces any such undisturbing record to be the same ray throughout this connected overlap graph. Alternatively, appending them and then applying the constructed completion would give the already excluded original transformation. The preparation relation is therefore required. Enlarging a common blank carrier does not supply it. An actual whole may contain a usable earlier record. Whether the operation has that contact changes the task, rather than violating the whole's closure.

**The original preparation has a finite error gap.** Put r=1/4. Permit any positive C with diagonal one, and measure the largest mismatch |Aᵢⱼ−BᵢⱼCᵢⱼ| on the cycle edges. Its exact minimum is

    δₙ = r (1 − cos(π/n)).

To prove the lower bound, choose unit vectors for C and place the unique negative ratio edge last by relabeling. The successive desired residual contacts run from e₁ through e₂,…,eₙ to −e₁. In the real inner-product space with inner product Re⟨·,·⟩, their spherical angles sum to at least π. Thus some edge has angle at least π/n and real overlap at most cos(π/n). Its complex entry differs from the required sign by at least 1−cos(π/n). The angle inequality follows directly by decomposing two unit vectors into components along a third: if the two intervening angles sum to at most π, Cauchy–Schwarz bounds the endpoint inner product below by the cosine of that sum. Larger sums give the trivial π bound.

For attainment, use real two-dimensional residual vectors eᵢ=(cos((i−1)π/n), sin((i−1)π/n)). Their adjacent overlaps are cos(π/n), and the closing overlap is its negative. Every cycle-edge mismatch is exactly δₙ. Nonedge mismatches vanish because both prepared Grams have zero there. This proves the bound without a numerical optimization or a dimension limit on the residual.

There is also a nonzero operational error floor under the same channel model. If every requested pure output has survival probability at least 1−ε, an isometric dilation supplies unit eᵢ with ||Vψᵢ−φᵢ⊗eᵢ||≤√(2ε): project onto φᵢ, normalize that component and use 2(1−√(1−ε))≤2ε. For ε=1 the resulting bound is trivial. Each overlap mismatch is at most 2√(2ε), by expanding the difference of the two inner products between unit vectors. Therefore

    ε ≥ δₙ² / 8.

This last bound is a sufficient impossibility margin, not the optimal channel infidelity. For a fixed n it rules out arbitrarily accurate simultaneous realization. It decreases with n, so it supplies no size-independent experimental tolerance. Exact preparation relations, or controlled errors in their acquisition, remain essential. The preceding δₙ is sharp for Gram mismatch. These two error questions must not be conflated.

The consequence for VI is a change in what saturation must bind. A collection of individually certified applications can leave the common realization impossible. The retained object must include how their source, residual and context coordinates are shared. Storing local certificates with independently chosen witnesses does not give a whole certificate. Conversely, the spanning-forest construction shows how a finite common witness can settle an entire family without enumerating all cycles. The added information is a relation among the certificates, with its coverage established for the declared graph.

**A direct question can address the whole relation.** For the normalized pure projectors ρᵢ, the cyclic quantity

    Tr(ρ₁ρ₂⋯ρₙ) = ⟨ψ₁,ψ₂⟩⟨ψ₂,ψ₃⟩⋯⟨ψₙ,ψ₁⟩

is unchanged by independently rephasing the representative vectors. Orienting the cycle toward the +i overlap gives +i4⁻ⁿ and −i4⁻ⁿ in the constructed pair of families, although every two-state overlap probability and every matched mixture entropy agrees. It is not an absolute phase to be read by an outside reference. A joint permutation test can address its imaginary part: prepare the n stated inputs, coherently control a cyclic permutation with an internal two-state register, and read that register's Y coordinate. For the convention giving the displayed trace, the positive probability is (1+Im Tr(ρ₁⋯ρₙ))/2. Reversing the permutation conjugates the trace, so its orientation and the register's calibration are part of the specified procedure. Expanding the two control branches proves this relation. The construction is the [cycle-test procedure of Oszmaniec, Brod and Galvão](https://arxiv.org/pdf/2109.10006).

It requires the joint preparation and controlled permutation to be available in that model. For n=3 the probabilities are 65/128 and 63/128. Their separation shrinks as 4⁻ⁿ, so this particular test becomes difficult at large n even though the exact obstruction persists. These are predictions of the declared procedure, not reported experimental data or an inference from one observed outcome.

**Conjugating the whole description is a different comparison.** If every state, operation and instrument is conjugated together, all their probability predictions are unchanged. For example Tr(E*ρ*)=Tr(Eρ) for a state ρ and an effect E, because that probability is real. The internal Y instrument is also conjugated, so it reverses along with the cycle quantity. IiS21 compares preparation families under one fixed interaction contract. It excludes a transition of those sources with that contract retained, and supplies no absolute orientation of the whole. The relevant phase is relative to other internal forms. If the permitted contacts omit every phase-sensitive question, their restricted description may identify the families. That quotient cannot then certify the stronger common transformation. This is the same obligation to transport the context as in IiS10 and VC15, now applied to the whole conjugation attack.

**The static realization keeps the sharing that the obstruction uses.** `ResidentTransportContact<A,B,T>` takes two actual field accessors with the same source and a transport application whose input is A's answer and whose computed output is B's answer. Its certificate retains both accessors and T. Existing `JointEvidence` joins such certificates only when their whole source agrees. Here that common source describes one assignment of residual frames to the different preparation indices. Finite nesting therefore builds a common family without a new phase, positivity or realizability marker. The accessors are structural projections here, not primitive observers.

`ThreePhaseContactsForceCollapse<W>` derives equality of the first frame's two sides from the three signed contact equations at the same resident addresses. The desired side equality is its conclusion. `Checks/RelationalReturn.swift` supplies identity and exchange contacts from one resident triple of oriented frames. Each tree obtained by deleting a cycle edge has a concrete common assignment. Two reversals instead give a full common assignment for every frame. Expected refusals cover the closing negative contact on a noncollapsed frame, merging certificates with different source assignments, and using a transport that starts at the wrong resident field. The original relational-return checks already protect the noncollapsed zero/successor frame.

This two-orientation representation applies to the exact signed constraint: IiS21 first derives eⱼ=±eᵢ, so a connected component can only use the two orientations of one nonzero residual vector. A diagonal formal frame is also statically admitted, but represents zero and cannot satisfy that vector's unit normalization. The Swift proof covers the actual field equalities, their common source and this finite certificate grammar. The Gram criterion, arbitrary-n construction, dimension independence and quantitative bounds have their mathematical proofs above. They are not inferred from one compiler run or an arbitrary open interface conformance.

**Eliminating a station phase need not survive averaging.** This is a
measurement-level application of the cycle relation, with a different
question from the Gram completion above. At a resolved observation index
k let the three oriented correlations have the specified scalar form

    Yᵢⱼ(k)=gᵢ(k) conjugate(gⱼ(k)) Vᵢⱼ.

The three nonzero source correlations V are fixed over the chosen block;
the station gains are nonzero and may change arbitrarily. There is no
additive noise in this exact statement. Multiplying the three readings
from the same index gives

    B(k)=Y₁₂(k)Y₂₃(k)Y₃₁(k)=|g₁(k)g₂(k)g₃(k)|² B_source.

Consequently any nonnegative weighted average of these products with
nonzero total weight has the phase of B_source. No station phase or
absolute temporal origin has to be determined. Shared endpoint gains
do have to refer to the same values in the three occurrences. Literal
simultaneity is one sufficient implementation of that relation; known
stability or transported endpoint readings can also establish it.

Forming a product after averaging the three baselines is a different
operation. For a fixed unit point-source correlation and three equal
observation weights, take the station-gain rows

    (1,1,1),  (1,i,1),  (1,i,i).

The corresponding baseline rows (12,23,31) are

    (1,1,1),  (−i,i,1),  (−i,1,i).

Every row product is 1. Their column means are
(1−2i)/3, (2+i)/3, (2+i)/3. The product of these means is
(11−2i)/27, with a nonzero phase. In particular,
(2+i)²=3+4i and (1−2i)(3+4i)=11−2i verify the discrepancy directly.
All gains have unit modulus, every row obeys the common-station law,
and the averaging weights and times are shared. No thermal fluctuation,
changing source, or independent baseline defect is needed.

**Exact normalized cycle preservation restricts the joining kernel.**
For N resolved readings, fix weights λ_rst≥0, Σ_rst λ_rst=1 independently
of the unknown phases, and consider a
weighted join of normalized baseline phases at indices r,s,t. Assume
each station phase at each index can vary independently, while the
source phases remain fixed. Its output equals the unit source cycle
for every such variation if and only if λ is supported on r=s=t.

To prove this, divide by the unit source cycle. A summand becomes

    χ_rst=g₁(r) conjugate(g₁(t))
          g₂(s) conjugate(g₂(r)) g₃(t) conjugate(g₃(s)),

with unit gains. It is identically 1 precisely when all three indices
agree. If a positive-weight term is not of this form, choose a phase
appearing with a nonzero exponent so that this χ differs from 1.
Every term has real part at most 1, so the weighted real part is strictly
less than 1. Thus the claimed exact unit reply fails. The diagonal
kernel attains it by cancellation. This establishes necessity for the
exact complex unit answer, not a classification of kernels preserving
only its argument. If some gain occurrences are already constrained
equal, the allowed support broadens to the triples whose endpoint
occurrences balance within those established classes. Requiring a
shared external clock would be stronger than that relation.

Separate baseline averages use λ_rst=a_r b_s c_t. If each factor is a
nonnegative distribution, exact preservation throughout the free-phase
family therefore requires all three supports to be the same singleton.
The diagonal average instead admits any number of joined observations.
The difference is which acquisitions are joined, not how many samples
are taken.

**A valid averaged correlation matrix does not recover this provenance.**
Let v₁=(1,1,1), v₂=(1,i,1), v₃=(1,i,i), and form
K=(v₁v₁†+v₂v₂†+v₃v₃†)/3. The variable-gain point source above has exactly
this averaged matrix, including its unit diagonal and all reverse
baselines. A second realization has ideal fixed instruments and three
mutually incoherent source modes with these station responses and equal
intensities. Its source correlation is K itself. Positivity follows
directly from the displayed factors, so a covariance-consistency check
does not distinguish the realizations. Their source closure phases
differ, although their entire averaged correlation record agrees.

The second realization need not be an arbitrary matrix called a sky.
Within the monochromatic scalar plane-wave model, take three stations
at (0,0,0), (L,0,0), (0,L,0). The wavevectors with transverse components
(0,0), (π/(2L),0), (π/(2L),π/(2L)) give precisely the three displayed
response vectors. Choose their common magnitude κ>π/(√2 L), and use
the positive longitudinal component completing that magnitude. Three
mutually incoherent equal-intensity waves then give K. This is an ideal
model construction, not a claim about M87's sky or its calibrated data.

Thus the source-phase question does not factor through the averaged
matrix on this combined source-and-instrument family. Keeping the
resolved joint products separates the two realizations. Recovering all
individual gains remains unnecessary. The phase lost here is an
acquisition relation; no inconsistency of the containing whole is needed.

This is a known practical boundary, not a discovered failure of EHT.
[EHT Paper III](https://arxiv.org/pdf/1906.11240), §7.2 and §8.3–8.5,
defines closure phase, tests coherence after calibration, and explicitly
discusses bias after averaging station-corrected segments. Its Fig. 23
compares measured closure phases across processing pipelines. The
counterexample and joining-kernel proof here are exact ideal examples,
not a reanalysis of those observations. Additive noise, source variation,
and the finite integration used to obtain each Y require their own
measurement model; the identity does not provide exact raw-data immunity.

**The phase question admits more than exact complex preservation.**
Normalize each nonzero baseline reading to unit modulus and retain the
same fixed source phases as above. Choose two resolved acquisitions r,t.
The joined triple at r equals the unit source cycle q. The mixed triples
with indices (r,r,t) and (t,t,r) equal qχ and qχ⁻¹ respectively, where

    χ=g₁(r) conjugate(g₁(t)) g₃(t) conjugate(g₃(r)).

Here gains also denote their unit normalizations. The station-2 phases
cancel within each mixed triple, and the other factors reverse in the
second. The inverse relation is derived from the acquired endpoint
factors, not inferred from similar final answers. With fixed 0≤d≤1, form

    Z=d q+(1−d)(qχ+qχ⁻¹)/2=q[d+(1−d)Re χ].

This construction preserves the phase of q with a nonzero output for
every free unit χ **if and only if d>1/2**. Indeed the real bracket lies
between 2d−1 and 1, and χ=−1 attains the lower endpoint. At d=1/2 the
output can vanish; below it can have the opposite phase. Thus the
diagonal-kernel condition for the full complex unit reply was too strong
for this narrower question. This is an exact result within the specified
mixed-pair family, not a classification of all phase-preserving kernels.
The coefficients express relative weights in this construction, not a
new physical constant.

**Two acquisitions admit a better sharp threshold.** Consider all eight
triples of indices from {r,t}, with fixed nonnegative weights summing to
one. Let d be the total weight on (r,r,r) and (t,t,t). There exists a
choice of the other weights giving a nonzero answer with the source
phase for every independently free station phase **if and only if
d>1/3**. This concerns normalized readings and a phase-only output;
the earlier d>1/2 threshold was for just one inverse mixed pair.

For attainment give each of the six mixed triples weight (1−d)/6.
Set ηᵢ=gᵢ(r)conjugate(gᵢ(t)). Their six nuisance factors are precisely
ηᵢ conjugate(ηⱼ), i≠j. Thus the output is

    q[(3d−1)/2+(1−d)|η₁+η₂+η₃|²/6].

Its real scale is at least (3d−1)/2, which is positive in the stated
range. For necessity set (η₁,η₂,η₃)=(1,ω,ω²), where |ω|=1,
ω≠1 and 1+ω+ω²=0. Every mixed factor then has real part −1/2.
For any distribution of the six weights, the real part after division
by q is (3d−1)/2. At or below zero it cannot be a positive real number.
No prior symmetry of the proposed weights is required for this refusal.

In particular, a product of two-epoch equal-weight baseline means has
d=1/4 and can reverse the phase. Mixing that product with a genuinely
joined normalized triple, with weight a on the latter, changes
d to (1+3a)/4. The six mixed weights are already equal. The resulting
phase is universally preserved, with a nonzero output, exactly when
a>1/9; its minimum scale is (9a−1)/8. This repairs the specified output
map. It is not an acquisition-cost advantage over using the joined
triple directly, nor a noise-optimal estimator or an assertion that
one ninth of the information suffices.

For the specified product-of-means pipeline this repair has a general
cycle formula. On n≥3 stations, keep two normalized acquisitions and
one fixed unit source cycle q. Put ηᵢ=gᵢ(r)conjugate(gᵢ(t)), with cyclic
indices. After factoring the joined cycle at t, the product of the
baseline means divided by q is

    Pₙ=2⁻ⁿ ∏ᵢ(1+ηᵢ conjugate(ηᵢ₊₁)).

It is real: conjugating every factor divides their product by
∏ᵢηᵢ conjugate(ηᵢ₊₁)=1. Its exact minimum is −cosⁿ(π/n).
If a factor vanishes this bound is immediate. Otherwise write each
ηᵢ conjugate(ηᵢ₊₁)=e^{iδᵢ} with −π<δᵢ<π. Their sum is 2πm and
Pₙ=(−1)ᵐ∏ᵢcos(δᵢ/2). A negative value requires odd m, so |m|≥1.
Concavity of log cos on (−π/2,π/2) bounds the positive product by
cosⁿ(mπ/n)≤cosⁿ(π/n). Equality is attained by making all phase
ratios equal to e^{2πi/n}, which is compatible with their cyclic
product being 1. Thus mixing this output with a joined normalized
cycle, with weight a, preserves its phase and a nonzero answer
uniformly exactly when

    a > cosⁿ(π/n)/(1+cosⁿ(π/n)).

At equality the attaining gains cancel the output; below it they
reverse it. For n=3 this is a>1/9. This is a sharp bound for this
particular pipeline and one added joined term. It does not optimize
all kernels on larger cycles or introduce a geometry-independent
physical threshold. The phase-circle model and its composition are
the stipulated contact relations, as in the preceding cycle proofs.

The earlier one-inverse-pair construction has the positivity identity:

    d+(1−d)Re χ=(2d−1)+(1−d)|1+χ|²/2.

It follows by expanding the square and using |χ|=1. At d=3/4 the scale
is 1/2+|1+χ|²/8, strictly positive without determining χ. Merely pairing
two arbitrary unit numbers instead would not supply this real scale;
their inverse relation carries the result. Normalizing a zero or noisy
baseline requires a separate admission and error analysis.

**A positive margin supports a bounded-error answer.** Let the constructed
reply be Z=qA with A≥a₀>0; for example, a₀=2d−1 in the one-pair family
or a₀=(3d−1)/2 in the equal-six family. If a final acquired value is
Z+e with |e|≤ε<a₀, it is nonzero
and its phase differs from q by at most arcsin(ε/a₀). Rotate by q⁻¹:
the true point is a real A≥a₀, and the radius-ε disk about it lies
inside that angular cone. The tangent gives sin(error)≤ε/A. At ε=a₀,
the attaining minimum-scale phases permit exact cancellation. Above it,
reversal is possible.
This error budget concerns the final complex reading. Deriving it from
thermal noise or separately normalized measurements is another task;
no independent-noise hypothesis was used to obtain the bound.

**Joint coherence constrains the phase without locating its cause.**
Let C=Σ_k w_k z(k)z(k)† for finite w_k≥0 and three-component complex
records z(k). The weights and record index are common to all entries.
For every vector u, u†Cu=Σ_k w_k|z(k)†u|²≥0. Write Dᵢ=Cᵢᵢ. The
three-by-three determinant condition is therefore

    D₁D₂D₃+2 Re(C₁₂C₂₃C₃₁)
      ≥ D₁|C₂₃|²+D₂|C₃₁|²+D₃|C₁₂|².

This form uses no absolute amplitude scale. Multiplying each station
record by a fixed nonzero complex calibration multiplies both sides
by the same positive |g₁g₂g₃|². For Dᵢ>0 normalize
Kᵢⱼ=Cᵢⱼ/√(DᵢDⱼ). If all three off-diagonal moduli rᵢⱼ are nonzero,
the closure phase ψ obeys

    cos ψ ≥ (r₁₂²+r₂₃²+r₃₁²−1)/(2r₁₂r₂₃r₃₁).

The underlying obligation is the preceding polynomial inequality;
the angle is one way of reading it. If all r equal 1, it forces the
cycle to close. A weak right-hand side may give no useful angular
restriction. At a zero correlation the cycle phase is undefined.

One can prove the same restriction without introducing an angle or
diagonalizing a matrix. Remove the component of each station vector
along the first. Cauchy–Schwarz for the two residuals gives

    |K₂₃−K₂₁K₁₃|² ≤ (1−|K₁₂|²)(1−|K₁₃|²).

Thus near-perfect relations to one internal reference constrain the
remaining relation. The reference is part of the same acquired object.
Common positive weighting suffices; stationarity, a uniform sampling
law, and an external clock are unnecessary for this finite identity.
This does not derive the complex linear field model from bare distinction.

Both source-and-instrument realizations above satisfy this bound, so it
does not identify the cause of an observed phase. Nor may correlations
obtained using unrelated integration weights or subtractive noise
estimates be treated as this particular Gram construction without
establishing the required joint relation.

The averaging bias need not require large phase jumps. Replace i in
the three gain rows by z=e^{iθ}. The product of the three baseline means
is [12+6z+z²+8z⁻¹]/27, with imaginary part
−2 sin θ(1−cos θ)/27. It is nonzero for arbitrarily small nonzero θ.
This identity locates a finite-precision issue; it does not make a bias
below an instrument's actual error distinguishable in data.
**The same two-dimensional family appears on both sides.** The
cos(π/n) above and in the earlier residual-record construction are
linked by an explicit map. Use the convention ⟨x,y⟩=x†y. For two
equal-weight acquisitions choose the second station gains to be 1
and the first gains ηᵢ=e^{2iθᵢ}. Their averaged correlation matrix is

    Kᵢⱼ=(1+ηᵢ conjugate(ηⱼ))/2=⟨fᵢ,fⱼ⟩,
    fᵢ=(e^{−2iθᵢ},1)/√2.

Rephase each fᵢ by e^{iθᵢ} and apply the same unitary matrix

    R = (1/√2) [[1,1],[i,−i]].

Direct multiplication gives R(e^{iθᵢ}fᵢ)=(cos θᵢ,sin θᵢ).
The rows of R are orthonormal. The resulting Gram entry is
e^{−iθᵢ}e^{iθⱼ}Kᵢⱼ=cos(θᵢ−θⱼ). Individual phases cancel around
every closed cycle, so this map preserves the cycle products.
With θᵢ=(i−1)π/n these are exactly the real two-dimensional vectors
used earlier for the attained record and error bounds. The two
constructions share these joint relations, not just a numerical cosine.

Their questions still differ. Each neighboring overlap has modulus
cos(π/n), approaching 1, while the full overlap product is
−cosⁿ(π/n), tending to −1. In the two-acquisition example, both
original cycles equal 1; each adjacent baseline changes by only
e^{−2πi/n}. Averaging each baseline separately halves that local phase
and gives the negative cycle. Thus arbitrarily good *neighboring*
coherence supplies no size-independent small bound on the whole cycle
phase. This does not assert that every pair of vertices is nearly
identical: distant pairs retain substantial differences. Nor does the
Gram correspondence transfer the physical roles of elapsed time,
quantum memory, access or cost between the two realizations.
An error bound against a target matrix also requires transporting
that target and the specified error measure.

**Local halving need not preserve a joint relation.** For unit z≠−1,
the normalized mean m(z)=(1+z)/|1+z| obeys m(z)²=z. Nevertheless,
for z=e^{2πi/n}, n≥3, one has zⁿ=1 but m(z)ⁿ=−1. All the local
means in this example are defined. A closed loop need not remain
closed when each edge independently takes this phase midpoint.

More generally no total multiplicative choice h on U(1) can satisfy
h(z)²=z. Multiplicativity at −1 would give h(−1)²=h(1)=1, while
the required square is −1. This is a prohibition derived from the
given two-return relation, not a separate ban on taking roots. It
does not rule out choosing a root for one phase or using additional
endpoint relations. In particular, it is not a refusal of m at an
admitted input: −1 was excluded from that partial mean, whose
cycle failure was established separately above.

There is a positive joint construction. On a supplied finite graph
with unit edge values rᵢⱼ, inverse values on reversed edges, and
product 1 around every cycle, propagate vertex phases pᵢ from an
internal root so that rᵢⱼ=pᵢ conjugate(pⱼ). The cycle relations make
this consistent. Choose any square root sᵢ of each vertex phase,
then put hᵢⱼ=sᵢ conjugate(sⱼ). These edge values square to rᵢⱼ
and every cycle still closes. Branch choices are coordinated through
shared endpoints. This constructs compatible phase data; an instrument
that acquires or implements those roots needs its own access relation.
The contrast is between a function of each isolated edge value and
a construction using the actual joint graph.

## §14. A finite refusal before an amplitude scale

**IiS22 (one context-independent binary table cannot preserve this return diagram).** Start with four resident frames, arranged in two rows and two columns. A frame is an ordered pair of fields. Write n for exchanging those fields, and N for applying n to all four frames. These are internal addresses. There is no supplied amplitude, angle, norm, probability law or measurement event. The four frames do not claim to exhaust the whole.

Construct X₁ by exchanging the rows, X₂ by exchanging the columns, Z₁ by applying n to the second row, and Z₂ by applying n to the second column. Each operation is its own inverse. X₁ and Z₁ exchange order with the residual N, as do X₂ and Z₂. Operations with different subscripts commute, and N commutes with all four. These equations follow by tracking the actual fields. They are not separate algebraic premises. In the following words, operations are written in order of application.

| | First place | Second place | Third place |
|---|---|---|---|
| First row | X₁ | X₂ | X₁X₂ |
| Second row | Z₂ | Z₁ | Z₂Z₁ |
| Third row | X₁Z₂ | X₂Z₁ | (X₁Z₂)(X₂Z₁) |

Every entry is an involution. Within each row and column, the entries commute. The three row products and the first two column products are identity. The third column product is N.

*Derivation.* The first two factors in each of the first two rows and columns commute because their subscripts differ. Their product is the third entry. For the third row, exchanging the two factors produces two copies of N, which cancel. Its last entry is therefore also an involution. In the third column, exchanging X₁X₂ with Z₂Z₁ again produces two cancelling residuals. But rewriting X₁X₂Z₂Z₁ as (X₁Z₂)(X₂Z₁) requires one same-subscript crossing. Thus the last entry equals N times the product of the first two, giving N for the full column. This also proves its commutation with those entries. QED

The eight leaf addresses have three binary roles: row r, column c and side p. On these addresses the four actions are (r,c,p)↦(r⊕1,c,p), (r,c,p)↦(r,c⊕1,p), (r,c,p)↦(r,c,p⊕r) and (r,c,p)↦(r,c,p⊕c). The central residual changes only p. These formulas recode the constructed pair exchanges. They add no geometry. The operations are affine on the address bits and require no three-input nonlinear gate. This differs from the Toffoli gate-arity question. Three bits address these eight places, while their arbitrary contents can contain further distinctions. They do not bound all the information to three bits. This finite permutation realization also prevents treating the operation algebra alone as evidence of uniquely quantum behavior.

**The proposed compression has a precise contradiction.** Give each of the nine entries one code, either preserve or reverse an oriented two-field frame. Require the same code wherever that entry occurs, and require composition within each row or column to preserve its return answer. Identity must be coded as preserve and N as reverse. The six target answers are therefore five preserves and one reverse. Yet composing all six coded answers uses every cell code twice. Two preserves or two reversals cancel, so the combined code must be preserve. It cannot be reverse on a frame with distinct fields.

This is a refusal of that common code, not a claim that the displayed operations are inconsistent. Their actual source-bound compositions realize every equation. Nor does it forbid all binary answers. One context, or context-indexed answers, changes the representation being tested. Adding unrelated internal fields cannot repair a proposed table that still retains these nine shared addresses, six composition equations and one noncollapsed output frame. M71 applies to that finite witness. An actual alteration of an answer or of its sharing changes a premise.

It also does not forbid numbering the operations. Distinct numerical names can retain the whole finite operation diagram if its actual composition rules are carried with them. What fails here is reducing each entry to one of two frame actions and preserving the six products under their commutative composition. A pair representation with enough retained relational content is a different candidate. LQ13's boundary criterion tests its adequacy, without requiring that a boundary be a number or that every pair be a binary answer.

**Repetition across scales requires an actual transport.** Let c:X→Y be a proposed change of description, with each source action T and image action T′ satisfying c(Tx)=T′(c(x)) on the relevant sources. Let the compared answer satisfy q(x)=q′(c(x)). Induction over an admitted finite word gives q(w(x))=q′(w′(c(x))). Therefore, if two words have different source answers, their transported words must still have different image answers. For partial operations, preservation of the admissions and refusals being compared is also required. This is the existing transition and VC15 criterion applied across descriptions, rather than a new scale axiom.

Each T′ is one common action on the image for its declared source family. Choosing a different image action from an omitted source distinction would not satisfy this requirement, even if each individual application produced a commuting square. VC9's source-selected decoder attack applies here too.

For IiS22, the five returns and sixth reversal transfer if these action relations are retained, and the refusal survives only if the image still distinguishes the relevant reversal. An image identifying x with N(x) cannot expose that refusal. Different carriers can therefore express the same relational obstruction, while a coarser contact can cease to reveal it. Neither closure nor the existence of a pair supplies a transport between arbitrary scales. Changing physical size, changing carrier and discarding distinctions are different changes to test.

The event rule is part of that transport. [Qu et al.](https://www.nature.com/articles/s41534-021-00492-1) experimentally test the square with single photons and separately analyse coherent light theoretically. In the latter analysis, selecting single-click events versus including multiple-click events changes the contextuality test. The paper is not an experimental demonstration of identical behavior at both intensities. Its comparison gives a direct attack on an asserted scale correspondence: keeping the optical arrangement does not by itself keep the measured event or its selection rule. Repeated formulas or similar drawings cannot supply that missing relation.

The argument is the finite algebra of the Mermin–Peres square, described together with its measurement implementation in [Kirchmair et al.](https://arxiv.org/abs/0904.1655). The construction here identifies it inside the existing frame exchanges of LQ13. It is not a new physical law derived from closure. It locates a specific compression that VI must refuse, and distinguishes the operation diagram from its proposed scalar image.

**The static proof computes the words.** `FrameSquare` uses `SwapBoundaryReading`, `PairedApplication`, `LowerFrameFlip` and `AlternateFrameFlip`. `FrameSquareProducts` derives the six answers for eight arbitrary field types. Every sequential application binds its input to the preceding answer. Specified intermediate field arrangements are checked at those seams, rather than accepted as a final result table. `FrameSquareContextOrders` derives the four primitive squares and the six required order exchanges. The other five squares are the computed context products.

`FrameSquareTrivialReturnCollapsesFrames` derives equality of all four pairs' sides if the sixth return is equated with its source. These side equalities are its conclusions. A zero/successor contrast supplies a positive refusal of that identification. Expected compiler failures cover erasing the sixth return and restarting a later application from the original source. Frames whose two sides already agree do return trivially, as a positive countercheck. Thus the result requires a retained contrast. The universal binary-code counting argument is proved above. The compiler checks the actual operation identities and collapse implication, not a new open conformance label asserting contextuality.

**An empirical comparison can use finite answers before fitting a curve.** Code preserve as +1 and reverse as −1. For a candidate common table, at least one of the six target parities fails. Hence its six signed scores sum to at most 4. A mixture of such tables obeys the same bound when the six contexts sample one common ensemble. This is an elementary consequence of the nine shared codes, without importing a quantum probability rule.

The trapped-ion study reports the six correlations 0.92(1), 0.93(1), 0.90(1), 0.90(1), 0.89(1), −0.91(1), with the combined score 5.46(4). It also changes measurement order and preparations. Those are published measurement summaries, not data collected or raw events reanalysed here. For the physical correspondence, the frames need the stated signed-coefficient interpretation, and the entries need calibrated repeatable binary measurements with the required shared contexts. A reversible operation and the instrument measuring its associated binary property are different contacts. Permutation identities alone do not establish that instrument contract. The article's extra disturbance test uses an explicit bound relating unobserved changes to observed repeated-measurement errors. That bound is an additional assumption, and is not derived from the displayed score.

There is a further quotient to check. When N is interpreted as a common sign of a quantum state, its isolated channel agrees with identity. The static frame contrast is then not an observed change of that isolated state. The six measurement parities concern the joint outcomes of the specified binary instruments. A coherent phase comparison instead needs the retained internal reference of IiS10. These are different ways a richer contact can retain a distinction omitted by an isolated channel. Neither can be replaced by silently treating a global sign as a directly visible scalar.

**Attack the physical correspondence before claiming a prohibition in nature.** A device receiving the context can return two internal seed bits a,b and a third bit a⊕b⊕p, where p is the required parity for that context. With the four seed pairs equally represented, every single-place marginal is balanced and every two-place marginal is uniform, while all six context parities are satisfied. The displayed generator is a counterconstruction, not a new empirical claim. It uses a context-dependent third answer. It therefore has no common nine-answer table, despite agreement of the overlapping marginal statistics. The seed, context and record can all be inside one whole.

Consequently neither matching single-answer frequencies nor a high score by itself proves that the contact identity was preserved. Actual measurement sequences, repeatability, disturbance, context selection and retained records matter. Context-sensitive apparatus and contextual quantum measurements cannot be distinguished by silently omitting those relations. The forbidden operation is the asserted erasure of context while retaining all these answers. Physical measurements can supply evidence against that erasure under an established measurement contract. Reality does not execute a contradictory table.

**What this settles about the cosine question.** The finite return diagram precedes a numerical response curve. Its construction works by exchanging fields, and has no assigned answers for intermediate phase contacts. It therefore cannot identify a cosine, a quadratic visibility constraint or a probability law. Supplying a trigonometric composition equation would introduce the missing content as a premise. In particular, the equation C(u+v)+C(u−v)=2C(u)C(v) is not licensed by these return identities or by bare relationality.

IiS29 supplies a separate positive route: an extremal score in an
established real Gram reading determines the cosine comparisons on its
finite preparation family, with dimension two as a conclusion. Its
positive reading and saturation conditions are additional relations,
not consequences silently assigned to the return diagram here.

The next question must address an actual internal refinement: which intermediate contacts exist, which recombinations of the same retained source agree, and which counted answers those contacts preserve. S32 already shows why mutually consistent returns and unique centres do not establish an arithmetic scale. A useful target here is a new refusal that survives changing the intermediate cut while preserving its actual source and all admitted compositions. Only after that diagram determines the response may a familiar coordinate formula be identified with it. The present result supplies an exact finite restriction for that investigation, rather than interpolating an unproved curve between it.

## §15. An operation can require a larger address domain

**IiS23 (exchanging two action roles forces an extension of this permutation representation).** Keep IiS9's four addressed places A⁺, A⁻, B⁺, B⁻. Here the superscripts name the two fields of a frame. Regard X and Z as their actual permutations: X exchanges A⁺ with B⁺ and A⁻ with B⁻, while Z exchanges B⁺ with B⁻ and fixes both A places. No amplitude, angle or numerical response is supplied. Ask for a further reversible change H, itself an involution, that exchanges these two action roles:

    H X H = Z,     H Z H = X.

The words denote successive applications, with the source and all intermediate addresses retained. This is a new contact requirement to investigate. The original pair grammar does not require such an H to exist.

**Four places cannot carry it by permutation.** If a place a is fixed by Z, then H(a) must be fixed by X. The original Z fixes two places, while the original X fixes none. A bijection of those same four places cannot meet the displayed equations. This argument excludes every permutation candidate, without searching a table of 24 cases. Equivalently, the two transpositions in X and the one transposition in Z have different fixed-place structures.

**Any faithful extension needs at least eight places.** Require the old four places to remain distinct and retain both old actions on them. Under the group generated by X and Z they form one orbit: the exchanges reach all four from A⁺. Conjugation by H exchanges the generators, so it sends this entire orbit to another orbit of the same size. Since A⁺ is fixed by Z, H(A⁺) is fixed by X and cannot belong to the old orbit. Group orbits that intersect coincide. The new four-place orbit is therefore disjoint from the old one. At least four further places are necessary, independently of any additional places elsewhere in the domain.

**Eight suffice, using the same pair constructors.** Take two copies of the old address block. On the first block let X̃ act as X and Z̃ as Z. On the second let X̃ act as Z and Z̃ as X. Let H exchange the two blocks, keeping their four corresponding places aligned. Then H² is identity, H X̃ H=Z̃ and H Z̃ H=X̃ by following either block. Both original actions remain exact on the first block. Each block and its relation to the other belong to the supplied whole. This proves the lower bound is attained.

The extra block is not an outside exception to a law. It provides the previously missing fixed-place structure while preserving the old actions. The false stronger hypothesis was that exchanging these roles cannot be realized by permutations at all. It can, once the address domain changes in this explicit way. Nor does this imply eight physical states are needed for a quantum Hadamard gate. A linear amplitude transformation uses a different operation class from permutations of these four places. Eight is the minimum for this specific extension problem, not a universal quantum dimension or a limit of three bits on all content.

**The duality also supplies a smaller compositional step.** Write R for applying Z̃ and then H. Two applications give R²=Z̃X̃. The existing crossing law gives (Z̃X̃)²=Ñ, which reverses both fields of every frame in both blocks. Therefore

    R⁴=Ñ,     R⁸=id.

On an addressed source changed by Ñ, the R-orbit has exactly eight members: its period divides eight and does not divide four. Thus the shorter step is established by its compositions before introducing a fractional angle or a duration. This supplies another explanation of the required extension: the old four-cycle has only the even steps of this eight-cycle.

`DualModeActions` constructs the two blocks, both lifted actions and their exchange using `PairedApplication`, `ExchangeModes` and `ReverseSecondPhase`. `DualModeReturns` derives both conjugacies, the primitive returns and the two-, four- and eight-step answers for eight arbitrary field types. The intermediate field arrangements are checked by `SequentialReading`. The slot-orbit proof establishes minimality over arbitrary permutation extensions. The type proof establishes the displayed construction and its word identities.

The checks also attack a proposed scale reduction. Reading only the first block preserves the old X and Z answers exactly. Two inputs with equal first blocks and different second blocks have different first-block answers after H. Thus the old view has no common H action without more information. The complete resident pair does. Positive zero/successor differences witness this failure and the nontrivial fourth return. Compiler refusals cover an alleged fixed single-marker input for X, an identity fourth return, removal of the other block and restarting a repeated step from the wrong source. Equal payloads can conceal a moved address, so the positive marker matters. A moved field position alone is not a measured physical signal.

**Indefinite exact subdivision cannot close on a fixed finite permutation domain.** More generally let R₀ be a nonidentity involution and require Rₖ₊₁²=Rₖ for each admitted refinement. Induction gives Rₖ order exactly 2ᵏ⁺¹. Its 2ᵏ⁺¹-th power is identity, while its 2ᵏ-th power is R₀, which is not identity. Since every divisor of 2ᵏ⁺¹ is a power of two, no smaller order is possible. A permutation of this order must have an orbit of length 2ᵏ⁺¹: every orbit length divides that power, and if all divided its half the permutation would have smaller order. Consequently the faithful address domain must have at least 2ᵏ⁺¹ places.

Each finite depth has a finite countermodel to a stronger infinitude claim. Take one cycle of length 2ᵏ⁺¹, use one-place advance for Rₖ, and successive doublings of that advance for the earlier Rⱼ. All required root equations and the nontrivial involution are satisfied. An arbitrarily long but finite observed hierarchy does not establish that every refinement is available. Requiring the whole hierarchy excludes a fixed finite permutation domain, but supplies no continuum, topology, cosine, probability law or geometric scale. S32 concerns refinement of readings under specified centre and scale actions. Here the bound follows from refining an actual return word and retaining its nonidentity, without a centre or an arithmetic coordinate on the forms.

**A physical contact can test the word without supplying its interpretation in advance.** The target is to calibrate the short action relations with their internal reference retained, then compare longer held-out words. In a coherent optical realization of the complete signed actions, the fourth R-word would reverse the working branch relative to the reference, and the eighth would restore their relation. The isolated working channel can return after four while that joint comparison differs. Channel-only calibration of H² or Z² is insufficient: an omitted common phase in a primitive implementation can alter the later reference comparison. IiS10–IiS13 identify that missing obligation. No physical demonstration of this eight-address realization or the proposed four/eight test is asserted here.

There is already relevant experimental evidence about directly reading an order relation. [Procopio et al.](https://arxiv.org/abs/1412.4006) send a heralded photon through two coherently related orders of polarization gates and recombine the paths. The output port distinguishes the promised commuting and anticommuting cases. Their Pauli-pair data report a success probability 0.973±0.016, and the paper discusses interferometer calibration and gate-dependent path changes. This is a different arrangement from IiS10's fixed recovery, but it measures the order residual through an internal joint contact. The gate promise, prepared paths and output-event definition are part of the experiment. It is not evidence that a global sign of an isolated state is observable, or that the new refinement hierarchy has been experimentally established. No raw events were reanalysed here.

The next unresolved question is now narrower: which further role exchanges or subdivisions are physically admitted, and which response relations persist through them? Four places already fail one exact requirement. Eight repair it without producing a numerical response curve. The finite diagram determines that extension and its return pattern, while the physical availability of additional contacts remains an empirical and relational obligation.

## §16. What local silence and incidence leave undecided

**IiS24 (a contact table can preserve local distributions without being quantum).** Take two addressed settings on each of two internal participants and two distinct answer forms, named a and b. These names carry no arithmetic. Specify the possible joint answers:

| First setting | Second setting | First alternative | Second alternative |
|---|---|---|---|
| u | v | (a,a) | (b,b) |
| u | v′ | (a,a) | (b,b) |
| u′ | v | (a,a) | (b,b) |
| u′ | v′ | (a,b) | (b,a) |

At every setting pair each local projection admits both a and b. If the two alternatives in each row have equal weights, both local distributions also agree across the other participant's setting. Those marginal distributions therefore carry no signal about that setting. This is the Popescu–Rohrlich contact pattern, not a proposed new physical observation. [Rohrlich and Popescu](https://arxiv.org/abs/quant-ph/9508009) show that no-signaling permits correlations stronger than quantum theory allows. Thus the no-signaling condition does not determine the quantum response law. No claim that this table has a relativistic physical implementation follows from its marginals.

**The admission graph does not even determine no-signaling.** Instead give the first alternative the same strictly greater weight than the second in every row, keeping both weights positive. At second setting v′, the second participant's favored answer is a when the first setting is u and b when it is u′. Its distribution now changes. The possible answers, all four joint supports, and the separate local supports remain unchanged. Equal and unequal weighting thus give opposite answers to the signaling question on the same incidence graph. Removing numerical weights from a representation is safe for admission questions here, but not for this statistical question. The missing content is the weighting relation, regardless of its notation.

**One common table of local answers is a stronger and different requirement.** If the first participant has answers a_u and a_u′ independent of the other setting, and the second has b_v and b_v′ independent of the first setting, the first three perfect agreements force all four answers equal. The fourth contact then cannot require a different pair. The same argument applies at each shared hidden condition in a setting-independent mixture. These are requirements on that common representation. Rejecting every process without such a table would reject quantum Bell correlations as well. A common physical process need not supply simultaneously readable answers for incompatible interventions.

**The existing constructors expose the exact boundary.** `BinaryContactAlternatives<A,B>` supplies these four context tables for arbitrary field types. Its last table is the actual `ResidentCutExchange` of the equal-answer table. `TransposeEntries` collects the two participants' answer lists. The first lists agree. The second lists agree after swapping their alternative addresses, as `BinaryContactLocalLists` derives. For distinct zero/successor markers the joint tables differ, and the second lists before that swap differ. Both differences support expected compiler refusals. The proof retains the context and the actual exchange. It certifies neither physical weights nor a separated implementation. Hiding alternative addresses preserves local distributions only with the specified weight symmetry. Those addresses cannot also be claimed as retained local records.

**Local filtering can reproduce any finite table of retained coincidences.** Fix nonempty finite setting sets X,Y of sizes m,n and finite output sets. Let P(a,b|x,y) be any normalized conditional table, without assuming no-signaling or quantum realizability. Prepare a shared record λ=(u,v,a,b) with weight P(a,b|u,v)/(mn), independently of the actual settings x,y. Give the first participant only (u,a) and the second only (v,b). At the first site, output a when x=u and otherwise no detection. At the second, output b when y=v and otherwise no detection. Each response depends only on that site's setting and packet.

For every actual (x,y), the first detection probability is 1/m, the second is 1/n, and the joint detection probability is 1/(mn). Conditional on joint detection, u=x and v=y, so the retained output distribution is exactly P(a,b|x,y). The full records, including no detection, admit this local model. The retained coincidences can display any desired conditional table. Constant efficiencies and even independence of the two detection flags at each setting do not make selection independent of the prepared record λ.

For IiS24's binary table, eight equally weighted prepared records suffice. Let u,v,r be uniform independent bits. The first packet contains (u,r), and the second contains (v,r⊕uv). Choose actual settings independently of those records and accept locally only when they match u and v. Both local efficiencies are 1/2 and every coincidence efficiency is 1/4. The accepted outputs have equal parity in three contexts and opposite parity in the fourth, with balanced alternatives. Thus the PR coincidence table does not require a PR device supplying an answer on every trial. Comparing the two acceptance flags is a later joint contact, so a signaling table after that conditioning would not constitute an available faster-than-light signal.

`PostselectedPRFromLocalPackets` in `Checks/Interactions.swift` retains the four guessed setting pairs and their two prepared output alternatives. `CoincidenceRow` sends each setting, guess and payload to its own `AcceptedLocalGuess` constructor. The resulting four accepted rows are the existing IiS24 table. A positive zero/successor distinction and a refusal check that the same prepared guess accepted at 10 cannot be accepted at 00. These types check local packet contents, successful composition and the admission difference. The normalization and efficiency claims follow from the finite weights above, without a probability runtime or a certificate of an implemented detector. The refused conformance concerns the accepted-answer channel. No detection remains an outcome of the complete physical trial, not an event removed from reality.

This is a finite instance of the data-rejection issue identified by [Pearle](https://journals.aps.org/prd/abstract/10.1103/PhysRevD.2.1418). It is a counterconstruction to the proposed inference from filtered data, not a reanalysis or dismissal of the cited experiments. The distributional premises are explicit and the settings, shared preparation and records can all belong to one whole. Independence here is a relation among internal preparations, not an exterior source.

**The full trial supplies a direct obstruction to that attack.** Suppose each prepared record supplies one common table of binary local responses A₀,A₁,B₀,B₁, with values + or 0. No detection is coded as 0. At each such record,

{A₀=+, B₀=+} ⊆ {A₀=+, B₁=0} ∪ {A₁=0, B₀=+} ∪ {A₁=+, B₁=+}.

If the left event occurs and the first two right events fail, B₁ and A₁ must both be +. Averaging over one setting-independent law of prepared records gives the Clauser–Horne form used by [Shalm et al.](https://tsapps.nist.gov/publication/get_pdf.cfm?pub_id=919674):

P(++|00) ≤ P(+0|01) + P(0+|10) + P(++|11).

This finite cover is the mathematical proof here. Its premises include the common local table and common preparation law. Closure of the whole does not supply either premise, and the static packet checks above do not certify probability laws.

In the eight-record attack, code the emitted bit 1 as + and both bit 0 and no detection as 0. On full trials the four displayed probabilities are respectively 1/8, 1/8, 1/8 and 0. They satisfy the required bound: 1/8 ≤ 1/4. After discarding every non-coincidence they become 1/2, 0, 0 and 0. The removed single-detection events carry precisely the obligations that the selected table appears to violate. The code merges two local outcomes only for this specified test. It does not identify their complete records.

**A safe preparation filter preserves a common source across settings.** Let λ include the response resources and a readiness flag R, with their law independent of actual settings, conditional on the retained prior history. Conditioning on R=1, when it has positive probability, changes that law but leaves it common to all settings. The same cover and inequality remain valid on the admitted trials, provided each yields a coded outcome including no detection. Here λ is the tested resource description, not the whole reality including the setting generators. All these systems can remain inside one whole. Absence of a causal path from a setting to readiness is not by itself statistical independence: a common cause can correlate both.

In [Hensen et al.](https://arxiv.org/pdf/1508.05949), a central herald selects successful preparations. Its event is spacelike separated from the setting-generation events. The local choices and readouts run independently of whether that herald succeeds. A readout window with no count receives the negative outcome. Thus a universal chronological instruction to herald before choosing would misdescribe this contact. The proposed exclusion depends on the actual causal arrangement, the signal-speed restriction and the independence premise. The experiment does not derive those from an external clock or from closure alone.

**Safe compression need not retain every trial in the final statistic.** Shalm's local trial rule records detection or its absence. The [supplementary analysis](https://journals.aps.org/prl/supplemental/10.1103/PhysRevLett.115.250402/LHFSupplementary.pdf) retains four scored event categories, including the single-detection penalties, and uses a stopping count set before test analysis. Its bound permits device memory. Selection justified by that bound differs from keeping only coincidences or choosing a favorable endpoint. Finite experimental evidence excludes the tested conjunction statistically. It does not deductively select one underlying physical theory.

The VI obligation is therefore stronger than matching the successful table and its aggregate detection rates. A transfer must preserve the source-setting admission relation, or prove that the proposed reduction preserves the particular restriction being tested. VC46–VC47 already distinguish successful-answer agreement from availability agreement. Neither keeping every record nor placing an event earlier on a chosen clock is the general criterion. The criterion is a sufficient relation for the promised inference, including selection and stopping when they affect that inference.

AC7 §6b identifies an invariant for positive selection of the narrower form q(a,b)∝f(a)g(b)p(a,b): every alternating cycle ratio survives. Its hidden-parity counterconstruction also shows why physical locality alone does not imply this factorization on the visible answers. A local packet can retain a source relation omitted by a or b. The present guessed-setting attack makes the same distinction at the trial-admission boundary. A useful selection invariant must bind the actual filter inputs, not infer them from the names of the two sites.

LQ13 already gives a binary-incidence representation of any finite joint relation by retaining its admitted tuples as shared witnesses. It applies to this table too. Consequently binary representation, a common internal witness and local incidence agreement do not select quantum theory. The central missing question is which additional, physically supported composition and reading requirements exclude this table while retaining the observed quantum contacts. Naming those requirements quantum, positive or coherent would not establish them.

One existing reconstruction illustrates how much further content can enter: [Chiribella, D'Ariano and Perinotti](https://arxiv.org/abs/1011.6451) use causality, distinguishability, compression, local distinguishability and pure conditioning, together with purification, to derive quantum theory in their operational setting. These are candidate relations to audit, not consequences imported into VI from their names. In particular, purification concerns a pure extension of an operational state and uniqueness up to specified reversible changes of the purifying system. Placing a source and an apparatus inside one whole does not supply this relation.

The number-free core therefore retains source-bound contacts, their actual compositions, distinctions under internal references and the permitted alternative interventions. Response weights, the general amplitude carrier, and the law selecting quantum-compatible joint contacts remain obligations. IiS9, IiS21–IiS23 retain finite word and joining obstructions. IiS11–IiS20 retain stronger results inside an explicitly supplied Hilbert-space model. Their different premises must survive the comparison with general relativity in Difference §5l.

## §16a. A finite contact can determine the programmed operation

A program is another physical input, with its own contact geometry. Exact deterministic execution of distinct unitary channels requires orthogonal complete program states in the usual product-input model. The [Nielsen–Chuang no-programming theorem](https://arxiv.org/html/quant-ph/9703032v1) follows from the same preservation used in IiS20: if a fixed isometry executes U and V, its residual vectors e_p,e_q are independent of the data, and

    ⟨p,q⟩ I = ⟨e_p,e_q⟩ U†V.

A nonzero program overlap therefore makes U†V a scalar multiple of I. Distinct channel names cannot supply the orthogonality of their actual program carriers. A program-dependent record elsewhere in the apparatus belongs to that complete input. A common blank workspace alone does not change its overlap. This is a specified quantum-model restriction, not a consequence of closure alone.

Permitting a heralded successful branch changes the contract. [Vidal, Masanes and Cirac](https://arxiv.org/html/quant-ph/0102037v1) construct a one-qubit phase program with success probability one half and retain a distinguishable failure branch. The following finite calibration derives the whole successful map and its bound directly, without sampling a continuum of phases or prescribing that circuit.

**IiS25 (Three program phases and three data rays force one successful operation up to scale).** Fix data and program qubits with internally calibrated bases. Let

    p_z = (|0⟩+z|1⟩)/√2,       U_z = diag(1,z),       |z|=1.

One fixed completely positive trace-nonincreasing map takes the joint data/program input to a successful data output. All other outcomes remain outside this branch. Choose any three distinct z. For each, require that the successful output at each of the three data inputs |0⟩, |1⟩ and |+⟩ has support in the corresponding target ray U_z|d⟩. A zero output is allowed by this support condition, so success must also be witnessed separately if it is claimed.

Represent this branch by a contraction K from data⊗program to data⊗E, retaining its Kraus index inside E. Then the nine ray conditions force

    K|00⟩=|0⟩v,   K|01⟩=0,   K|10⟩=0,   K|11⟩=|1⟩v

for one residual vector v with ‖v‖≤1. Consequently, on every data input and every phase z, its success probability is the same p=‖v‖²/2≤1/2 and its successful operation is p U_z(·)U_z†. More strongly, the successful map on arbitrary joint data/program inputs is fixed up to that one scale. One independently established success probability fixes the scale. The failure operation remains undetermined.

*Proof.* The |0⟩ tests at two distinct phases force K|00⟩ and K|01⟩ to have data component |0⟩ only. The |1⟩ tests similarly confine K|10⟩ and K|11⟩ to |1⟩. Write these four residual vectors as a,b,c,d. For a fixed z, the |+⟩ test requires the two data components to have the same residual after the target phase is removed. Hence

    c+zd = z(a+zb).

The vector-valued quadratic c+z(d−a)−z²b vanishes at three distinct points. The invertible three-point Vandermonde relation gives c=b=0 and d=a=v. This determines K on its complete input basis. Contractivity at |00⟩ gives ‖v‖≤1. Applying K to an arbitrary ψ⊗p_z yields U_zψ⊗v/√2, which proves the channel and probability statements. QED

The number of phases matters: testing only z=1 and z=−1 permits deterministic execution. Those two program states are orthogonal, so a fixed controlled operation can apply I or Z and succeed with probability one. Testing only the two basis data rays is also insufficient: the identity data channel passes them for every z with probability one but fails the phase-sensitive |+⟩ target. The third program and the coherent data probe close different missing relations.

**Every pair of the same three programs permits more.** Take z∈{1,ω,ω²} with ω a nontrivial cube root of one. Each pair has a processor executing its two target channels exactly with success 9/16 on every data input. Yet no common processor can achieve that probability on the triple, by IiS25. To construct a pair, choose phases of its program and target representatives so their program overlap is 1/2 and the relative target unitary W obeys W†W=I and W+W†=I. Give the two success residuals unit norm and overlap 4/9. At success probability s=9/16 the difference between the complete input Gram operator and the successful-output Gram operator is

    [ tI   B  ],       t=7/16,       B=I/2−W/4.
    [ B†   tI ]

Here B†B=3I/16 and t²I−B†B=I/256, because 49−48=1. The block operator is positive. Factor it as the Gram operator of the failure outputs. Together with the proposed success outputs this gives an isometry on the input span, as in IiS20, and hence a valid fixed processor for that pair. The two program states span their qubit, so the construction covers arbitrary data. The pairs use separate processors. Their existence does not supply one processor for all three. This finite gap survives arbitrarily large blank residual spaces.

The half bound is attained by a permutation of four addressed amplitudes. On a product input with data amplitudes (α,β) and program amplitudes (u,w), `ResidentCutExchange` sends

    ((αu,αw),(βu,βw))  to  ((αu,βw),(βu,αw)).

Read the first pair at success flag s and the second at failure flag f. This is a unitary permutation in the stipulated orthonormal basis, with both flags internal. For p_z the complete output is

    [ |s⟩ U_zψ + |f⟩ z X U_z⁻¹ψ ] / √2,

where X exchanges the two data modes. Both branches have probability one half. The inverse phase and mode exchange in the second branch are retained relations, not missing information sent outside the whole. `CutExchangeReturns` already proves the generic permutation's return in bare Swift. Its existing source-recovery and branch-omission refusals cover those field relations. The Hilbert-space interpretation and the universal probability bound come from the proof above, not from a new marker protocol.

**The bound is a preparation ratio.** Replace p_z by √r|0⟩+z√(1−r)|1⟩, with 0<r<1 fixed. The same nine ray conditions now force the crossed columns to vanish and √r a=√(1−r)d. If w names this common vector, success has probability ‖w‖²≤min(r,1−r), since both remaining input columns are contractive. This bound is attainable by taking those columns to be |0⟩w/√r and |1⟩w/√(1−r), and completing the contraction with a failure branch. Thus 1/2 comes from the balanced preparation. It is not an additional universal constant. At r=0 or r=1 the programs coincide up to phase and nonzero exact execution of three distinct phase operations is impossible under this same interface.

**A finite inequality survives imperfect ray tests.** Use the three programs z∈{1,ω,ω²}, where |ω|=1, ω≠1 and 1+ω+ω²=0. For each data input d∈{0,1,+}, let e_d be the mean over those programs of the joint probability of success and the data outcome orthogonal to U_z|d⟩. These are unnormalized error probabilities, retaining rejected trials. Let p̄ be the mean success probability over the six program/basis-data preparations, using d=0,1. Every fixed branch of the stated kind obeys

    p̄ ≤ 1/2 + [√(8e_+) + √(2(e_0+e_1))]²/4.

In particular e_0,e_1,e_+≤ε gives p̄≤1/2+(3+2√2)ε, together with the elementary p̄≤1. This is a sufficient witness inequality. Its nonzero-error coefficient is not claimed optimal.

*Proof.* Write K's four columns, with all letters vectors in E, as

    K|00⟩=|0⟩A+|1⟩B,   K|01⟩=|0⟩C+|1⟩D,
    K|10⟩=|0⟩E₀+|1⟩F,  K|11⟩=|0⟩G+|1⟩H.

Averaging the three phase factors cancels their nonconstant terms. It gives

    2e_0=‖B‖²+‖D‖²,       2e_1=‖E₀‖²+‖G‖²,
    8e_+=‖B+F‖²+‖A+E₀−D−H‖²+‖C+G‖².

The six preparation projectors average to I/4, so 4p̄=‖K‖²_HS. Contractivity bounds the squared norms of columns 00 and 11 together by 2. Put t=2(e_0+e_1) and b=‖B‖²+‖G‖²≤t. The vector triangle inequality for (C,F)+(G,B) gives

    ‖C‖²+‖F‖² ≤ [√(8e_+) + √b]².

The two other terms ‖D‖²+‖E₀‖² equal t−b. Thus the remaining column norm is at most 8e_++t+2√(8e_+b), which is bounded by [√(8e_+)+√t]². Combining the two column bounds proves the inequality. QED

The zero-basis-error restriction has a sharp tradeoff. If e_0=e_1=0, the bound reduces to p̄≤1/2+2e_+. For any e_+ between 0 and 1/4, take orthogonal residual vectors v,w with ‖v‖=1 and ‖w‖²=4e_+. Set the four columns to |0⟩v, |0⟩w, |1⟩w, |1⟩v. This is a contraction and attains that bound. Thus even perfectly preserved basis readings allow greater success by admitting error on the coherent data probe.

This uses nine specified preparations and output tests, without tomography of E. The joint probability e_d requires both conditional fidelity and branch probability. Preparation, analyzer calibration and one common branch law are premises. If each recorded event probability differs from the corresponding ideal-model value by at most δ, and each recorded error mean is at most ε, the directly conservative bound is p̄_recorded≤1/2+δ+(3+2√2)(ε+δ). Establishing δ, including statistical uncertainty, is an experimental obligation. No exact equality is inferred from finite counts.

**Pure local preparations already fix their joint input.** This removes one redundant independence premise. For a joint quantum state, a pure marginal |a⟩⟨a| confines the state's support to |a⟩⊗H, by positivity. The joint state must factor through that pure vector. Hence the stipulated pure data and program marginals already force their product on those ports. More quantitatively, suppose their overlaps with the intended pure states are at least 1−η_D and 1−η_P. Their two target projectors commute on different ports, so their joint target probability is at least 1−η_D−η_P. The trace distance from the target product is at most √(η_D+η_P), bounded also by one. This follows by purifying the actual state, choosing a target purification with that overlap, and contracting the pure-state trace distance under partial trace. Every event probability for one fixed processor then differs by at most that amount. This supplies a preparation contribution to δ. Analyzer and sampling errors still require their own bounds. It does not exclude an additional phase-related input to the processor.

A hidden program-related input changes this test. Orthogonal internal tags for the three preparations allow a fixed device to read the tag and execute the corresponding unitary deterministically, while the displayed program qubit still has precisely the same three local states. The tag is inside the whole, but outside the earlier declared input. Conversely, under a fixed quantum processor and product data preparation, exact deterministic execution of the three distinct channels requires orthogonal complete programs. If their displayed qubits are the stated pure states, their nonzero pair overlaps force the remaining program records to have mutually orthogonal supports. This also covers mixed records: every pure state in a program's support must implement the same unitary, since a mixture producing a pure target can contain no component outside that ray. The no-programming relation then applies to every pair of support vectors. At least three perfectly distinguishable program records are necessary. This conditional inference locates a missing input relation. Data violating the earlier inequality alone would not choose between such an input, changed calibration and failure of the other premises.

The example ties U2c to physical admission. Several internal realizations remain, yet the successful operation is forced by a small set of zero-error contacts and one scale. Matching those successful outputs does not make execution deterministic. The complete branch relation provides the probability limit and the place for the other output. The realized quantum carrier and its calibrated input relations supply the premises that pure label compatibility would omit.

## §16b. The retained program determines the next contact

**IiS26 (The overlap of neighboring program weights is the exact success capacity).** Keep one data qubit and let the specified program instead be

    p_z = Σ_(j=0)^(d−1) √r_j z^j |j⟩,
    r_j>0,       Σ_j r_j=1,       |z|=1.

These are coherent preparations in a calibrated orthonormal basis. The integer j names the specified phase power. It is not a count of interchangeable memory cells. Require exact successful execution of U_z for every phase. Equivalently, the three data-ray conditions of IiS25 at d+1 distinct phases suffice for this declared finite encoding. Among all fixed heralded processors, the largest phase-averaged success probability is

    p_* = Σ_(j=0)^(d−2) min(r_j,r_(j+1)).

It is attainable with this same success probability at every phase and every data input. It is therefore also the optimal worst-phase guarantee. For d=1 it is zero.

*Proof.* The basis-ray conditions confine each input data sector to its matching output sector. Write K|0,j⟩=|0⟩a_j and K|1,j⟩=|1⟩b_j. The coherent data ray requires

    Σ_j √r_j z^j b_j = z Σ_j √r_j z^j a_j.

A polynomial of degree at most d vanishes at d+1 distinct calibration phases, so its coefficients vanish. Thus b_0=a_(d−1)=0 and

    c_j := √r_j a_j = √r_(j+1) b_(j+1),       0≤j≤d−2.

The successful joint output is U_zψ⊗Σ_j z^j c_j. Phase averaging removes all unequal powers, giving p_mean=Σ_j‖c_j‖². Contractivity at the two actual input columns gives ‖c_j‖²≤min(r_j,r_(j+1)). For attainment, choose mutually orthogonal c_j with these squared norms. Both data-sector column maps are contractions, hence so is K. Complete K with a failure branch. Orthogonality makes p(z)=p_* independent of z. QED

Uniform averaging over d+1 roots of unity gives the same mean, so the bound also has a finite exact sampling formulation after the ray conditions have established the family. At the maximum, the residual vectors c_j must be orthogonal: each saturates at least one of its two column norm bounds, and a unit-norm column of a contraction is orthogonal to every other input column's image. Applying that to the corresponding data sector gives ⟨c_j,c_k⟩=0 for j≠k. Thus attaining the capacity also fixes the successful residual Gram relation and removes phase dependence from its probability. The residual may still coherently retain z.

For a balanced d-mode program, p_*=(d−1)/d. This agrees with the phase-storage construction of [Sedlák and Ziman](https://arxiv.org/html/2008.09555v1), where N uses of the source phase operation prepare the d=N+1 charge family. The proof here concerns the specified prepared family. Its dimension alone does not supply those phase powers or their preparation cost.

The arrangement of weights also matters. For the same powers 0,1,2, weights (1/2,1/3,1/6) give p_*=1/2, while (1/2,1/6,1/3) give 1/3. The weight multiset and its Shannon entropy agree. Their attachment to the phase powers differs. That attachment changes the exact execution limit even though a statistic invariant under weight permutation cannot see it.

The same three-qubit carrier illustrates the difference. Here p_z names the balanced qubit program (|0⟩+z|1⟩)/√2. Three independent copies of p_z have charge weights (1,3,3,1)/8 on their four-dimensional symmetric span, giving p_*=5/8. The joint program p_z⊗p_(z²)⊗p_(z⁴) has eight equally weighted powers, giving 7/8. Both use three qubits. Their source relations differ. Producing the powers through repeated calls to one phase operation uses 1+2+4 calls in the latter preparation. The multiple-copy setting and its limitations are studied by [Brazier, Bužek and Knight](https://arxiv.org/html/quant-ph/0505202v1). Neither improvement is free memory growth outside the whole.

**Continued execution consumes a particular overlap.** Suppose p_*>0 and the complete successful residual is retained coherently and supplied to the next processor. At optimal success it has the normalized weights min(r_j,r_(j+1))/p_*. Applying the same construction again takes the next neighboring minimum. The probability that k such executions all succeed is therefore

    p_(k) = Σ_(j=0)^(d−1−k) min(r_j,r_(j+1),…,r_(j+k)),

with an empty sum giving zero. This is also the optimal phase-averaged and worst-phase success for one joint exact heralded execution of U_z on k arbitrary data qubits, including entangled inputs. To see the bound, let |b⟩ be any data basis state of Hamming weight w. Exact execution on all data superpositions requires

    K(|b⟩⊗p_z) = z^w |b⟩⊗e_z

with one residual e_z independent of b. The w=0 sector expresses e_z as a polynomial in z. The w=k sector removes its powers above d−1−k. Equating each remaining coefficient in every weight sector gives

    √r_(j+w) K|b,j+w⟩ = |b⟩c_j,       0≤w≤k.

The other coefficients vanish. Contractivity bounds ‖c_j‖² by every r_(j+w). Phase averaging gives the displayed sum of minima, and orthogonal c_j attain it uniformly. One joint success condition for arbitrary data and all phases is essential. A promise on separate selected successes is weaker. This joint bound is not claimed to follow from the nine preparations of IiS25 for a larger program or data space.

For balanced weights this reduces to p_(k)=(d−k)/d for 0≤k<d, then zero. The successful remainder loses one endpoint of its phase-power support each time. Reapplying the initial one-use probability as if the program were unchanged would give the wrong joint guarantee. Discarding or measuring part of that residual can remove the next processor's access to the required phase relations. Their inclusion somewhere in the whole does not supply that access. This is a quantum instance of Matter M70's distinction between a prepared application and repeatable use, with the limitation supplied by the program's retained phase relations rather than a classical count of labels.

**The condition is matching relative powers.** Consecutive labels are not essential. Let a finite program support J⊂ℤ carry positive weights r_j summing to one, and let the target data unitary multiply its basis vectors by z^w for weights w in a finite nonempty set W⊂ℤ. The same coefficient argument gives the optimal phase-averaged and worst-phase success

    p_*(J,W) = Σ_(t : t+W⊆J) min_(w∈W) r_(t+w).

For a successful residual power t, every data weight w must have its actual program partner t+w. Each partner bounds the same residual coefficient's squared norm. Summing those bounds after phase averaging proves necessity. Orthogonal residual coefficients attain them, as above. Translations of the program or data power labels only translate t and preserve the result. The relation t+w=j and the preparation weights do the work. Renaming separated powers as adjacent labels would change that relation.

**Two unavailable operations can acquire a common realization.** Consider the specified three-mode program

    q_z = (|0⟩+z²|2⟩+z⁵|5⟩)/√3.

Every distinct z gives a distinct program ray: equality of two rays requires both (z/z′)²=1 and (z/z′)⁵=1, hence z=z′. Nevertheless no fixed successful processor using one q_z can execute U_z exactly for all phases with any nonzero success. Its support J={0,2,5} contains no neighboring pair t,t+1. Equivalently, the residual powers required by data |0⟩ and |1⟩ do not intersect. Distinct program rays do not themselves supply a usable exact operation or perfect discrimination from one specimen.

Two copies with the same z change the contact. Their total power support and weights are

    (0,2,4,5,7,10),       (1,2,1,2,2,1)/9.

There is exactly one neighboring pair, 4 and 5. The optimal exact one-operation success is therefore 1/9. An explicit successful contraction maps the data/program vector |0⟩|2,2⟩ to |0⟩, and maps |1⟩(|0,5⟩+|5,0⟩)/√2 to |1⟩/√2. It is zero on the orthogonal complement of those two input vectors. The output on ψ⊗q_z⊗q_z is z⁴U_zψ/3. The two specified input vectors are orthogonal and their image norms are at most one, so a failure branch completes this operation without an exterior sink.

The shared source phase of the copies is essential. Independent phases would be a different input family. The result is a preparation-dependent quantum example, with no claim of a new physical law: each component's exact-use capacity for this task is zero, while their coherent joint preparation has positive capacity. The missing operation arose from a new match between retained relations, rather than from a choice among names or an increase in the precision of a reported number.

Capacity alone does not describe that future contact. The equally weighted program with powers {0,3,8} also distinguishes all phase rays and has zero one-use capacity for U_z. Two copies have powers {0,3,6,8,11,16}, still without neighbors, so their capacity remains zero. The two original families have the same dimension, the same component weights and the same exact-use capacity, but different answers after taking two copies. A scalar summary adequate for the current task therefore need not compose with that actual preparation operation. This is the quantum counterpart of the compression question in Matter M25a. It uses preservation of overlaps by one physical map, beyond M25a's premise of literally identical complete response inputs.

**IiS27 (Finite-copy exact use is possible precisely for a faithful phase program).** For a finite occupied support J with positive weights, choose j₀∈J and put g=gcd{j−j₀:j∈J}. A single occupied power has g=0. The following three properties are equivalent:

1. Every distinct phase z gives a distinct program ray.
2. g=1.
3. Some finite number N of copies in the specified product preparation with the same source phase permits exact U_z with a uniform nonzero heralded success probability.

*Proof.* Two phase preparations have the same ray exactly when their phase ratio ξ obeys ξ^(j−j₀)=1 for all j∈J. This permits no ξ≠1 exactly when g=1. The N-copy support NJ consists of sums of N occupied powers. Its adjacent-power criterion is that NJ contains two sums differing by one. If such sums exist, their difference is an integer combination of the original differences, so g=1. Conversely, Bézout's identity for g=1 supplies integer coefficients a_j with Σ_j a_j=0 and Σ_j a_j j=1. Split their positive and negative parts. Each part contains the same finite number N of terms, producing two actual sums in NJ that differ by one. Both have positive preparation weight. IiS26 then supplies positive exact success. QED

This characterizes eventual access to this operation in the specified preparation family. It does not construct extra copies from one unknown specimen. The N preparations must actually be available from the same source, with the stated product relation. The index N is not a number of times one unchanged program can be reused. Two occupied powers cannot exhibit activation from zero one-copy capacity: either their difference is one and one copy already works, or g≠1 prevents every N. Three occupied powers suffice, as {0,2,5} shows. This minimality concerns this phase-program contract, not a universal number of bits for reality.

## §16c. A returned mediator has different permissions along the word

**IiS28 (exact interleaving conditions for a borrowed qubit).** Fix the
usual finite-dimensional complex quantum model, two working qubits A,B,
a borrowed qubit C and an arbitrary finite register R. The coherent
implementations P=CX_(A→C) and Q=CZ_(B,C) are supplied contacts. Their
availability is not inferred from phase-blind calibration of X and Z;
IiS10 explains that distinction. Execute P,Q,P,Q in that order. Products
below use the conventional rightmost-first operator notation.

On a control branch ab, the borrowed action is

    ZᵇXᵃZᵇXᵃ = (−1)^(ab) I_C.

Thus the complete word F=QPQP is CZ_(A,B)⊗I_C, also tensored with I_R.
This operator identity applies to arbitrary joint input states, including
entanglement with R. C need not be prepared, measured or reset. Borrowing
unknown ancilla states is an established circuit resource; see
[Khattar and Gidney](https://quantum-journal.org/papers/q-2025-05-21-1752/).
The present question is which additional action can occur *during*
this particular word without changing either process's specified effect.

Let a fixed CPTP channel M act on CR in the gap after j contacts,
independently of the control values. The required combined channel is
the same as F together with M on CR; these two complete operations
commute. Require equality on every joint ABCR input. For any Kraus
representation M(ρ)=Σ_μ M_μρM_μ†, the exact conditions are:

| Gap j | Executed prefix L_j | Necessary and sufficient condition |
|---|---|---|
| 0, before the word | I | Any channel M on CR |
| 1, after P | P | Every M_μ commutes with X_C⊗I_R |
| 2, after P,Q | QP | M=id_C⊗N_R for a channel N on R |
| 3, after P,Q,P | PQP=FQ | Every M_μ commutes with Z_C⊗I_R |
| 4, after the word | F | Any channel M on CR |

*Proof.* The suffix is F L_j†. After removing the common complete
unitary F, the inserted channel has Kraus operators

    L_j† (I_AB⊗M_μ) L_j.

It must equal the channel with Kraus operators I_AB⊗M_μ. Choose a
linearly independent minimal Kraus list. The two minimal lists for
the same channel differ by a unitary mixing of their indices, by
factorization of their common Choi matrix. Every L_j is identity in
the control block 00. Restricting the mixing equation to that block
gives M_μ=Σ_ν u_μν M_ν. Linear independence forces u=I. Consequently
every I_AB⊗M_μ must commute with the *controlled prefix itself*.
Conversely those commutations immediately establish channel equality.
Changing Kraus representation only takes linear combinations, so the
criterion is representation independent.

For L₁ the nontrivial control blocks are X. For L₂ the 10 and 01
blocks are X and Z; commuting with both also handles the 11 block ZX.
For L₃ the nontrivial blocks are Z and −Z. Commuting with Z forces a
matrix on CR to be block diagonal in C's computational basis; commuting
with X equates its two diagonal blocks. Thus the common commutant is
exactly I_C⊗End(R). At j=2, each Kraus operator is I_C⊗N_μ, and trace
preservation gives Σ N_μ†N_μ=I_R. At j=0,4 the prefix acts trivially
on CR up to its independent working action. This proves the table. QED

The proof uses the established quantum-channel model and its joint
extension, as in [IBM's formulation](https://quantum.cloud.ibm.com/learning/en/courses/general-formulation-of-quantum-information/quantum-channels/quantum-channel-basics)
and IiS17. It does not derive that model from closure. R and any records
omitted by the channel description can be parts of the same whole.

For a unitary on C alone, the first internal gap allows arbitrary
rotations about X (and a common phase), while the last internal gap
allows rotations about Z. The middle gap permits only a common phase.
For channels, dephasing in the X basis is allowed in the first gap,
and dephasing in the Z basis is allowed in the third. Arbitrary action
on R alone remains allowed throughout. A resource can therefore admit
some uses while being unavailable for other uses at the same stage.

**Standalone channel covariance is insufficient.** The channel
D_Z(ρ)=(ρ+ZρZ)/2 commutes with conjugation by X and by Z on C alone.
Nevertheless its Z Kraus operator does not commute with the controlled
prefix QP, so it fails the middle-gap condition. Likewise an inserted
unitary Z_C produces the complete operator

    F (Z_A⊗Z_C),

and an inserted X_C produces F (Z_B⊗X_C), with identities on omitted
factors. For B=0 and C=0, an inserted Z leaves C fixed but changes an
A=+ control to A=−. D_Z in that gap dephases this control instead of
leaving it at +. The mediator's unchanged local output in this example
does not certify the working action. If the inserted Pauli operation
is known, the displayed Z_A or Z_B correction repairs the specified
joint effect. That knowledge is additional to an unknown disturbance.

Several fixed channels may be inserted: if each satisfies the condition
at its actual gap, move it through its prefix and compose the resulting
CR channels in their original order. Their mutual commutation is not
needed. This gives the same complete F with that ordered CR action.
It does not give a policy access to an unobserved outcome or gap.
If an executor cannot distinguish the three internal gaps and must
choose one channel valid in all of them, their common allowed family
is only id_C⊗N_R. Acquiring the relevant prefix relation can therefore
permit a use that an undifferentiated busy/idle description cannot.
The stages here are positions in the executed contact order, not
measurements against an exterior clock.

`BorrowedPhase.swift` reuses IiS9's signed-field operations. It derives
the complete-word and middle-Pauli identities in all four control
branches, generically in the four amplitude terms of each branch.
Those branch equations can be applied independently to arbitrary
control blocks; complex linear interpretation gives the stated operator
identities and their untouched-reference extension. No probability,
norm or interpretation of an arbitrary type as a qubit follows from
the field grammar. The general CPTP classification is the proof above,
not a compiler enumeration of quantum channels. The finite checks
reject an empty complete action and unmodified middle-gap interleaving.
No hardware experiment or quantum scheduling implementation is claimed.

## §16d. An extremal joint comparison forces a cosine profile

**IiS29 (a sharp finite comparison determines its real Gram without a dimension premise).**
Let n≥3. The admitted real symmetric reading matrix G has G≥0 and
Gᵢᵢ=1 for i=0,…,n−1. Its entries refer to the same preparations and
the same comparison. Define the signed-chain score

    S(G) = Σᵢ₌₀ⁿ⁻² Gᵢ,ᵢ₊₁ − Gₙ₋₁,₀.

Equivalently, use unit vectors v₀,…,vₙ₋₁ with this real Gram and close
the chain at vₙ=−v₀. The last minus sign is a specified opposite
comparison, not a directly observable global sign of an isolated quantum
state. Then

    S(G) ≤ n cos(π/n),

and equality holds **if and only if**

    Gᵢⱼ = cos((i−j)π/n)    for every i,j.

Thus one extremal scalar reading fixes all the real pair readings on
these preparations. In particular their minimal real Gram representation
has dimension two. No two-dimensional carrier, smooth parameter,
autonomous reduced dynamics, common linear update, preassigned spatial
angles or Born probability rule was assumed. Positivity, normalization,
the actual signed incidences and attainment of the bound remain premises.
Nothing here says that an arbitrary physical process attains that bound.
If the shared nonzero self-reading is D instead of 1, apply the result
to G/D: the score bound is nD cos(π/n) and the forced entries are
D cos((i−j)π/n). The normalization is a ratio within the acquired
reading, not a universal physical constant.

*Proof.* On the finite index space, let T act by
(Tx)ᵢ=xᵢ₊₁ for i<n−1 and (Tx)ₙ₋₁=−x₀. This is a signed permutation
of the index roles, with Tⁿ=−I. Put A=(T+Tᵀ)/2. Directly,
S(G)=tr(AG). Vectors with entries exp(i(2k+1)πj/n), j=0,…,n−1,
diagonalize A with eigenvalues cos((2k+1)π/n). Its top eigenvalue is
c=cos(π/n), and its real eigenspace is spanned by the two columns of

    Fⱼ = (cos(jπ/n), sin(jπ/n)).

Since cI−A≥0 and G≥0, tr((cI−A)G)≥0, while tr G=n. Equality forces
range G into that two-dimensional eigenspace: the positive matrix
G¹ᐟ²(cI−A)G¹ᐟ² has trace zero, hence is zero. Consequently G=FMFᵀ
for some real symmetric M≥0. Its diagonal entries are

    (M₁₁+M₂₂)/2 + (M₁₁−M₂₂)cos(2jπ/n)/2
                       + M₁₂ sin(2jπ/n).

On n≥3 equally indexed positions, the three displayed functions 1,
cos(2jπ/n), sin(2jπ/n) are independent and orthogonal under the finite
sum. Requiring every diagonal entry to be 1 therefore gives M=I.
Conversely FFᵀ has unit diagonal and attains the stated bound. QED

The trigonometric coordinates diagonalize an already specified finite
incidence matrix. They were not obtained by fitting the acquired answers
and defining their control parameter with an inverse cosine. The number
n counts actual roles. Its connection to a physical angle, clock or path
length still needs a contact relation.

**Three preparations make the obstruction visible without trigonometry.**
Write a=⟨v₀,v₁⟩, b=⟨v₁,v₂⟩, c=⟨v₀,v₂⟩. Then

    3−2(a+b−c) = ‖v₀−v₁+v₂‖² ≥ 0.

At the maximum a+b−c=3/2, the residual is zero, so v₁=v₀+v₂.
The three unit self-readings give c=−1/2 and a=b=1/2. These individual
answers were not separate premises. More generally, without equal
normalization, put Dᵢ=‖vᵢ‖². Saturation of
a+b−c≤(D₀+D₁+D₂)/2 forces

    2a=D₀+D₁−D₂,   2b=D₁+D₂−D₀,   2c=D₁−D₀−D₂.

The common scale can remain unknown. Reading a ratio or a probability is
an additional question; the linear map p=(1+a)/2 is not derived by this
norm identity.

**A sharp finite-precision statement for the three-preparation case.**
If S≥3/2−ε with 0≤ε≤1/2, each signed edge t∈{a,b,−c} lies in

    1/2−√(2ε)−ε ≤ t ≤ 1/2+√(2ε)−ε.

For t=a, maximize the other two contributions at fixed v₀,v₁:
b−c=⟨v₁−v₀,v₂⟩≤√(2−2a). Writing u=√(2−2a) gives
S≤a+u=3/2−(u−1)²/2. Hence |u−1|≤√(2ε), which yields both bounds.
They are attained by choosing u=1±√(2ε) and v₂ along v₁−v₀;
the u=0 endpoint is immediate separately. Relabeling and reversing
the appropriate vectors applies the same argument to b and −c.
Thus the square-root precision cost is real, not an artifact of an
uncontrolled approximation. Error intervals in acquired comparisons
must first establish the stated lower bound on S.

**Four preparations give two unmeasured answers and a sharp error bound.**
For n=4 the score uses four of the six pair readings. At S=2√2,
the other two are forced to G₀₂=G₁₃=0. This also follows directly from

    2√2−S = [‖v₀−(v₁−v₃)/√2‖²
                    + ‖v₂−(v₁+v₃)/√2‖²]/√2.

If a certified score lower bound L satisfies 2≤L≤2√2, then

    |G₀₂|, |G₁₃| ≤ (L/4)√(8−L²).

Both bounds are separately sharp. For t=G₁₃, Cauchy–Schwarz gives
S≤‖v₁−v₃‖+‖v₁+v₃‖=√(2−2t)+√(2+2t). Squaring and rearranging
with S≥L≥2 gives the bound. Grouping the score around v₀ and v₂
instead proves the same statement for G₀₂. For attainment at a fixed t,
choose v₀ along v₁−v₃ and v₂ along v₁+v₃; the zero-sum endpoints
at |t|=1 are treated by freely choosing the unused unit vector.

For example, L=14/5 forces both unmeasured absolute readings to be at
most 7/25. Equality for G₁₃ is attained by the rational unit vectors

    v₀=(3/5,−4/5),  v₁=(1,0),
    v₂=(4/5,3/5),   v₃=(7/25,24/25).

Their signed edge readings are 3/5,4/5,4/5,3/5, and G₁₃=7/25.
This is an exact attaining construction, not a numerical fit. If each
of the four acquired edge readings has absolute error at most η, their
recorded score Ŝ supplies L=Ŝ−4η. The theorem applies only when this
lower bound reaches its stated range. A standard error alone is not
a deterministic simultaneous error bound.

**The two sharp intervals are not a joint rectangle.** Put a=G₁₃ and
b=G₀₂. For prescribed a,b∈[−1,1], the exact maximum is

    Smax(a,b)=2√(1+√((1−a²)(1−b²))).

To prove this, the ordered vector pairs X=(v₀,v₂), Y=(v₁,v₃) have
Grams A_b=[[1,b],[b,1]] and A_a=[[1,a],[a,1]]. With
D=[[1,−1],[1,1]], the score is Σᵢⱼ Dᵢⱼ⟨Xᵢ,Yⱼ⟩. Factoring the
pairs through orthonormal two-frames reduces the maximum to the sum
of singular values of M=A_b¹ᐟ² D A_a¹ᐟ². Their squares sum to
‖M‖F²=4, and their product is |det M|=2√((1−a²)(1−b²)). The
relative two-frame is a contraction, so the singular-value sum is an
upper bound; choosing its orthogonal polar factor attains it in a
common real plane. This argument also covers singular A_a or A_b by
extending the unused frame direction. Squaring the sum proves the formula.

Consequently, for 2≤L≤2√2, existence of a unit Gram with these a,b and
S≥L is equivalent to

    (1−a²)(1−b²) ≥ (L²/4−1)².

At L=14/5, |a|=7/25 forces b=0, and conversely. If |a|=|b|, each
is at most 1/5. These endpoints are attainable. Keeping the two
individual intervals but dropping this relation would admit joint
answers excluded by the same acquired score.

For general n, let P project onto the top eigenspace above, and let
γ=cos(π/n)−cos(3π/n)>0. With ε=n cos(π/n)−S and
r=tr((I−P)G), the spectral gap gives r≤ε/γ. In particular, an almost
maximal score bounds how much of this reading lies outside the
fundamental two-dimensional index profile. One explicit, not claimed
sharp, bound on the entire real matrix is

    ‖G−FFᵀ‖F ≤ (1+√n) √(2n min(n,ε/γ)).

Indeed, for E=G−PGP, blockwise positivity gives
‖E‖F²≤2(n−r)r+r²≤2nr. The matrix N=PGP−FFᵀ is supported on P,
and the same three finite Fourier components of its diagonal give
‖N‖F≤√n‖diag N‖₂. Since diag N=−diag E, the bound follows by the
triangle inequality. No statistical independence is used. Larger n
does not automatically make certification easier: γ shrinks.

No positive score tolerance forces exact rank two. For 0<δ<1,
Gδ=(1−δ)FFᵀ+δI has unit diagonal, rank n, and score
(1−δ)n cos(π/n). Its score approaches the maximum as δ approaches
zero. The preceding estimate bounds the remaining contribution; it
does not assert its absence.

**Cosine real readings do not determine complex phase.** If the source
profiles belong to a complex Hilbert space and the acquired G reads only
Re⟨vᵢ,vⱼ⟩, the conclusion above determines that real Gram. It must not
be strengthened to the full Hermitian Gram. At saturation there are
real-orthonormal profiles e,f with

    vⱼ = cos(jθ)e + sin(jθ)f,      θ=π/n,
    ⟨e,f⟩=iκ,                    −1≤κ≤1.

Using the convention ⟨x,y⟩=x†y, the full family of compatible complex
Grams is

    Hᵢⱼ = cos((j−i)θ) + iκ sin((j−i)θ).

Necessity follows by expressing the vectors in the forced real plane;
Cauchy–Schwarz gives |κ|≤1. Every κ is attained by
e=(1,0), f=(iκ,√(1−κ²)). At |κ|=1 the complex span is one-dimensional;
for |κ|<1 it has dimension two. The real comparison did not decide this
complex dimension or the rest of the physical carrier.

For n=3, the oriented closure product is

    H₀₁H₁₂H₂₀ = −(1/2+iκ√3/2)³.

At κ=0 it is −1/8; at κ=1 it is 1. More strongly, κ=±1/2 gives
the same complete real Gram **and** every overlap magnitude, yet the
closure products are (10∓9i√3)/64. Their phases differ. Thus even
these combined readings do not determine the oriented closure phase.

Without the extra magnitude readings, the ambiguity covers the entire
phase circle, for every n≥3. Write zκ=cos θ+iκ sin θ. The full
oriented cycle is

    B(κ)=H₀₁H₁₂···Hₙ₋₂,ₙ₋₁Hₙ₋₁,₀=−zκⁿ.

Here zκ never vanishes, since cos θ>0. A continuous phase lift is
Φ(κ)=π+n arctan(κ tan θ). It runs from 0 to 2π as κ runs from
−1 to 1. Thus the exact maximal real comparison is compatible with
every closure phase. Fixing |H₀₁| instead fixes |κ| through
|H₀₁|²=cos²θ+κ²sin²θ, generally retaining the sign ambiguity above.

This ambiguity has an acquisition realization inside IiS21's ideal
station-gain model. For a unit point source, use two gain configurations
gⱼ⁺=exp(−ijθ) and gⱼ⁻=exp(ijθ) with nonnegative weights p and 1−p.
Their averaged matrix is

    Hᵢⱼ=p exp(i(j−i)θ)+(1−p)exp(−i(j−i)θ),   κ=2p−1.

Every cycle before averaging is 1. Nevertheless every value of p gives
the same maximal real score, while the three-station averaged cycle
has the different phases just exhibited. A real cosine profile, even
exactly extremal, therefore cannot certify that the unresolved gain
changes preserved closure phase. This is an explicit ideal countermodel,
not a finding of this error in EHT data.

One additional scalar reading suffices within this exact family. A
calibrated relative quarter-turn Q on the actual second preparation,
Qv₁=i v₁, gives

    h = Re⟨v₀,Qv₁⟩ = −κ sin θ.

Since sin θ≠0, κ=−h/sin θ reconstructs the remaining Gram. The two
κ alternatives prove that the earlier readings alone cannot do so;
the displayed contact supplies an attaining one-query construction.
Its control relation and shared source must be available to the executor.
Calling an arbitrary new measurement a quarter-turn does not establish
them. With the real Gram exact, |δh|≤η gives |δκ|≤η/sin θ; uncertainty
in that Gram or control needs an additional bound.
This recovers the acquired Hermitian Gram. It does not undo earlier
averaging or identify the intrinsic source phase over IiS21's larger
joint family of unknown sources and instruments.
If the retained record already includes the complex entries, its imaginary
part supplies this extra reading without a fresh physical acquisition.
The worst-case one-contact bound concerns an interface initially exposing only the
real comparisons and magnitudes, with the stated quarter-turn available.

**Finite saturation still leaves unmeasured contacts free.** On the
regular grid tⱼ=jπ/n, both kernels C₀(t)=cos t and

    Cα(t)=(1−α)cos t + α cos((2n+1)t),      0<α<1,

give every same pair reading and the same maximal signed-chain score.
Both are normalized positive comparison kernels, continuous and even,
with period 2π and C(t+π)=−C(t). For the second, an explicit unit profile is

    vα(t)=(√(1−α)cos t, √(1−α)sin t,
           √α cos((2n+1)t), √α sin((2n+1)t)).

At t=π/(2n), however, Cα(t)=(1−2α)cos t. For α=1/2 the new reply
is zero while C₀(t)>0. The whole finite acquired Gram was correct;
the missing intermediate contact, not a defective old datum, separates
the realizations. A continuum claim needs further coverage or a
justified restriction on possible modes. One grid, however accurately
measured, supplies neither. This also distinguishes the forced real
plane on the acquired family from a dimension bound on every future
preparation.

**New preparations can be admitted through their actual anchor readings.**
In the exact n=4 case, e=v₀ and f=v₂ are orthonormal in the real
comparison space, with v₁=(e+f)/√2 and v₃=(f−e)/√2. For a new
unit preparation w, acquire a=⟨e,w⟩ and b=⟨f,w⟩ under the same
comparison contract. Joint positivity then gives

    w=ae+bf+r,       r⊥e,f,       ‖r‖²=1−a²−b²,
    ⟨v₁,w⟩=(a+b)/√2,            ⟨v₃,w⟩=(b−a)/√2.

The two anchor readings determine every old-to-new comparison even
when r remains unknown. The equality a²+b²=1 forces r=0; membership
in the old plane is then a conclusion. For another unit z with
anchor readings c,d, the exact possible interval is

    |⟨w,z⟩−(ac+bd)| ≤ √((1−a²−b²)(1−c²−d²)).

Cauchy–Schwarz gives necessity, and residuals with any prescribed
allowed inner product give sufficiency when their dimension is free.
If either residual vanishes, the new mutual comparison is exact.

For several new preparations the intervals are again insufficient
jointly. Put their anchor columns in a 2×m matrix A, and let K be
their proposed real comparison matrix, with Kⱼⱼ=1. The exact extension
criterion, including all comparisons to the old family, is

    R=K−AᵀA ≥ 0.

Necessity reads R as the common residual Gram. For sufficiency, factor
R as such a Gram in a space orthogonal to e,f and append those residuals
to the specified projections. For example, three zero projections
allow each separate new pair to have comparison −1. Assigning −1
to all three pairs is impossible: their residual Gram has diagonal
1 and the all-ones vector has quadratic value −3. The least additional
real dimension for a fully specified feasible K is rank R. No bound on
all future preparations follows. These extension statements concern
real readings; complex quadratures remain separate acquisitions.

The familiar alternative cos³t=(3cos t+cos 3t)/4 is itself a positive
comparison kernel, with a periodic form. On the three
preparations 0,π/3,2π/3 it gives S=3/8 instead of 3/2; its Gram
determinant is 1−3/64−2/512=243/256>0. Thus positivity and the return
symmetries admit it, while saturation excludes it on that family.

The other premises also have explicit boundaries. For n=4, dropping
joint positivity admits G=I+2A: every two-by-two principal block is
positive, but S=4 and G has a negative eigenvalue 1−√2. Valid isolated
pairs therefore do not supply the joint contract. Replacing the closing
minus by a plus instead admits the all-ones rank-one Gram with score n;
the opposite endpoint is substantive. At n=2 the two signed terms
cancel for every Gram, so no uniqueness conclusion follows. These are
failures of the proposed inference under weakened premises, not failures
of reality.

**Scope and external comparison.** Extremal correlation rigidity and
sum-of-squares self-testing are established mathematical methods; see
[Šupić et al., introduction and §3](https://arxiv.org/pdf/1511.09220) and
[Bharti et al., §III.3](https://arxiv.org/html/2104.13035).
This is an explicit finite Gram application in VI, not a priority claim
for cosine rigidity or a new Bell theorem. There is no assumed division
into two distant parties or derivation of a quantum state from Bell
statistics here. In particular, a real Gram cannot be inferred from
arbitrary separately acquired binary probability tables by naming
them comparisons. A Gram factorization such as IiS15, or an independently
established physical reading relation, supplies the positive domain.
IiS30 below classifies one finite acquisition and averaging mechanism
that supplies it, including necessary conditions on its shared weights.
Projecting an observed noisy table to the positive cone changes its
reading and requires an error bound. EHT's comparison of J and P does
not by itself establish this extremal contract.

The proof above is finite mathematics, independent of a runtime search.
No open Swift conformance named after its conclusion is used as a proof
of positivity or an inequality on unknown real readings. The result
removes a dimension premise for the acquired real question, identifies
its remaining complex ambiguity, and supplies a distinguishing contact.
It does not derive the positive reading or the Born rule from the bare
existence of a distinction.

## §16e. Which acquisition preserves a joint positive comparison?

**IiS30 (fixed pair averaging has a finite test for universal joint positivity).**
There are n≥3 channels and m≥1 acquisition indices. A record supplies
unit complex values xᵢ(k), independently free at every i,k. The proposed
processing has fixed real coefficients aᵢⱼ(k)=aⱼᵢ(k), independent of
those values, and reads

    Hᵢᵢ=1,
    Hᵢⱼ=Σₖ aᵢⱼ(k) conjugate(xᵢ(k)) xⱼ(k),     i≠j.

Assume Σₖ aᵢⱼ(k)=1 on every pair: a constant comparison is preserved.
The coefficients are not initially required to be nonnegative. The
following are equivalent:

1. H is positive semidefinite for every admitted array of unit values.
2. H is positive semidefinite on the nm arrays obtained from all +1
   records by changing just one channel at one acquisition to −1.
3. In each of those sign probes, the flipped channel has the same
   real comparison against every unchanged channel, and this answer
   is in [−1,1].
4. There are common λₖ≥0, Σₖλₖ=1, such that aᵢⱼ(k)=λₖ for
   every off-diagonal pair i,j.

*Proof.* (1) implies (2). For (2)⇒(3), flip channel i at index k. Two
other channels j,l still have Hⱼₗ=1. In a unit Gram, that forces
their vectors to coincide, hence Hᵢⱼ=Hᵢₗ, and a positive two-by-two
block bounds each real comparison by one in absolute value. For
(3)⇒(4), the actual processing gives 1−2aᵢⱼ(k) and 1−2aᵢₗ(k).
Their equality makes all weights incident to i agree at k. Apply
the same argument at each channel.
Symmetry and connectedness of the complete pair graph give a common
λₖ on all edges. The interval in (3) gives
|1−2λₖ|≤1, so 0≤λₖ≤1. Pair normalization gives their sum one.
Finally (4) gives the explicit profiles

    vᵢ=(√λ₁ xᵢ(1), …, √λₘ xᵢ(m)),     Hᵢⱼ=⟨vᵢ,vⱼ⟩.

Their Gram is positive for every unit record, including arbitrary
complex phases. This proves (1) for all those records, beyond the tested sign cases. QED

No optimization over unknown hidden carriers is needed for this
criterion. In each sign probe it is enough to check that the flipped
channel has the same reply against all the unchanged channels, and
that this real reply lies in [−1,1]. These finite equalities and bounds
already imply common weighting, and therefore universal positivity in the stated
processing class. The nm count is a sufficient test set, not a claimed
minimum. The coefficients may be unknown to the tester; their fixed
linear form, pair normalization and the actual sign preparations must
still be established. Data-dependent weighting or an unadvertised
input is outside this inference. Exact tests do not supply a tolerance
theorem for noisy or imperfectly prepared probes; the local spectral
margin below keeps their preparation relations exact.

The three-channel obstruction has an elementary determinant certificate.
For a sign probe, the principal matrix on the flipped channel and two
unchanged channels is

    [[1,r,s], [r,1,1], [s,1,1]],      det=−(r−s)².

Thus positivity forces r=s, and the two-by-two minors force |r|≤1.
The third channel removes the independent choice of two averaging
weights without adding an external controller.

**Group probes reduce the sufficient preparation count.** At index k,
flip a nonempty proper subset of the channels, leaving every other
record +1. Inside each of the two groups all comparisons equal one.
Positivity therefore makes every comparison across that cut the same
real number in [−1,1]. All crossing weights at k coincide. Assign the
n channels distinct binary labels of length r=⌈log₂ n⌉; each bit
supplies a nontrivial cut. Every pair crosses some cut, and any two
nontrivial cuts of a complete graph share a crossing edge. To see the
latter, absence of a common edge would force the second cut's labels
to agree across every pair separated by the first, hence everywhere.
The shared edges make all cut weights agree. Thus m⌈log₂ n⌉ group
preparations suffice to replace the nm individual flips in IiS30.
For n=4, (1,1,−1,−1) and (1,−1,1,−1) at each index suffice.
This counts preparations followed by acquisition of the joint matrix,
not individual pair readings. It assumes group flips are available
and claims no optimality or equal physical cost of different probes.

**A local tolerance bound retains a square-root dependence.** Suppose
a specified individual-flip matrix satisfies H≥−εI, ε≥0, while its
diagonal and the unchanged comparison Hⱼₗ=1 remain exact. Positivity
of H+εI, applied to coordinate vectors eᵢ and eⱼ−eₗ, gives

    |Hᵢⱼ−Hᵢₗ|² ≤ 2ε(1+ε),
    |aᵢⱼ(k)−aᵢₗ(k)| ≤ √(ε(1+ε)/2),
    −ε/2 ≤ aᵢⱼ(k) ≤ 1+ε/2.

The last line follows from a two-by-two principal block of H+εI.
The difference bound is sharp for this single three-channel condition:
take the displayed r,s matrix with s=−r and
r²=ε(1+ε)/2. Its eigenvalues are 2, 1+ε and −ε. This is a local
certificate, not a simultaneous optimal bound for the entire set of
probes. Errors in normalization, the unchanged comparison or actual
sign controls must enter separately; a numerical eigenvalue tolerance
alone does not establish a physical error budget.

This makes common weighting a consequence of a preservation obligation,
rather than an extra preference for a tidy data format. It does not
require a known external clock, stationary channels, independent samples
or a calibrated absolute phase. The acquisition index binds products
to actual shared records. Calling unrelated records the same index
does not create that relation.

**A false joint geometry can be manufactured from exact unit records.**
Use just two records x(1)=(1,1,1), x(2)=(−1,1,1). Read pairs 01 and
12 from the first, and pair 20 from the second. Every pair has a
normalized nonnegative weight and an exactly acquired product. Yet

    H = [[1,1,−1], [1,1,1], [−1,1,1]].

Every two-by-two principal block is positive. But for c=(1,−1,1),
cᵀHc=−3. The three-position score is 3, exceeding IiS29's positive
Gram bound 3/2. The contradiction is in treating the assembled table
as one Gram, not in any individual record or in reality. This is a
counterexample to a processing contract, not evidence of an error in
an actual astronomical pipeline.

**The unrestricted-amplitude criterion identifies the exact wider class.**
For arbitrary real or complex xᵢ(k), now let the self-readings also be
computed by the kernel. Put Wₖ=(aᵢⱼ(k)), real symmetric, and

    C(x)=Σₖ D(x(k))† Wₖ D(x(k)),

where D puts the channel values on a diagonal. Then C(x)≥0 for every
array x if and only if Wₖ≥0 separately for every k. Sufficiency follows
by positive congruence and addition. For necessity, set all records
to zero except the k-th, whose channel values are all one. The output
is exactly Wₖ.

If this processing also preserves every constant channel profile,
then ΣₖWₖ=J, the all-ones matrix. For u⊥1, positivity gives
0=uᵀJu=ΣₖuᵀWₖu, so Wₖu=0 for every k. Each Wₖ is therefore
λₖJ with λₖ≥0 and Σₖλₖ=1. Here common weights also include the
self-readings. In the preceding unit-record contract individual
diagonal weights cannot be identified this way: every |xᵢ(k)|² is
already one.

Without preservation of constant comparisons, common weights are not
necessary. Any collection Wₖ≥0 provides a positive output, with
explicit factors obtained from the Wₖ. For example, keeping only
diagonal entries always preserves positivity but discards all cross
comparisons. This is a different reading. The general factor argument
is an application of established matrix positivity and Schur products,
not a priority claim; see [Khare's account of the Schur product theorem](https://arxiv.org/abs/1910.03537).

**Missing records and the declared question matter.** In a pipeline that
uses only actually available same-index pair products, with no imputation,
a positive common λₖ requires all pairs of the declared channel family
to be available at k. Otherwise the unavailable pair has zero weight
there, and commonality forces λₖ=0. Thus, within this processing class,
using partially observed records through independent pair renormalization
cannot guarantee both an unchanged constant comparison and positivity
for every source. A smaller declared family may have usable common
records; nothing here requires discarding it because unrelated channels
were missing. Model-based completion or altered kernels are possible,
but must establish their own relation to the requested source reading.
The familiar loss of positivity under pairwise deletion is already
documented in the [R statistics manual](https://www.stat.ethz.ch/R-manual/R-devel/library/stats/html/cor.html).
The theorem concerns uncentered fixed linear product averaging, and is
not a general characterization of centered covariance estimators.

Finally, supplying positivity does not supply IiS29's extremum. If the
entire actual preparation family consists only of real sign records,
each signed cycle has product −1 and therefore at least one negative
edge. Its score is at most n−2, as is any common positive average.
That is strictly below n cos(π/n) for n≥3. The sign probes above
certify the processor on a richer unit-phase family only because its
fixed formula applies there; they do not prove that those richer
physical preparations are available. Admission of the comparison,
attainment of its bound, and extension to new preparations remain
different relations.

**A maximal average also constrains every used phase record.** In IiS30's
common positive mixture, write G=Re H=ΣₖλₖG⁽ᵏ⁾ and M=n cos(π/n).
Each G⁽ᵏ⁾ is a unit real Gram, so Sₖ≤M. If S(G)=M, nonnegative
deficits sum to zero and Sₖ=M whenever λₖ>0. IiS29 fixes every such
G⁽ᵏ⁾ to the same cosine Gram. A scalar unit-phase record is a planar
real configuration, so its only possibilities are

    xⱼ(k)=exp(iγₖ) exp(iσₖjπ/n),     σₖ∈{−1,+1}.

Indeed its first two noncollinear positions fix a real orthogonal
map from the cosine plane; that map is a rotation or a rotation with
reflection. The common phase γₖ cancels in comparisons. Consequently
the full acquired Gram has IiS29's parameter κ=Σₖλₖσₖ. The freedom
of the averaged closure phase persists even though every contributing
record is individually extremal. A deficient record cannot be hidden
by an above-bound compensating record.

More generally, if S(G)≥M−ε for ε≥0, the total weight of records with
Sₖ≤M−δ is at most ε/δ for δ>0, or one if that quotient is larger.
This is the finite inequality δΣ_bad λₖ≤Σₖλₖ(M−Sₖ)≤ε. It gives
no uniform closeness of every low-weight record and assumes the same
established nonnegative mixture.

## §16f. A positive comparison can exclude every scalar-phase mixture

**IiS31 (four channels are the first obstruction, with a sharp residual witness).**
Let Pₙ consist of matrices with a finite representation

    Hᵢⱼ=Σₖλₖ conjugate(xᵢ(k)) xⱼ(k),
    λₖ≥0,    Σₖλₖ=1,    |xᵢ(k)|=1.

The number of records and the common weights are unrestricted. Every
such matrix is positive with unit diagonal. The converse holds for
n≤3, but fails at n=4. This compares realizations of an acquired
matrix. IiS30 instead classifies processing rules which remain positive
for every input; its quantifiers do not assert the converse here.

**The four-channel witness.** Use the unit profiles

    v₀=(1,0),    v₁=(0,1),
    v₂=(1,1)/√2,    v₃=(1,i)/√2,

and let H*=Gram(v₀,v₁,v₂,v₃), with ⟨u,v⟩=u†v. The two exact
relations v₂=(v₀+v₁)/√2 and v₃=(v₀+iv₁)/√2 have zero squared
residual. In a positive scalar-phase mixture these zero residuals
would have to hold in every record of positive weight. With
z=conjugate(x₀)x₁, the first requires Re z=0, the second Im z=0,
contradicting |z|=1. Thus H*∉P₄, irrespective of the number of
hidden records. Positivity of H* itself follows from its given vectors.

The exclusion has an exact positive margin. Put

    c₂=(−1/√2,−1/√2,1,0)ᵀ,
    c₃=(−1/√2,−i/√2,0,1)ᵀ,
    Q(H)=c₂†Hc₂+c₃†Hc₃,     d=3−2√2.

Then

    Q(H)≥d    for every H∈P₄,       whereas Q(H*)=0.

For one scalar record, minimize each residual over x₂ and x₃ at
fixed x₀,x₁. Set u=Re z and v=−Im z, so u²+v²=1. The reverse
triangle inequality gives

    Q ≥ (√(1+u)−1)²+(√(1+v)−1)².

For −1≤t≤1,

    (√(1+t)−1)²=t²/(1+√(1+t))² ≥ t²/(1+√2)².

Adding proves Q≥d. The record (x₀,x₁,x₂,x₃)=(1,1,1,(1+i)/√2)
attains d: its second residual is zero and its first has squared
modulus (√2−1)². Linearity in H extends the sharp bound to all
positive mixtures. The pointwise proof also excludes arbitrary
probability distributions of scalar phases, not only finite mixtures.

**Zero residual identifies the matrix, including the unread pair.**
For any positive unit-diagonal H, Q(H)=0 implies both vector residuals
are zero. The unit norms of v₂=(v₀+v₁)/√2 and v₃=(v₀+iv₁)/√2
give Re H₀₁=0 and Im H₀₁=0. Thus v₀,v₁ are orthonormal and
H=H*, in particular

    H₂₃=(1+i)/2.

The same witness therefore has two distinct conclusions: Q<d excludes
the scalar-phase family, while Q=0 together with joint positivity and
unit diagonal identifies the full comparison matrix. It does not identify
one physical realization of that matrix.

For an inexact residual q=Q(H)≥0, a direct bound on the unread pair is

    |H₂₃−(1+i)/2|
      ≤ (2+√2)√q + (1+√2)q/2.

This constant is not claimed optimal. Put E=(v₀+v₁)/√2,
F=(v₀+iv₁)/√2, r=v₂−E, s=v₃−F, ρ=‖r‖ and σ=‖s‖;
then ρ²+σ²=q. For H₀₁=u+iv and c=(1+i)/2,

    ⟨E,F⟩=c(1+u−v),
    u−v=q−2 Re⟨v₂,r⟩−2 Re⟨v₃,s⟩,
    H₂₃−⟨E,F⟩=⟨r,v₃⟩+⟨v₂,s⟩−⟨r,s⟩.

Consequently the absolute deviation is at most
(1+√2)(ρ+σ)+q/√2+ρσ. Use ρ+σ≤√(2q) and ρσ≤q/2.
The unit-Gram bound |H₂₃|≤1 also caps the deviation by 1+1/√2.
The square-root order cannot be replaced uniformly by O(q): replacing
only v₂ of H* by exp(it)v₂ gives q=|exp(it)−1|² and deviation
√(q/2). A certified upper bound q≤ε supplies the same displayed
bound with ε, without acquiring the pair 23. Positivity and actual
unit normalization remain necessary for that prediction.

**Only five pair locations enter this witness.** With unit diagonal,

    Q(H)=4+Re H₀₁−Im H₀₁
             −√2(Re H₀₂+Re H₁₂+Re H₀₃+Im H₁₃).

The pair 23 is unused. This requires six real component readings;
no claim of minimal measurement count is made. With individual absolute
error bounds on just those components, a sufficient total error is

    B=η₀₁,R+η₀₁,I+√2(η₀₂,R+η₁₂,R+η₀₃,R+η₁₃,I).

Alternatively, let Ĥ denote acquired
values with simultaneous bounds |Ĥᵢⱼ−Hᵢⱼ|≤ηᵢⱼ on these five
complex entries. Then, keeping the true unit diagonal,

    |Q(Ĥ)−Q(H)| ≤ √2(η₀₁+η₀₂+η₁₂+η₀₃+η₁₃)=B.

For the 01 entry, the coefficient Re−Im has Euclidean norm √2;
each other selected component has the same norm. Hence Q(Ĥ)+B<d
certifies exclusion of every scalar-phase mixture. This bound concerns
actual entry errors, not unqualified standard deviations. If measured
self-readings are used instead of a known unit normalization, add
their four absolute error bounds: each diagonal coefficient of Q is
one. The measurement and normalization relations must still address
the same underlying matrix.

As one illustrative perturbation, H_t=(1−t)H*+tI, 0≤t≤1, remains positive
with unit diagonal and Q(H_t)=4t. It is excluded for t<d/4. This
is a sufficient exclusion interval from this witness, not the exact
membership threshold of the entire one-parameter family.

**Why fewer than four channels cannot have this obstruction.** For
n≤3 factor a positive unit-diagonal H as Gram(vᵢ) with spanning profiles in
Cʳ. If r≥2, the r²-dimensional real space of Hermitian r×r matrices
contains a nonzero T solving vᵢ†Tvᵢ=0 for all n profiles, because
r²>n. T has both eigenvalue signs: a semidefinite T with these zero
forms would annihilate every spanning vᵢ. Choose t₊,t₋>0 so
I+t₊T and I−t₋T are positive and singular. Their Gram matrices
still have unit diagonal and lower rank. Mixing them with weights
t₋/(t₊+t₋) and t₊/(t₊+t₋) recovers H. Repeat on each lower-rank
term. The finite recursion ends at rank-one unit-diagonal Grams,
precisely scalar-phase records. Thus every n≤3 positive unit Gram
has a finite phase mixture. In particular every three-channel
restriction of H* has such a realization, while the four restrictions
cannot all be explained by one shared mixture.

This rank argument belongs to the established geometry of extreme
correlation matrices; [Li and Tam, Theorem 1 and Corollary 2, p. 904](https://people.wm.edu/~cklixx/corr.pdf)
give the general characterization and the complex bound r²≤n for
extreme points. No priority for the four-channel threshold is claimed.
Its minimality allows arbitrary weights and record count. Fixing those
resources, or restricting the allowed phases, changes the question.

**The refused mechanism is specifically phase-only.** H* has an explicit
two-record scalar realization as soon as amplitudes may vary. Give
weight 1/2 to each record

    (√2,0,1,1),     (0,√2,1,i).

Their weighted complex Gram is H*, with every averaged self-reading
equal to one. Individual record amplitudes are not unit. Thus unit
diagonal after averaging does not establish phase-only fluctuations
before averaging. Classical vector modes also realize the four supplied
profiles. The witness is not a quantum-versus-classical test and cannot
be applied to arbitrary unknown EHT gains by normalization alone.

The finite joint matrix is also not an identified history. Under a
simultaneous rephasing vⱼ↦dⱼvⱼ, |dⱼ|=1, put D=diag(dⱼ). Then
H↦D†HD and c₂,c₃↦D†c₂,D†c₃ preserve Q. Their
relative quadratures must be supplied by the actual comparison, as
in IiS29. No absolute external phase reference is established by the
numerical form of the witness.

## §16g. A mean comparison forces hidden intensity fluctuations

**IiS32 (the scalar realization of H* has a sharp minimum intensity variance).**
Retain one common positive scalar-record acquisition

    Hᵢⱼ=E[conjugate(aᵢ)aⱼ]=H*ᵢⱼ,     i,j=0,…,3,

where E is a finite normalized nonnegative weighted sum. Amplitudes
are now unrestricted. Put Iᵢ=|aᵢ|², so E Iᵢ=1, and define the
sum of normalized intensity variances

    V=Σᵢ E[(Iᵢ−1)²].

Then the exact minimum over all such scalar realizations is

    Vmin=(√17−3)/2.

It is attained by two explicitly given records below. In particular,
the previously exhibited equal-weight records (√2,0,1,1) and
(0,√2,1,i) have V=2; they demonstrate possibility but do not minimize
the required fluctuations. The new conclusion concerns fourth moments
not contained explicitly in the mean comparison matrix. Q=0, with
IiS31's positive normalized reading, already supplies H=H* and hence
this implication for any proposed scalar realization.

*Proof.* The two zero residuals force, in every positive-weight record,

    a₂=(a₀+a₁)/√2,      a₃=(a₀+ia₁)/√2.

Let t=(|a₀|²+|a₁|²)/2. At t>0 define

    x=Re(conjugate(a₀)a₁)/t,
    y=Im(conjugate(a₀)a₁)/t,
    z=(|a₀|²−|a₁|²)/(2t).

Scalarity gives x²+y²+z²=1. The four intensities are
t(1+z), t(1−z), t(1+x), t(1−y). Therefore, with u=(x−y)/√2,

    F=Σᵢ Iᵢ²=t²[5+z²+2√2u],     −1≤u≤1.

Set s₊=√(5+2√2), s₋=√(5−2√2),
α=(s₊+s₋)/2 and β=(s₊−s₋)/2. Concavity of the square root places
it above the chord between u=−1 and u=1, so pointwise

    √F ≥ t√(5+2√2u) ≥ t(α+βu).

At t=0 every aᵢ is zero by the residual equations, and the inequality
continues as zero≥zero. The mean Gram gives E t=1 and
E(tu)=(Re H₀₁−Im H₀₁)/√2=0. Hence E√F≥α. Cauchy–Schwarz
for the normalized weights gives E F≥(E√F)²≥α². Since all four
mean intensities equal one,

    V=E F−4 ≥ α²−4=(√17−3)/2.

For attainment let ζ=(1−i)/√2, and for σ∈{+1,−1} put

    λσ=sσ/(2α),       tσ=α/sσ,
    a⁽σ⁾=√tσ (1, σζ, (1+σζ)/√2, (1+iσζ)/√2).

The weights sum to one and λσtσ=1/2. Thus the first two channels
have mean squared amplitudes one and mean mutual comparison zero;
the residual equations supply every other entry of H*. Each record
has z=0, u=σ and √F=tσsσ=α, so both inequalities are equalities.
This proves necessity and attainment over arbitrary finite record
counts. The same expectation proof holds for general probability
distributions with finite fourth moments; an infinite V cannot evade
the lower bound. QED

The variables x,y,z are derived coordinates of the two scalar
amplitudes, not an assumed physical sphere or a qubit interpretation.
The normalization makes V a sum of relative intensity variances.
If the original mean intensities Dᵢ are known and nonzero, normalize
aᵢ by √Dᵢ first; the corresponding quantity is Σ Var(Iᵢ)/Dᵢ².
The bound is tied to the particular acquired normalized Gram H*.
It is neither a universal physical constant nor a statement that each
individual channel must fluctuate by the same amount.

**A weaker finite-error bound works before full identification.** For
any common scalar acquisition with E|aᵢ|²=1, let q=Q(H). Then

    V ≥ [(√2−1−√q)₊]²/(2+1/√2),

where t₊=max(t,0). To prove it, replace each aᵢ mathematically by a
unit phase pᵢ in the same direction, choosing any phase when aᵢ=0.
Its common phase Gram lies in P₄. The residual map

    T a=(a₂−(a₀+a₁)/√2, a₃−(a₀+ia₁)/√2)

has squared operator norm 2+1/√2. In the weighted record norm,

    √d ≤ ‖T p‖ ≤ √q+√(2+1/√2)‖a−p‖,
    ‖a−p‖²=Σ E[(|aᵢ|−1)²] ≤ V.

The last inequality uses (|aᵢ|²−1)²=(|aᵢ|−1)²(|aᵢ|+1)².
Rearrange, using √d=√2−1. This is a valid but nonoptimal bound;
at q=0 the preceding sharp result is stronger. An acquired upper
bound q≤ε can replace q here. The phase replacement is a device in
the proof, not a newly assumed available physical operation.

These are predictions conditional on a scalar-record explanation.
Four fixed vector-valued profiles realize H* with constant norms and
need not have this scalar intensity variance. Thus a simultaneous
measurement below both the geometric and applicable variance bounds
would reject the shared scalar-record account or another used contact
assumption; it would not by itself identify a unique physical cause.
No intensity records or new physical experiment were acquired here.

## §16h. The residual witness has a passive implementation and an acquired calibration

**IiS33 (optimal passive scale, one extra mode, and four calibration preparations).**
Use four coherent scalar input amplitudes a∈C⁴ and the residual map

    T = [ −1/√2  −1/√2   1  0 ],
        [ −1/√2  −i/√2   0  1 ]
    M=T†T,     Q(a)=‖Ta‖²=a†Ma.

For IiS31's convention Hᵢⱼ=E[conjugate(aᵢ)aⱼ], this gives
E Q(a)=Q(H). The coefficients in each residual are a row acting on
a; this convention matters for the imaginary coefficient.

The implementation class is a fixed, single-pass, lossless linear
transformation on these four input modes and additional modes prepared
with zero field. Two selected output intensities are added with equal
unit weights. Other output modes are retained in the energy accounting.
For every input a, demand

    J(a)=κQ(a),     κ>0.

Then the largest possible scale and the least number of additional
input modes at that scale are

    κmax=1/Λ,     Λ=2+1/√2;       one additional mode.

This is a mode and scale optimum in the stated class, not an optimum
over component counts, latency, nonlinear devices, repeated passes,
or arbitrarily weighted detector readings.

**Construction and lower bounds.** Set λ=2−1/√2 and ζ=(1−i)/√2.
Direct multiplication gives

    TT† = [ 2          (1−i)/2 ],
          [ (1+i)/2     2      ]
    u₊=(ζ,1)/√2,       u₋=(ζ,−1)/√2,
    TT†u₊=Λu₊,         TT†u₋=λu₋.

Define orthonormal input directions

    w₊=T†u₊/√Λ,       w₋=T†u₋/√λ.

A four-mode unitary first extracts b₊=w₊†a and b₋=w₋†a,
and two orthonormal coordinates of ker T. An explicit kernel basis is

    k₀=(1/√2,0,1/2,1/2),
    k₁=(0,1/√2,1/2,i/2),
    g=⟨k₀,k₁⟩=(1+i)/4,
    k⊥=(k₁−gk₀)/√(7/8).

Thus rows w₊†, w₋†, k₀†, k⊥† give the required four-mode unitary.
Put ρ=λ/Λ. Couple b₋ to the extra empty input e by the lossless mixer

    d₊=b₊,
    d₋=√ρ b₋+√(1−ρ)e,
    h =−√(1−ρ)b₋+√ρ e.

The two kernel coordinates pass unchanged. At e=0,

    J=|d₊|²+|d₋|²
     =|b₊|²+ρ|b₋|²=Q(a)/Λ.

If the two specified residual amplitudes themselves are required,
apply the two-mode unitary with columns u₊,u₋ to (d₊,d₋). Its
outputs are exactly Ta/√Λ, with the same summed intensity. That
last mixer is unnecessary for the question J alone.

For necessity, the selected input-to-output block A of any allowed
unitary is a contraction. The demand for all a gives A†A=κM.
Since the nonzero eigenvalues of M are Λ and λ, κΛ≤1.
With no additional input mode, A consists of two complete rows of
a four-mode unitary, so AA†=I₂. Its two nonzero squared singular
values are both one, whereas κΛ and κλ are unequal. No positive
scale works without an extra mode in this equal-weight class.
The displayed five-mode construction attains the bound. QED

There is an exact resource tradeoff: with unequal positive reading
weights the four-mode transform alone suffices,

    Q=Λ|b₊|²+λ|b₋|².

The extra mode is needed to put the relative weight into a passive
transformation followed by an unweighted sum. Its outgoing amplitude
h is generally nonzero; the additional port is not returned empty.
No reusable empty-memory or information-erasure claim follows.

**Four preparations certify the answer without identifying the device.**
Let an otherwise unknown fixed linear passive device give
J(a)=a†Ka, where 0≤K≤I. This includes the selected outputs of a
larger unitary with genuinely empty extra inputs. Suppose the four
normalized preparations above give

    J(k₀)=J(k⊥)=0,       J(w₊)=1,       J(w₋)=ρ.

Then necessarily K=M/Λ, so the readout is correct for every a∈C⁴.
Indeed positivity makes both zero-read directions lie in ker K.
Positivity of I−K and J(w₊)=1 give Kw₊=w₊. Hermiticity then
leaves only the orthogonal direction w₋, whose eigenvalue is fixed
by its acquired reading ρ. Conversely M/Λ has these four readings.

The saturation of passivity does real work. At a smaller scale,
four diagonal readings alone need not certify the answer. If
0<κ<1/Λ, the two active eigenvalues κΛ and κλ are strictly
between zero and one. Adding a sufficiently small nonzero off-diagonal
Hermitian entry between w₊ and w₋ preserves positivity and passivity
as well as all four diagonal readings, but changes other answers.
For example choose its modulus squared below both κ²Λλ and
(1−κΛ)(1−κλ). Further superposition probes would then be needed.
No minimality over every possible calibration protocol is claimed.

**Four are necessary for pure-preparation identification in this class.**
Suppose a protocol acquires exact scalar readings v†Kv on at most
three known vectors, with no additional restriction on 0≤K≤I.
Let S be their complex span. Since S is proper, consider its nonzero
orthogonal complement. If K has a nonzero off-diagonal block between
S and S⊥, conjugate K by a unitary which is identity on S and a
nontrivial scalar phase on S⊥. The new positive contraction differs
from K and preserves every acquired reading. If that block is zero,
replace K's S⊥ block by any different positive contraction. This also
preserves the readings. Thus every such transcript leaves an alternative.
The same construction preserves a deterministic adaptive protocol's
entire transcript, since each subsequent query sees the same earlier
answers. The four displayed preparations attain this lower bound for
K₀. This is exact identification from the acquired relations, not a
claim about probabilistic tests with an allowed failure probability.

The pure-preparation restriction matters. If one admitted query can
prepare the known equal mixture of k₀ and k⊥ and return its common
averaged intensity, its zero reading forces both kernel readings to
vanish. That mixed query and the two bright queries suffice. Preparing
and joining the two mixture components is then part of that query's
resource; their cost has not disappeared.

**The four tests also give a finite-error certificate.** Assume the
true readings on those four preparations differ from their displayed
targets by at most ν≥0, including the established measurement error.
In the ordered basis (w₊,w₋;k₀,k⊥), write

    K = [ C  B  ],       K₀=M/Λ=diag(1,ρ,0,0).
        [ B† D ]

Then tr D≤2ν and ‖D‖≤2ν. From the positive principal block of
I−K,

    |C₁₂|²≤(1−C₁₁)(1−C₂₂)≤ν(1−ρ+ν).

Therefore ‖C−diag(1,ρ)‖≤e, where
e=ν+√[ν(1−ρ+ν)]. Positivity of K gives
‖B‖≤√(‖C‖‖D‖)≤√(2ν), using ‖C‖≤1. Since e≥2ν,
the block diagonal and off-diagonal parts give

    ‖K−K₀‖ ≤ Δ(ν),
    Δ(ν)=min{1, ν+√[ν(1−ρ+ν)]+√(2ν)},
    |J(a)−Q(a)/Λ|≤Δ(ν)‖a‖²   for every a.

The cap one follows because both effects are positive contractions.
This bound is sufficient, not an optimal robustness constant. It is
derived from four actual readout constraints, rather than postulating
closeness of all device coefficients. Unknown output phases and
unobserved output coordinates need not be reconstructed.

The square-root order of a uniform all-input error is unavoidable
for these four tests. Conjugate K₀ by a rotation through θ in the
plane spanned by w₊ and k₀, leaving w₋ and k⊥ unchanged. This
remains a positive contraction with the same spectrum. Its four
diagonal errors are sin²θ,0,sin²θ,0 in the corresponding order,
whereas ‖Kθ−K₀‖=|sin θ|. The two-dimensional difference has
trace zero and determinant −sin²θ. Thus ν=sin²θ permits a
√ν change in an input answer; no uniform O(ν) bound follows
from these four inexact readings alone.

Linearity, passivity, the prepared directions, the intensity scale and
one common device effect across the tests remain the admission
conditions. Finite tests do not establish arbitrary nonlinear behavior
or unrestricted future stability. With an unknown common detector gain,
the scale can instead be supplied by a simultaneous total-power
reference which is established to preserve ‖a‖²; calling two detectors
identical is not that relation. Preparation errors need their own bound.

**Exactly which unknown unitary motion leaves the answer unchanged.**
For a unitary R acting at the specified four-mode input boundary,

    Q(Ra)=Q(a) for all a
      iff R†MR=M
      iff RM=MR.

The three distinct eigenvalues Λ,λ,0 therefore give the complete
stabilizer U(1)×U(1)×U(2): arbitrary separate phases on w₊ and w₋,
and an arbitrary unitary transformation within ker T. Such motion
can change from acquisition to acquisition without changing Q or
total power on any of them. It need not preserve each residual
amplitude, each input intensity, or the full comparison matrix.
Independent phase changes of the original four channels generally
do not commute with M. The input boundary matters: an invariant
readout does not identify every internal stage with that input.

**A refusal survives unknown common amplitude changes and integration.**
Broaden the phase-only family to records aᵢ=c xᵢ, |xᵢ|=1, with
an arbitrary shared complex envelope c in each record. Put

    P=Σᵢ|aᵢ|²,       η=(3−2√2)/(4Λ).

IiS31's pointwise bound gives, including a zero-power record,

    Q(a)/Λ≥ηP,       J(a)≥max{0,η−Δ(ν)}P.

The ideal constant η is sharp by the attaining phase record in
IiS31. Summing these inequalities with any common nonnegative
weights preserves them. A positive unknown gain shared by J and P
within each record can be absorbed into those weights. Thus arbitrary
common amplitude changes need not be reconstructed to use this
refusal. They can still change the numerical integrated ratio by
reweighting different records; only the bound is guaranteed.

In the lossless five-mode construction with e=0, P is the sum of
all five output intensities. The two witness outputs alone do not
provide this total-power reading. If acquired integrated values Ĵ,P̂
have simultaneous absolute error bounds Bⱼ,Bₚ, a sufficient exclusion is

    P̂−Bₚ>0,
    (Ĵ+Bⱼ)/(P̂−Bₚ) < η−Δ(ν).

This rejects the equal-modulus scalar-record explanation under the
given contact and error conditions. A nonpositive right side provides
no such test. The integrated readings must retain their common
weights; unrelated detector histories are not covered. Q=0 by itself
also does not supply IiS31's separate unit-diagonal normalization
needed to identify H*.

**The particular refusal tolerates more error than uniform reconstruction.**
The preceding all-input deviation Δ is not required to be the only
route to the equal-modulus question. Keep the same four tests and put

    χ(ν)=ν/ρ+√[ν(1−ρ+ν)/ρ],
    γ(ν)=√[(1−χ(ν))₊],
    F(ν)=[(γ(ν)√η−√(2ν))₊]².

Then every equal-modulus scalar record satisfies

    J(a)≥F(ν)P(a).

To prove it, split a=a_L+a_N into the active plane and ker T.
For C₀=diag(1,ρ), the acquired diagonal and off-diagonal bounds give

    ‖C₀⁻¹ᐟ² C C₀⁻¹ᐟ²−I₂‖≤χ(ν),
    C≥γ(ν)² C₀,       D≤2ν I₂.

Write J(a)=‖K¹ᐟ²a‖². The reverse triangle inequality now gives

    √J(a) ≥ [γ(ν)√(a_L†C₀a_L)−√(2ν)‖a_N‖]₊
           ≥ [γ(ν)√η−√(2ν)]₊ ‖a‖.

Here a_L†C₀a_L=Q(a)/Λ≥η‖a‖², and ‖a_N‖≤‖a‖.
The square root of K is a proof device; it is not an additional
implemented operation or measured output phase. Squaring proves the
claim. This bound is sufficient, not an exact worst-case optimization.
It has F(0)=η and retains the common-weight integration and detector
error reasoning above: F(ν) can replace η−Δ(ν) in the acquired
ratio test. Taking the larger of the two valid lower bounds is also
permitted.

A fully analytic finite-error example shows the difference. At
0≤ν≤1/1000, use ρ>2/5 and η>1/65. The latter follows from
√2<17/12 and η=(3−2√2)/(8+2√2). Then

    χ(ν)<1/400+1/25<1/20,
    γ(ν)√η>√(19/1300)>3/25,
    √(2ν)<1/20,
    F(ν)>49/10000.

For the first inequality, the squared radical in χ is below
601/400000<1/625. All comparisons are rational after squaring
positive sides. Thus this calibration accuracy still forces more
than 0.49 percent of the total power into the witness outputs under
the excluded family. The true integrated output ratio, or a certified
upper bound on it, below 49/10000 suffices for refusal. At ν=1/1000
the earlier η−Δ bound is negative, since Δ≥√(2/1000)>η.
This improves a sufficient experimental margin without adding probes
or contradicting the square-root obstruction for arbitrary inputs.
It does not certify the availability of this accuracy on hardware.

**A program of acceptance conditions has a separate reachability cost.**
On one common fixed passive effect define the measured configuration loss

    L(K)=J(k₀)+J(k⊥)+[1−J(w₊)]+|J(w₋)−ρ|.

All terms are nonnegative. Hence L=0 iff K=K₀, and L≤ℓ
supplies ν≤ℓ for the four-probe bounds. The program may therefore
specify these preparations, target replies and tolerances without
specifying a unique optical matrix. The same device must underlie
the acquired four terms, or their transport to one device must be
established. L is a readout loss, not an automatically descending
physical energy or a proof that any feedback rule converges.

Its attainability already distinguishes two complete control families.
For an arbitrary lossless four-mode unitary with two equally read
outputs and no extra input, K is a rank-two orthogonal projection.
Write a=J(w₊), b=J(w₋). Since tr K=2,

    L=3−2a−b+|b−ρ|≥1−ρ.

Use a≤1 and |b−ρ|≥b−ρ. Projection onto the span of w₊,w₋
attains equality. Thus the exact minimum over this whole four-mode
family is 1−ρ>0: no improvement of its optimizer can meet L=0.
The five-mode family with one empty input has minimum zero, attained
by the explicit construction above. Extra unobserved loss channels
would change the four-mode family rather than evade its proof.

This separates a sufficient acceptance specification from the contact
resources that can reach it. Physical self-configuration through
orthogonal training fields and local feedback is an established
constructive direction; see [Miller, *Self-Configuring Universal Linear
Optical Component*](https://arxiv.org/abs/1303.4602). That design's
feedback mechanism is additional structure, not a convergence theorem
for an arbitrary device equipped with L. A specific controller and
its preparation and measurement costs remain to be realized here.

The upper power scale also cannot be manufactured from tested maxima.
For example the passive block [[2/5,1/5],[1/5,2/5]] gives 2/5
on each of two orthonormal preparations, but 3/5 on their normalized
sum. Dividing by the largest tested reading makes the two replies
one while the unseen reply becomes 3/2. It has not established
K≤I in the new units. The independent power scale used above is
therefore substantive even when the program is expressed as replies.

**Physical scope.** Lossless coherent mode transformations and their
beam-splitter/phase-shifter synthesis are an established setting; see
[Clements et al., *An Optimal Design for Universal Multiport Interferometers*](https://arxiv.org/abs/1603.08788).
The construction here specializes that setting to this witness,
derives its restricted resource optimum, and connects it to acquired
calibration and an error-tolerant refusal. It does not derive optical
linearity from distinction alone. No device has been built, no detector
noise model has been experimentally established, and no computational
speed advantage is claimed. The scalar fields and summed intensities
are a classical coherent-wave model, not individual noiseless photon
outcomes. Optical losses or nonempty auxiliary inputs require their
effect to be bounded before applying the same certificate.

## §16i. Compiling the refusal needs a smaller interface than compiling Q

**IiS34 (projection witness, minimal outputs and probes, finite local configuration).**
Retain IiS33's residual map T, active plane S=range T† and null
plane N=ker T. Write Π=Π_S. A full lossless four-mode unitary
can send S to the two read outputs and N to the other two. Its
summed read intensity is

    JΠ(a)=a†Πa=|⟨w₊,a⟩|²+|⟨w₋,a⟩|².

This is a different question from exact Q/Λ. It satisfies

    Π≥T†T/Λ,       JΠ(a)≥Q(a)/Λ.

Thus for the equal-modulus scalar family aᵢ=c xᵢ, |xᵢ|=1,
the same positive lower bound η=(3−2√2)/(4Λ) holds for JΠ/P.
Every input in N remains exactly dark. Four modes suffice without
the extra input needed for the unequal coefficients of exact Q/Λ.
This preserves a particular refusal and its null examples, not the
numerical Q reading or every future question about the source.

**Projection is pointwise maximal among passive readings with this null plane.**
If 0≤K≤I and J_K(n)=0 for every n∈N, positivity gives KN=0.
Hermiticity leaves K supported on S, where K≤I_S. Hence K≤Π.
The projection maximizes the read intensity for every input among
all passive effects retaining these exact null examples. This also
maximizes any worst-case margin over an excluded input family in
that class. The inherited number η need not be the sharp margin
of the projection for equal-modulus inputs; that stronger numerical
optimization is not asserted. Larger responses to intended inputs
outside N still need to be assessed rather than called an improvement.

**Two read modes are necessary for a strictly positive phase-family margin.**
One linear scalar output gives a rank-at-most-one effect. If it is
nonzero and dark on all N, its coefficient direction w belongs to S.
Write w=T†(α,β), so

    w₀=−(α+β)/√2,      w₁=−(α−iβ)/√2,
    w₂=α,              w₃=β.

The first two magnitudes are at most (|α|+|β|)/√2. Conversely,

    α=−[(1+i)w₀+(1−i)w₁]/√2,
    β=−(1−i)(w₀−w₁)/√2,

so |α| and |β| are each at most |w₀|+|w₁|. Thus no one of
the four magnitudes |wᵢ| exceeds the sum of the other three.
Four planar vectors with lengths lᵢ=|wᵢ| can close: the attainable
pair-sum length intervals [|l₀−l₁|,l₀+l₁] and
[|l₂−l₃|,l₂+l₃] overlap under exactly those inequalities.
Choose the two pair sums to have the
same length and opposite directions. Therefore unit phases xᵢ can
be chosen with w†x=0.

Every such one-output readout has an equal-modulus input which is
also dark; it cannot give a uniform strictly positive separation.
The rank-two projection does separate, so two scalar intensity modes
are minimal in this single-pass class with all N retained as null.
Extra empty input ports do not remove the rank-one obstruction.
This is not a lower bound for every adaptive experiment or for a
detector which already combines several orthogonal modes.

**Two pure null preparations identify the projection in the admitted class.**
For a full four-mode unitary and two equally read outputs, the
unknown K is a rank-two orthogonal projection. Acquiring

    J(k₀)=J(k⊥)=0

puts both orthonormal preparations in ker K. Its kernel dimension
is exactly two, so ker K=N and K=Π. In this class one pure
preparation cannot identify Π: for any probe v, choose unit
r∈S∩v⊥ and n∈N∩v⊥. Both intersections are nonzero. A
nontrivial rotation in span(r,n) fixes v, conjugates Π into a
different rank-two projection, and preserves the acquired reading.
Thus two pure scalar-reading queries are necessary and sufficient
for this exact calibration. IiS33's four-query lower bound was for
the larger class of all positive contractions.

The structural admission is substantive: under mere passivity K=0
passes both null tests. Losslessness of the complete four-mode
transformation and the calibrated meaning of power are not proved
by its two dark outputs. A known mixed preparation supported on N
can also combine the two tests into one acquired average, with the
mixture's preparation and common acquisition counted separately.

**Two inexact null probes bound both sides of the discrimination.**
Let δ≥0 bound the sum of the two true null readings. For δ<1,
write the rank-two projection K in S⊕N blocks C,B,D. Positivity,
K≤I and tr K=2 give

    tr D≤δ,       0≤D≤δ I_N,
    tr(I_S−C)=tr D≤δ,       C≥(1−δ)I_S.

For a=s+n, define p=‖s‖²/‖a‖² when a≠0. Since K is a
projection, √J=‖Ka‖. The reverse triangle inequality gives

    J(a)/P(a) ≥ [ (√((1−δ)p)−√(δ(1−p)))₊ ]².

The expression before clipping increases with p. Therefore, on the
equal-modulus family,

    J/P ≥ B(η,δ),
    B(η,δ)=[(√((1−δ)η)−√(δ(1−η)))₊]².

It is positive exactly when δ<η. The geometric bound based only
on p≥η and leakage at most δ is sharp. The exact phase-family
minimum μ, derived below, is larger than η and sharpens this use
of the bound. To attain the
geometric bound when δ≤η, select unit s∈S,n∈N, take
a=√η s+√(1−η)n, and rotate just that S,N pair so its measured
direction is √(1−δ)s−√δ n. Retain the other S direction.
The null leakage is δ and the displayed lower bound is equality.
If δ≥η, a rotation with leakage η≤δ makes this a dark.

For every intended input a∈N the same calibration gives J/P≤δ.
More generally if p≤ε, then

    J/P≤min{1,(√ε+√δ)²},

by the triangle inequality, ‖Ks‖≤‖s‖ and ‖Kn‖≤√δ‖n‖.
This explicitly accounts for departures of an intended input from
the null plane; the effect on such inputs is not inferred from the
excluded-family bound alone.

If each null probe is at most ν=1/1000, take δ≤1/500. An
analytic conservative margin is

    intended N:          J/P≤1/500,
    equal-modulus family: J/P>3/500.

Indeed η>1/65 gives √((1−δ)η)>123/1000, whereas
√(δ(1−η))<9/200. The difference exceeds 39/500 and its
square exceeds 3/500. These are rational comparisons after squaring.
Consequently an additional certified absolute error at most 1/1000
in the final ratio still leaves the two classes on opposite sides
of the threshold 1/250: measured ratios are at most 3/1000 for
N and greater than 5/1000 for the equal-modulus family. This is
a sufficient error budget, not a statement about available detectors.
Inputs outside both classes are not automatically classified.

The bounds pass to commonly weighted nonnegative acquisitions,
including an unknown positive gain shared by J and total power
within each record. Error bounds and input preparation remain tied
to those same acquisitions. The ratio's full-power reference must
include the other two outputs or be independently established.

**The exact equal-modulus margin of this projection.** The preceding
η bound follows from a different quadratic witness. For Π itself,
the sharp answer over the entire equal-modulus family is

    μ = min_{|xᵢ|=1} ‖Πx‖²/4 = 1/2 − √(10+√2)/7 > 0.

Here is an analytic maximization of the complementary null-plane
power; no phase grid or numerical search is needed. Write

    V = [ 1       0   ],       N=range V,
        [ 0       1   ]
        [ 1/√2    1/√2]
        [ 1/√2    i/√2]
    a₊=1+1/√2,  a₋=1−1/√2,
    Λ=1+a₊,     λ=1+a₋,     ζ=(1−i)/√2.

V†V has eigenvalues Λ,λ with eigenvectors (1,ζ),(1,−ζ).
Consequently n₊=V(1,ζ)/√(2Λ) and n₋=V(1,−ζ)/√(2λ)
are an orthonormal basis of N. Rephase all four coordinates by
D=diag(1,conjugate(ζ),exp(iπ/8),exp(−iπ/8)). This preserves
the set of unit-modulus inputs, and gives

    Dn₊=(1,1,√a₊,√a₊)/√(2Λ),
    Dn₋=(1,−1,i√a₋,−i√a₋)/√(2λ).

Parameterize the two pairs of coordinates of y=Dx by

    (y₀,y₁)=exp(iα)(exp(iβ),exp(−iβ)),
    (y₂,y₃)=exp(iγ)(exp(iε),exp(−iε)).

Set u=cos²β and v=cos²ε. Maximizing the relative phase α−γ
in |⟨Dn₊,y⟩|²/4+|⟨Dn₋,y⟩|²/4 gives exactly

    f(u,v)=1/2+(h/2)(v−u)+√R,
    R=q uv+r(1−u)(1−v),
    h=2√2/7,  q=(10+√2)/49,  r=(10−√2)/49.

Every u,v in [0,1]² and its maximizing relative phase are
available. On the open square R>0 and

    det Hess f = −(q+r)qr/(4R²) < 0.

Thus no interior point is a local maximum. To verify the derivative
identity, use Rᵤ=(q+r)v−r, Rᵥ=(q+r)u−r and
RᵤRᵥ−(q+r)R=−qr; the affine part of f has zero Hessian.
On u=0 or v=0 the maximum is at (0,0), since √r>h.
On u=1 or v=1 the maximum is at (1,1), since √q>h.
These inequalities follow from h²=8/49<r<q. Since q>r,
the full maximum is f(1,1)=1/2+√q. Subtracting it from
one proves the displayed μ.

An attaining phase input is

    x*=(1, ζ, (1+ζ)/√(2a₊), (1+iζ)/√(2a₊)).

Equivalently x*=(1,exp(−iπ/4),exp(−iπ/8),exp(iπ/8)).
Each coordinate has modulus one, Dx*=(1,1,1,1), and direct
projection gives null power fraction (1+√a₊)²/(2Λ)=1/2+√q.
For a simple rational enclosure μ>1/58: √2<17/12 and
137/12<(98/29)² imply √(10+√2)<98/29. The earlier η is
less than 1/60, since that inequality reduces to √2>86/61,
which follows by squaring. Thus μ>1/58>η. By the pointwise Loewner
optimality above, μ is also the largest uniform equal-modulus
margin among all passive effects retaining the whole of N as null.
This is optimality under that null contract, not under every possible
measurement or every possible excluded family.

**A sharp calibration boundary for this one scalar decision.** Replace
η by μ in the two-probe estimate. For 0≤δ<1 the exact worst-case
equal-modulus response, over all rank-two projections with total
null leakage at most δ, is

    B(μ,δ)=[(√((1−δ)μ)−√(δ(1−μ)))₊]².

The lower bound was proved above. It is now attained by an actual
member of the excluded family: write x*/2=√μ s+√(1−μ)n
with unit s∈S and n∈N. For δ≤μ let K project onto
√(1−δ)s−√δ n and a unit vector s₂∈S orthogonal to s.
Its total null leakage is δ and its response on x*/2 is the
displayed value. If δ≥μ, use the same construction with leakage
μ; it makes x*/2 dark while meeting the stated upper bound.

The intended family N has response at most δ. Therefore a single
uniform threshold separates the two families for all devices
allowed by this aggregate certificate exactly when

    δ < δcrit = (1−√(1−μ))/2.

Indeed B(μ,δ)>δ is equivalent to this inequality; on the positive
branch, take square roots and use
μ=(1−√(1−μ))(1+√(1−μ)). At equality the attaining device
gives the same response δ on the excluded input x*/2 and on
the intended input n. For δcrit≤δ<μ its restriction to N
has eigenvalues δ,0, so an intended input has response B(μ,δ)
as well. For δ≥μ both families can have response zero in one
admissible device. Thus beyond the boundary even an arbitrary
decoder of this sole final power fraction cannot always distinguish
the families. The obstruction can occur in the same device, not
just in two differently calibrated devices.

This boundary uses the sum of the two calibration readings. A
decoder retaining additional individual readings, preparations or
subsequent contacts has a different information contract. If the
final power fraction has certified absolute error at most e, the
strict uniform-threshold condition becomes B(μ,δ)−δ>2e.
That last statement is a worst-case bounded-error guarantee, not
a statistical model of the detector.

**A finite controller under explicit local contacts.** Admit an arbitrary
unknown fixed four-mode unitary U, repeatable orthonormal training
inputs k₀,k⊥, intensity readings at the needed individual output
modes, and available lossless two-mode controls acting on any of
the five pairs listed below. Controls can be set, probed, and returned
to their preceding setting. Their action, not their absolute optical
phase, is known:

    G(c,s,φ) = [ c             exp(iφ)s ],
               [ −exp(−iφ)s  c        ],
    c,s≥0,      c²+s²=1.

For any unknown pair of scalar output amplitudes x,y, three probe
settings acquire the needed local relation. In the identity setting
read A=|x|² and B=|y|². In balanced settings c=s=1/√2 read
the first-output powers P₀ and Pπ/2 at phases 0 and π/2. Then

    z=conjugate(x)y,
    Re z=P₀−(A+B)/2,
    Im z=(A+B)/2−Pπ/2.

When A,B>0, choose

    c=√[B/(A+B)],       s=√[A/(A+B)],
    exp(iφ)=−conjugate(z)/√(AB).

Scalar coherence gives |z|²=AB. Substitution yields
c x+exp(iφ)s y=0, while the second output retains power A+B.
If A=0, use the identity; if B=0<A, use c=0,s=1 with any φ.
If both vanish, no operation is needed. The rule depends only on
the acquired local intensities and their relative quadrature. Unknown
common input phase on a repeated training launch cancels from them.
An unaccounted gain change between the settings does not cancel.

Designate output modes 0,1 as the final read pair. Starting from
the actual unknown U, use the nulling operation in this order:

    training k₀:  (0,3), (1,3), (2,3);
    training k⊥: (0,2), (1,2).

The first three operations put all of Uk₀ in output 3; previously
zeroed coordinates are not touched again in that stage. Unitarity and
orthogonality then force the transformed k⊥ to have zero component
at output 3. The last two operations act only on modes 0,1,2,
preserve the first training result and put k⊥ in output 2. Both
training inputs now have zero power in the read pair, so the final
effect is Π. This proves termination after at most five committed
nulling rotations for every initial U under the stated ideal contacts.

The routing proof uses only orthonormality of the two training
inputs. The same pair schedule and local rule therefore configure
the projection onto the orthogonal complement of any supplied
orthonormal pair in C⁴. Different training fields can specify
different readouts without a different controller algorithm. A positive
phase-family margin for each new null plane still needs its own
proof; the specific margin and one-output obstruction above are
not inferred from arbitrary orthogonality alone.

At most fifteen training probe settings determine those rotations;
each identity setting acquires two intensities, and each balanced
setting the indicated intensity. Setting, restoring and physically
holding the controls is additional work. Two final null acquisitions
then check the retained device. The two-query minimum for a fixed
device's certificate is not the total cost of obtaining that device.
Training uses repeatable prepared signals, not free copies of an
unknown working input. Access to individual training-output powers
is stronger than the final two-output sum and is counted as a
controller resource. No minimality of the controller's count is claimed.

With control or measurement error, the five-step exact proof is not
a guarantee of achieving any prescribed tolerance. The final two
acquisitions instead give the δ certificate above for the device
actually reached, provided it remains in the projection class.
Unbounded drift during or after training requires a new relation;
successful acquisition on a previous device does not transfer itself.

This is progressive configuration by local intensity contacts, within
the established direction of [Miller's self-configuring optical
components](https://arxiv.org/abs/1303.4602), specialized to a sufficient
readout rather than a specified full unitary. No new physical apparatus
or priority for optical self-configuration is claimed. The admitted
local controls, preparations and classical feedback calculations remain
part of the implementation. What has been supplied is a finite
constructive route from the accepted relations to the target readout,
with a separate certificate for the device's acquired tolerance.

**Four committed rotations suffice when the whole null plane is trained.**
The five-step controller also fixes the individual training vectors'
destinations, which the projection question does not require. With
common acquisitions of the known uniform mixture on N, the same
available two-mode contacts permit a shorter retained program.

On any triple of current output modes, acquire its 3×3 coherency
matrix C from that mixed training input. One identity setting reads
its three diagonal powers; balanced settings with phases 0 and π/2
on each of the three pairs read its off-diagonal entries. With
Cᵢⱼ=⟨xᵢ conjugate(xⱼ)⟩, these readings are

    Re Cᵢⱼ=P₀−(Cᵢᵢ+Cⱼⱼ)/2,
    Im Cᵢⱼ=Pπ/2−(Cᵢᵢ+Cⱼⱼ)/2.

Each temporary setting is restored before the next acquisition.
The mixture has two known orthogonal constituents and the current
transformation is fixed and linear, so C is positive with rank at
most two. Choose a normalized v∈ker C. The row v† gives
zero average power, hence zero on both training constituents.
For exact nulling, any positive training mixture with full support
on N suffices; uniform weights are used below for the explicit
tolerance and preparation-cost bounds, not to create the kernel.
This kernel is constructively available from C: at rank two use a
nonzero column of its adjugate; at rank one project a coordinate
vector off a nonzero column's span; at rank zero choose any
coordinate vector. Normalization and branch selection are part of
the classical controller, not unmeasured properties of the source.

Any normalized three-component row (a,b,c), up to an irrelevant
common phase, is the first row of two permitted G rotations.
Take a≥0 by that common phase, put t=√(|a|²+|b|²), and
first mix modes (first,second) with cosine a/t and complex sine
b/t, then (first,third) with cosine t and complex sine c.
The resulting row is (a,b,c). If t=0, take the first rotation
as identity and swap into the third mode. Zero sine coefficients
need no assigned phase.

Apply this construction first to modes (0,2,3), using committed
pairs (0,2),(0,3). The whole trained plane now has zero component
at output 0. Repeat on modes (1,2,3), using (1,2),(1,3). Output
0 is untouched and output 1 becomes zero on the whole plane.
Unitarity then identifies the two-read-output effect as Π, without
requiring k₀ and k⊥ to occupy individually named remaining outputs.
This works for every initial U and for every supplied orthonormal
training pair.

Four is also the minimum worst-case number of such committed
contacts. The possible two-dimensional complex planes in C⁴ have
an eight-real-dimensional open chart: the graphs of arbitrary
complex 2×2 matrices near zero. A fixed word of at most three
G contacts has at most six real continuous parameters. Its smooth
image in the space of planes has no eight-dimensional open set.
For example, covering a compact six-dimensional parameter region
by O(ε^−6) small boxes and using the smooth map's Lipschitz
bound gives total eight-dimensional covering volume O(ε²),
which tends to zero. There are only finitely many pair choices for
words of length at most three, so their union cannot cover the
chart. Inverses are also permitted G contacts. Thus some initial
planes cannot be returned by three contacts even if completely
known. Adaptive acquisition does not enlarge this set of retained
words. This proves the lower bound, matched by the construction.

The exact resource statement is four committed two-mode rotations,
with no free extra phase screens, multi-mode controls or irreversible
resets. A probe rotation that is not restored belongs to the retained
word and must be counted. Acquisition is a separate cost: the
construction above uses at most fourteen mixed probe settings,
seven per triple, followed by final calibration. Realizing every
mixture by two separate pure launches uses up to twenty-eight
launches before final checks. Therefore fewer committed contacts
does not establish lower total acquisition time or energy than the
five-rotation pure-training controller. At finite errors, the retained
device must still meet an acquired tolerance; the ideal kernel
branches alone do not establish noisy-controller convergence.

There is nevertheless a finite robust guarantee when errors are
bounded in the acquired relations. Write r=dim N (r=2 here;
the same notation applies to the extension below). At stage i let
Cᵢ be the true local coherency matrix and let its Hermitian estimate C̃ᵢ satisfy
‖C̃ᵢ−Cᵢ‖≤eᵢ. Choose a normalized vᵢ whose estimated
Rayleigh quotient is at most λmin(C̃ᵢ)+tᵢ, where tᵢ≥0
is a certified solver tolerance. Since λmin(Cᵢ)=0,

    vᵢ†Cᵢvᵢ≤2eᵢ+tᵢ.

This follows directly from the two Rayleigh-quotient error bounds;
it does not require a nonzero spectral gap or a stable kernel vector.
If the actual implemented normalized row differs, up to a common
phase, from vᵢ† by norm at most kᵢ, then its mixed training
power is at most

    pᵢ≤(√(2eᵢ+tᵢ)+kᵢ/√r)².

Here the uniform rank-r training mixture gives Cᵢ≤I/r.
Assume the implemented rotations remain unitary and confined to
their admitted mode pairs. Later stages leave already processed
read modes untouched, so their contributions accumulate without
reintroducing that power. The final total null leakage obeys

    δ≤r Σᵢ (√(2eᵢ+tᵢ)+kᵢ/√r)².

For the four-mode case with exact row synthesis and solver,
δ≤4(e₀+e₁). If every acquired diagonal and balanced power
has absolute error at most ν, the explicit reconstruction gives
diagonal errors at most ν and off-diagonal errors at most
2√2ν. The maximum absolute row sum therefore yields
eᵢ≤(1+4√2)ν, and consequently

    δ≤8(1+4√2)ν.

Together with B(μ,δ) this is a finite conditional accuracy
guarantee for the four-rotation controller, beyond a check
after an unspecified search. The small-matrix solver, repeated
preparations, power error bounds and pair-local unitary control
errors are substantive resources. Unbounded drift or leakage into
other mode pairs is not covered by kᵢ. Independent final admission
can verify the reached device and can be sharper than this worst-case
propagation bound.

The construction and lower bound extend to a proper r-dimensional
trained null subspace in Cᵈ. Let m=d−r outputs be read, leaving
r fixed unread modes. For each read mode, acquire the coherency
matrix on that mode together with the r unread modes from the
uniform null-subspace mixture. It has rank at most r. A kernel
row of length r+1 can be implemented by r successive G rotations
between that read mode and the unread modes, zeroing the whole
trained subspace there. Explicitly, for a normalized row (a₀,…,a_r)
with a₀≥0, set t_j=√(Σ_{l=0}^j |a_l|²). At step j use
cosine t_{j−1}/t_j and complex sine a_j/t_j when t_j>0;
if t_j=0 use identity. Induction gives the normalized prefix row,
and t_r=1 gives the required final row. Subsequent stages never touch earlier read
modes. The resulting exact retained count is

    r(d−r).

The complex Grassmann chart has 2r(d−r) real dimensions, so
the preceding dimension argument forbids a smaller universal count
of these two-parameter contacts. This is an exact worst-case
control count, under availability of the required pairs and without
free extra controls. Direct pairwise coherency acquisition as above
uses at most (d−r)[1+r(r+1)] mixed probe settings. If a mixture
is implemented by r pure launches, that cost is multiplied by r.
The program can therefore minimize retained rotations while being
far from optimal in total acquisition resources. Neither this
Grassmann-space bound nor the controller asserts a new physical
law or priority for subspace elimination by plane rotations.

## §16j. A power certificate and a coherent continuation

**IiS35 (The downstream question determines whether a local power
certificate composes).** Let A:X→Cᵐ be a finite linear amplitude
map with K=A†A≠0. Suppose acquisition identifies K, while the
output coordinate frame of A remains unspecified. A subsequent
passive reading has a known effect 0≤E≤I on Cᵐ. The complete
reading on x is

    J_E(x)=x†A†EAx.

Every UA with U unitary has the same local power effect K.
Conversely, every other map A′ into the same Cᵐ with A′†A′=K
has this form: Ax↦A′x is a well-defined isometry of the two
image spaces and extends to a unitary of Cᵐ.

For a fixed x with q=x†Kx, the possible composite readings over
this entire compatible family form exactly the interval

    [λmin(E)q, λmax(E)q].

For q=0 the interval is {0}. Otherwise UAx runs through the
sphere of squared norm q. Rayleigh quotients reach both eigenvalue
extremes and every intermediate value, by superposing orthogonal
extremal eigenvectors with the required nonnegative squared weights.
Consequently K determines this downstream reading for every input
and every freely compatible output frame if and only if E is scalar.
The excluded K=0 case determines zero for every E.

If only a smaller family G of output changes is admitted, the exact
criterion is instead

    A†(U†EU−E)A=0       for every U∈G.

When the image Y₀=range A is invariant under G and A maps onto
Y₀, this is equivalently invariance of E compressed to Y₀ under
the restricted group action. A commutant criterion without those
range conditions would be stronger than the pullback condition.
This is an instance of VI's continuation-scoped sufficiency, already
present in IiS7, IiS10 and VC35, here with the complete compatible
answer interval for a power-calibrated physical module.

**The projection controller supplies a concrete full-range failure.**
Keep its two working output amplitudes available to a subsequent
linear optical element. During calibration they may be measured
on repeatable training launches; this is not a proposal to recover
coherence after destructive detection of the working signal. Put

    A₀=[w₊†; w₋†],      A₁=X A₀,
    X=[0 1; 1 0],       E=[1 0; 0 0].

Both A₀†A₀ and A₁†A₁ equal Π. Both pass every local test
of their total two-output power, including the two null preparations.
For the same input w₊ the continued readings are respectively
one and zero. The new question concerns a selected coherent
output direction, which the former sum-of-powers certificate left
undetermined. There is no error in that former certificate.

**One joint bright preparation certifies the needed branch.** In this
two-output class A†A=Π implies AA†=I₂. Let the subsequent
analyzer read E=ee† for a normalized output direction e. Then

    A†EA=zz†,       z=A†e∈S,       ‖z‖=1.

For a desired unit w∈S, one acquired composite reading
J_E(w)=1 forces |z†w|=1 and hence zz†=ww†. This proves
the complete continued reading |w†x|² for every input x, without
identifying A or its other output direction. Zero additional readings
cannot suffice in general, by the A₀,A₁ example. Thus one joint
scalar reading is necessary and sufficient after the local effect
has been identified, within this admitted analyzer class.

There is also a local route to obtain the bright condition. Apply
the IiS34 two-mode acquisition and rotation to the normalized field
Aw, routing it to e (with a known final relabeling if needed).
This uses at most three probe settings for that two-mode contact,
then one joint verification at the retained setting. No inference
from the number of verification queries to the total training cost
is made. For an inexact joint reading at least 1−ε, the two
rank-one effects obey

    ‖zz†−ww†‖=√(1−|z†w|²)≤√ε.

The equality follows from the two eigenvalues in span(z,w).
It bounds the normalized response error on every input, conditional
on the earlier exact projection-class admission.

For a final single coherent scalar output there is an even shorter
whole-device certificate. Any passive linear cascade ending in that
output has an effect zz† with ‖z‖≤1, regardless of its internal
factorization. A unit input w giving output power one forces
zz†=ww† directly. No separate calibration of its internal stages
is required for that one final question. A reading at least 1−ε
still implies ‖zz†−ww†‖≤√ε: writing t=‖z‖² and
r=|z†w|², the norm is

    [1−t+√((1+t)²−4r)]/2,

which is nondecreasing with t on r≤t≤1 and is at most √(1−r).
The normalized-input and calibrated passivity conditions matter.
An unresolved sum over several scalar modes is not a rank-one
effect on the basis of its appearance on one detector alone. This narrower
one-direction question does not replace IiS34's two-mode readout,
which separates a whole equal-modulus family and has a one-mode
obstruction.

A coordinated change A↦UA, E↦UEU† leaves A†EA unchanged.
Thus preserving the joint reading can allow both parts to change.
An independent change of A with E held fixed need not do so.
The relation between the changes must be established by the actual
contact or by renewed joint acquisition; writing a conjugation formula
does not make that acquisition free.

## §16k. Replacing device admission by acquired support relations

**IiS36 (Two mixed preparations identify a projection among all
passive effects, with dimension-dependent tolerance).** Let N and S
be orthogonal complementary subspaces of dimensions d_N,d_S>0.
The input space and their preparations are admitted; the unknown
device is only required to have a positive contraction K on that
space. Unlike IiS34's two pure null tests, no rank or complete
lossless implementation is assumed. Supply the known mixed inputs

    σ_N=Π_N/d_N,       σ_S=Π_S/d_S.

They mean actual commonly weighted preparations with a calibrated
normalized power reading, not labels attached to unrelated records.
The two acquired numbers

    j_N=tr(Kσ_N)=0,       j_S=tr(Kσ_S)=1

force K=Π_S. Positivity makes a zero quadratic expectation a
kernel relation: K annihilates N. Applying the same argument to
I−K and σ_S makes K the identity on S. This proves the
claim on the whole input space. Losses and extra unread ports are
allowed by the positive-contraction class; the bright condition tests
the needed transmission instead of inferring it from a dark output.

Two such scalar expectation queries are minimal when arbitrary
known density matrices may be prepared. For any single preparation
σ, put p=tr(σΠ_S). The different contraction pI gives the same
answer. This includes p=0 and p=1, since Π_S is nontrivial.
The count is of mixed expectation queries. Preparing a uniform
mixture over d_N or d_S independent directions, or estimating it
from separate pure launches, is a real resource and is not counted
as one elementary event by this statement.

If a further admission tr K≤d_S is established, one bright mixed
query j_S=1 suffices. It fixes K=I on S, already using the
entire trace budget; positivity leaves no response on N. For a
passive map into d_S scalar output modes the budget follows from
AA†≤I_{d_S}. Common nonnegative averages of such effects
preserve the budget even when their average has a larger rank.
The count concerns scalar coherent modes in the admitted model,
not the number of detector packages. This admission is weaker than
complete losslessness or a fixed projection rank.

With j_S≥1−ν and δ=d_Sν<1, the same argument gives
tr D≤δ and C≥(1−δ)I_S, writing K in S⊕N blocks C,B,D.
Thus IiS34's B(μ,δ) bound,
intended upper bound δ and their sharpness all apply in the
four-mode case. Equivalently, two orthonormal pure bright probes
with summed deficit at most δ supply that average. A dark probe
and a bright probe do different work under a trace budget: the
bright one can acquire the useful transmission instead of assuming
the complete device is lossless.

For bounded errors j_N≤ν_N and 1−j_S≤ν_S, write K in
S⊕N blocks C,B,D. With

    a=min{1,d_Nν_N},       b=min{1,d_Sν_S},

the trace bounds give D≤a I_N and C≥(1−b)I_S. Hence for
an input with active power fraction p=‖Π_Sx‖²/‖x‖²,

    J(x)/P(x)≥[(√((1−b)p)−√(a(1−p)))₊]²,
    x∈N implies J(x)/P(x)≤a.

Use the reverse triangle inequality on K^(1/2)x for the lower
bound. For IiS34's excluded family one can substitute p≥μ;
the expression is increasing in p. These are sufficient tolerance
bounds in the larger passive class. In the matched case a=b=δ,
they give precisely B(μ,δ) and the intended upper bound δ.
The rotated projections constructed in IiS34 belong to this larger
class and attain both the lower bound and its indistinguishability
witnesses. Thus δcrit is sharp here too under the two matched
trace bounds. This transfer has a new proof and an additional
bright acquisition; it is not inferred from the two dark readings.

The uniform mixture is minimax for converting this kind of scalar
error to a worst-direction guarantee. For any full-support density
matrix σ on a d-dimensional subspace, tr(Dσ)≤ν implies
D≤(ν/λmin(σ))I. A rank-one D on a least-weight eigenvector
attains that conversion, up to the contraction cap. Since
λmin(σ)≤1/d, no choice improves the worst coefficient d;
σ=I/d attains it. If σ has deficient support, one direction is
completely untested. Thus the exact number of mixed query types
can remain two while the necessary accuracy and preparation support
scale with dimension. Two displayed averages are not a
dimension-independent certificate at a fixed error tolerance.

**Uniform attenuation changes the exact acquisition minimum.** Fix
a proper rank-r projection Π_S and a target K₀=γΠ_S with
0<γ<1. In the class of all positive contractions, exactly r²+1
scalar expectation queries with freely chosen known mixed inputs
are necessary and sufficient to identify this target effect. The
lower bound holds even if γ is supplied and queries are chosen
deterministically from earlier answers.

For sufficiency use one full-support mixed input on N to acquire
zero, forcing K to annihilate N. On S choose r² normalized
pure preparations whose projectors span the real vector space
Herm(S). For an orthonormal basis eᵢ, one explicit choice is eᵢ
and, for each i<j, (eᵢ+eⱼ)/√2 and (eᵢ+i eⱼ)/√2.
Acquiring γ on every one fixes all diagonal entries to γ and
all off-diagonal entries to zero. It also acquires γ if that scale
was initially unknown.

For necessity, fix the transcript produced by K₀ for at most r²
queries σ₁,…,σ_m, and restrict their linear measurement map
to Herm(S). If this restriction has a kernel, take a nonzero
Hermitian Δ in it. For sufficiently small nonzero ε,
K₀+εΔ is another positive contraction with exactly the same
answers; γI_S is strictly inside the positive-contraction interval
on S. If instead the restriction is injective, then m=r² and
it is an isomorphism onto R^m. Choose Δ∈Herm(S) solving

    tr(σⱼΔ)=−tr(σⱼΠ_N)      for all j.

For sufficiently small ε>0,

    K′=γΠ_S+εΔ+εΠ_N

is again a positive contraction with the same transcript. Its null
block is now εI_N, so it differs from the target. Adaptive choices
do not avoid the witnesses: retaining all answers along the target
transcript retains the same later choices. This proves necessity.

In the four-mode rank-two case the exact minimum is therefore
five, whereas the unattenuated projection needs only two mixed
queries. The discontinuity is in exact identification: saturation
of the known upper bound supplies relations that an interior
transmission γ does not. At nonzero tolerances the earlier direct
question bounds can still be useful; five is not a lower bound
for every sufficient family-separation task. Normalizing one bright
reading to itself cannot establish isotropic transmission on all of S.
The same r²+1 count and face-based mechanism already appear for
identifying a fixed rank-r state by POVM outcomes in [Carmeli,
Heinosaari, Schultz and Toigo, §5.2](https://arxiv.org/pdf/1611.04388).
Their normalized-state/outcome contract and this unknown-effect/
positive-probe contract are different; the explicit proof above
establishes the latter and its contrast with γ=1. POVM outcome
probabilities also satisfy a normalization relation, so their count
is not interchangeable with independent scalar probe queries. The broader role
of positivity is also studied by [Kalev, Kosut and Deutsch](https://www.nature.com/articles/npjqi201518).
This is a scoped application and comparison, not a claim of priority
for the r²+1 count or for the geometry of certification.

**A surviving-power denominator changes the acquired relation.**
The preceding admission uses power relative to the input norm, or
an independently established equivalent reference. Suppose instead
that only a selected fraction of the surviving output power is read:

    j_G(x)=x†Kx/(x†Gx),       0≤K≤G≤I.

Here G describes all retained output power, including the unread
part. For mixed preparations the corresponding ratio is
tr(Kσ)/tr(Gσ); it is the ratio of the acquired powers, not an
unweighted average of per-launch ratios. Assume both training
denominators are positive. The same extreme ratios on σ_N and
σ_S then force exactly

    K=G_S⊕0_N,       G=G_S⊕G_N,

where the first block refers to S. Zero on N annihilates N for K;
one on S annihilates S for the positive operator G−K. Their
cross blocks therefore vanish. These relations do not force G_S
to be a scalar, or even invertible.

There is an exact failure with perfect ratios. Write the normalized
excluded input x*/2=√μ s+√(1−μ)n as above, and choose a
unit s₂∈S orthogonal to s. Set

    K=γ s₂s₂†,       G=K+Π_N,       0<γ≤1.

Both training ratios are respectively zero and one, with nonzero
denominators. Yet j_G(x*)=0, the same as for intended inputs
in N. This construction is passive. It can be implemented by
transmitting s₂ and N to the retained ports and losing the active
direction s. It is not an additive-noise or rounding effect.
For γ=1 even the complete four-mode device can be lossless:
route s into an output omitted from G and route s₂,N into the
three retained outputs. The missing power is then entirely present
elsewhere in the same device. Conservation of the complete field
does not make the truncated denominator a full-power reference.

Even insisting on G_S=γI_S, G_N=I_N with γ>0 gives only
j_G(x*)=γμ/(γμ+1−μ), which approaches zero as γ decreases.
Thus an unknown uniform attenuation of just the working subspace
also removes a uniform nonzero error margin from these ratios.

A sufficient additional relation is G_S≥ℓI_S and G_N≤uI_N
with ℓ>0,u≥0. Without reconstructing either full block it gives

    j_G(x)≥ℓμ/[ℓμ+u(1−μ)]

on the excluded family, and zero on N whenever its denominator
is nonzero. A common unknown positive scale multiplying both
bounds cancels; their relative strength does not. Thus rejecting
an absolute gain standard is compatible with a precise relational
guarantee, but rejecting every relation between the two subspaces'
transmissions is not. This is a different denominator contract
from the earlier input-power calibration.

**A local control floor can be acquired before further optimization.**
IiS34's exact nulling step assumes a scalar coherent pair throughout
the three probe settings. More generally let A=⟨|x|²⟩,
B=⟨|y|²⟩ and z=⟨conjugate(x)y⟩ refer to one common
nonnegative acquisition. The same three settings acquire these
relations, with |z|²≤AB. Under an available two-mode rotation
with c=cos θ,s=sin θ, first minimize its phase. The output is

    I(θ)=A cos²θ+B sin²θ−2|z|sin θ cos θ.

If the full interval 0≤θ≤π/2 and all relative phases are
available, the exact minimum is

    Imin=(A+B−√((A−B)²+4|z|²))/2.

This follows by minimizing the sine and cosine of 2θ, or by
diagonalizing the positive 2×2 acquisition matrix. Zero is
reachable exactly when AB=|z|², including a zero component.
When the determinant is positive, more accurate search through
these same controls cannot produce zero: the obstruction is in
the common preparation, not in the search algorithm.

If the available mixing angles instead form [θlo,θhi]⊆[0,π/2]
while relative phase remains fully available, the optimal angle is
the projection of

    θ*=(1/2)atan2(2|z|,B−A)

onto that interval. When A=B and z=0 every angle is optimal.
For a nonzero coherent pair, θ*=atan2(√A,√B), and the
exact constrained minimum simplifies to

    (A+B) sin² dist(θ*,[θlo,θhi]).

This separates a preparation obstruction from a restricted-control
obstruction using acquired relations. It does not assume that a
real device has a freely available relative phase or the full ideal
angle interval. Imperfect Mach–Zehnder elements have forbidden
splitting-ratio regions in the explicit model of [Hamerly,
Bandyopadhyay and Englund](https://www.nature.com/articles/s41467-022-34308-3).
Their analysis is external evidence that this control admission
cannot be replaced by the word “tunable.” The formulas here are
direct consequences of the specified local contact and acquisition.

## §16l. Acquiring the relation that the next control needs

**IiS37 (Retained comparisons reduce configuration acquisitions).**
Keep IiS34's fixed linear device, repeatable training preparations,
admitted two-mode G contacts and mode-resolved power access. A probe
setting below means one identity configuration, or one temporary
two-mode rotation followed by restoration. It can read all output
powers. It is not one photon or an assertion of exact finite-sample
statistics. Committed rotations and preparation launches are separate
resources.

Let a fixed positive training mixture have full support on an
r-dimensional subspace N of Cᵈ, and let m=d−r outputs be read.
The r(d−r)-rotation controller can be acquired using at most

    1+r(r−1)+2r(d−r)

mixed probe settings, before independent final admission.

*Construction.* The initial identity setting reads all d diagonal
powers. Acquire both quadratures of each pair among the r unread
outputs, costing r(r−1) further settings. At a read stage, only the
r complex comparisons between the current read output and those
unread outputs remain to be acquired. The current read output has
not been touched by previous stages; its diagonal is still the
initial acquired diagonal. These 2r settings complete the local
(r+1)-mode matrix. Choose a kernel row and implement it with r G
contacts, as in IiS34. Transport the acquired local matrix through
that known word and retain its unread r×r block. This is the actual
block required at the next stage. No already acquired unread pair
has to be measured again. Counting the initial block and all read
stages gives the formula. Positive full support makes a zero mixed
reading zero on every trained direction. ∎

This construction uses the actual common source and actual known
transition between readings. Identical names on unrelated blocks
would not implement the transport. A unitarily transported matrix
error has the same operator norm, and compression to the unread
block cannot increase it; new acquisition errors still enter when
new rows are added. Exact reuse is not a claim that uncertainty
disappears on later stages.

In C⁴ with r=2 this gives eleven mixed settings instead of fourteen,
while keeping the four committed rotations. If the mixture is
implemented by two separate pure launches at each setting, the
corresponding upper counts are twenty-two and twenty-eight launches.
These counts do not include preparation, actuator restoration,
power integration or final admission.

**Uniform training reduces the four-mode count further, to nine.**
Now retain the stronger current contract C=P/2, where P is the
rank-two orthogonal projector onto the actual transformed training
plane. Acquire the first triple (0,2,3) in seven settings, with the
identity also reading mode 1. Implement the two G contacts making
the whole training plane dark at mode 0. The known first triple
transports exactly through those contacts; mode 1 is untouched.

On the remaining modes (1,2,3), the actual projector has the form

    P_R=I₃−ww†,       ‖w‖=1.

The transported unread block therefore supplies

    B=I₂−(P_R)_{ {2,3},{2,3} }=b b†,
    b=(w₂,w₃),       q=‖b‖²,
    |w₁|²=1−q.

If q=0, mode 1 is already dark. If q=1, w=(0,b) is known up to
an irrelevant common phase. Otherwise choose j∈{2,3} maximizing
Bⱼⱼ, so Bⱼⱼ≥q/2>0. Fix the common phase by taking
bⱼ=√Bⱼⱼ and reconstruct b=B eⱼ/√Bⱼⱼ. Two balanced
settings on (1,j), with phases 0 and π/2, acquire the one complex
entry (P_R)₁ⱼ. They determine

    w₁=−(P_R)₁ⱼ/√Bⱼⱼ.

The normalized row w† is then implemented by the two final G
contacts on (1,2),(1,3). Mode 0 is untouched. Thus all of N is
dark on the read pair, and the complete readout is the target Π.
The count is at most seven plus two mixed settings and four
committed rotations for every initial U, including the branches
where fewer settings or identity contacts suffice. No hidden
source matrix is an input to the controller.

Nine is a constructive upper bound for this entire procedure,
not a proved global minimum of all possible acquisition strategies.
The shortcut from eleven to nine uses a uniform mixture and
unitarity: a general rank-two mixed matrix on three modes is not
necessarily proportional to I−ww†. The broader eleven-setting
construction does not need this special spectrum.

**The uniform method can tolerate moving individual profiles.**
The fixed full upstream unitary can be weakened for the nine-setting
construction. Suppose the actual unitary U_t may change between
trials, but U_t N=L for one common r-dimensional output subspace L.
At each trial the conditional input training state is Π_N/r,
independently of the currently selected U_t. Then

    U_t(Π_N/r)U_t†=Π_L/r

for every t. Thus the acquired mixed covariance is the same even
though the image of every individual pure training vector may move.
The controller acquires and nulls L. Once W maps L to the unread
outputs, unitarity gives

    U_t† W† D W U_t=Π_{N⊥}

for every such t, including later use. No fixed internal frame on N
or N⊥ is required. The general r-dimensional retained-block
construction also applies to this common uniform covariance.

This conditional preparation relation matters. Cycling through pure
inputs while the device changes in a way correlated with that cycle
does not automatically produce Π_L/r. Nor can one replace a common
L by an arbitrary varying plane. Both changes can destroy the shared
covariance used by the acquisitions.

The twelve-pure-setting method in IiS38 has a different requirement:
its successive pair readings must describe a repeatable coherent
profile. To see the difference, allow one pure input to sweep through
two orthogonal outputs spanning L. Its acquired two-mode covariance
can have positive determinant, so no one two-mode rotation nulls it,
by IiS36's local control floor. Yet the common mixed plane still has
a null row in each appropriate (r+1)-mode block, and the mixed
method remains applicable. Fewer pure launches therefore does not
dominate the mixed method over these distinct source-stability
contracts. Keeping the needed subspace can be enough when keeping
each preparation's output is impossible or unnecessary.

**Adaptation saves real answers even against arbitrary fixed linear
readings.** The nine-setting procedure identifies the whole unknown
rank-two projector P in C⁴: its known final word W determines
P=W†(I−D)W. It acquires at most eleven new real expectation
values: three diagonal powers after the known trace relation, six
first-triple quadratures and two final adaptive quadratures.

By comparison, fourteen scalar linear readings are necessary and
sufficient to identify every such P if all the readings are fixed
before any answers are obtained, even when arbitrary positive
measurement effects are allowed. These are scalar expectation
counts, not numbers of detector configurations or individual
particles. The adaptive procedure's nine settings and eleven
scalar values are different resource counts.

For necessity, the real space of trace-zero Hermitian four-by-four
matrices has dimension fifteen. At most thirteen fixed scalar
readings leave a kernel of dimension at least two in this space.
On the unit circle of any two-dimensional kernel plane the odd
continuous function X↦tr(X³) must vanish somewhere. For that
nonzero X, tr X=tr(X³)=0 makes its characteristic polynomial
even, by Newton's identities. Its real eigenvalues therefore come
in pairs a,−a,b,−b. Scale so |a|,|b|≤1. In each corresponding
two-space the two rank-one projections

    P_a=(1/2)[[1+a,√(1−a²)],[√(1−a²),1−a]],
    Q_a=(1/2)[[1−a,√(1−a²)],[√(1−a²),1+a]]

differ by diag(a,−a). Direct sums for a,b and conjugation by
the eigenbasis of X give distinct rank-two P,Q with P−Q=X.
All the fixed readings agree on them. A predetermined list of
thirteen or fewer linear answers cannot identify every plane.

For sufficiency, choose fourteen orthonormal trace-zero Hermitian
directions spanning the orthogonal complement of

    Z=diag(3,−1,−1,−1)

inside the trace-zero space. Read those directions along with the
already known trace. They leave only the ambiguity P−Q=tZ.
But every difference of equal-rank projections has

    tr((P−Q)³)=tr P−tr Q−3tr(PQ)+3tr(PQ)=0,

whereas tr((tZ)³)=24t³. Thus t=0. Each chosen direction B
can be implemented as a positive effect I/4+sB with sufficiently
small known s>0; the fixed trace removes its constant contribution.
This proves the exact fourteen-scalar bound in the stated broad
fixed-linear interface.

The construction also supplies a stable inverse, as follows. Let E be
the Frobenius-orthogonal projection onto these fourteen directions.
For X=P−Q, the paired eigenvalues give
|X₀₀|≤‖X‖_F/√2. Since ⟨Z,X⟩=4X₀₀ and
‖Z‖_F²=12,

    ‖E(X)‖_F²≥‖X‖_F²/3.

Accordingly two projectors whose fourteen-coordinate records differ
by at most η in Euclidean norm differ by at most √3η in
Frobenius norm. Physical conversion to the chosen positive effects
also includes their known scaling s. An exact answer-count saving
therefore does not by itself prove a saving in photon count or
precision; the two procedures have different conditioning and
different physical configurations.

There is no contradiction with the adaptive eleven-answer
construction. The later linear functionals depend on earlier
acquired answers, so there is no single fixed measurement kernel
on the whole family to which the preceding impossibility applies.
Neither eleven adaptive scalar answers nor nine mixed settings
have been proved minimal. The general distinction between model
dimension and globally sufficient fixed measurements is established
in [Heinosaari, Mazzarella and Wolf](https://arxiv.org/abs/1109.5478);
the explicit paired-spectrum argument above supplies the stated
four-mode comparison, without claiming priority for constrained
tomography.

**Identifying the promised family and excluding other positive
states have different costs.** The fourteen fixed readings above
identify P/2 among normalized rank-two projectors. They need not
identify it among all density matrices. For example, with
P=diag(1,1,0,0), every

    σ=P/2−tZ=diag(1/2−3t,1/2+t,t,t),  0<t<1/6,

is a different full-rank state with the same fourteen readings.

For the stronger fixed-linear task—every P/2 must be distinguished
from every other positive trace-one matrix—the exact minimum is
fifteen scalar expectations. Any smaller fixed list has a nonzero
trace-zero Hermitian kernel element X. Change its sign if necessary
so that X has at most two negative eigenvalues. Choose a rank-two
P commuting with X whose range contains every negative eigenspace.
Then P/2+tX is a different density matrix for all sufficiently
small t>0, yet gives the same readings. Fifteen independent
trace-zero directions attain the bound by determining the whole
Hermitian matrix with its known trace.

This distinction is established in the literature on complete and
strictly complete tomography, including [Baldwin, Deutsch and
Kalev, Section II](https://arxiv.org/pdf/1605.02109). Here the target
family is specifically the equal-eigenvalue rank-two states, and
the fixed bound is uniform over every member, without an excluded
set of exceptional targets.

**Twelve adaptive scalar expectations suffice for the stronger
task.** Modify the first step of the nine-setting procedure. After
the initial diagonal reading, omit a coordinate j with smallest
P_jj, inferred as twice its normalized power. Its value is at
most 1/2. Let A be the other three coordinates, and acquire their
six real cross quadratures. These initial readings contain nine
independent real expectations and determine the full compression
C_A of C=P/2.

The restriction T:range P→C^A has

    T†T=I−(P e_j)(P e_j)†  on range P,
    λ_min(T†T)=1−P_jj≥1/2.

In particular C_A has rank two. Apply the same completion procedure
as above to obtain the known candidate P, using at most two further
quadratures. The change of omitted coordinate does not require a
physical permutation: A contains at least one of the two designated
read outputs; null that output first, then send the remaining null
row to the other designated read output with two contacts on the
remaining three modes. The known anchor block can include that
second output before it is nulled. Thus the four-contact interface
and the acquisition count are unchanged.

Finally acquire one additional scalar expectation of K=I−P, by
reading the completed controller. On a target C=P/2 this value is
zero. If any positive trace-one σ gives the same whole adaptive
record, this last equality forces σ=PσP: positivity turns a zero
expectation of I−P into absence of support outside P. The initial
record also fixes σ_A=C_A. Since T is injective, its left inverse
then gives σ=P/2. No rank, flat spectrum or upper eigenvalue bound
has been imposed on this competing σ. The original program may
use the promised family to propose P; the extra acquired relation
certifies the proposal against the larger positive class.
If no candidate matches the acquired relations, the construction
does not declare that the actual source has the promised form.

The total is at most twelve adaptive real expectations, implemented
by at most ten mixed probe configurations in the stated interface:
one initial power configuration, six first-block quadratures, at
most two completion quadratures, and one final sum of powers.
This twelve is not the twelve pure training configurations of
IiS38. It is an upper bound for this stronger identification task,
not a proved adaptive minimum. No photon-count saving follows
without an accuracy and sampling analysis.

**The extra relation has a uniform finite-error version.** Let P
now be any known rank-two candidate, and choose its omitted j so
P_jj≤1/2. For an arbitrary positive trace-one actual state σ,
suppose acquired bounds establish

    tr((I−P)σ)≤η,
    ‖σ_A−(P/2)_A‖≤κ.

Then the trace distance obeys

    (1/2)‖σ−P/2‖_1 ≤ min(1,3√η+2κ).            (37a)

More generally, if the acquired coordinate choice has
γ²=1−P_jj>0, the right-hand expression before clipping is
(1+γ^(−2))√η+κ/γ². Thus a noisy initial choice can use
the actual candidate's γ, rather than asserting an exact pivot
bound that the acquired record did not supply.

For a proof, write δσ=σ−PσP. Decompose σ into pure states.
For a pure component with outside weight a, the trace norm of
its difference from the unnormalized projection is
√(4a−3a²)≤2√a. Convexity of trace norm and concavity of
the square root give ‖δσ‖_1≤2√η. Let J restrict to A and
let L:C^A→range P be the left inverse of T. Then
LJP=P and ‖L‖≤1/γ. With Δ_A=σ_A−(P/2)_A,

    σ−P/2 = δσ−LJ δσ J†L† + L Δ_A L†.

The first two terms have total trace norm at most
(1+γ^(−2))2√η. The last has rank at most two and operator
norm at most κ/γ², hence trace norm at most 2κ/γ².
Divide by two; γ²≥1/2 proves (37a).

The same argument applies to any known trace-one candidate ρ₀
supported on a rank-r projector P. For a coordinate restriction J
injective on range P with smallest singular value γ>0, an acquired
outside weight η and compression error
‖JσJ†−Jρ₀J†‖≤κ imply

    (1/2)‖σ−ρ₀‖_1
      ≤min(1,(1+γ^(−2))√η+rκ/(2γ²)).

The rank used in the last trace-norm estimate is that of the known
candidate support, not a promised rank of the actual σ. Thus the
mechanism is an acquired support relation plus an injective reading
on that support; the four-mode counts are one application.

The quantities η and κ are acquired bounds, not exact zeros
declared by a fitting routine. For an estimated first block C̃_A,
one may take κ=‖C̃_A−(P/2)_A‖+e₀, using its established
operator error e₀. If the realized final effect differs from I−P
in operator norm by at most e_K, an upper event-probability reading
q_U gives η≤min(1,q_U+e_K). Statistical failure budgets for
these bounds also remain part of the certificate. The same actual
state must underlie the compared readings, or an established
transfer must provide them for that state; arbitrary drift is not
removed by positivity.

**A particular question can need less than the full-state bound.**
Let F be the desired Hermitian observable and H a proposed reading
of the compressed record JσJ†. Put

    D=F−J†HJ,       P D P=0.

The equality is the content that makes the proposed reading correct
on the candidate support. With a=tr((I−P)σ), positivity gives

    |tr(Fσ)−tr(H JσJ†)|
      ≤2‖P D (I−P)‖√(a(1−a))
          +‖(I−P)D(I−P)‖ a.                    (37b)

Indeed the off-diagonal block of a positive state has trace norm
at most √(a(1−a)); factor the positive block matrix and apply
the Hilbert–Schmidt Cauchy–Schwarz inequality. Pair it with the
off-diagonal block of D, and bound the remaining positive block
by its trace a. This proves (37b). For only an upper bound a≤η,
the always valid simpler right-hand side is
2‖P D(I−P)‖√η+‖(I−P)D(I−P)‖η. An acquired record error
adds its own term, for example ‖H‖_1κ for compression operator
error at most κ.

If D also has no block between P and its complement, only the
linear leakage penalty remains. When that block is present, a
square-root penalty can be necessary: in two dimensions, take
P=|0⟩⟨0|, D=|0⟩⟨1|+|1⟩⟨0| and the pure state with
amplitudes √(1−a),√a. Its missing comparison is exactly
2√(a(1−a)). For D=I−P the missing answer is instead exactly
a. Thus the error required by the downstream question is not
determined solely by how much total power was omitted. The
remaining cross relation determines whether the question incurs
an amplitude or a population penalty.

A nonzero error bound does not certify exact rank: the full-rank
states σ_z=(1−z)P/2+zI/4, 0<z<1, have η=z/2 and κ=z/4
and approach P/2 arbitrarily closely. Formula (37a) certifies a
distance relevant to subsequent readings, not absence of every
additional occupied direction.

Full state identification is an optional stronger question. A
controller can already be applicable from its acquired support
leakage and phase-family floor. The present completion does not
make tomography a new prerequisite for IiS38 or IiS40.

**Free output-coordinate phases do not reduce the retained minimum.**
IiS34 excluded extra free controls from its lower-bound contract.
For diagonal phase screens in the same output control bank, that
restriction can be removed. For D=diag(e^{iθ₀},…,e^{iθ_{d−1}}),

    D Gᵢⱼ(c,s,φ) D†=Gᵢⱼ(c,s,φ+θᵢ−θⱼ).

An arbitrary word with k G contacts and arbitrarily many such
screens can therefore be rewritten D_total V, where V contains
only k G contacts. The final coordinate read projector commutes
with D_total, so the complete input power effect is unchanged by
discarding that screen. The set of attainable readout effects with
k contacts is exactly the former set. The lower bound r(d−r)
and its attaining construction survive these free phase controls.
This does not cover controls inserted before the unknown device,
additional mixing operations or questions about coherent output
phases relative to an external continuation.

**The remaining phase has an exact action-dependent query price.**
After the first exact nulling stage, suppose the acquired block has
0<q<1. Write b=√q u, with u a known unit vector in modes 2,3.
All remaining compatible null directions are

    w_φ=√(1−q)e^{iφ}e₁+√q u,       φ∈R/(2πZ).

For a normalized final read row v† in these three modes, the
remaining total null leakage is

    L(v,φ)=v†P_R(φ)v=1−|w_φ†v|².

It is twice the power of the uniform training mixture in that
single output. It is already the contribution to IiS34's δ, not
an extra normalization of δ.

With no phase acquisition,

    min_{‖v‖=1} max_φ L(v,φ)=min(q,1−q).

For a proof, discard any component of v outside span{e₁,u}:
it can only reduce every overlap. A relative phase can always
make the cross term nonpositive, so the largest guaranteed
squared overlap is max(q,1−q). It is attained by v=e₁ or v=u.
The apparatus can therefore meet any tolerance at least this
large without learning the remaining phase.

If a strictly smaller uniform tolerance is required, two restored
single-pair probe settings are necessary and sufficient in the
worst case. Every such setting depends on φ through at most one
real sinusoidal contrast. The two output powers of its mixed pair
have a fixed sum, while all other powers are unchanged. A zero
contrast leaves two antipodal phase alternatives. Their null
vectors have overlap magnitude |1−2q|. No common normalized row
has guaranteed squared overlap larger than

    (1+|1−2q|)/2=max(q,1−q).

Indeed the average of the two rank-one projectors has that
largest eigenvalue, bounding the smaller of the two overlaps;
the bound is attained. Thus one setting cannot improve the
zero-query worst-case tolerance. Two quadratures of a nonzero
anchor identify φ and attain zero leakage. Adaptivity does not
avoid this one-query transcript. This proves a zero-or-two
worst-case query price for the specified tolerance task and
specified single-pair interface, not for simultaneous multi-pair
measurement architectures.

An individual first answer can nevertheless justify stopping.
If it leaves two null vectors w₊,w₋, their exact best common
leakage is (1−|w₊†w₋|)/2. A normalized, phase-aligned sum of
the vectors attains the bound; if their overlap vanishes, take
their equally weighted sum. Whether the second query is needed
is consequently a question about this acquired branch.

**A phase interval can specify the best action without specifying
the phase.** Suppose the remaining phase is known only to lie
in an arc |φ−φ₀|≤a, with 0≤a≤π. Its exact minimax leakage is

    R(q,a)=(1−√(1−4q(1−q)sin²a))/2,    0≤a≤π/2;
    R(q,a)=min(q,1−q),                  π/2≤a≤π.

For a≤π/2, absorb φ₀ into the first coordinate and choose v
from the top eigenvector of

    [[1−q, √(q(1−q)) cos a],
     [√(q(1−q)) cos a, q]].

Its components can be chosen nonnegative. The two endpoint
phases minimize its overlap, and the top eigenvalue gives
1−R. No other phase of v improves the smallest cosine over
the arc. For a≥π/2 that smallest cosine is nonpositive for
every phase choice, and a single known component attains the
optimal max(q,1−q) overlap. This also proves optimality among
complex rows and rows with a third orthogonal component.

**Weak phase information need not make the action unstable.**
Keep the preceding block exact, and suppose the acquired complex
anchor h=w₁ conjugate(bⱼ), with j chosen as above, has error
at most e in modulus. Its true modulus is

    H=√((1−q)|bⱼ|²).

For e<H, the measurement disk confines φ to an arc of half-width
at most arcsin(e/H). The minimax row just constructed gives

    L≤2q(1−q)e²/H²≤4e².

The first inequality follows from
(1−√(1−x))/2≤x/2 for 0≤x≤1. For e≥H, choose the
phase-independent row instead. Then

    L≤min(q,1−q)≤2q(1−q)≤4H²≤4e².

There is also a sharp uniform bound, rather than only that
quadratic envelope:

    F(e)=(1−√(1−8e²))/2,    0≤e≤1/(2√2);
    F(e)=1/2,              e≥1/(2√2).

For e<H the arc formula gives L≤F(e), using
|bⱼ|²≥q/2. For e≥H, put t=min(q,1−q). Then
t(1−t)=q(1−q)≤2e², implying t≤F(e) on the first
range; on the second range a known-component row always gives
L≤1/2. For attainment on the first range choose q≤1/2 with
q(1−q)=2e² and |b₂|²=|b₃|²=q/2. Now H=e and the
record h=0 leaves every phase possible, forcing leakage q=F(e).
At and above e=1/(2√2), use q=1/2. Thus this is the exact
worst-case minimax guarantee over the known-block families and
admissible complex-error records. The coefficient four in the
simpler bound is attained at that transition. This concerns one
complex acquired-error disk; different error geometry gives a
different sharp formula.
The phase angle itself can be arbitrarily unstable as H→0.
Its weight in the required action supplies the missing control.
Errors in the earlier block are not included in this last bound.

**Nine settings also admit an end-to-end finite-error bound.**
The following conservative controller avoids dividing by a nearly
vanishing phase reference. Let every newly read scalar power have
absolute error at most ν. Suppose the first acquired local matrix
has operator error at most e₀; direct reconstruction gives the
available choice e₀=(1+4√2)ν. Use an exact minimum-Rayleigh
row and exact pair-local unitary synthesis at the first stage.
Then the actual first read leakage t=P₀₀ satisfies

    t≤t₀=min(1,4e₀).

On the remaining three modes a rank-two projection P has the
compression form

    P_R=I₃−Q−t uu†,
    Q=ww†,     ‖w‖=‖u‖=1,     w†u=0.

For 0<t<1, the projection block equations give eigenvalues
1,1−t,0 for P_R: its coupling to the first coordinate is
an eigenvector of eigenvalue 1−t. The endpoint cases follow
directly; when t=1 any orthonormal pair in the complementary
two-space can be used for w,u. Thus this decomposition exists
without selecting a stable eigenvector from noisy data.

Transport the first local estimate through the known committed
word and retain its two-mode block C̃_B. Put B̃=I₂−2C̃_B.
Relative to the true Q_B its operator error is bounded by

    E_B=2e₀+t₀.

Choose j∈{2,3} maximizing the real diagonal of B̃. Mode 1's
diagonal still has its original scalar error ν, while the
transported diagonal at j has error at most e₀. The two new
balanced readings therefore estimate the complex entry
Q₁ⱼ with error at most

    E_X=√2(3ν+e₀)+t₀/2.

The last term bounds t|u₁ conjugate(uⱼ)|; it is at most
t/2 by normalization. Form h̃ whose anchor coordinates are
the j-th column of B̃ and whose first coordinate is the
negative of twice the newly acquired C₁ⱼ. Then

    ‖h̃−Q eⱼ‖≤h=√(E_B²+E_X²).

Write q̃=tr B̃ and p₋=B̃ⱼⱼ−E_B. Two explicit possible
continuation rows have certified leakage bounds

    v=e₁:             b₀=min(1,max(0,q̃+2E_B));
    v=h̃/‖h̃‖:       b₁=min(1,h²/p₋), if p₋>0.

Use b₁=1 when p₋≤0; if h̃=0 it cannot give a certified
bound below one, so take e₁. Choose the row with the smaller
bound and synthesize it with at most two G contacts.

For the first bound, P_R≤I−Q gives leakage at e₁ at most
q=tr Q_B≤q̃+2E_B. For the second, Q eⱼ has squared
norm Qⱼⱼ≥p₋. Its distance from the line spanned by h̃
is at most h, yielding 1−|w†v|²≤h²/p₋; again
P_R≤I−Q converts this to a power bound. This also explains
why a small reference is a reason to choose another action,
not to claim an accurate phase by unstable division.

The final total leakage obeys

    δ≤t₀+min(b₀,b₁)
      ≤t₀+min(1,2E_B+√(4E_B²+2h²)).

For the uniform bound, split at
q̃=√(4E_B²+2h²). Below it use b₀. Above it, maximal
anchor selection gives p₋≥q̃/2−E_B>0 and the b₁ bound
is at most the same number. Zero-error limiting cases are
read directly from the exact construction. This proves a
finite guarantee for the shortened acquisition itself, not
only for a perfectly known first block.

This conservative bound may be worse than the fourteen-setting
bound at the same per-reading error. Fewer settings has not
been equated with uniformly better precision. Solver error,
imperfect row realization, drift and cross-talk require their
own admitted bounds; the preceding version assumes exact
solver and pair-local unitary contacts. Independent final
admission measures the device actually reached and can be
substantially tighter.

## §16m. Learn in one program and execute an equivalent shorter one

**IiS38 (Question-preserving normalization separates learning from
retained control cost).** Let D be a fixed rank-m coordinate read
projector in Cᵈ, with r=d−m. Suppose a known, physically admitted
unitary word V acts after an otherwise unknown source. There is
a word W of at most r(d−r) allowed G contacts such that

    W† D W=V† D V.

The original word can be kept when already shorter. Consequently
one can choose a replacing word with no larger contact count and
at most r(d−r) contacts. This is an exact equality of complete
final power readings, not equality of the two unitary maps.

*Construction.* The known word defines the known projector

    P_V=V†(I−D)V.

Apply IiS34's r(d−r)-contact subspace construction algebraically
to range P_V: at each stage compute the relevant local projector
block from the known word, choose its kernel row, and synthesize
that row with r G contacts. No query to the unknown source is
needed. The resulting W sends range P_V to ker D, so
W†(I−D)W=P_V and the displayed equality follows. The
worst-case retained bound is attained by IiS34's dimension
obstruction. Phase screens within the same output bank can be
removed as in IiS37. ∎

For every actual field y, including one supplied by an unknown
lossy or time-dependent upstream process,

    ‖D W y‖²=‖D V y‖².

Thus normalization does not require identifying the upstream
unitary U, and the equality itself does not require that the
upstream process be unitary at all. It compares both programs
on the same field. A certificate acquired on an earlier source
does not automatically apply to a later changed source: W on
the later field equals V on that later field, not necessarily
V on the earlier field.

**This removes the apparent acquisition penalty in the four-mode
controller comparison.** The five-rotation pure-training procedure
can itself reuse its known powers. For the first training vector,
one identity setting reads all current powers. Each nulling
contact then needs only its two new quadratures: the unaffected
powers remain known, and the surviving power of the nulled pair
is its former sum. Three contacts therefore need seven pure
settings. After these contacts, one new identity reading for
the second training vector and two quadratures for each of its
two contacts need five more. Total: at most twelve pure probe
settings, rather than the unshared upper bound of fifteen.

Let V be the resulting known five-contact word, whether the
actual training result is perfect or imperfect. Normalize its
power effect to a four-contact W. Reset only the controlled bank
and install W; do not reset or infer the unknown source. The
same final readout is obtained with no new source acquisition.
In particular, any previously established tolerance for V's
reading transfers through this equality, as long as the admitted
controls, source relation and reset remain valid.

The full resource statement is therefore:

    at most twelve pure training settings;
    five committed contacts accumulated during learning;
    at most four contacts in the retained working program;
    independent final admission, when required by the physical contract.

Twelve is an upper bound, not an acquisition minimum. The
learning contacts have not disappeared: temporary probes, reprogramming and
restoration are real work. Nor does this show that a fixed
five-element mesh can always be replaced in place by an
arbitrarily ordered four-element mesh. The theorem uses the
same permitted pair-word interface as IiS34; the required word
must be physically implementable in the actual bank.

For r orthonormal pure training inputs in Cᵈ, progressive
individual routing uses

    L=(d−1)+(d−2)+…+(d−r)=rd−r(r+1)/2

training contacts. Retaining powers gives r initial pure
readings plus 2L quadrature settings, or r(2d−r) pure
settings. Normalizing the learned word still leaves at most
r(d−r) working contacts, without further unknown-source
measurements. The source family need not be reconstructed
beyond what is carried by that known learned word.

**Twelve pure settings need not assume perfectly observed zeros.**
For the four-mode schedule, suppose each acquired normalized scalar
power has absolute error at most ν, and the two-mode controls and
minimum-Rayleigh solver are exact. At each contact reconstruct the
two-by-two pure coherency block from its stored diagonal estimates
and the two newly measured quadratures. Choose its minimum-Rayleigh
row, implement that row and transport the entire estimated block
through the known contact. Store the surviving diagonal from that
transport; do not replace it by the old pair sum on the assumption
that the other actual output vanished.

Each fresh leaf diagonal has error at most ν. If the surviving
anchor diagonal has error at most a, each new real quadrature has
error at most (3ν+a)/2. The two-by-two matrix error is therefore
at most

    e(a)=a+(3ν+a)/√2,       a≥ν.

The actual pure two-mode block has minimum eigenvalue zero.
The acquired minimum-Rayleigh row consequently leaves power at
most 2e(a), by comparing its estimated value with a true null row.
Transport gives the surviving diagonal error at most e(a).
Starting from a=ν, the three successive available error bounds are

    e₁=(1+2√2)ν,
    e₂=(3+4√2)ν,
    e₃=(7+7√2)ν.

The first training vector incurs at most 2(e₁+e₂+e₃) total
power outside its assigned unread mode. Subsequent contacts avoid
that mode, so they cannot increase this total, although they can
redistribute the residual. The second training vector uses a new
identity reading and incurs at most 2(e₁+e₂) power in the final
read modes. For the orthonormal training pair their sum is the
total null leakage. Hence the learned word satisfies

    δ_V≤min(2,(30+38√2)ν).

This is a conservative sufficient bound, not an optimal error
constant. It requires the same actual source at the compared
settings and exact admitted contacts; contact implementation
errors are treated separately below. It does show that the
twelve-setting scheme survives finite acquired error without
an unstable division by a weak phase reference. Independent final
admission can supply a tighter bound for the actual device.

**Approximate implementation has a scoped transfer bound.**
Suppose V and W are the commanded unitary words above, while
the physically implemented unitary words Ṽ,W̃ satisfy
‖Ṽ−V‖≤e_V and ‖W̃−W‖≤e_W. Then

    ‖W̃† D W̃−Ṽ† D Ṽ‖≤e_V+e_W=:e.

For unitaries A,B, put R=AB†. The difference of their
conjugated projectors has norm ‖DR−RD‖. In the decomposition
range D⊕ker D this commutator has only its two off-diagonal
blocks, whose norms are each at most ‖R−I‖=‖A−B‖.
Apply this inequality to both implementations and use the
commanded equality. A sum of per-contact operator errors is
an available word-error bound by telescoping products of
unitaries; a common physically established error bound can
be tighter. Passive nonunitary implementation errors require
a different effect bound.

With the same unitary upstream source as in IiS34, let the
earlier total null leakage be δ_V. For the same trained N,

    δ_W≤(√δ_V+√r e)².

Indeed leakage is the squared Frobenius norm of the read
projector applied to an orthonormal basis of the transformed
N. The two projectors differ in operator norm by at most e;
the triangle inequality gives the bound. In particular, an
exact old null becomes at most r e² leakage, rather than
requiring a first-order power penalty. A final acquired
certificate can supersede this conservative transfer bound.

This result separates a useful learning path from a useful
working path. It does not preserve the intermediate history,
the power of each read mode separately, or the coherent frame
passed into an arbitrary next analyzer. IiS35 provides a
counterexample to that last extension. What is preserved is
the stated sum-of-powers question on every input to the bank.

Equivalently, W=R V for a known block unitary R commuting
with D. The normalization has changed only the internal
output frames within the read and unread groups. If a later
analyzer originally reads an effect E, replacing it by
R E R† restores the old composite reading. The availability
and actuation cost of that analyzer change must be supplied;
an arbitrary continuation does not adjust itself for free.

**A common unknown coordinate phase need not be learned.** Suppose
the actual controls are ΔGΔ† for one unknown diagonal unitary Δ,
common to all probes, committed contacts and the two alternative
programs. The power detectors commute with Δ. Acquisitions then
describe Δ†CΔ, and the actual programs are ΔVΔ† and ΔWΔ†.
Their effects remain equal because the commanded effects are equal.
All exact acquisition and normalization results therefore hold in
this unknown common frame. Knowing every absolute control phase
is a stronger requirement than this question needs. Independent
edge offsets or changing frames between contacts need not admit
such one Δ and are not covered by this argument.

**The number of distinguishable output groups gives a general
retained-control bound.** Let the final requested observable
be diagonal, with distinct values λ₁,…,λ_s of multiplicities
d₁,…,d_s, summing to d. Its conjugates can all be synthesized
with at most

    C(d₁,…,d_s)=Σ_{i<j} dᵢ dⱼ
                 =(d²−Σᵢdᵢ²)/2

G contacts, and this is the minimum worst-case count.
Align the first eigenspace at cost d₁(d−d₁), keep it fixed,
and align the next in the remaining complement; continue.
The costs sum to the displayed number. For the lower bound,
off-diagonal blocks of an infinitesimal unitary change between
distinct eigenspaces give 2Σ_{i<j}dᵢdⱼ independent real
directions of the observable orbit: the commutator multiplies
each such block by a nonzero eigenvalue difference. Fewer
two-parameter contacts cannot cover that open orbit chart,
by the same smooth-image argument as IiS34.

Every known unitary word before this observable can therefore
be normalized at this cost without identifying its unknown
input. Merging two outcome groups of dimensions a and b
reduces the worst-case contact count by exactly ab. That is
a change of the question, with its sufficiency to be justified
for the downstream task, not an unexplained improvement in
implementing the old observable.

In four modes the groupings (1,1,1,1), (1,1,2) and (2,2)
give respectively six, five and four contacts in the worst
case. The exact Q readout with two distinct nonzero weights
belongs to the middle spectral class; the sufficient Π
readout belongs to the last. These are family bounds. The
specific Π additionally has the direct four-contact
obstruction below. Classical unitary synthesis and its
Givens decompositions are established subjects, including
[Clements et al.](https://arxiv.org/abs/1603.08788). The
result here spells out which output distinctions this
normalization preserves and how its equality transports an
acquired reading; it is not a claim to have invented optical
unitary synthesis or unitary orbit geometry.

**A different elementary coupler changes the count.** If an
elementary contact is instead a fixed balanced splitter
B(φ)=G(1/√2,1/√2,φ), with arbitrary available relative phases
and free diagonal screens, the minimum worst-case count for that
same observable orbit is 2C(d₁,…,d_s). Each balanced contact
has only one continuous parameter after the screens have been
moved to the final boundary, so fewer than 2C cannot cover the
orbit of real dimension 2C. Conversely every general G can be
made from two balanced contacts up to an irrelevant diagonal:
choose 0≤t≤π with c=sin(t/2), s=cos(t/2), and put

    φ₁=φ−π/2,       φ₂=φ₁+t.

Direct multiplication gives

    B(φ₂) B(φ₁)
      =diag(e^{i(t/2−π/2)},e^{−i(t/2−π/2)}) G(c,s,φ).

Moving these diagonal factors to the output proves the upper
bound. Thus four general controllable mixing contacts and eight
fixed balanced contacts are different resource statements; eight
here is a family worst-case bound, not a proved minimum for the
single Π witness. The familiar Mach–Zehnder construction has
precisely this distinction between fixed splitters and a tunable
compound element. Actual fabrication errors can also restrict the
reachable ratios, as analyzed by [Hamerly et al.](https://www.nature.com/articles/s41467-022-34308-3).
Contact count alone is not chip area, insertion loss or elapsed
experimental time.

**The specified witness itself requires four contacts.** IiS34's
dimension argument established a worst-case lower bound among
all rank-two projections in C⁴. The particular target Π=I−Π_N
also has a direct obstruction to three contacts when synthesized
directly in the declared input coordinates, equivalently when
the uncounted upstream map is identity. An already mixing
upstream device can supply part or all of this action; this is
not a four-contact lower bound for every possible initial U.

For any rank-two projection Q obtained by conjugating a coordinate
rank-two projection with a word of at most three G contacts,

    Im(Qᵢⱼ Qⱼₖ Qₖᵢ)=0

for every triple of distinct coordinates. To prove this, form the
graph of the mode pairs used by the word. If it is connected on
four vertices, its at most three occurrences must be the three
distinct edges of a tree. One diagonal change of coordinates
removes all three G phases. The resulting word and projection
are real, and each displayed cyclic product is unchanged by
that diagonal change. If the graph is disconnected, every
component has at most three vertices. The projection is block
diagonal. Any contributing triple must be inside a three-mode
block; a projection of rank one or codimension one there has
a real cyclic product (respectively + or − a product of three
nonnegative squared moduli). Rank zero and full rank give zero.
Other triples cross blocks and also give zero. This covers
repeated contacts as well as shorter words.

For the actual N=range V₀, with

    V₀=[[1,0],[0,1],[1,1]/√2,[1,i]/√2],

direct inversion gives

    (V₀†V₀)⁻¹=(1/7)[[4,−1−i],[−1+i,4]].

Therefore, writing P=Π_N,

    P₀₁=−(1+i)/7,
    P₁₂=(3+i)/(7√2),
    P₂₀=(3+i)/(7√2),
    P₀₁ P₁₂ P₂₀=−(1+7i)/343.

Its imaginary part is −1/49; for Π=I−P it is +1/49.
The four-contact upper construction is thus minimal for this
specified readout even when its complete matrix is known.
The argument permits free diagonal screens in the same bank,
by their elimination above. It does not demand a physical
loop in the wiring: with longer words, repeated contacts on
a tree can carry phases that one common coordinate change
does not remove.

The obstruction has a nonzero tolerance. If a three-contact
projection Q were within operator distance e of Π, entrywise
errors would be at most e. Expanding the difference of the
three factors gives

    1/49 ≤ e(5+2√10)/49
            +e²(√2+2√5)/7+e³.

At e=1/15 the right side is strictly smaller than 1/49.
For an exact rational check, use √10<19/6, √2<10/7,
√5<9/4, obtaining the upper bound

    34/2205+83/22050+1/3375 < 1/49.

The right side increases with e≥0. Consequently every
three-contact Q has ‖Q−Π‖>1/15. Equal-rank projectors
obey ‖Q−Π‖²≤tr(Π_N Q), by their principal-angle
decomposition. Thus its total intended-null leakage satisfies

    δ>1/225.

This is a certified lower bound, not the sharp distance to
the three-contact family. It already exceeds IiS34's
aggregate-certificate threshold δcrit: μ<1/57 and
1/57<896/50625=4(1/225)(1−1/225), so
δcrit=(1−√(1−μ))/2<1/225. For μ<1/57,
use √2>24/17 and 194/17>(385/114)² in the exact
formula μ=1/2−√(10+√2)/7.

Hence three contacts cannot even enter that proven uniform
leakage-admission region. This does not prove that every
possible three-contact device fails every alternative,
more specifically acquired phase-family decision criterion.
That stronger task would have to compare the actual family
responses, not just this sufficient aggregate certificate.

**Passive loss does not lower this exact synthesis count.**
Replace each G by an arbitrary passive two-mode contraction,
without changing the mode carrier or the rank-two final read
projector. If the resulting word M has exact effect
M† D M=Π, then M is norm preserving on S=range Π and sends
S completely into the read outputs. For every input in S,
norm cannot decrease at any intermediate stage: subsequent
contractions could not restore that decrease.

At each stage, the current projections of S into that contact's
two modes therefore form a subspace on which the contact is
an isometry. Extend that isometry to a two-mode unitary. Making
these replacements successively preserves the complete action
on S. The resulting unitary word with the same number of
two-mode contacts has the same rank-two read projector Π.
Every two-mode unitary is a G contact times a diagonal phase
screen; those screens do not reduce the minimum. Thus a
three-contact passive implementation of this exact unit-gain
projection would yield an impossible three-G implementation.

This proof needs full transmission on S, not losslessness on
all modes. It does not apply to a target γΠ with γ<1, to
gain elements, additional prepared inputs or a different final
question. The quantitative 1/225 leakage bound above was
proved for the unitary/projection class; this exact
unitarization argument does not transfer that numerical
bound to every approximately matching passive effect.

**Configuration count is not observation count.** IiS37–38 count
distinct controlled probe settings. An exact expectation is not
obtained from one photon or from an unspecified finite integration.
Here is one explicit final-admission contract for the implemented
projection-class device, using established elementary counting
statistics rather than treating an observed zero as an exact null.

Freeze a candidate K in the admitted rank-m projection class before
the final batch. Prepare the uniform mixture σ_N=Π_N/r, and record
a binary read event on each of n fresh normalized input trials.
Let the fixed event probability be q=tr(Kσ_N)=δ/r, with independent
trials. Accept only if the whole batch has zero read events. Under
the bad-device hypothesis δ≥δ_* >0, the probability of acceptance
is at most

    (1−δ_*/r)^n.

For false-acceptance budget 0<α<1, the exact smallest batch size for
this zero-event acceptance rule is therefore

    n≥ceil(log α / log(1−δ_*/r)),       0<δ_*<r.

Equality at δ=δ_* proves the necessity for this specified rule.
This is not a lower bound for every possible testing procedure.
Equivalently the zero-event branch has one-sided upper confidence
limit q_U=1−α^(1/n). The probability statement concerns false
certificates under repeated trials; it is not a posterior probability
assigned to a fixed unknown q. Such exact binomial limits are
standard; see [NIST](https://www.itl.nist.gov/div898/software/dataplot/refman2/auxillar/exacbici.htm).
For application to IiS34, choosing δ_* strictly below δcrit is
a convenient conservative way to retain an explicit positive
classification gap.

A randomized preparation is not necessary. Prepare each of the r
orthonormal training vectors equally often, with n divisible by r.
For their fixed probabilities p_j, whose average is δ/r,
independent trials give probability

    [∏_{j=1}^r(1−p_j)]^(n/r)≤(1−δ/r)^n

by the arithmetic-geometric mean inequality. Thus a balanced
deterministic schedule gives the same bound. Unequal uncontrolled
coverage of the training directions does not give this conclusion.

Full independence can also be replaced by the actual weaker
obligation used in the argument: on every all-zero prefix under
the bad-device hypothesis, the next conditional read probability
must have the asserted lower bound. Multiplying the conditional
probabilities then proves the same result. Merely giving every
trial the same marginal probability is insufficient. If one Bernoulli
variable is drawn once and copied on every trial, each marginal is
q but the all-zero probability remains 1−q for every batch length.

**Imperfect preparation and detection need a detection relation.**
Suppose the actual uniform training preparation differs from σ_N
by at most ε in trace distance, and the detected event probability
is at least η times the ideal read probability, for an acquired
0<η≤1. The effect bound 0≤K≤I gives a preparation-induced
probability error at most ε. A bad device then has detected-event
probability at least

    p_* = η(δ_*/r−ε)_+.

When 0<p_*<1, replace δ_*/r in the batch formula by p_*.
When p_*=0, no finite zero-event batch supplies this certificate:
the premises still allow a bad device whose admitted event is
never detected. A relation such as detector effect F≥ηD is one
way to justify the detection factor. It must be acquired or supplied
by the physical contract, not inferred from the absence of clicks.

These statements use normalized emitted/prepared trials with a
defined event, not a denominator that silently discards losses.
Zero leakage alone does not establish that an arbitrary passive
device transmits the complementary signal space. IiS36's bright
capacity or another suitable admission remains necessary when the
projection class itself has not been established. The statistical
batch does not manufacture that structural assumption.

**Repeated tuning cannot restart the same confidence budget for
free.** Even a fixed bad candidate with 0<q<1 eventually produces
an all-zero batch almost surely if independent batches of a fixed
length are tried indefinitely and the first zero batch is accepted:
each batch has success probability (1−q)^n>0. This procedure's
eventual false acceptance is one, not α.

A simple valid replacement allocates α_j in advance with
Σ_j α_j≤α, for example α_j=α/[j(j+1)]. A candidate may depend
on all preceding work, but is frozen during batch j; use fresh data
with the required conditional law and choose its batch length from
α_j before observing that batch. The conditional bound and union
bound then control the probability of any bad accepted candidate
by α. Reusing training data as if it were independent admission
data does not satisfy this construction. More efficient procedures
that remain valid throughout monitoring are studied by
[Howard et al.](https://arxiv.org/abs/1810.08240); this paragraph
uses only the displayed elementary allocation.

Neither a finite batch nor a continuing confidence bound licenses
unrestricted future source drift. The admitted relation between
the tested device and its later use remains part of the result.

## §16n. Four contacts are necessary for the question itself

**IiS39 (Three-contact scalar indistinguishability).** In the
direct four-mode input coordinates, let a retained word contain at
most three admitted G contacts and arbitrary diagonal phase screens
in the same bank. Read only the total normalized power in a fixed
rank-two output group. For every such word there exist a normalized
pure input in N and a normalized equal-modulus phase input giving
exactly the same scalar reading. No decoder of that reading can
separate the two whole input families, even with exact acquisition.

The four-contact Π construction separates them by 0 versus at least
μ. Consequently four is the minimum retained contact count for this
actual discrimination question, beyond reproducing a chosen
matrix or entering a particular sufficient leakage certificate.

The upstream map is identity for this direct-synthesis lower bound.
An uncounted upstream unitary could already implement the required
mixing. Further measurement configurations, mode-resolved vector
answers, ancillary inputs, feedback during the queried action and
nonunitary contacts are different interfaces.

*First step: the short readout has a real coordinate form.* Its
effect Q is diagonally equivalent to a real symmetric matrix:
Q=Δ A Δ† for a diagonal unitary Δ and real symmetric A. If the
contact graph connects all four modes, three contacts are precisely
three distinct tree edges. One choice of node phases makes all
three G matrices real. If the graph is disconnected, Q splits into
blocks of size at most three. Inside a three-mode block a projection
has rank zero, one, two or three; rank one and rank two are vv† or
I−vv† and become real after phases are removed from v. Smaller
blocks have the same property. The blocks can be gauged separately.
Free phase screens can first be moved to the irrelevant final screen,
as proved in IiS37. Thus every allowed three-contact Q has the stated
real form, including repeated-contact and degenerate cases.

*Second step: every real four-mode correlation has a phase mixture.*
Here is a finite constructive version of the established real
correlation rank argument. Factor a real positive unit-diagonal
matrix R as Gram(v_i), with spanning v_i in R^p. If p≥3, the space
of real symmetric p×p matrices has dimension p(p+1)/2>4. Choose
nonzero H with v_iᵀH v_i=0 for all four i. It has both signs,
because a semidefinite H would annihilate the spanning vectors.
The two boundary matrices I+t₊H and I−t₋H are positive and
singular for suitable positive t₊,t₋. Their Gram matrices still
have unit diagonal, have lower rank and mix back to R with weights
t₋/(t₊+t₋) and t₊/(t₊+t₋). Repeat until each term has rank at
most two. A real unit Gram of rank at most two is

    R_ij=cos(θ_i−θ_j)=Re(z_i conjugate(z_j)),   |z_i|=1.

It is therefore the equal mixture of zz† and its entrywise
conjugate. The recursion supplies a finite phase mixture for R.
This is the real counterpart of IiS32's complex argument for at
most three modes. The general extreme-rank condition is classical;
see [Li and Tam](https://people.wm.edu/~cklixx/corr.pdf).

*Third step: exhibit overlap of the two answer sets.* Let V₀ be
the four-by-two matrix with rows (1,0), (0,1), (1,1)/√2 and
(1,i)/√2, and put

    ρ_* = V₀V₀†/4.

This is a trace-one positive matrix supported on N, with every
diagonal entry 1/4. It is not the uniform mixture Π_N/2; uniform
training is not needed for this impossibility argument. The matrix

    R=4 Re(Δ†ρ_*Δ)

is real positive with unit diagonal. Positivity follows by testing
real vectors against the original positive Hermitian matrix. By the
second step, σ=Δ R Δ†/4 is a mixture of normalized equal-modulus
phase inputs. Since A is real symmetric, its trace against the
imaginary skew-symmetric part vanishes. Hence

    tr(Q σ)=tr(Q ρ_*).

The common value lies between the minimum and maximum of Q on
normalized pure inputs in N. Every intervening value is attained
there, by the Rayleigh quotient on that subspace. It also lies
between the minimum and maximum on the phase torus; the torus is
connected and the reading continuous, so every intervening value
is attained by one pure phase input. Thus the equality is realized
by a pure input from each family, not only by two ensembles. ∎

The argument actually proves the overlap for any diagonally real
Hermitian scalar effect on these four inputs. The contact graph is
one way to force that restriction on the admitted reading. It does
not make an imaginary cyclic product sufficient for discrimination;
the already constructed Π supplies the positive direction.

This obstruction concerns the information carried by the final
scalar. Repeating that same exact expectation does not remove its
ambiguity. Under an independently established repeated binary
measurement model, the two pure inputs also give the same complete
distribution of those repeated binary outcomes. A new contact or
additional acquired observable can change the answer space.

**Why this real-form argument has a finite domain.** The rank
reduction also works for any real correlation matrix with at most
five positions, since 3·4/2>5. It fails as a universal statement at
six positions. For example the real Gram of e₁,e₂,e₃ and
(e₁+e₂)/√2,(e₁+e₃)/√2,(e₂+e₃)/√2 is positive with unit
diagonal and has zero value of the three corresponding squared
linear residuals. A scalar phase record cannot make those residuals
zero: it would require three unit vectors in the real plane to be
pairwise orthogonal. Positive mixtures cannot repair a nonnegative
residual that vanishes only when each supported record vanishes.

There is also a uniform nonzero bound. For the three original unit
phases put c_ij=Re(conjugate(z_i) z_j). Their real Gram has rank
at most two and trace three, so tr(G²)≥9/2 and
Σ_{i<j}c_ij²≥3/4. Minimizing each of the three additional phases
separately, the total residual is at least

    Σ_{i<j}(√(1+c_ij)−1)²
      ≥ (3/4)(√2−1)² > 0.

This bound is not asserted sharp. The example prevents extending
the four-mode real-form indistinguishability to arbitrary numbers
of channels. Complex contact orientation matters to the specified
four-mode witness; it is not a universal requirement of every
phase-mixture exclusion problem.

## §16o. A finite reading of whether classical environmental correction can suffice

**IiS40 (A robust witness against mixtures of unitary channels).**
Use a declared four-dimensional trace-preserving quantum channel Φ,
with the same channel applying to the compared preparations. Let

    s=(1,1,1,1)ᵀ/2,
    b_j=⟨j|Φ(|j⟩⟨j|)|j⟩,
    ε=Σ_{j=0}^3(1−b_j),
    q=tr(Π Φ(|s⟩⟨s|)).

Here Π and its exact phase-family margin μ are those of IiS34.
Every mixture of unitary channels, with arbitrary unitaries rather
than only diagonal phase actions, satisfies

    q≥[(√μ−√(2ε))_+]².                         (40a)

Thus upper acquired bounds q≤q_U, ε≤ε_U certify that Φ is
not a mixture of unitaries whenever

    q_U < [(√μ−√(2ε_U))_+]².

This is a sufficient witness from four basis-return preparations and
one coherent preparation with a Π reading. It is not full channel
tomography, nor a claim that five is a minimum acquisition count.
No exact Schur or basis-preserving form is assumed in (40a).

*Proof.* First consider one four-by-four unitary U. Choose a
diagonal unitary D whose diagonal phases agree with the nonzero
diagonal entries of U; choose any phase at a zero entry. Put
ε_U=Σ_j(1−|U_jj|²). Then

    ‖U−D‖_F² = 2Σ_j(1−|U_jj|) ≤ 2ε_U.

Since Ds is an equal-modulus phase input, ‖ΠDs‖≥√μ. For a
mixture Φ=Σ_a p_a U_a(·)U_a†, use the Hilbert-space norm that
is the square root of the weighted sum of squared vector norms.
The triangle inequality, contraction by Π and the displayed bound
give

    √q ≥ (√[Σ_a p_a‖ΠD_a s‖²]
                −√[Σ_a p_a‖(U_a−D_a)s‖²])_+
        ≥ (√μ−√[2Σ_a p_a ε_{U_a}])_+.

The last weighted sum is exactly the acquired ε. Squaring proves
(40a). The same proof holds for an admitted probability distribution
of unitaries. ∎

For every t>0 a simpler linear consequence is

    q+(2/t)ε ≥ μ/(1+t).

Indeed √q+√(2ε)≥√μ, and weighted Cauchy-Schwarz gives
(√q+√(2ε))²≤(1+t)q+2(1+1/t)ε. At t=1 the condition
q_U+2ε_U<μ/2 is a convenient, more conservative certificate.

**An admitted sufficient reading can replace the exact Π.** More
generally suppose the actual effect K satisfies 0≤K≤I and an
acquired uniform phase-family floor

    ⟨Ds|K|Ds⟩≥ℓ  for every diagonal unitary D.

For q_K=tr(K Φ(ss†)), the same proof with K^(1/2) in place of
Π gives q_K≥[(√ℓ−√(2ε))_+]² for every random-unitary
channel. Full identification of K as Π is unnecessary. In particular
IiS34's admitted controller has ℓ=B(μ,δ) and response at most
δ on N. Applied to the example below, whose ε is zero and
whose output is supported on N, it still violates the channel
inequality whenever B(μ,δ)>δ, precisely the already established
δ<δcrit region. The physical reading's old sufficient admission
therefore transfers directly to this new question; one need not
first pay the more conservative error of reconstructing its full
operator. General passive two-sided bounds from IiS36 can supply
their corresponding ℓ and intended upper response instead.

The channel's five preparation/reading combinations do not include
the separate work required to admit K, the basis preparations and
their detectors. The compared statistics must retain those actual
links; an ideal effect named Π in a calculation does not calibrate
an unexamined physical analyzer.

Only the sum of basis-return deficits is used. It can also be
acquired by uniformly preparing a classical label j, sending |j⟩
and checking whether the output label equals that same j. If the
return probability of this joined protocol is b̄, then
ε=4(1−b̄). The label remains part of the acquisition. Discarding
it first leaves the unlabelled state I/4, whose unchanged output
under every mixture of unitaries does not determine b̄. This is
one joint protocol with four preparation branches, not a replacement
by one unlabelled mixed-state expectation.

**The existing matrix supplies an explicit violating channel.**
Let V₀ have the rows used in IiS39 and set C_*=V₀V₀†. The map

    Φ_*(ρ)=C_* ∘ ρ

uses entrywise multiplication. It has diagonal Kraus operators

    A₀=diag(1,0,1/√2,1/√2),
    A₁=diag(0,1,1/√2,i/√2),

with A₀†A₀+A₁†A₁=I. It is therefore a completely positive
trace-preserving channel. Every basis state is preserved, so ε=0.
The coherent input gives Φ_*(ss†)=C_*/4=ρ_*, supported on N,
so q=0. This violates (40a) by the nonzero margin μ.

The same correlation matrix, in the transposed Heisenberg convention,
already appears in [Buscemi, Chiribella and D'Ariano, Eq. (9)](https://arxiv.org/pdf/quant-ph/0504195).
Their work establishes the decoherence/correction setting and the
four-dimensional counterexample. This is not a new channel or a
new discovery of the failure of classical environmental correction.
The present calculation supplies the displayed finite witness and
its population-error tolerance using the already constructed Π.
No claim of priority for this witness is made without a dedicated
literature comparison.

**What the witness says about recovery.** In the standard scheme,
one measures the entire output environment of an initially pure
environmental dilation, transmits its classical outcome to the
system and applies an outcome-dependent trace-preserving recovery
on the system. Exact deterministic recovery of every unknown input
on the full four-dimensional space is possible only for a channel
that is a mixture of unitaries. This is [Gregoratti and Werner's
Proposition 2 and its equal-dimension consequence](https://arxiv.org/pdf/quant-ph/0209025).
A violating acquired pair (q_U,ε_U) therefore excludes every
correction scheme of that form, without reconstructing the full
channel or searching through all environmental measurements.

**Every chosen three-path code can be correctable although the
four-path space is not.** For Φ_*, restrict the unknown input in
advance to any selected three of the four basis paths. Their three
environmental qubit Bloch vectors lie in an affine plane, so choose
a unit normal n with n·r_j=c constant on those selected paths.
Measuring the environment along n then has probabilities

    p_±=(1±c)/2

independent of the unknown path label within this code. Each
conditional diagonal Kraus operator therefore has equal entry
moduli √p_± on the code. For a nonzero branch it is a scalar
times a diagonal unitary, and the corresponding phase correction
restores every superposition in the selected three-path space.
Zero-probability branches are irrelevant. The choice of code and
its correction interface must be fixed for that use.

For all four paths, the Bloch vectors are (0,0,1), (0,0,−1),
(1,0,0), (0,1,0), which are not coplanar. The already proved
random-unitary exclusion rules out every general environmental
measurement and conditional trace-preserving recovery on the
whole four-dimensional input, beyond measurements along one
axis. Thus separately available corrections for every proper
three-path code do not supply one correction for an arbitrary
four-path input. This is the known qubit/qutrit versus four-level
boundary of the cited decoherence work, now expressed by the same
environmental profiles as the optical witness; no new priority is
claimed for that boundary.

The complete state can nevertheless be recoverable through coherent
joint access. One explicit dilation of Φ_* is

    |j⟩|0⟩_E ↦ |j⟩|v_j⟩_E,

where v_j are the two-component rows of V₀ read as environmental
kets. The map is an isometry and extends to a unitary on the joint
system. Its inverse restores the input when that joint coherent
operation is available. All the diagonal classical labels already
survive Φ_* unchanged. The obstruction concerns simultaneous
recovery of arbitrary superpositions by the specified classical
environment-to-system interface. It does not assert loss of the
global state, impossibility of probabilistic filtering, failure on
every smaller code or impossibility under unrestricted joint access.

**The exclusion is separated from the whole random-unitary set.**
As a further conservative consequence, use the convention

    h=(1/2)‖Φ_*−Ψ‖_diamond

for any random-unitary channel Ψ. Each output event probability
differs by at most h, so Ψ has q≤h and ε≤4h. Substitution in
(40a) gives

    h ≥ μ/(1+2√2)² = μ/(9+4√2).

For h<μ/8 take square roots and rearrange
√h≥√μ−√(8h); for h≥μ/8 the stated smaller lower bound
already holds. This is not asserted to be the exact distance or a
formula for the optimum approximate recovery fidelity. It does
show that the obstruction is not only a distinction at one exactly
specified matrix.

**A randomized witness can tolerate changing channels.** Separate
blocks of the five preparations cannot by themselves establish a
common channel. A setting-aware source can apply I on every basis
probe and a unitary R with Rs∈N on every coherent probe. It then
gives ε=q=0 although each applied transformation is unitary. Randomly
permuting those acquired records afterwards cannot repair the missing
relation between preparation and applied transformation.

There is a positive extension that does not require one stationary
channel. In round k, conditional on the admitted preceding history,
let Φ_k be a trace-preserving random-unitary map on a fresh input.
It may depend arbitrarily on that history. The current preparation
choice is sampled independently of this conditional map and is not
an additional control input to it. The actual quantum state remains
its input; independence does not mean the device is unable to respond
to that state. K is one admitted effect with phase-family floor ℓ.

Fix t>0 before acquisition. Choose the coherent preparation s with
probability t/(t+8), and each basis preparation |j⟩ with probability
2/(t+8). Give each round a binary flag X_k:

- on the coherent branch, X_k=1 when the K event occurs;
- on basis branch j, X_k=1 when the output fails its j-return test.

All admitted trials are counted. Under the conditional random-unitary
hypothesis, the linear form of (40a) gives

    Pr(X_k=1 | preceding history)
      =[t q_k+2ε_k]/(t+8)
      ≥ p₀(t):=ℓ t/[(1+t)(t+8)].                 (40b)

No temporal stationarity or independence of the output flags was
used. The common relation is between the five possible preparations
and the conditional map in this round. A classical preparation tag
that controls Φ_k destroys this premise, as the example above shows.
Trusted randomization is an experimental relation, not a conclusion
from the acquired frequencies or the absence of a declared wire.

The greatest guaranteed floor in this family is obtained at
t=√8=2√2:

    p₀=ℓ/(9+4√2).

Indeed the derivative of t/[(1+t)(t+8)] has the sign of 8−t².
This optimizes the displayed family of linear-witness sampling
rules. It does not compute the exact random-unitary boundary or the
best possible channel-testing protocol. For K=Π and Φ_* every
flag is zero in the ideal experiment, whereas every conditional
random-unitary explanation has the stated positive floor. The same
constant as the preceding diamond-distance lower bound appears
because both balance one coherent test against four return tests.

**A finite recorded result.** For a batch length n fixed in advance,
under (40b),

    Pr(Σ_{k=1}^n X_k≤c)
      ≤ Σ_{j=0}^c binom(n,j) p₀^j(1−p₀)^(n−j)   (40c)

for integers 0≤c≤n. To see this without an iid assumption, realize
each conditional Bernoulli flag from a fresh uniform random number
using its conditional probability p_k≥p₀. The same uniforms with
threshold p₀ produce independent Bernoulli variables bounded above
by X_k. This supplies a coupling and proves (40c). Equivalently,
backward induction on the remaining number of rounds proves the
same stochastic domination.

In particular an all-zero batch has probability at most (1−p₀)^n.
Taking n≥⌈log(α)/log(1−p₀)⌉ makes this particular rejection rule
have false-rejection probability at most α under the stated null.
This is an upper error probability conditional on that hypothesis,
not its posterior probability after seeing the data. Rejection
excludes the hypothesis that every conditional map remained in the
random-unitary class; it does not identify a stationary channel,
locate the exceptional round, or guarantee future behavior.

The counting rule uses actual acquisition randomization, joined
basis labels, and admitted event probabilities. It is not obtained
by shuffling a previously measured block experiment. Stopping or
repeating batches after favorable data requires the separately
allocated significance budget described above, or a justified
time-uniform rule. General witness games with correlated noise and
imperfect random choices are established methods; see [Dirkse et
al., Sections II–III and Appendix B](https://arxiv.org/pdf/2002.12400).
Here the explicit flag and its floor come from the present channel
inequality, rather than a new statistical principle.

**Finite calibration has to preserve a positive floor.** Suppose
the recorded coherent-event probability differs from its admitted
model probability by at most ζ_s, and each recorded basis-failure
probability by at most ζ_j, uniformly conditional on the preceding
history. With exact sampling probabilities, (40b) becomes

    p_eff(t)=max(0,
      [tℓ/(1+t)−tζ_s−2Σ_j ζ_j]/(t+8)).

If the conditional distribution of the five settings additionally
differs from its prescribed distribution in total variation by at
most ξ, replace this by max(0,p_eff(t)−ξ). The latter bound follows
because each branch event probability lies in [0,1]. Apply (40c)
using the remaining floor, if it is positive. Systematic errors
that reduce the floor to zero are not repaired by increasing n.
These error bounds must include the relation between preparation,
detection, missing events and their denominator; postselection on
successful transmission is not automatically the declared channel.

**An acquired analyzer can be admitted before the channel game.**
Learning may use an arbitrary procedure. Freeze its resulting K and
use a separate, valid admission experiment to produce δ_U with

    Pr(δ>δ_U)≤α_cal

in the admitted projection class. On its valid branch, the already
proved relation supplies ℓ=B(μ,δ_U), since B is nonincreasing
in δ over the relevant small-leakage range. It is unnecessary to
reconstruct K or the learning trajectory. If the resulting floor
is not useful, this acquisition gives no channel certificate.

Choose the channel-test parameters and its batch size from that
record before the new batch. Let its conditional false-rejection
budget be α_test. Under the conditional random-unitary hypothesis,
the probability of a false final exclusion is at most

    α_cal+α_test.

Indeed split failure into an invalid analyzer certificate and a
rejection on a valid calibration history. The first has probability
at most α_cal; on every valid history (40b)–(40c) bound the second
by α_test. If another instrumental relation is only statistically
admitted, its own failure budget must also be included or justified
jointly. A final data-dependent restart cannot silently reset them.

This closes a sufficient path from learning through independent
analyzer admission to a finite channel test. It still requires the
actual K used during the test to be the admitted K, or to have an
acquired transfer relation supplying the same floor. IiS38's
question-preserving V→W normalization gives one such exact relation;
its approximate form supplies a correspondingly weakened δ bound.
An analyzer replaced without that relation is a new unknown, even
if all past calibration records remain intact.

**A concrete carrier specification, not an experiment.** A direct
dilation uses four path modes as the system and polarization as a
two-dimensional environment. Starting with environmental H, apply
path-conditioned polarization rotations to prepare respectively

    H, V, (H+V)/√2, (H+iV)/√2.

Tracing polarization gives precisely Φ_*. An analyzer that acts
identically on both polarizations and sums their detections reads
K⊗I_E and thus q_K. The per-path inverse rotations restore any
path superposition before the polarization is discarded. This
specifies the contrast between coherent joint recovery and the
excluded classical environmental-feedback interface.

The path analyzer must actually satisfy the common-polarization
contract; otherwise the purported system-only measurement can use
the environmental degree of freedom that the question excluded.
Classical vector light also realizes the corresponding first-order
coherency equations. Single-photon preparation and the quantum
channel interpretation require their own experimental admission.
No chip, optical bench or quantum recovery test was run here. The
use of a qubit environment for non-random-unitary phase damping
has precedents, including [Helm and Strunz, Sections II–III](https://arxiv.org/pdf/0910.5364);
this specification asserts no experimental priority.

All quantum conclusions here require the channel, preparation and
measurement contracts just stated. The earlier classical-wave
coherency experiment alone does not establish a quantum channel or
exclude amplitude-varying classical fields; IiS32 explicitly supplies
such an amplitude-varying realization. The new physical meaning is
conditional on a separately admitted channel experiment, not inferred
from the word "phase" or from the mathematical matrix alone.

## §16p. Joint acquisition can certify support without identifying the analyzer

**IiS41 (A sharp support certificate and an optimal two-branch
acquisition).** Fix a projector P with 0<rank P<d on a
d-dimensional input space. Put Q=I−P and r=rank Q>0. The question about an
unknown density matrix σ is its leakage a=tr(Qσ). A binary
analyzer has an unknown effect 0≤K≤I; its event probability is
q=tr(Kσ). All probabilities use the complete admitted trial
population. The reference preparation and the actual source must
enter the same input space of the same analyzer in each compared
use. An extra preparation label supplied to the analyzer, or a
joint quantum register correlated with the source but absent from
the declared input, changes this contract.

IiS37 used an admitted approximation to Q to acquire leakage.
Full analyzer identification is a sufficient way to establish that
relation, but it is unnecessary for this particular question.

**One bright reference gives a sharp inverse bound.** Suppose the
reference τ=Q/r acquires a bright deficit

    b=r[1−tr(Kτ)]=tr(Q(I−K)) ≤ b_U <1.

For 0≤q_U<1−b_U and an acquired q≤q_U,

    a≤R(b_U,q_U)
      :=[√((1−b_U)q_U)+√(b_U(1−q_U))]².       (41a)

Set R=1 if b_U≥1 or q_U≥1−b_U. Thus R(b,0)=b and
R(0,q)=q. These are upper bounds on true probabilities, not
frequencies treated as exact expectations.

For a proof, first purify σ to |ψ⟩ and put
|w⟩=(Q⊗I)|ψ⟩/√a when a>0. Since Q(I−K)Q is positive
with trace at most b_U, ⟨w|K⊗I|w⟩=x≥1−b_U. Splitting
the overlap through K and I−K and applying Cauchy–Schwarz,

    √a=|⟨w|ψ⟩|
       ≤√(xq)+√((1−x)(1−q)).

For q<1−b_U, the right side is largest over x≥1−b_U
at x=1−b_U. Its square increases with q until q=1−b_U.
This proves (41a), including mixed σ. The case a=0 is immediate.

The bound is attained in a two-dimensional plane. Choose unit
u∈range Q, v∈range P, and

    k=√(1−b)u+√b v,     k_perp=√b u−√(1−b)v,
    K=|k⟩⟨k|+Q−|u⟩⟨u|,
    ψ=√q k+√(1−q)k_perp.

Then K is a projection, its bright deficit is exactly b, the
source event probability is q, and tr(Q|ψ⟩⟨ψ|)=R(b,q).
For q≥1−b, leakage one is possible under the same upper
calibration bound, by taking σ=|u⟩⟨u| and giving K eigenvalue
q on u and eigenvalue one on the other Q directions. When
b_U≥1, one entire Q direction can remain dark.

Only the bright reference was used. No zero response on P, rank
bound on K, full unitarity, or equality K=Q was assumed. For
example K=I passes the reference perfectly but never yields a
useful small source response. Soundness of a conditional certificate
does not require every admitted analyzer to accept a good source.
Conversely, without any relation between K and Q, K=0 hides
arbitrary leakage. Additional source trials alone cannot repair it.

The defect b is an operational floor for this calibration record:
even an exactly zero source probability cannot exclude leakage b.
This is a joint compatible realization, not an imperfection of the
decoder. Improving that conclusion requires stronger calibration
or an additional distinguishing contact.

**The same relation can be acquired jointly.** There is no need
to separate a calibration block from a source block. Fix 0<π<1.
In each trial secretly choose the actual source with probability π
or the known reference Q/r with probability 1−π. The analyzer
receives the chosen quantum state, but not an additional branch
label. Score a flag X=1 for a K event on the source branch or an
I−K event on the reference branch. Thus

    p=Pr(X=1)=πq+(1−π)b/r.

Both events are failures of the desired discrimination, but neither
identifies the guilty component on its own. Put t=(1−π)/(rπ).
For every σ and every positive contraction K,

    q+t b≥h_t(a)
      :=[1+t−√((1+t)²−4ta)]/2.                 (41b)

For a pure σ=|ψ⟩⟨ψ| with leakage a, minimize

    q+t b=tr(K(σ−tQ))+tr(tQ)

over 0≤K≤I. An effect supported on the negative eigenspaces
of σ−tQ attains the minimum. In span(Qψ,Pψ), its two
potentially nontrivial eigenvalues are

    [1−t±√((1+t)²−4ta)]/2.

The other r−1 Q directions have eigenvalue −t. Summing the
negative eigenvalues and adding tr(tQ)=t·r gives (41b).
Endpoint cases follow by continuity.
For a mixed state, apply the pure-state bound to a decomposition
using the same K. The function h_t is increasing and convex in
a, so Jensen's inequality gives the same bound at tr(Qσ).
This is the elementary spectral argument behind binary quantum
minimum-error discrimination, applied to the present question.

In particular a≥ε implies the exact single-trial floor

    p≥f_π(ε)
      =[x+y−√((x+y)²−4xyε)]/2,
    x=π,     y=(1−π)/r.                         (41c)

Every value of this lower boundary is attainable by a pure source
with leakage ε and a projective analyzer as above. The minimization
already permits arbitrary positive effects, so the result does not
rely on knowing that a laboratory analyzer is lossless.

**The best mixing probability is explicit.** For 0<ε≤1, define
s=√(r(1−ε)). The maximal guaranteed flag probability over this
particular two-branch, one-flag protocol is

    p_* = ε/[r+1+2s],
    π_* = (1+s)/[r+1+2s].                       (41d)

For an algebraic proof, let z=f_π(ε) and eliminate y=(1−x)/r.
The defining equation z(x+y−z)=εxy becomes

    εx²−[ε−z(r−1)]x+z−rz²=0.

The largest value of the lower root z is at a double root in x;
its discriminant is

    ε²−2ε(r+1)z+[(r−1)²+4rε]z².

The smaller zero is precisely p_*, and its x is π_*.
Substitution shows p_*≤min(x,y); it is therefore the relevant
lower root. Since f_π is the infimum of affine functions of π,
it is concave; this attained stationary maximum is global. At
ε=1 the formula gives x=y=1/(r+1) directly. No optimization
by numerical search is used.

As ε tends to zero,

    p_*/ε → 1/(1+√r)².

For the previous four-mode, rank-two question r=2, the exact
floor is ε/[3+2√(2(1−ε))]. This is a probability per complete
trial, not a number of optical contacts. The preparation and
control cost of supplying Q/r is still a separate resource.
Optimality in (41d) concerns this specified score and these two
preparation branches; it is not a lower bound for all conceivable
state-verification experiments.

**Uniform reference is minimax within its support.** More generally
let a known reference τ have support Q and least eigenvalue λ>0
on Q. Since τ≥λQ, its reference-failure probability is at least
λb. The same proof gives a floor with y=(1−π)λ. It is sharp:
choose u to be a least-weight eigenvector, use a pure source in
span(u,v), and let the analyzer be the identity on the other Q
directions. The optimized floor is

    p_{*,λ}=λε/[1+λ+2√(λ(1−ε))].               (41e)

For fixed π the bound increases with λ. Since λ≤1/r, Q/r
maximizes the worst-case floor among all references supported on
Q. A rank-deficient reference has λ=0: choose a hidden unit
u∈Q in its kernel, σ=|u⟩⟨u|, and K equal to the projector
onto the reference support. Both flag probabilities are zero.

Complete knowledge of τ is not necessary for a valid, possibly
nonsharp floor. The established relation τ≥λQ alone suffices
for (41e)'s fixed-π precursor, even if τ also has support on P.
Attainment and the reference-optimality claim above concern the
stated exact-support class. A claimed numerical λ must follow
from the preparation relation; a full-support name is not a lower
eigenvalue bound.

**A question-preserving action can improve the guarantee.** The
square-root calibration floor is caused by unknown cross action
between P and Q. If a further established relation gives [K,Q]=0,
then

    q≥(1−b)a,     a≤min(1,q/(1−b))  for b<1.  (41h)

Indeed the positive Q block is at least (1−b)Q, and the P
block contributes nonnegatively. With the same two-branch score,
minimization in this commuting class gives

    p≥min(πε,(1−π)/r)  whenever a≥ε.

To attain it, put the source's entire Q component on one direction
u, set K=I on the other Q directions and zero on P, and choose
the eigenvalue on u to be either zero or one. The optimal mixing
and exact single-trial floor for this restricted class are

    π_c=1/(1+rε),       p_c=ε/(1+rε).           (41i)

This improves (41d), except at ε=1 where they coincide. It does
not follow from the two observed numbers alone: the rotated
projectors attaining (41a) generally fail to commute with Q.

There is a constructive way to supply the relation without learning
K. If the exact reflection Z=P−Q is an admitted control, apply
it with probability one half before the analyzer, independently of
the probe branch and of the analyzer's current effect. Averaging
this actual physical action gives the pinching channel

    D(σ)=(σ+ZσZ)/2=PσP+QσQ.

It preserves a=tr(Qσ) and leaves Q/r unchanged. The effective
effect is

    K_eff=(K+ZKZ)/2=PKP+QKQ,

so it commutes with Q irrespective of the unknown K. Thus the
improved score floor applies to the original leakage question.
The ratio of its exact floor to (41d) is

    p_c/p_*=[r+1+2√(r(1−ε))]/(1+rε),

which tends to (1+√r)² as ε decreases to zero for fixed r.
This compares guarantees per trial, not total implementation cost.
The reflection and its randomization are additional resources.

A trusted reflection is a relation to the independently fixed P;
it is not supplied by writing the nominal inverse of an unadmitted
analyzer. In the earlier controlled optical interface, an admitted
W with W†D_out W=Q realizes it as
W†(I−2D_out)W. If W needs four G, this gives an upper bound
of eight G plus the phase screen; no minimality of that realization
is asserted. The extra control could outweigh a saving in acquired
events. A wrongly aligned W has the same defect as the reference
counterexample below.

If the actual pinching channel is at most ν from this ideal map
in half diamond norm, every branch event probability changes by
at most ν. Hence max(0,p_c−ν), with other admitted errors also
included, remains a sufficient flag floor. Requiring this control
accuracy is explicit; it is not inferred from successful counts.

Pinching destroys cross coherences. It preserves this population
question and the target P/2, but it need not preserve a later
question sensitive to those coherences. Using it on fresh destructive
validation trials does not justify modifying an untested retained
state. This is an instance of making the acquisition simpler by an
action that preserves the specified question, not by declaring all
removed relations physically absent.

**Finite trials and changing analyzers.** Fix the candidate P, the
mixing probability and batch length before the validation batch.
Conditional on the admitted previous history, each fresh source
probe and the reference must be tested by one common effect K_k.
K_k may change arbitrarily with that history. Under the null that
every conditional source has leakage at least ε, (41c) gives
Pr(X_k=1|history)≥f_π(ε). The coupling from IiS40 therefore
proves, for 0≤c≤n,

    Pr(ΣX_k≤c)
      ≤Σ_{j=0}^c binom(n,j) f_π(ε)^j
                          (1−f_π(ε))^(n−j).    (41f)

At π=π_* an all-zero batch accepts the source despite the
persistent-bad null with probability at most (1−p_*)^n. Thus

    n≥ceil(log α / log(1−p_*))

suffices for this rule. A fixed pure source and fixed minimizing
analyzer attain the bound, with iid trials. This is the exact
worst-case sample requirement of the stated all-zero rule at that
mixing probability, not a universal verification lower bound.

For a fixed conditional source state σ on each fresh source
trial, invert these tests to bound its leakage. If u is the ordinary one-sided binomial upper endpoint
computed from the count c and confidence budget α, put

    A_π(u)=[(x+y)u−u²]/(xy),  if u<min(x,y),
    A_π(u)=1,                otherwise.         (41g)

Then a≤A_π(u) is a valid one-sided confidence statement even
when K_k changes by history. The justification is inversion of
(41f); u is not asserted to bound every actual conditional flag
probability. For c=0, u=1−α^(1/n). For a varying source,
rejection only excludes the persistent-bad null. It does not by
itself certify the next source state or the quality of an untested
retained copy.

A candidate chosen by learning is allowed: condition on that
learning record and validate on fresh trials. This does not make
initial compressed readings valid for a later changed source. To
apply IiS37's state-distance bound to a fixed σ, that same-state
or transferred-reading relation remains necessary. With an admitted
compression error κ and leakage confidence endpoint a_U from
(41a) or (41g), its bound becomes

    (1/2)‖σ−P/2‖_1≤min(1,3√a_U+2κ).

The reference query is an additional preparation resource; it is
not silently included in IiS37's count of source expectations.
Failure budgets for compression and reference admission must be
combined with α. For a particular question, (37b) can use a_U
without requiring full-state identification.

**Classical shared information has an intermediate price.** The
unpinched bound has a useful extension beyond one common effect
on the averaged source. Let an unobserved classical variable ℓ
have the same distribution w_ℓ on both current branches, independently
of the current random choice. Conditional on ℓ the source is σ_ℓ
and the analyzer uses K_ℓ. They can be correlated. The reference
remains Q/r in every ℓ. No value of ℓ need be acquired.

Writing a_ℓ=tr(Qσ_ℓ), the flag probability satisfies

    p≥Σ_ℓ w_ℓ f_π(a_ℓ)
      ≥f_π(Σ_ℓ w_ℓ a_ℓ),

because f_π is convex. Thus (41c) and its optimized floor remain
valid for the actual average input leakage. A fixed pure source and
analyzer still attain the lower boundary, so the larger classical
class has not weakened this particular guarantee.

The stronger pinched price (41i), however, does not survive the
same extension unchanged. Conditional on ℓ its floor is
min(πa_ℓ,y), where y=(1−π)/r. This function is concave,
but min(πa_ℓ,y)≥a_ℓ min(π,y). Consequently the exact
classically correlated pinched floor and optimal mixing are

    p_corr=ε/(r+1),        π_corr=1/(r+1).       (41j)

For attainment let ℓ be freshly drawn with probabilities 1−ε
and ε. In the first branch set σ_ℓ to a pure P state and
K_ℓ=Q, giving no flag. In the second set σ_ℓ=|u⟩⟨u|
for u∈Q. If π≤y choose K_ℓ=Q, giving flag probability π;
otherwise choose K_ℓ=Q−|u⟩⟨u|, giving probability y.
All these effects commute with Q. The average source has leakage
ε, and the total flag probability is ε min(π,y). Maximizing
this expression proves (41j). A prior that fixes only the marginal
input state cannot justify the larger price in (41i).

Thus the independent-source commuting contract, a classically
correlated source and analyzer, and a joint quantum register are
three different acquired situations. Formula (41j) still improves
the unpinched floor, while the quantum-register example below can
violate both corresponding local-input bounds. No information is
called irrelevant solely because its classical label was not read.

**The reference and actual branch relationship still do work.**
If the actual reference differs from Q/r in trace distance by at
most ν_R, its contribution changes the flag floor by at most
(1−π)ν_R. A bounded source-routing error ν_S adds at most
πν_S. A total-variation error ξ in the intended branch choice
subtracts at most ξ. Thus a sufficient remaining floor is

    max(0,f_π(ε)−(1−π)ν_R−πν_S−ξ).

Use it in (41f), if positive. Unknown detector efficiency or a
common binary reporting error can be absorbed into K_k itself;
no separate close-to-Q assumption on that effect is needed.
The outcome and trial-denominator relation still must be admitted.

Three explicit failures locate the remaining obligations.

1. A wrong reference can agree perfectly with the analyzer. In a
   two-dimensional plane take P=|0⟩⟨0|, Q=|1⟩⟨1|,
   k=cosθ|1⟩+sinθ|0⟩, K=|k⟩⟨k|, and prepare the actual
   reference |k⟩ instead of |1⟩. The orthogonal source
   cosθ|0⟩−sinθ|1⟩ gives q=0, while the reference is bright
   with probability one. Its leakage is sin²θ. Preparing and
   reading through the same wrongly aligned inverse controls can
   create this agreement. A common change of the question P as
   well is a different, covariant statement; here P was fixed.

2. If the current branch label is available separately, K=0 on
   source trials and K=I on reference trials make every flag zero
   for any source. The actual quantum input may inform the
   analyzer in the usual way; the minimization over K already
   includes that possibility. What is excluded is an additional
   perfectly readable source/reference label or other unmodelled
   degree of freedom carrying it.

3. Postselection can give perfect retained results at equal keep
   rates. In two dimensions let ψ=√(1−a)|0⟩+√a|1⟩ with
   0<a<1, and reference |1⟩. Use the three-outcome measurement
   E_0=|0⟩⟨0|/2, E_1=|ψ_perp⟩⟨ψ_perp|/2, and
   E_?=I−E_0−E_1≥0. Interpret outcomes 0 and 1 as the
   desired source/reference answers and discard ?. No retained
   answer is wrong, while both branches retain exactly (1−a)/2
   of their trials. Keeping those equal detection fractions does
   not repair the invalid renormalization. All complete trials
   were essential to (41f).

There is a quantum-context limit as well. For r=2, let a source
be maximally entangled between Q and an extra two-dimensional
register R available to the analyzer. Its leakage is one. Replace
only the input on reference trials, so that the joint reference
is (Q/2)⊗(I_R/2), and choose the joint effect
K_joint=I−|Φ_2⟩⟨Φ_2|. The source event is zero and the
reference failure probability is 1/4. At π=1/3 the flag
probability is 1/6, below (41d)'s claimed local-input floor 1/3.
This does not refute (41d): no single effect on the declared input
alone describes both uses. Fresh probes independent of the
analyzer's quantum memory, or an enlarged admitted input contract,
are needed. Classical history dependence and the correlated classical
extension above were permitted; arbitrary unmodelled quantum side
information was not.

An admitted finite quantum context can restore a bound. Suppose
R has dimension m and, conditional on the admitted history, its
marginal ω_R satisfies ω_R≥λ_R I_R with λ_R>0. On a
reference trial replace only H by Q/r, leaving the same marginal
on R. The joint reference is then

    τ_HR=(Q/r)⊗ω_R≥(λ_R/r)(Q⊗I_R).

Apply the reference bound above on the enlarged, explicitly declared
input H⊗R, with Q'=Q⊗I_R and λ=λ_R/r. This gives

    p≥[x+y−√((x+y)²−4xyε)]/2,
    x=π,     y=(1−π)λ_R/r,

for a joint source with tr(Q'σ_HR)≥ε and any common joint
effect. The bound is valid without accessing R for measurement.
It uses its acquired marginal lower bound and the reference-replacement
relation, not a claim that all external memory has been described.
Additional marginal constraints can make this sufficient bound
nonsharp; no universal optimum under all such constraints is claimed.

For a uniform marginal ω_R=I_R/m, the earlier formula uses
the effective reference rank rm. In the explicit r=m=2 example,
at ε=1 it supplies the floor 1/5 with source probability 1/5.
The maximally entangled source and K_joint above attain it.
Thus admitting that particular extra register changes the attainable
verification price instead of making verification impossible.
Unknown or unbounded additional quantum context remains outside
this repaired contract.

**Relation to existing verification work.** Quantum state verification
already connects expectation gaps to finite sample requirements;
[Pallister, Linden and Montanaro](https://arxiv.org/abs/1709.03353)
is one primary source. [Chen et al., PRX Quantum 6, 040353,
§II](https://journals.aps.org/prxquantum/pdf/10.1103/fyw6-lq1l)
explicitly study subspace overlap and combine its verification with
further logical-state estimation. Their given verification-operator
construction differs from the unknown-effect joint acquisition
here. Trusted preparation with uncharacterized measurement is also
an established research direction; [Pusey, §I](https://arxiv.org/pdf/1502.03010)
treats channel quantumness, a different question. These are primary
comparisons, not evidence of priority for the present formulas.

The contribution to this chain is a complete relation between a
partially specified reference, an unknown analyzer, the desired
support question, optimal two-branch mixing, and finite acquisition.
It removes a need to identify K, but retains and tests the
consequences of the actual relations that replaced that need.
No optical apparatus or quantum experiment was run for this result.

## §16q. Local replacement and private control admit arbitrary correlated memory

**IiS42 (Sharp support testing with arbitrary correlated memory).**
IiS41's finite-register repair is sufficient, but a dimension cutoff
and a lower eigenvalue bound on the memory are unnecessary under
genuine local replacement. This continuation audits the supplied
analytical note, retains its question and score, and proves three
sharp guarantees. Memory can have any finite dimension, without a
common upper bound. No assertion about arbitrary infinite-dimensional
operator domains is needed.

Let S be finite dimensional, P a nonzero proper projector,
Q=I−P, and r=rank Q. The analyzer can access an arbitrary register
R correlated with the source. Before the current private branch
choice the joint state is ω on S⊗R. Write

    Ω=(Q⊗I_R)ω(Q⊗I_R),     a=tr Ω,
    ω_R=tr_S ω,             τ=Q/r.

The source branch supplies ω. The reference branch replaces only
S and supplies

    θ=τ⊗ω_R.                                      (42a)

The same marginal R remains available. The old S can move into an
inaccessible internal reserve; local replacement does not require
destruction of global history. Supplying that reserve or an extra
preparation label to the analyzer would change (42a). The branch
choice, with source probability π, is independent of the pre-existing
joint state and unavailable separately to the analyzer. One common
effect 0≤K≤I acts on its complete declared input. A flag is the K
event on the source branch or its complement on the reference branch:

    p=π tr(Kω)+(1−π)tr[(I−K)θ].

All trials are counted. The null is a≥ε, where 0<ε≤1. Conditional
past history is permitted, provided these relations hold afresh at
each current trial. The state and K need not be identified.

The exact optimized lower flag probabilities are

| Common local preprocessing before K | Sharp floor under a≥ε |
|---|---|
| Identity | ε²/[r²+ε+2r√(ε(1−ε))] |
| P–Q pinching | ε/(r²+1) |
| Pinching and depolarization within Q | ε/2 |

These optimize the branch probability within the stated experiment;
they do not optimize all physical experiments or their total costs.
The last row also attains a ceiling for the common local channel
class specified below.

**The joint relation supplies a dimension-independent inequality.**
For every source in (42a),

    Ω≤r(Q⊗ω_R),          θ≥Ω/r².                  (42b)

For an unnormalized vector χ supported in Q⊗R, write its Schmidt
decomposition χ=Σ_{j=1}^k √s_j u_j⊗v_j, with k≤r. For every z,

    |⟨χ,z⟩|²≤k Σ_j s_j |⟨u_j⊗v_j,z⟩|²
              ≤r⟨z,(Q⊗tr_S|χ⟩⟨χ|)z⟩.

Summing over a pure decomposition proves
Ω≤r Q⊗B for B=tr_S Ω. The partial traces of P–Q cross blocks
vanish. Hence ω_R=B+tr_S[(P⊗I)ω(P⊗I)]≥B, proving (42b).
Neither an inverse of ω_R nor its least eigenvalue occurs. The
relationship of the two inputs replaces that spectral assumption.

**The unprocessed boundary is sharp, including for mixed sources.**
Set x=π and c=(1−π)/r². For 0<π<1,

    p≥g_π(a)
     =[x+ca−√((x+ca)²−4xc a²)]/2.               (42c)

Indeed, (42b) bounds p below by
x tr(Kω)+c tr[(I−K)Ω]. For ω=|ψ⟩⟨ψ| and a>0, put
Ω=a|w⟩⟨w|. Then |⟨w,ψ⟩|²=a. Minimizing over effects is
the spectral minimum of x|ψ⟩⟨ψ|−ca|w⟩⟨w|, plus ca.
On their two-dimensional span its trace is x−ca and its
determinant is −xc a(1−a). The resulting minimum is (42c).
At a=0,1 the same expression holds by continuity.

For a mixed decomposition with leakages a_j and weights t_j,
the same fixed K gives a lower bound Σ_j t_j g_π(a_j).
Writing R(a)=(x+ca)²−4xc a², differentiation gives

    g_π''(a)=2x³c/R(a)^(3/2)>0,     g_π'(0)=0.

Thus g_π is convex and nondecreasing. Endpoint degeneracies are
handled by continuity. Jensen's inequality proves (42c) at the
actual mean leakage. The cases π=0,1 have the zero lower bound.

For attainment choose a unit vector u in P, a basis q₁,…,q_r
of Q, and orthonormal memory vectors 0,1,…,r. Prepare

    ψ_a=√(1−a)|u,0⟩+√(a/r)Σ_j |q_j,j⟩,
    Φ_r=(1/√r)Σ_j |q_j,j⟩.

Then Ω=a|Φ_r⟩⟨Φ_r| and
ω_R=(1−a)|0⟩⟨0|+(a/r)Σ_j|j⟩⟨j|.
The reference has eigenvalue a/r² on Φ_r. The positive remainder
θ−Ω/r² is orthogonal to span{|u,0⟩,Φ_r}. Set K=I on that
remainder and use the minimizing spectral projector on the span.
Every inequality in (42c) is an equality. The source itself works
for every π; only the minimizing effect changes. For 0<a<1 this
uses dimension r+1 of R, and at a=1 dimension r suffices. Sharpness
is over the allowed memory class, not every separately fixed smaller R.

Monotonicity reduces a≥ε to a=ε. The optimal branch choice is

    D=r²+ε+2r√(ε(1−ε)),
    π_mem=[ε+r√(ε(1−ε))]/D,
    p_mem=ε²/D.                                  (42d)

One explicit optimization check is to put z=g_π(ε). Its quadratic
identity, with the smaller spectral root understood, is

    ε²π²+[z(r²−ε)−ε²]π+εz−r²z²=0.

At (42d) the quadratic in π has zero discriminant. For 0<ε<1,
substitution gives the smaller root and ∂g_π(ε)/∂π=0.
Concavity in π follows independently: for the fixed attaining
source the score is the infimum over K of affine functions of π.
Thus this stationary point is a global maximum. At ε=1,
g_π(1)=min(π,(1−π)/r²), giving π_mem=p_mem=1/(r²+1).
For fixed r and small ε, p_mem is asymptotic to ε²/r².
For r=2, a=1, π=1/3, (42c) gives 1/6, exactly IiS41's
quantum-memory counterexample; optimizing π gives 1/5.

A useful sharp corollary concerns an exactly dark source. If
tr(Kω)=0 and z=tr[(I−K)θ], then

    a≤min(1,r√z).                                (42e)

Let E be the support projector of ω. Darkness and positivity
give KE=0 and I−K≥E. Thus z≥tr(EΩ)/r². Hilbert–Schmidt
Cauchy–Schwarz applied to √ω and E(Q⊗I)√ω gives
a²≤tr(EΩ), because their inner product is a and the first
squared norm is one. The pure family above with K=I−|ψ_a⟩⟨ψ_a|
attains z=a²/r². Darkness alone cannot remove this context cost.

**Removing cross coherence changes the exact memory price.**
Apply D_PQ(ρ)=PρP+QρQ locally on both branches. It preserves a
and fixes τ. The source is the sum of its two positive diagonal
blocks. Dropping its nonnegative P contribution and using (42b),

    p≥π tr(KΩ)+(1−π)tr[(I−K)Ω]/r²
      ≥a min(π,(1−π)/r²).

Pinching ψ_a gives the mixture of |u,0⟩ and Φ_r. Choose K=0
on the first, K=I on extra reference support, and K=0 or I on
Φ_r according to the cheaper coefficient. This attains the bound.
Consequently

    π_deph=1/(r²+1),       p_deph=ε/(r²+1).       (42f)

IiS41's ε/(r+1) for correlated classical memory remains a different
theorem on a smaller class. No classical and quantum memory bounds
are silently identified.

**A stronger local action preserves all of P.** Define

    T_Q(ρ)=PρP+tr(Qρ)Q/r.                        (42g)

On the full input it gives

    (T_Q⊗id_R)(ω)=ω_PP+(Q/r)⊗B,
    B=tr_S Ω≤ω_R,       tr B=a.

It fixes τ and preserves the original leakage. It is exactly the
identity on every state supported in P, including entangled states
with R. It need not preserve cross coherence or information within Q.

There is an explicit unitary implementation without first measuring
P versus Q. Let W_jk be the r² Weyl unitaries on Q. Uniformly
and privately select one of

    U_sjk=P+(−1)^s W_jk,      s∈{0,1}.           (42h)

Here W_jk is zero outside Q. Averaging over s cancels the cross
blocks. Weyl averaging sends every Q block to its trace times Q/r,
including operator-valued blocks on R. This proves (42g). One trial
uses one selected unitary, not 2r² sequential trials. This is an
upper construction for the ensemble size, with no minimality claim.
The fresh seed must be independent of the conditional input and
unavailable to the analyzer until its recorded outcome. The controller
may retain it internally; global information need not be erased.

For any joint K define the memory effect

    M=tr_S[(Q⊗I)K(Q⊗I)]/r,       0≤M≤I_R.

The flag probability after (42g) obeys

    p≥π tr(MB)+(1−π)tr[(I−M)ω_R]
      =π tr(MB)+(1−π)tr[(I−M)B]
        +(1−π)tr[(I−M)(ω_R−B)]
      ≥a min(π,1−π).

The last discarded term is nonnegative: both factors are positive,
though they need not commute. Therefore

    π_twirl=1/2,             p_twirl=ε/2.         (42i)

For equality it suffices to use classical memory:

    ω=(1−a)ρ_P⊗|0⟩⟨0|+aτ⊗|1⟩⟨1|,
    θ=τ⊗[(1−a)|0⟩⟨0|+a|1⟩⟨1|],

with ρ_P supported in P. On memory label 0 the two states
are orthogonal and have zero minimum flag score. On label 1 they
are identical τ and give a min(π,1−π). No quantum entanglement
is required to attain this boundary.

This also proves a ceiling for every common local CPTP channel F
on S satisfying

    F(τ)=τ,                  F*(Q)=Q.            (42j)

The second condition keeps F(ρ_P) in P, by positivity and its
zero Q expectation. The first leaves the shared τ component
unchanged. The same classical construction still attains the
minimum a min(π,1−π) after F. Hence no such F in this same
two-branch, one-terminal-flag protocol can guarantee more than ε/2
for arbitrary shared memory. T_Q attains the ceiling. This does
not constrain protocols with further trusted measurements, different
accessible outputs, or a different reference question.

For comparison, if the source and analyzer memory are independent,
the Q block after T_Q is aτ times that same independent memory.
Direct minimization gives min(πa,1−π), optimized to ε/(1+ε).
The remaining penalty in (42i) is already forced by classical
correlation. None of these soundness guarantees forces an arbitrary
badly functioning analyzer to accept a good source. For good P
states a zero-flag analyzer exists, K=Q⊗I; arbitrary K may reject
them. No completeness guarantee for an unknown apparatus is inferred.

**The preserved question and failed extensions are explicit.**
The adjoint is

    T_Q*(O)=POP+[tr(QO)/r]Q.

Consequently its fixed observable space is exactly

    { PAP+cQ : A acts on P, c is a scalar }.      (42k)

This follows in both directions by comparing diagonal and cross
blocks. All observables internal to P survive. An arbitrary later
operation that converts discarded coherence into a population changes
the requested question. A family of later readings requires F*(O)=O
for each O that is actually reused.

Two short counterexamples show why the input relationships cannot
be replaced by nominal device names.

1. **Disclosed random seed.** For r=2 take source Φ₂ supported
   in Q⊗R, leakage one, and θ=τ⊗I_R/2. If the selected U in
   (42h) is disclosed, the analyzer can undo it and use
   K₀=I−|Φ₂⟩⟨Φ₂|. Equivalently it uses the seed-dependent
   effect (U⊗I)K₀(U†⊗I). The source event is zero and reference
   failure is 1/4. At π=1/2 the score is 1/8, below (42i)'s
   1/2. Every U fixes τ; revealing its value is enough to break
   the averaged-input guarantee.
2. **Changed memory on replacement.** Let the source be
   σ⊗|0⟩⟨0|, even with leakage one. If the actual reference is
   τ⊗|1⟩⟨1|, K=I_S⊗|1⟩⟨1| gives zero flags on both
   branches. This is a perfectly readable extra branch label and
   violates (42a). More source trials do not repair that violation.

**A concrete control cost in the admitted four-mode interface.**
For r=2 use the already admitted W satisfying W†D_out W=Q,
with at most four G contacts, and its actual inverse. The controls
in (42h) are

    W†[I_{P bank} ⊕ (−1)^s σ_j]W,
    σ_j∈{I,X,Y,Z}.

I and Z in the Q bank require diagonal phases only; X and Y
require at most one G plus diagonal phases. For example the G
with c=0,s=1,φ=π/2 is iX, and with φ=0 is iY; a block
phase supplies the remaining scalar. Thus a selected control needs
at most nine G plus phase screens. Pinching needs at most eight G
plus a phase screen, as in IiS41. These are constructive upper
counts, not minima, and phase screens are additional admitted controls.
Reciprocal propagation cannot be substituted for W† without an
established inverse relation.

The channel is invariant under a change of basis within Q, so W
need only establish the P/Q banks. Knowing every internal Q basis
coordinate is unnecessary. But a wrongly aligned splitter changes
the original question and is not repaired by internal averaging.

For fixed false-acceptance allowance 0<α<1, the all-zero rule
uses the sufficient exact worst-case count

    N(p₀,α)=ceil[log α/log(1−p₀)].                (42l)

Under a specified additive cost model with common trial cost C₀,
G cost C_G and additional admitted phase/seed costs C_φ,D and
C_φ,T, sufficient execution budgets are respectively

    N(p_mem,α) C₀,
    N(p_deph,α)(C₀+8C_G+C_φ,D),
    N(p_twirl,α)(C₀+9C_G+C_φ,T).

Reference preparation, reference fractions, acquisition of W, and
label-hiding delays must be included in the actual C₀ or added
explicitly; branch-dependent costs must be weighted using that row's
π. The displayed common C₀ may instead be a common upper bound.
Comparing upper budgets alone does not establish an actual runtime
advantage. If C_D and C_T are actual comparable per-trial costs,
then for r=2 and small ε the leading total costs are
5C_D log(1/α)/ε and 2C_T log(1/α)/ε. Twirling is cheaper
in that limit precisely when C_T<(5/2)C_D. This isolates a resource
question instead of calling randomization free. Variable control
routes must not disclose the seed or source/reference branch.

**Errors, repeated use and instruments.** If the actual joint
source and reference inputs to K have trace distances at most
δ_S,δ_R from their ideal processed inputs, then

    p_actual≥p_ideal−πδ_S−(1−π)δ_R.              (42m)

At (42i) the floor is ε/2−(δ_S+δ_R)/2, if positive. A half
diamond-norm bound on the implemented local channel is sufficient
uniformly over entangled R. A directly acquired bound on the actual
joint inputs also suffices. Reduced S-state accuracy alone does not.
For a composed implementation, half diamond errors add by telescoping
and contraction; the nine-contact construction has the sufficient
control error bound 9ν_G+ν_phases when each G has error at most
ν_G. Preparation, private-choice and routing errors are separate.
A zero remaining certified floor is inconclusive, not proof that
all physical protocols fail.

If every conditional trial under the null a_k≥ε has a positive
floor p₀, conditional multiplication gives

    Pr(no flags in n trials)≤(1−p₀)^n.

The constructions above can be freshly repeated to attain this
bound, so (42l) is sharp for that declared rule and ideal class.
Adaptive history and arbitrarily large admitted quantum memory do
not require an iid assumption. Fresh branch/seed independence and
the local-replacement relation remain required on every trial.
This rejects persistently bad conditional input leakage; unrestricted
drift does not permit certification of the next untested state or a
retained copy. Optional restarts still need a total failure budget.

Finally, an effect does not determine a measurement instrument.
For any unitary V, the instrument

    I₀(ρ)=VPρPV†,           I₁(ρ)=QρQ

has effects P,Q and is trace preserving in sum, while V can move
a good state out of P after the non-event. T_Q's preservation of
P does not establish nondisturbance of the unknown final analyzer.
Reuse of a measured output therefore needs its own continuation
relation.

**Relation to prior results and scope of the audit.** The spectral
minimization is the standard binary discrimination geometry; see
[Watrous, Theorem 3.4](https://cs.uwaterloo.ca/~watrous/TQI/TQI.3.pdf).
For normalized inputs its minimum is
[1−‖πρ−(1−π)θ‖₁]/2. A common channel cannot decrease this
minimum, by trace-norm contraction. Here that helps soundness by
removing distinctions that let a leaking source avoid the flag,
while preserving the question. Private random unitary channels are
an established resource; [Mosca, Tapp and de Wolf, §4](https://arxiv.org/html/quant-ph/0003101)
give the Pauli construction. Their full-register encryption problem
differs from preserving P while randomizing Q. Sequential memory
and connected instruments also have an established framework in
[Chiribella, D'Ariano and Perinotti](https://arxiv.org/html/0904.4483).
These comparisons do not establish priority of the present minimax
formulas or an experimental implementation.

The supplied continuation's operator inequality, pure attainers,
mixed convexity, optimal priors, preprocessing bounds and ceiling
were independently rederived analytically. The explicit failure
constructions and four-mode control budget locate their physical
obligations. No numerical matrix script, Swift compiler, judge or
apparatus was run for this result. IiS41's finite-memory argument
remains valid on its original scope; (42a–m) supplies the stronger
scope through the actual source/reference relationship.

## §16r. A support-preserving test can destroy a recoverable continuation

**IiS43 (A reusable repair construction and its continuation boundary).**
IiS42's channel T_Q preserves support leakage and every state wholly
inside P. It is an intervention for a stated test, not an error
corrector. An input outside P can still carry perfectly recoverable
logical information. The following finite construction specifies when
that information can be restored, what T_Q makes impossible, and
which resources a repeated execution must retain.

Let H=L⊗S, dim L=d≥2 and dim S=2. S is a syndrome register,
not the entire physical input S used in IiS42. Put

    P=I_L⊗|0⟩⟨0|,       Q=I_L⊗|1⟩⟨1|,
    Enc(ρ)=ρ⊗|0⟩⟨0|,    V=I_L⊗|1⟩⟨0|.

Thus rank P=rank Q=d. The tensor coordinates represent an
admitted correspondence between two physical mode banks. Equivalently,
given orthogonal equal-rank P,Q and an admitted partial isometry
V with V†V=P and VV†=Q, use these formulas in that frame.
For d=2 the carrier has four modes. A bank splitter alone need
not determine V's internal correspondence.

**A constructor restores the data and the syndrome.** Define

    C(σ)=PσP+V†σV
        =tr_S(σ)⊗|0⟩⟨0|.                       (43a)

The Kraus operators P,V† satisfy P+VV†=I, so C is CPTP.
For a channel E with Kraus operators E_j, this particular C
corrects every encoded input exactly iff

    E_j P=α_j P+β_j V   for every j.            (43b)

Sufficiency is constructive: PE_jP=α_jP and V†E_jP=β_jP,
so C E Enc(ρ)=Σ_j(|α_j|²+|β_j|²)Enc(ρ)=Enc(ρ).
Trace preservation supplies the coefficient sum one. Equality of
channels also preserves correlations with every untouched reference.
For necessity, every Kraus operator of the identity channel on
the code must be a scalar multiple of identity there. To see this,
a pure input has a pure identical output, so each Kraus image is
collinear with that input; linearity on superpositions makes the
coefficient independent of the input. Apply this to the composite
Kraus operators PE_jP and V†E_jP. Adding their P and Q
components yields (43b).

This is a special instance of the established Knill–Laflamme
conditions: P E_i†E_j P=(α_i*α_j+β_i*β_j)P. The construction
does not provide protection against arbitrary errors on the logical
register. It makes the relation needed by this particular repair
explicit; see [Knill and Laflamme, Theorems 3.2–3.5](https://arxiv.org/html/quant-ph/9604034).

For example, E may apply any channel to S alone. It may also
give a coherent syndrome rotation, rather than a classical error
flag. Let J=V+V†=I_L⊗X. Both an arbitrary mixture of I,J
and exp(iθJ), with unknown θ, satisfy (43b). C corrects them
without acquiring their mixture probability or θ. With a working
implementation of C available at each step, repeated noise–repair
cycles return the same encoded logical state by induction. Supply
and reset of that implementation's resources are addressed below.

**The subspaces do not specify the repair map.** If the actual
transfer is VU for an unknown logical unitary U, the nominal
repair V† returns UρU†, wholly in P. All P/Q population
readings of VρV† and VUρU† report the same complete transfer.
For a logical qubit, U=Z sends |+⟩ to |−⟩ after nominal repair,
although the post-repair leakage is exactly zero.

There is no common universal repair for all such U: one available
input V|ψ⟩ can arise from logical ψ with transfer V or from
logical U†ψ with transfer VU. A decoder would have to give
two different answers on the same input. Thus a relative logical
correspondence, or some weaker relation sufficient for the selected
question, is needed in addition to the bank geometry. IiS42's
basis independence within Q is useful for its test, but it cannot
be silently borrowed for restoration of arbitrary logical data.

**What happens when the test preprocessing is reused on the data.**
Consider the correctable noise, with 0≤η≤1,

    N_η(ρ)=(1−η)ρ⊗|0⟩⟨0|+ηρ⊗|1⟩⟨1|,

as a channel from L to H. Its leakage is η and C N_η=Enc.
Applying IiS42's full randomization on Q instead gives

    A_η(ρ)=T_Q N_η(ρ)
          =(1−η)ρ⊗|0⟩⟨0|+η(I_L/d)⊗|1⟩⟨1|. (43c)

For an entangled input ρ_LR the second component becomes
(I_L/d)⊗|1⟩⟨1|⊗ρ_R. Logical correlations on that component
are absent from the available output. The statements below give
the recovery access to H only, with arbitrary fixed ancillary
resources independent of the unknown input. They exclude the
private random seed and complementary environment containing the
discarded information. That access restriction is essential.

Three execution tasks now have distinct exact answers.

**A deterministic unknown-state output has an unavoidable error.**
Over all CPTP recoveries R:H→L,

    inf_R (1/2)‖R A_η−id_L‖_diamond
          =η(1−1/d²).                            (43d)

Any such recovery produces a logical channel
Λ=(1−η)R₀+η Rep_τ, where R₀ is CPTP and τ is a fixed
state. On a normalized maximally entangled input Φ_d, its overlap
with the desired Φ_d is at most 1−η+η/d²: the first component
has overlap at most one, and τ⊗I/d has overlap exactly 1/d².
The binary measurement {Φ_d,I−Φ_d} gives the lower trace-distance
bound in (43d), and hence a lower diamond bound for every R.

For attainment decode by tr_S, giving
Λ=(1−η)id+ηD with D(ρ)=I/d. Weyl averaging writes
D=d⁻²Σ_j Ad_{W_j}, with one W_j=I and the other d²−1
unitaries traceless. The triangle inequality gives
(1/2)‖id−D‖_diamond≤1−1/d², since a difference of two
channels has diamond norm at most two. Φ_d attains equality.
This proves both the optimization and its attaining recovery. For
the four-mode case the bound is 3η/4. The noise was exactly
correctable before T_Q; this floor is introduced by that action.

**An exact heralded output has a sharp success price.** A trace-
nonincreasing success map may return the correct unknown state
only when it declares success. Its success probability, uniformly
over all logical states, is at most

    1−η.                                        (43e)

For a pure input ψ write its successful unnormalized output as
(1−η)S₀(ψ)+ητ=p_ψ ψ, where τ≥0 is the image of the fixed
Q component. If η>0, positivity forces the support of τ inside
the ray of every ψ. Since d≥2 this requires τ=0. Thus
p_ψ≤1−η for every ψ. When η<1, exactness on every pure input
forces each Kraus operator of S₀ to be a scalar identity, so
S₀=q id with q≤1 and success probability (1−η)q independent
of the input. Keeping P and decoding attains (43e). At η=1
there is no nonzero universal exact success branch. Discarding
failed specimens cannot be reported as a deterministic repair.

**Some binary questions remain exactly implementable.** Let
0≤A≤I_L be a desired logical effect. A single effect 0≤M≤I_H
on A_η(ρ) reproduces tr(Aρ) for every logical ρ iff

    λ_max(A)−λ_min(A)≤1−η.                      (43f)

Indeed, A_η*(M)=(1−η)M₀₀+ηb I_L, with
b=tr(M₁₁)/d∈[0,1] and 0≤M₀₀≤I. Necessity follows
from the spectral spread. For 0<η<1 and the stated inequality,
choose any t in the nonempty interval

    max(0,λ_max(A)−(1−η))≤t≤min(η,λ_min(A)),

then set M₀₀=(A−tI)/(1−η) and M₁₁=(t/η)I, with
zero cross blocks. This is an effect giving the required reading.
At η=0 every effect is possible; at η=1 precisely scalar effects
are possible. Every nontrivial projector has spectral spread one,
so a nonzero η excludes its exact single-trial reproduction. Weaker
contrast can still be read exactly by the displayed construction.

For η<1, A_η is nevertheless injective: its P block is
(1−η)ρ. Knowing that entire output density operator would determine
ρ by a linear formula. Repeated preparations with a justified
common η can also support statistical inversion. Such inversion
is not a CPTP map producing one unknown quantum specimen and is
not automatically a binary effect with outcomes in [0,1]. The
mathematical availability of a decoder and its admissible physical
execution are separate questions. Equations (43d–f) give exact
differences between them; multiple-use coding is outside this model.

The effect synthesis in (43f) uses the actual η. If two distinct
rates remain possible and one fixed M must implement A for both,
subtracting the two equations
A=(1−η)M₀₀+ηbI forces M₀₀=bI and hence A=bI. Thus only
scalar effects work uniformly without resolving that rate ambiguity
in this single-trial format. In contrast, the deterministic and
heralded attaining state recoveries above do not need η as an
execution input. A parameter known to the proof is not thereby
available to the executor. A full output density description would
include η as its Q population; finite acquisition is another task.

**The preserved question must include its continuation.** For a
later channel F and final observable O, inserting a preprocessing
T leaves that same execution's answer unchanged for every input iff

    T*F*(O)=F*(O).                              (43g)

For inputs restricted to a subspace K with projector Π_K, the
condition is equality of the compressions Π_K(·)Π_K instead.
This follows by the trace pairing and testing all pure states in
the declared domain. It permits a question-relative replacement;
it does not identify the two processes on every future use.

Here C*(O)=O₀₀⊗I_S, so Fix(C*)=B(L)⊗I_S. In contrast,
IiS42 gives Fix(T_Q*)=B(P)⊕C Q. Their intersection with
the lifted logical algebra consists only of scalar identities.
For example O=A⊗|0⟩⟨0| is itself fixed by T_Q*, but
the repair continuation pulls it back to C*(O)=A⊗I_S,
which is fixed only for scalar A. On N_η(ρ), the difference
in the same repaired reading is

    η[tr(Aρ)−tr(A)/d].

Thus preservation of the endpoint observable by itself is too weak.
This does not contradict (43f): that theorem permits constructing
a different measurement M for the individual question. The specific
old continuation, existence of another reading, and production of
an unknown quantum state are three distinct execution contracts.

**The missing phase relation has a finite admission construction.**
For d=2, take the actual composed device F=C E Enc, with target
Enc. If one common CPTP process satisfies

    F(|0⟩⟨0|)=Enc(|0⟩⟨0|),
    F(|+⟩⟨+|)=Enc(|+⟩⟨+|),                   (43h)

IiS11 forces F=Enc on the whole logical qubit, including entangled
references. The proof applies equally to this isometric target:
each pure output forces each Kraus image into its target ray;
the nonzero overlap makes the two environment coefficient vectors
equal, and the probes span the input. Two orthogonal basis probes
would still permit dephasing. A support check against the larger
P alone would permit the logical Z counterexample above.

This gives a sufficient acquired bridge for the composed action,
without reconstructing the entire E or V. At finite errors the
existing IiS13 constructor applies to these same probes: use their
overlap 1/√2 and input-column least singular value √(1−1/√2)
in its bound. If survival on each named pure output is at least
1−ε_i, put δ_i=√(2−2√(1−ε_i)),
w=min(2,√(2(δ₀+δ₊)/(1/√2))). A sufficient half diamond
error from Enc is

    min(1, √(δ₀²+(δ₊+w)²)/√(1−1/√2)).           (43i)

This is a conservative composition of an existing bound, not a
new optimal estimate. IiS42 can supply statistical upper bounds
on these two output leakages when each exact target ray, its
corresponding reference preparation and the local-replacement
contract are admitted. Apply that test on sacrificial calibration
outputs, not on the payload that must continue coherently. Combine
failure allowances for the two tests and other admitted errors.
The same-channel or justified drift relation across the two probe
families and later use remains required. Finite successful trials
do not supply the exact equalities (43h).

**Repeated restoration consumes or exports a record.** A unitary
implementation on H alone cannot realize C. For the same logical
ψ, the orthogonal states |ψ,0⟩ and |ψ,1⟩ would both have to
become |ψ,0⟩. A unitary preserves their inner product. In
particular, the four-mode lossless G interface alone does not
provide this reset from its P/Q splitter alone.

A unitary implementation with a supplied clean ancillary register
A is explicit: swap S with A initially in |0⟩ and leave L
untouched. The syndrome becomes zero and the logical state is
preserved; the old syndrome, with any correlations, moves to A.
The working module's logical and syndrome outputs are ready for
another cycle, but its clean ancillary resource has been spent.

More generally, suppose a reversible realization resets n freely
supplied binary syndrome registers to the same standard state,
returns all work registers to their fixed joint pure initial state,
starts with a fixed pure reserve, and leaves the
logical data unchanged. If a declared reserve B is the only output
allowed to distinguish the 2^n orthogonal syndrome histories, then

    dim B≥2^n.                                  (43j)

Fix a pure logical input and the standard initial work/reserve state. Unitarity
preserves orthogonality of the 2^n histories. All final factors
except B are the same, so B must contain that many orthogonal
states. Swapping each syndrome into a fresh binary reserve attains
the dimension count. The theorem presupposes those freely supplied
histories and no other record-bearing output; it is not a claim
that every physically possible noise history is independent.
If records go elsewhere, that place is part of the enlarged resource
interface. Restoring individual mixed marginals while allowing
correlations to retain the histories is a different contract.
No temperature, heat-per-bit law or absolute clock is
inferred from this dimensional argument.

This is why a repeatable logical channel is weaker than a fully
renewed physical implementation. A supplied reservoir, spare register,
or an established reversible uncomputation may close the next step.
The correctness of the present output does not produce those resources.
The same distinction underlies Matter's admitted renewal interfaces,
but its finite primary-record reserve is a different theorem.

The random seed has the complementary role. If the controller
retains the seed of T_Q and the randomized system is still
undisturbed, it can undo the selected unitary. Then the effective
input for the continuation includes that record and (43d–f) do
not apply. After an arbitrary unknown analyzer acts, seed disclosure
alone cannot invert its instrument. IiS42 fixes outcome statistics,
not that instrument. Neither local erasure nor the existence of
a global record establishes a presently available recovery.

**Support restoration is not contraction of every logical error.**
C has output leakage zero for every input, but acts identically
on all states in P. Two different states in P keep their trace
distance, so C cannot satisfy a uniform strict contraction toward
every unknown logical target. A repeated small logical rotation
diag(1,e^{iδ}) keeps leakage zero at every cycle; starting from
|+⟩ its X expectation after n cycles is cos(nδ). Neighboring
support certificates alone therefore allow accumulated logical drift.
A relation e_{k+1}≤κe_k+ξ must specify which error it contracts
and derive κ from the actual dynamics. It does not supply the
missing logical relation in (43b) or (43h).

**What can already be reused by a planner.** The formulas constitute
a finite constructive rule, rather than a nominal `CorrectBackend`:
given P,Q,V and an admitted error relation, (43a) builds the repair;
(43h–i) builds a sufficient admission task for its composite action;
(43g) checks a proposed preprocessing against the actual continuation;
(43d–f) select between approximate state output, exact heralded output
and a single-effect reading; (43j) states a resource obligation
for repetition. The same constructions transport through an admitted
change of frame and do not require a new proof for each basis.
This is one worked rule family for HORN's finite-generation idea,
not an implemented universal planner, quantum compiler or claim
of quantum acceleration.

The distinction between correcting a subsystem and correcting
observables is established in [operator quantum error correction](https://arxiv.org/abs/quant-ph/0412076)
and [Bény, Kempf and Kribs](https://arxiv.org/abs/0705.1574).
The present calculation connects those distinctions to IiS42's
particular useful but destructive preprocessing; priority is not
claimed. An experimental counterpart to the need for a logically
indistinguishable error record appears in
[Gertler et al., Fig. 1 and the recovery construction](https://arxiv.org/html/2004.09322):
their reservoir-driven correction requires matched transition paths
and reservoir emission that does not reveal the logical path.
That experiment uses engineered drives and a reservoir; it does
not demonstrate this four-mode construction or autonomous rebuilding
of its controller.

The result supplies a coherent repair cycle under declared error and
resource relations, a sharp obstruction when the wrong test operation
is reused, and an explicit acquisition task for the missing logical
bridge. It does not show that a module manufactures its own successor,
its own error model or an inexhaustible supply of clean resources.
No apparatus, numerical simulation, Swift compiler or judge was run
for this analytical continuation.

## §16s. Acquired uncertainty can select an optimal repair without identifying the fault

**IiS44 (A coherent probe chooses a minimax continuation).**
IiS43 requires an admitted correspondence between the P and Q banks.
The bank address alone does not establish its logical phase. Here a
partially acquired correspondence is sufficient to construct an optimal
repair. The objective is preservation of an unknown logical qubit,
including its entanglement with an untouched reference. The result is
not a claim that every unknown channel has this form.

Use IiS43's H=L⊗S with dim L=dim S=2 and its declared bank frame.
For a complex number |z|≤1 define the qubit channel

    D_z([[a,c],[c*,d]]) = [[a,z c],[z* c*,d]].       (44a)

The convention is that z multiplies the upper-right matrix entry.
These are exactly the CPTP qubit channels that fix both basis pure
states. Indeed, if E fixes |i⟩⟨i|, positivity and purity make every
Kraus operator send |i⟩ into its own ray. Both fixed rays make all
Kraus operators diagonal. Their normalized diagonal columns have
an inner product z with |z|≤1. Conversely (44a) is a phase rotation
composed with a mixture of I and Z. This reuses the fixed-ray argument
of IiS12; it does not infer a unitary fault from correct basis outputs.

The faulty contact in the present scope is

    N_{η,z}(ρ)=(1−η)ρ⊗|0⟩⟨0|
                    +η D_z(ρ)⊗|1⟩⟨1|,          (44b)

where 0≤η≤1 and z belongs to an acquired nonempty compact set K
in the closed unit disk. The branch is classical, the good branch is
identity, and its weight is independent of the logical input. An
arbitrary coherent coupling of logical data, syndrome and environment
is a different class. All controls below use the admitted logical
frame; a change of that frame requires the corresponding transport.

The whole form (44b) has a finite relational foundation, rather than
requiring a nominal promise about input-independent η. Let F_0,F_1
be the raw, subnormalized CP branch maps in the admitted bank frame,
with F_0+F_1 trace preserving. Suppose each branch sends each basis
input into its own ray, with arbitrary nonnegative weights, and

    F_0(|+⟩⟨+|)=q|+⟩⟨+|.

All branch Kraus operators are diagonal. Comparing the two diagonal
entries and the coherence of the last relation forces F_0=q id.
Trace preservation then fixes both F_1 basis weights to 1−q;
its remaining coefficient gives F_1=(1−q)D_z. Thus η=1−q and
(44b) follow, including zero-weight endpoints. Separate equality
assumptions for the two branch probabilities would be redundant here.
These are raw relations, including occurrence weights. Normalized
basis outputs alone do not suffice: F_0(ρ)=|0⟩⟨0|ρ|0⟩⟨0| and
F_1(ρ)=|1⟩⟨1|ρ|1⟩⟨1| preserve every surviving basis output,
but the branch probability depends on the input and the discarded
branch leaves complete dephasing. This example fails the additional
good-branch coherent relation. Exact relations and their finite-data
approximations must still be distinguished, as below.

That foundation also has a quantitative part. With exact basis-ray
preservation, write F_0's two basis weights as p_0,p_1 and its
coherence multiplier as c, so |c|²≤p_0p_1. A coherent input has
raw good-branch weight q=(p_0+p_1)/2 and wrong-ray mass
t=tr[|−⟩⟨−|F_0(|+⟩⟨+|)]=(q−Re c)/2. Positivity gives

    ((p_0−p_1)/2)²+(Im c)² ≤ 4t(q−t),
    |p_0−p_1| ≤ 4√(t(q−t)).                     (44b′)

Indeed p_0p_1=q²−((p_0−p_1)/2)² and Re c=q−2t.
At t=0 the exact input-independent branch follows. This bounds an
otherwise hidden dependence of the branch probability on the input;
it is not by itself the full channel bound (44g). For uncertain q,t,
maximize over their compatible region. Substituting only an upper
bound on t is not valid past the maximum at t=q/2.

Write d_⋄(A,B)=½||A−B||_⋄. A recovery R:H→L is one fixed CPTP
map, independent of the actual z. It may have fixed auxiliary resources,
but it receives neither the unknown phase nor an environment record
that supplies it. A re-encoding into P can be appended without changing
the distance. Reset and reserve costs remain those separated in IiS43.
Further queries to the unknown fault are new acquisition, not fixed
auxiliary inputs hidden in the optimization over R.

**All recovery maps reduce to one scalar optimization.** Put

    h(K)=min_{|b|≤1} max_{z∈K}|1−b z|.

Then the exact worst-case recovery error is

    inf_R sup_{z∈K} d_⋄(R N_{η,z},id)=η h(K)/2.   (44c)

An attaining R leaves the good logical branch alone and applies D_b
on the faulty branch, for a minimizing b. It then discards or resets
the syndrome as declared. Compactness gives a minimizer. If only
η≤η̄ is available, the same construction is optimal for the enlarged
family with value η̄ h(K)/2. The control b does not require η as input.
Refining the evidence cannot worsen this optimum: K'⊆K implies
h(K')≤h(K), since the old action remains available. A later example
of a worse composed action is about a changed continuation question,
not an advantage of possessing less information.

This is an explicit channel constructor. For b=t e^{iβ}, choose
U_β=diag(e^{iβ},1); at b=0 take β=0. Its Kraus operators H→L are

    A_0=I_L⊗⟨0|,
    A_1=√((1+t)/2) U_β⊗⟨1|,
    A_2=√((1−t)/2) Z U_β⊗⟨1|.

They satisfy Σ_j A_j†A_j=I_H directly. The coefficient b comes
from the acquired set, not from a hidden copy of z. Implementing
these Kraus operators still uses the admitted bank controls and a
record/discard resource; the constructor does not manufacture them.
If an implementation realizes b' with |b'|≤1 and |b'−b|≤δ,
its worst-case error is at most η[h(K)+δ]/2. This follows from
|z|≤1 and (44d); precise real-valued control is not free, and a
finite control tolerance has an explicit charge. More general
half-diamond implementation errors add by channel contraction.

Here is a lower bound against all CPTP recoveries, not just mixtures
of phase gates. Since (44b) is block diagonal, R induces two qubit
channels R_0,R_1. Average them under simultaneous conjugation by all
logical diagonal phase rotations. Every D_z commutes with these
rotations; convexity and unitary invariance of the diamond norm show
that this averaging cannot increase any worst-case error. The resulting
channels multiply the upper-right entry by some a,b with |a|,|b|≤1.
They can still move populations; on input |+⟩ that adds to, rather
than removes, the trace-distance lower bound

    ½|1−(1−η)a−η b z|.

For η>0 set c=1−(1−η)a and r=ηb. Then |c|≥η, |r/c|≤1,
and

    max_K |c−r z| = |c| max_K |1−(r/c)z| ≥ η h(K).

The case η=0 is immediate. For the upper bound use the displayed
recovery, which gives D_γ with γ=1−η+η b z. For every |γ|≤1,

    d_⋄(D_γ,id)=|1−γ|/2.                         (44d)

To verify reference-uniformity, the difference is |1−γ| times a
diagonal unitary conjugation of the off-diagonal projection
(id−Ad_Z)/2. That projection has diamond norm one: the triangle
inequality gives the upper bound, attained on |+⟩. This proves (44d)
and (44c). No absence of an entangled input was assumed.

**One coherent probe family suffices for a strict improvement.**
Once both basis-output relations are admitted, prepare |+⟩ through
the faulty branch and acquire a lower bound f≥f₀ on

    f=⟨+|D_z(|+⟩⟨+|)|+⟩=(1+Re z)/2.

For ½≤f₀≤1 put κ=2f₀−1. The exact compatible family is

    K_κ={z:|z|≤1, Re z≥κ}.

Its optimal recovery and its exact error are

    b=κ,
    h(K_κ)=√(1−κ²),
    error=η√(1−κ²)/2=η√(f₀(1−f₀)).              (44e)

The upper bound follows from
|1−κz|²=1−2κ Re z+κ²|z|²≤1−κ².
For a lower bound the two possible faults

    z_±=κ±i√(1−κ²)

give exactly the same coherent survival f₀ and the same two basis
outputs. For every complex b,

    (|1−b z_+|²+|1−b z_-|²)/2
        =|b−κ|²+1−κ².

Thus no fixed recovery can beat (44e) using only these relations.
The witness average is a mathematical certificate of a worst case;
it is not a prior probability assigned to the physical fault.

The action D_κ on Q is particularly explicit: choose logical I with
probability f₀ and logical Z with probability 1−f₀. This preserves
logical populations and attenuates only their coherence. It is not
IiS42's full depolarization within Q. The private random choice in
IiS42 served test soundness; this random choice serves a declared
recovery objective. Its physical preparation and control are resources.
For example, m≥1 admitted fair bits, independent of one another and
of the incoming data and fault, give a uniform integer
J∈{0,…,2^m−1}. Apply I when J<floor(2^m f₀), and Z otherwise.
The resulting probability differs from f₀ by less than 2^{-m};
the recovery error increases by at most η 2^{-m}. This is a
finite control construction relative to a declared random-bit source,
not a proof that an arbitrary physical generator supplies those bits.

For example f₀=4/5 gives κ=3/5, the two witnesses z_±=(3±4i)/5,
and the exact error 2η/5. On them the recovered faulty multiplier is
(9±12i)/25, at distance 4/5 from one. The control receives the
bound 4/5, not the unavailable choice between the two phases.

With basis probes alone, every z in the disk is compatible, including
z=0. The optimal error is η/2. Therefore a coherent lower bound
strictly above 1/2 buys a strict improvement without identifying z.
For f₀≤1/2, the family still contains zero, and complete dephasing
b=0 remains optimal with error η/2. This does not infer Re z≥0.
“One probe” means one additional preparation/reading family, usually
many actual trials. It is not one-shot identification of a probability
or a general lower bound on the number of all conceivable experiments.

Nor does minimax optimality mean improvement on every individual
device. If z is subsequently identified, its optimal error is
η(1−|z|)/2: choose b=e^{-i arg z} when z≠0. A known unit-modulus
fault is exactly correctable; a known z strictly inside the disk need
not be. Partial phase ignorance and loss of coherence in the channel
are different obstructions, although the acquired family can contain
both.

**For pure phase uncertainty, the nearest convex-hull point is enough.**
There is also a geometric form of (44c). If Z is compact in the unit
circle and w is the nearest point to zero in conv Z, then

    b=conj(w),       h(Z)=√(1−|w|²).              (44f)

The projection condition Re(conj(w)z)≥|w|² proves the upper bound.
For the lower bound choose a convex representation Σ_j λ_j z_j=w.
For any b,

    Σ_j λ_j|1−b z_j|²
      =|b−conj(w)|²+1−|w|² ≥ 1−|w|².

At most three phases suffice as witnesses by planar convexity.
When w≠0, every positive-weight witness lies on the supporting line
Re(conj(w)z)=|w|², which meets the circle in at most two points.
Thus a continuum of unknown phases can admit a recovery construction
and a finite lower-bound witness without selecting its actual phase.

For the arc z=e^{iθ}, |θ|≤Δ≤π, the answer is b=cos Δ and
error (η/2)sin Δ when Δ≤π/2; for Δ≥π/2 it is b=0 and error η/2.
A known central phase multiplies
b by its inverse. Correcting only to the central phase, with |b|=1,
would have error η sin(Δ/2) on the short arc and is strictly worse
for 0<Δ<π/2. The useful extra attenuation is not an estimate of
the unknown phase; it is the action selected by its remaining ambiguity.

**Finite data need not postulate exact fixed rays.** Suppose an
admitted common CPTP qubit channel E has basis survival at least
1−ε_i for i=0,1, with 0≤ε_i≤1. Let

    δ_i=√(2−2√(1−ε_i)),
    s=min(1,√(δ_0²+δ_1²)).

There exists D_z with d_⋄(E,D_z)≤s. To prove this, take a
Stinespring isometry V. Its component on the desired output |i⟩
defines a normalized environment vector e_i, chosen arbitrarily if
that component is zero. Then

    ||V|i⟩−|i⟩e_i||≤δ_i.

The map V₀|i⟩=|i⟩e_i is an isometry even when e_0,e_1 overlap.
The operator norm ||V−V₀|| is at most √(δ_0²+δ_1²). The
two-isometry estimate of IiS13, or its direct pure-input proof with
an arbitrary reference, gives the stated half-diamond bound. Tracing
the environment of V₀ produces a channel of form (44a).

If E's coherent survival is at least f_L, then the same D_z obeys
Re z≥ℓ=2f_L−1−2s. When ℓ≥0 choose κ=ℓ; when ℓ<0 choose
κ=0 and use complete dephasing without claiming a nonnegative real
part. The resulting fixed repair has the sufficient bound

    error ≤ η min{1, s+½√(1−κ²)}.                (44g)

This is a stability estimate, not a claimed sharp minimax theorem
for approximate basis data. It assumes a qubit-to-qubit faulty map
after the declared routing. Leakage outside that output bank and
errors in the good branch require additional channel bounds; discarding
such outputs and renormalizing silently would change the question.
Finite input-state bounds are also the subject of [Mayer and Knill](https://arxiv.org/abs/1805.04491);
the elementary two-ray estimate here is proved explicitly.

**Acquisition has a finite rule and an explicit applicability boundary.**
IiS42 can test the leakage u of each disposable calibration output
from its desired target ray. Under its actual local-replacement,
hidden-choice and conditional-trial relations, the ideal flag floor
is u/2. For a fixed common faulty channel and predeclared n≥1,
0<α<1,
an all-zero record gives the confidence upper bound

    u_U=min{1, 2[1−α^(1/n)]}.                    (44h)

Precisely, for every fixed u>u_U the probability of that accepted
record is at most α. This does not assign posterior probability
to u. The three target families |0⟩,|1⟩,|+⟩ provide ε_0,ε_1
and f_L=1−u_{+,U} for (44g); a union bound charges the sum of
their allocated failure allowances. If exact basis preservation is
already structurally admitted, only the coherent family is additional.

For that exact-basis case, a target error 0<e<η̄/2 can be certified
by establishing u≤u_req, where

    u_req=(1−√(1−(2e/η̄)²))/2,
    n≥ceil[log α/log(1−u_req/2)].                 (44i)

Accept after n zero flags and use b=1−2u_req. For any compatible
channel satisfying the bound, the error is ≤e. The finite test can
falsely accept an incompatible channel only within the allocated
allowance. This is the sharp worst-case count of this particular
all-zero support test in the ideal IiS42 class, not an optimum over
all possible acquisition policies. For small e/η̄ its leading count
is 2η̄² log(1/α)/e². Nonzero preparation/control errors reduce the
flag floor as in (42m); the ideal count cannot be reused without accounting for those errors.

These are trials on the faulty logical output. Access to them is not
automatic from the existence of N_{η,z}. One may have an admitted
prepared invocation of the faulty branch. Otherwise the syndrome must
be read on actual calibration launches and the Q outputs retained;
all discarded launches and all test branches still count as physical
work. Under independent stationary fault flags with η>0, obtaining
n such outputs costs n/η launches in expectation, before other test
resources. A finite launch deadline needs a separately admitted yield
bound or an explicit chance of failing to gather the batch. At η=0
there is no faulty output to calibrate and no error to correct.

The analyzer may retain the arbitrary correlated memory admitted by
IiS42. This does not certify a common logical source channel: a
channel changing between calibration families or between acquisition
and data can invalidate (44g–i). For the stated inference, the same
E must apply on the declared conditional trials, or an acquired
transport/error bound must replace that relation. Calibration tests
consume disposable outputs; their unknown instruments are not passed
the data whose continuation is being preserved. Repeated attempts or
adaptive stopping need a total false-acceptance budget.

**Renewal preserves a bound only through an admitted change law.**
For a pure phase, suppose an acquired arc has center θ₀ and half-width
Δ₀, and each counted contact changes phase by at most ν in circular
distance. After h contacts a sufficient arc has half-width
Δ_h=min(π,Δ₀+hν). Formula (44f) then constructs the new one-step
optimal action for that admitted arc. For a demanded one-step error
e<η̄/2, its permitted horizon satisfies

    Δ₀+hν ≤ arcsin(2e/η̄).                       (44j)

This uses a relation between contacts, not a claim about absolute
physical time. The drift bound ν is an additional acquired or
otherwise established relation; it is not proved by the previous
finite record. Without any such restriction the next fault can be
any phase, and the old calibration gives no smaller worst-case floor
than η/2. As a concrete failure, z=1 during every calibration and
z=−1 during use leaves every old record unchanged; the old b=1
then has error η.

Per-step guarantees also do not provide an indefinitely preserved
unknown qubit. When the reduced logical maps really compose without
retained side records or environment feedback, n repaired contacts
give D_{γ_n⋯γ_1}, with γ_k=1−η_k+η_k b_k z_k. Hence

    total error=½|1−∏_k γ_k|
               ≤½Σ_k η_k|1−b_k z_k|.            (44k)

Acquiring a better control for the next step does not invert earlier
discarded loss of coherence. If random choices or other side records
are retained and available for later action, that joint continuation
must be analyzed instead of composing its reduced channels. IiS43's
distinction between a restored marginal and a restored usable joint
state remains in force.

**An optimal intermediate repair can spoil an exact final answer.**
There is a sharp instance of this distinction within the same model.
Let η=1 and let two successive faults have the admitted relation
D_z followed by D_conj(z), for one fixed unknown z=e^{iθ},
|θ|≤Δ and 0<Δ<π/2. Return the syndrome bank after each contact,
but leave the logical phase alone. At the final boundary,

    D_conj(z) D_z = id   for every allowed z.     (44l)

No phase acquisition is needed for that final-only question. In
contrast, inserting the one-step minimax D_b, b=cos Δ, after
each contact gives

    D_b D_conj(z) D_b D_z=D_{cos² Δ},
    final error=sin²(Δ)/2 > 0.                    (44m)

These are compositions of reduced channels, with the randomization
records unavailable for the next action. If the records are retained,
their own phase gates can be undone and the comparison has a different
available interface. If an accurate intermediate output is itself
required, (44l) does not meet that earlier requirement automatically.
The failure is therefore precise: one-step minimax optimality is not
a certificate of optimality for a later-only question under an
established relation between successive faults. The inverse-pair
relation does the work that separate phase identification would have
done. [Danageozian's multi-cycle analysis](https://quantum-journal.org/papers/q-2023-12-04-1195/)
likewise motivates retaining relationships between recovery cycles;
(44l–m) are the direct elementary calculation for the present family.

The cancellation relation itself has a direct acquisition in this
family. Pass a coherent |+⟩ preparation through the actual two-contact
sequence D_{z_2}D_{z_1}, rather than combining separate average records.
Its survival is f_pair=(1+Re w)/2, where w=z_2z_1 and |w|≤1.
Exact f_pair=1 forces w=1 and hence |z_1|=|z_2|=1 and
z_2=conj(z_1). Neither individual phase has been identified. For an
acquired lower bound 0≤f_L≤1 the final-only answer instead has

    d_⋄(D_w,id)=|1−w|/2 ≤ √(1−f_L).             (44n)

This follows from |1−w|²≤2−2Re w and is tight on the unit circle.
Finite agreement does not imply exact unitary factors. It can still
admit the whole continuation at a demanded error without calibrating
either contact separately. When f_L≥1/2, formula (44e) can
alternatively choose a repair at that final boundary; below it, the
stated complete-dephasing case applies. The actual composition and its transfer
from calibration to use remain required; separate marginal readings
do not supply that relation.

**Status and contribution.** Robust recovery against an uncertain
channel is an established optimization problem; [Kosut, Shabani and Lidar](https://qserver.usc.edu/wp-content/uploads/2013/07/physrevlett_100_020502.pdf)
explicitly consider uncertain noise families and worst-case objectives.
Their framework is external context, not a proof of (44c) or of the
present acquisition contract. Here the analytical contribution to the
current chain is a closed-form recovery from one acquired coherent
bound, witnesses against every CPTP alternative, a finite acquisition
route, and an explicit limit on reuse. No priority claim, hardware
experiment, quantum speedup or new physical law is asserted. The
constructor uses established bank/ray relations and actual acquired
bounds; it does not receive a nominal assertion that the backend is
correct. Exact mathematics, statistical admission, physical access and
continued applicability remain distinguishable obligations.

## §16t. A retained control relation can carry and then release a continuation

**IiS45 (Orthogonal recorded actions turn recovery into discrimination).**
IiS44's loss from two independently randomized repairs does not apply
when one control record remains available. The supplied continuation
suggests reusing that record. The construction below proves its joint
return, characterizes exactly what a compressed record must retain,
and gives a sharp error for partially distinguishable memory. The
question is preservation of a full unknown logical qubit, including
its correlations with an untouched reference, not arbitrary history.

Write Ad_U(ρ)=UρU† and d_⋄(A,B)=½||A−B||_⋄. All registers
are finite dimensional. The logical bank returns and the actual
phase-pair correspondence are those admitted in IiS44. No record
or complementary environment beyond the stated input is available
to the recovering operation.

**A control bit can return jointly, not just in its marginal.**
Use the η=1 paired-phase case of (44l–m). Let U_φ be a diagonal
qubit unitary, with its actual inverse
U_φ† later in the sequence. Let p=(1+c)/2, 0≤c≤1, and
prepare a bit R in τ_p=p|0⟩⟨0|+(1−p)|1⟩⟨1| independently
of the incoming data. Apply Z^s after each of the two contacts,
using the same retained value s. For every s and φ,

    Z^s U_φ† Z^s U_φ=I.                         (45a)

This follows from Z²=I and [Z,U_φ]=0. Thus the full controlled
unitary is I_R⊗I_L. For every input ρ_LE, including entangled
data and reference, the final state is τ_p⊗ρ_LE. After the first
contact the reduced data channel is D_c Ad_{U_φ}, exactly the
local mixture used in IiS44. After the second it is identity.
The same controlled identity holds for a coherent initial control
state; τ_p specifies the desired reduced first-step mixture.

For c=cos Δ, 0<Δ<π/2, this attains IiS44's first-boundary
minimax error and exact return at the second boundary in the stated
closed sequence. Two independent bits instead give D_{c²} after
the phase pair and final error (1−c²)/2. The separately tested
control channels are identical in these two implementations; their
multi-contact processes differ. This is an instance of the distinction
between channels and networks with memory studied by [Chiribella,
D'Ariano and Perinotti](https://arxiv.org/abs/0904.4483).

One bit can serve any number of completed pairs, with different
unknown paired phases and with incoming data entangled across pairs.
Every completed pair restores the joint factor τ_p and acts as identity
on its data. This is not a new bit of uncontrolled error history
entering a reset reserve at each cycle. Gate control, reliable storage,
and the physical bank-return resources of IiS43 are still required.
Intermediate measurement, record leakage or an unadmitted interaction
changes the sequence; reduced first-step accuracy is not permission
for arbitrary interventions between its two boundaries. Reuse here
does not provide the fresh independent secret choices required in
IiS42's statistical tests.

**Same marginals can permit either exact recovery or a strict error.**
There is a direct obstruction to replacing this joint relation by
separate checks on data and memory. Compare the channels

    A(ρ)=pρ⊗|0⟩⟨0|+(1−p)ZρZ⊗|1⟩⟨1|,
    B(ρ)=[pρ+(1−p)ZρZ]⊗τ_p.                    (45b)

Their data marginals agree on every input, including entangled
inputs. Their memory marginals are both τ_p. A is exactly repaired
by controlled Z. For B, the best recovery error is min(p,1−p),
as follows from (45d) below. Thus complete separate knowledge of
the two reduced channels still does not establish the ability to
recover. The missing content is their actual association with the
same control occurrence.

**Exact price of a partially distinguishable quantum record.**
Suppose the available record for s=0 or s=1 is respectively a
density operator σ_0 or σ_1 on M. For a fixed input-independent
choice probability p, the actual available channel is

    N(ρ)=pρ⊗σ_0+(1−p)ZρZ⊗σ_1.                 (45c)

The record states are fixed in the declared use; they are not
additional functions of the unknown payload. For every deterministic
CPTP recovery R:L⊗M→L, the exact optimum is

    inf_R d_⋄(R N,id)
      = e_* = (1−||pσ_0−(1−p)σ_1||_1)/2.       (45d)

The right side is the binary Helstrom error of distinguishing the two
record states with their actual preparation probabilities, an established
state-discrimination formula (see [Qiu](https://arxiv.org/abs/0707.3970)).
The equality with the optimum recovery error is proved below. It is not a prior
over an unknown phase, as in the worst-case witnesses of IiS44.

An explicit attainer measures M with the binary minimum-error test,
guesses s, then applies Z^s to the data. If the guess is wrong,
one Z remains; if correct, identity remains. The corrected channel
is (1−e_*)id+e_* Ad_Z and has half-diamond error e_* by (44d).
The test itself follows from D=pσ_0−(1−p)σ_1: choose the positive
spectral subspace of D for outcome zero. Its success is
(1−p)+tr D_+=(1+||D||_1)/2. A tie subspace may be assigned either way.

For a lower bound against all CPTP recoveries, expand each Kraus
operator A_k:L⊗M→L in the Pauli basis:

    A_k=Σ_{μ∈{0,x,y,z}} σ_μ⊗⟨v_{kμ}|,
    Σ_{k,μ}|v_{kμ}⟩⟨v_{kμ}|=I_M.

The second equality follows by taking the partial trace over L in
Σ_k A_k†A_k=I_L⊗I_M. Set M_0=Σ_k|v_{k0}⟩⟨v_{k0}| and
M_1=Σ_k|v_{kz}⟩⟨v_{kz}|. They obey M_0+M_1≤I_M. The overlap
F_e of the recovered half of a maximally entangled input with its
ideal return is

    F_e=p tr(σ_0 M_0)+(1−p)tr(σ_1 M_1).

Completing these two operators to a binary test cannot decrease
this expression, so F_e≤1−e_*. The ideal entangled-state projector
then witnesses trace distance at least 1−F_e≥e_*. Together with
the attainer this proves (45d), including arbitrary fixed ancillary
systems and arbitrary untouched references.

The operative feature is orthogonality of the possible actions, not
their names I and Z. On a d-dimensional full input space let a finite
unitary family obey tr(U_j†U_k)=dδ_jk. For the actual mixed channel
N_U(ρ)=Σ_j p_j U_jρU_j†⊗σ_j, with fixed input-independent
probabilities and retained record states, the same argument gives

    inf_R d_⋄(R N_U,id)=1−P_guess({p_j,σ_j}).     (45d′)

Here P_guess=max_{M_j≥0, Σ_jM_j=I}Σ_j p_j tr(σ_j M_j).
To prove the lower bound, complete {U_j†} to an operator basis
{B_μ} with tr(B_μ†B_ν)=dδ_μν and expand each recovery Kraus
operator as A_k=Σ_μ B_μ⊗⟨v_{kμ}|. The basis completion need
not consist of unitaries. Taking the input partial trace of the
trace-preserving constraint gives Σ_{kμ}|v_{kμ}⟩⟨v_{kμ}|=I_M.
The coefficients on U_j† induce a sub-POVM M_j, and the ideal
entanglement overlap is Σ_j p_j tr(σ_jM_j)≤P_guess. For attainment,
use an optimal record measurement and invert the guessed U_j.
Every wrong residual U_ℓ†U_j has zero trace. Its Choi vector is
therefore orthogonal to the ideal maximally entangled vector. The
total wrong-guess mass gives trace distance exactly 1−P_guess on
that input, and convexity bounds the diamond distance by the same
value. This proves the claimed equality in both directions.

For a uniform complete family of d² orthogonal unitary actions and
identical retained records, P_guess=1/d². The resulting error
1−1/d² recovers IiS43's complete-mixing obstruction. If this loss
occurs in a separately flagged branch of probability η, while the
other branch is identity, its exact contribution is η(1−1/d²).
Retaining distinguishable records reduces that same obstruction;
the two results concern different available joint inputs.

Without action orthogonality, recovery need not require identifying
the action to this accuracy. Take equal probabilities, identical
records, U_0=I and U_1=exp(−iαZ), with 0<α<π/2. Record
discrimination error is 1/2. Yet the midpoint correction exp(iαZ/2)
leaves D_{cos α}, with error (1−cos α)/2<1/2. Thus (45d′)
is a theorem for a specified relation between actions, not an
identification postulate about arbitrary recovery.

Returning to the I/Z pair, for 0<p<1 exact recovery holds iff σ_0
and σ_1 have orthogonal supports. Identical states give error
min(p,1−p). For pure records
with overlap t=|⟨r_0|r_1⟩|, the two-dimensional spectral calculation
gives

    e_*=[1−√(1−4p(1−p)t²)]/2.                  (45e)

For example, p=4/5 and t=3/4 give e_*=1/10; an absent record
would give 1/5, and an orthogonal record gives zero. These values
follow from exact algebra, not a numerical optimization.

Formula (45c) is a mixture with specified retained memory states.
It does not include off-diagonal terms of a full coherent dilation.
Keeping the entire unitary interaction and its environment can allow
direct inversion; it is a different input from (45c). In particular,
reading a program state and coherently undoing a recorded unitary
must not be silently treated as the same physical operation.

**Classical corruption and a test that need not identify the memory.**
If M is a classical record r with probabilities P(r|s), put
a_r=pP(r|0), b_r=(1−p)P(r|1). Then (45d) becomes

    e_*=Σ_r min(a_r,b_r).                        (45f)

Choose the more likely s for each actual record r and invert it.
For p≥1/2 an independently flagged erasure with probability ε
gives e_*=ε(1−p). A binary symmetric corruption with 0≤ε≤1/2
gives e_*=min(ε,1−p). When ε>1−p, ignoring the received bit
is optimal. An unreliable reading is not necessarily useful
because it is present. Bit-dependent erasure probabilities ε_0,ε_1
give min(pε_0,(1−p)ε_1), not an unweighted mean erasure rate.

Knowing the full matrices σ_s is sufficient to construct the optimal
test but is unnecessary for a useful upper guarantee. Fix an actual
binary memory reading. If its acquired misclassification probabilities
are u_0 and u_1 on the two actually labelled preparations, then the
resulting recovery has exact error

    e_read=p u_0+(1−p)u_1.                      (45g)

Thus an acquired upper bound on that weighted disagreement already
certifies a recovery with the same error bound, even if optimality and
the full memory channel remain unknown. The label must be tied to
the control that was really applied, and the prepared memory must
traverse the same admitted storage/readout path. Separate unlabelled
memory marginals, or averages from a changed path, do not establish
(45g). Finite confidence, drift and control errors require their own
budgets. Data need not be measured to test this memory reading.
If the actual joint channel differs from (45c) by half-diamond error
δ, the Helstrom recovery has sufficient error e_*+δ, capped at one;
a fixed reading instead gives e_read+δ, also capped at one.
That bound is constructive, not a new sharp optimum for all perturbed
channels. A noisy readout generally need not restore the memory's
original state for the next cycle.

**How far may the control record be compressed?**
For a finite family of known unitary actions U_j on the full input
space, suppose a classical record r is retained through weights
w_{rj}=p_jP(r|j). Its channel is

    N_U(ρ)=Σ_{r,j}w_{rj} U_jρU_j†⊗|r⟩⟨r|.

Exact deterministic full-input recovery is possible iff

    w_{rj}w_{rk}>0  ⇒  U_j†U_k is scalar.        (45h)

For necessity, each composite Kraus operator of an exact identity
channel is a scalar identity. Within a nonempty record fiber, let
A be a nonzero Kraus operator of the conditional recovery. Then
A U_j is scalar identity for every active j. Since U_j is invertible,
the scalar is nonzero, A is proportional to U_j†, and every other
active U_k must be proportional to U_j. Conversely, select one
representative per fiber and apply its inverse; global phases vanish.
This is the full-input-space instance of the correction condition,
consistent with [Gregoratti and Werner, Proposition 2](https://arxiv.org/html/quant-ph/0209025).

The minimal exact classical alphabet therefore separates the distinct
unitary actions modulo scalar phase, not every different history that
implemented them. For I and Z with both probabilities positive it has
two symbols. This is a single-use alphabet claim, not an entropy or
thermodynamic lower bound. On a proper encoded subspace, or for a
smaller family of output questions, fewer distinctions may suffice.
For example a Z-basis answer needs no record of a Z phase flip.
The full-unknown-qubit criterion cannot be transferred to that question.

**The future computation determines the correcting action.**
Suppose a known unitary F occurs after the recorded U_j. A unitary
correction V_j at the output realizes F on every input iff

    V_j F U_j=e^{iθ_j}F.

One explicit choice is

    V_j=F U_j†F†.                               (45i)

With that exact representative the full controlled operation is
I_R⊗F: the record is returned even if it is coherent. Allowing
arbitrary scalar phases in the first equality preserves the data
channel, but can rotate relative phases of a coherent record; its
return is a stronger statement than classical label return.
It requires an admitted coherent controlled implementation. Access
only to the individual channels Ad_{U_j} does not establish the
relative phases of their controlled implementations.

For U_j=Z^s and F=H, the output correction is X^s, since HZH=X.
Repeating Z^s gives the wrong branch action ZHZ when s=1. More
generally, a Pauli-only output interface can do this exact unitary
correction for both bit values iff FZF† is a Pauli up to scalar
phase. The label can remain one bit while the executable action it
selects changes. This is the established mechanism of [Pauli frame
tracking](https://arxiv.org/abs/1401.5872); (45i) makes the required
continuation relation explicit, rather than claiming a new gate calculus.

The partial-record optimum (45d) survives this known computation
unchanged. Given a guessed value ŝ, apply FZ^ŝF†. The full branch
then acts as FZ^{s⊕ŝ}. Conjugating the output by F† reduces both
the attaining recovery and every competing recovery to (45d).
Thus transporting the action need not increase the information
required of its record, even when F and Z do not commute.

This construction does not by itself transport an unknown noise
law. If the actual surrounding faults remain U_φ and U_φ†, inserting
F between them gives U_φ† F U_φ even before our random controls.
It equals F only under the appropriate commutation relation up to
phase. An H generally fails this condition. A new intertwining law,
an acquired phase or a different admissible implementation is needed.
The old proof of an empty phase pair is not admission of every
computation inserted into it. Implementing (45i) also has an actual
control cost; it is not granted by writing down the conjugation.

**A sharp final question has its own record-release boundary.**
For 0<p<1, discard the record and consider only the output of
Ad_F [p id+(1−p)Ad_Z]. The requested final output is the binary
projective measurement {Π,I−Π} of the ideal FρF†, with no demand
to preserve a quantum output. Some physical binary measurement on
the available output gives the exact requested probabilities for
every input iff

    [Z,F†ΠF]=0.                                  (45i′)

Indeed, let M be its outcome effect and put M′=F†MF and A=F†ΠF.
Exactness for every state is equivalent to

    pM′+(1−p)ZM′Z=A,     0≤M′≤I.

A projector is an extreme point of the interval of effects [0,I].
For a vector in its range, both effects in any strict convex
decomposition must have expectation one; for a vector in its kernel,
both have expectation zero. Positivity of each effect and its
complement then removes cross terms and fixes both effects to A.
Consequently M′=ZM′Z=A, proving necessity. If (45i′) holds,
the original measurement M=Π attains the answer directly.

For F=H, the sharp output X-basis question survives without the
record because its transported question is Z-basis. The output
Z-basis question does not, because its transported question is
X-basis. Thus the same data and same computation permit release
for one requested answer and forbid it for another. This is exact
equality of outcome distributions, not prediction of each individual
random outcome. An unsharp effect is a different question: it need
not be extreme, and rescaled readings such as those in IiS43 can
exist without (45i′). Nor does this measurement criterion certify
return of the whole logical state or replenishment of the record.
For an explicit unsharp counterexample, take p=3/4, F=I and
A=(I+X/2)/2. The physical reading M=(I+X)/2 obeys
pM+(1−p)ZMZ=A although [Z,A]≠0. The loss of sharpness is
therefore a real change in the release question, not just a label.

**Universal data return forces decoupling, but not replenishment.**
Let Λ:L→L⊗R be any CPTP implementation with a fixed initial
controller and suppose tr_R Λ=id_L on the entire quantum input
space. Its normalized Choi state has the pure maximally entangled
marginal |Φ⟩⟨Φ|. A joint state with a pure marginal must factor.
Channel–Choi correspondence therefore gives

    Λ(ρ)=ρ⊗σ_R   for one fixed σ_R.              (45j)

The same conclusion preserves every reference. Thus absence of
payload information in the final record is a consequence of exact
universal return, not an extra postulate. Equality σ_R=τ_initial
does not follow: a device may transmit the data perfectly while
replacing its memory. In (45a) that equality is proved by the full
controlled identity, and the resource really is reusable.

Preserving only two orthogonal basis states does not imply (45j).
A CNOT from the data into an initially zero record preserves both
basis states and copies their label, but dephases superpositions on
discarding the record. Nor does an unchanged record marginal prove
decoupling: after a first controlled Z on |+⟩, the record remains
τ_p while it is correlated with |+⟩ or |−⟩. The correlation disappears
only after the matching controlled inverse. Approximate data return
does not establish exact record independence or exact resource reset.

**Scope.** The construction provides a finite repeated continuation,
a necessary retained distinction, its exact loss penalty, and a
rule for transporting the recorded action through admitted computation.
It does not construct a general autonomous flow, infer stable storage
from a label, or produce a controller from no physical resources.
Environment-assisted recovery, Pauli tracking and quantum processes
with memory are established subjects. The analytical results here
connect those mechanisms to the particular IiS43–44 continuation and
its actual available inputs; priority and hardware implementation are
not asserted.

## §16u. A history may be compressed only relative to its continuation

**IiS46 (The retained decision must compose with the actual joint law).**
IiS45 characterizes a retained record for one net action. The supplied
continuation observes that many histories may have that same action.
Here this gives an optimal sequential construction, a sharp obstruction
to composing local error figures, and a criterion for safe compression.
A small Pauli interface then selects different sufficient records for
different final questions by one set of derived rules.

All spaces and histories below are finite. A history h has actual
probability p_h and retained quantum record state σ_h, independent of
the unknown logical input. The available channel is a classical mixture
over histories with those records. Coherent interference between histories,
input-dependent branch probabilities and inaccessible additional records
are different contracts. The error d_⋄ is the half-diamond distance of
IiS45; guarantees for binary questions use a separately defined measure.

**The net action, not every event, determines the recovery question.**
For a sequence of recorded Z^{s_j} actions with no intervening
noncommuting gates, write b(h)=s_1⊕…⊕s_m. Put

    A_b=Σ_{h:b(h)=b}p_h σ_h,
    D=A_0−A_1,       tr(A_0+A_1)=1.

The actual available channel and its exact recovery error are

    N(ρ)=ρ⊗A_0+ZρZ⊗A_1,
    e_end=(1−||D||_1)/2.                         (46a)

This is (45d) with subnormalized record operators; it includes
zero-weight parity classes and arbitrary correlations among histories
and their final records. An optimal binary reading of D followed by
the guessed inverse attains the optimum. Different histories inside
one parity class do not require different corrections at this boundary.
Their other consequences have not thereby been equated.

**Independent record pairs admit an optimal sequential construction.**
Assume now independence of the complete pairs (S_j,M_j), with
P(S_j=0)=p_j and conditional record states σ_{j,0},σ_{j,1}.
The full record is their tensor product, with no later unaccounted
interaction. Let

    D_j=p_jσ_{j,0}−(1−p_j)σ_{j,1},
    e_j=(1−||D_j||_1)/2.

Expansion by parity gives D=⊗_jD_j. Singular values of a tensor
product are all products of the singular values of its factors, so

    e_end=[1−∏_j(1−2e_j)]/2.                    (46b)

More than a scalar composition law follows. Read each record with
its own Helstrom test and XOR the guesses into one working bit.
The sign of a nonzero eigenvalue of ⊗_jD_j is the parity of the
negative signs of its factors. Therefore this sequential reading is
an optimal reading of D; joint quantum measurement cannot improve
it in this independent model. Zero eigenspaces may be assigned
arbitrarily. A constant optimal decision may require no stored bit.

The construction uses at most one reliable accumulator in addition
to the incoming record and its admitted reading. It does not make
erasure of spent records or reset of the accumulator free. Nor does
it preserve every later question about the histories. For equal
0<e_j=e≤1/2, e_end tends to 1/2 as m grows. Compact working
memory is compatible with a deteriorating continuation guarantee.
When two controls share a nondegenerate random bit, their net parity
is zero; independence and (46b) do not apply to that pair. A shared
deterministic bit is independent and also gives zero in (46b).

**Complete local channels do not determine the error of their join.**
Let S_1,S_2 be independent uniform control bits. Retain
R_j=S_j⊕N_j, where the noise vector (N_1,N_2) is independent
of the controls, has Bernoulli marginals e_j≤1/2, and can have
arbitrary internal correlation. Each complete local record channel
is the same binary symmetric channel with error e_j. The entire
unconditioned record R_1R_2 is also uniform for every such coupling.

For a fixed joint noise law, let t=P(N_1=N_2=1) and
f=e_1+e_2−2t. Given the records, net control parity differs from
reported parity with probability f. IiS45 gives exact error
min(f,1−f). The feasible interval 0≤t≤min(e_1,e_2) implies

    e_end ranges over
    [|e_1−e_2|, min(e_1+e_2,1/2)].              (46c)

Every value is attained. Indeed f ranges over [a,b] with
a=|e_1−e_2|, b=e_1+e_2; a≤1/2 and 1−b≥a, so the continuous
map f↦min(f,1−f) has exactly the displayed image.

For e_1=e_2=1/4, the same local channels permit:

| Noise coupling | Joint probabilities | Exact final error |
|---|---|---|
| Same noise bit | P(00)=3/4, P(11)=1/4 | 0 |
| Independent noise bits | Product of Bernoulli(1/4) marginals | 3/8 |
| Mutually exclusive errors | P(00)=1/2, P(10)=P(01)=1/4 | 1/2 |

Choosing the optimal parity reversal in min(f,1−f) requires the
joint law. If only these local BSC laws are established, the exact
minimax guarantee over all their allowed couplings is instead

    inf_R sup_couplings d_⋄(R N,id)
       =min(e_1+e_2,1/2).                       (46d)

For e_1+e_2≤1/2, XOR the records: its error f never exceeds
their sum. For a larger sum, a fair random parity correction gives
complete dephasing and error 1/2. These upper bounds are tight:
choose f=e_1+e_2 in the first case and f=1/2 in the second.
Both couplings are feasible, and (46a) bounds every CPTP recovery
for that witness, not just the XOR rule.

For arbitrary joint records in distinct accessible registers,
simultaneous local optimal readings retain their marginal errors.
XOR and the union bound give the sufficient guarantee
min(1/2,Σ_j e_j), without independence. The lower endpoint in
(46c) is specific to its stated BSC/noise model, not universal.

**Even lossless local compression need not preserve a continuation.**
Take independent uniform S_1,S_2 and an independent noise bit
K with P(K=1)=e, 0<e≤1/2. Retain

    M_1=(S_1,K),       M_2=S_2⊕K.               (46e)

Local optimal errors for the two controls are 0 and e. Nevertheless,
S_1⊕K⊕M_2 recovers net parity exactly. If K in the second record
is replaced by an independent copy K′, both complete local record
channels are unchanged, and so is the unconditioned joint record
distribution. The optimal parity error becomes e.

Now consider compression M_1↦S_1 in the original coupled system.
Every local question about S_1 is preserved: from S_1, adjoining
a fresh independent Bernoulli(e) bit reproduces the full local
channel M_1|S_1. Yet this compression changes the joint parity
error from zero to e. Regenerating the same local distribution
does not regenerate its association with M_2. Thus equivalence
for every local source question is still insufficient for replacing
that record inside this joint continuation. This does not forbid
compression; it identifies which contextual relation must survive.

**Exactly which memory processing preserves the current optimum?**
Let Λ be one common CPTP channel acting on the available memory
in (46a), and write D=D_+−D_- for its positive and negative parts.
Then ||Λ(D)||_1≤||D||_1, so processing cannot improve the best
recovery error. It preserves that optimum iff

    supp Λ(D_+) ⟂ supp Λ(D_-).                  (46f)

Equivalently, there is an output effect 0≤Q≤I whose pullback
X=Λ*(Q) acts as identity on supp D_+ and zero on supp D_-.
To prove it, observe

    tr D_+−tr(DX)
      =tr[D_+(I−X)]+tr(D_-X)≥0.

Equality holds exactly under those support conditions. An optimal
output effect attains equality iff output discrimination retains
the input optimum. Existence of such an output effect is equivalent
to orthogonality of the two positive output operators in (46f).
The action on ker D is irrelevant to this decision; positivity
of X and I−X removes cross terms with the fixed eigenspaces.

In particular, the binary Helstrom reading with P_+ the projector
onto supp D_+
maps a record operator T to

    H(T)=tr(P_+T)|0⟩⟨0|+tr[(I−P_+)T]|1⟩⟨1|.

It sends D to tr D_+|0⟩⟨0|−tr D_-|1⟩⟨1|, preserving its
trace norm. At most one classical bit therefore retains the full
current binary recovery optimum, even if the original memory is
quantum and high dimensional. This is an acquired decision, not
necessarily the true control bit. Its construction requires access
to the appropriate reading; existence is not free calibration.
It does not reconstruct the original record states. Any added
signal dependent on the actual history changes the available input
and is not common postprocessing of the old record.

The preparation weights matter. For a purely classical example,
take conditional record distributions

    P(r|0)=(1/2, 2/5, 1/10),
    P(r|1)=(1/10,1/5, 7/10).

At p=1/2 the optimal binary reading groups the first two symbols;
its error, before and after compression, is 1/5. If the actual
preparation probability changes to p′=1/4, the uncompressed
record still permits error 1/5, but the compressed record permits
only 1/4. The optimal sums of minima are respectively
3/40+1/10+1/40=1/5 and 9/40+1/40=1/4. Thus even a newly
chosen decoder cannot reuse the old compression with the old
strength. This is a changed ensemble, not a changed opinion about
unchanged physical probabilities.

**A finite set of continuation rules can select the needed record.**
Allow known single-qubit gates H and S=diag(1,i), and recorded
phase flips Z^s. Write the current actual unitary as P_ab F
up to scalar phase, where F is the ideal computation and
P_ab=X^aZ^b. Starting at (a,b)=(0,0), the output frame updates as

    H:       (a,b)↦(b,a),
    S:       (a,b)↦(a,a⊕b),
    Z^s:     (a,b)↦(a,b⊕s).                     (46g)

HZH=X, HXH=Z, SZS†=Z and SXS†=Y prove these updates;
induction on the admitted sequence proves the final action P_ab F.
Thus two accumulated parity expressions suffice for every history
in this interface, irrespective of its length. Two working bits suffice to update
their values when actual control values are available. Symbolically
naming two parities of unread controls does not acquire those values
or compress their physical records; their expressions may still grow.
Scalar phases are
ignored for this incoherent history mixture; coherent control of
histories can require their phases as additional content. These
are standard Pauli-frame mechanisms, consistent with [Chamberland,
Iyer and Poulin](https://arxiv.org/abs/1704.06662), not a new gate set.

Group the actual records by final frame:
A_ab=Σ_{h:frame(h)=(a,b)}p_hσ_h. Full quantum return relative
to F requires a four-way decision, with exact optimum
1−P_guess({A_ab}) by (45d′). No recovery of every history is
required. A given family may occupy fewer than four frames.

For just the binary Pauli-projective question Q, define its sign
bit χ_Q(a,b): it is b for Q=X, a for Q=Z, and a⊕b for Q=Y.
Set A_c^Q=Σ_{χ_Q(a,b)=c}A_ab. The exact best worst-case error
in the requested outcome probability is

    inf_{binary POVM M on data+memory} sup_ρ
      |P_M(+|actual ρ)−tr[Π_Q FρF†]|
      =[1−||A_0^Q−A_1^Q||_1]/2=:e_Q,
    Π_Q=(I+Q)/2.                                (46h)

For necessity, choose logical inputs whose ideal outputs are the
two Q eigenstates ρ_+,ρ_-. Their actual outputs are
ρ_+⊗A_0^Q+ρ_-⊗A_1^Q and the swapped expression. Their trace
distance is ||A_0^Q−A_1^Q||_1. Their equal-prior discrimination
error therefore lower-bounds the worst probability error by e_Q.
For attainment, read the sign bit with its optimal memory test,
measure Q on the data and relabel the result by that guess. For
ideal outcome probability q the actual probability is
e_Q+(1−2e_Q)q, whose worst discrepancy is exactly e_Q.

Exactness with memory holds iff A_0^Q and A_1^Q have orthogonal
supports. If memory is unavailable before reading or correcting,
exactness holds iff one sign class has zero total weight. All active
frames may commute or all may anticommute; the latter uses a fixed
outcome relabeling. Reading the relevant memory first and then
releasing it is a different valid route. This one-copy physical-POVM
criterion does not rule out statistical estimation with many copies
and estimators that are not themselves outcome probabilities.

The same rules distinguish multiple exits of one example. Let
Z^{s_1} occur, then H, then Z^{s_2}, with independent uniform
controls. The final frame is (a,b)=(s_1,s_2). If only their parity
k=s_1⊕s_2 is retained, the resulting guarantees are

| Required final output | Record needed by the rule | Optimum with only k |
|---|---|---|
| Full unknown logical state after H | Frame (a,b) | Half-diamond error 1/2 |
| X-projective answer after H | b | Probability error 1/2 |
| Z-projective answer after H | a | Probability error 1/2 |
| Y-projective answer after H | a⊕b=k | Exact probabilities |

For full return, each known k leaves two equally likely orthogonal
Pauli actions, giving error 1/2. Each of a,b is individually
independent of k, whereas the Y sign is k itself. A one-bit parity
that sufficed for an uninterrupted Z chain therefore does not
automatically suffice after an inserted H, yet remains exact for
one declared final question. Keeping the two frame bits permits
exact full return in this example.

**Scope and constructive content.** Equations (46g–h) are a bounded
procedure: transport the two parity expressions through admitted
contacts, select the frame or the sign demanded by the final output,
group the actual available record by that decision, and retain a
reading achieving its claimed bound. This is a mathematical
constructor and worked execution of its rules, not an implemented
hardware scheduler or proof that the joint record law is available
from local calibrations. In particular (46c–e) prohibit that shortcut.
The history quotient, acquired reading, execution cost and later
applicability must be related to the same continuation. No priority
claim or new physical dynamics follows from these finite models.

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

## Topics

### Encoding status

The unbound `InterferenceIsSubstitution`/`Contribution` and
`DarknessIsNormalForm`/`Observed` interfaces are retired. The actual finite
amplitude and quantum constructors remain in Examples. Their supplied
models do not encode every physical intensity or phase sum.
