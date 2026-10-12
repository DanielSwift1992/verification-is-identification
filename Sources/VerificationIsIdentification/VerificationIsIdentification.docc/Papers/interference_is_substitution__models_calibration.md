# Interference Is Substitution (Wave) — Models calibration

This part contains the original derivations for models calibration.

Family and original section headings: <doc:interference_is_substitution>.

Section setting: <doc:interference_is_substitution#5-What-the-optical-and-quantum-models-share>.

Required setting: IiS7 uses the preceding optical counterexample in §4. <doc:interference_is_substitution#4-Polarization-is-a-pair-of-slots>.

## Detail: §5. What the optical and quantum models share

The same two-dimensional projector describes the transmitted classical Jones amplitude and the transmitted branch of an ideal single-photon polarization measurement. A classical normalized intensity fraction and a single-photon transmission probability agree in this model. A classical beam intensity is not a certain one-photon outcome. Matter §5 distinguishes the response law, individual record and conditional state.

This provides a concrete VI test: an encoding that suffices for axis intensity questions need not suffice for a later diagonal question. A retained optical state can carry the missing relation within the same whole. If only its coarse intensity record is available, the added analyzer cannot be simulated as a decoder of that record. The current static examples check special supplied pairs and slots. They do not implement general Jones operators or derive the correspondence to an actual device.

### IiS7

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

### IiS8

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

### IiS9

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

### IiS10

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

## Detail: §6. What a calibration must establish

### IiS11

**IiS11 (Exact probes can force the channel family).** Fix a finite-dimensional complex space H, a target unitary U and a nonempty finite list of normalized pure probes ψᵢ. Join two probes when their inner product is nonzero. If their span is H and this graph is connected, every completely positive trace-preserving channel E satisfying E(ψᵢψᵢ†)=Uψᵢψᵢ†U† for all probes is the target channel on all states. These two conditions are also necessary for this universal certification property when dim H≥2. The unknown channel need not be assumed unitary. This is the exact-identification criterion in [Mayer and Knill, Theorem 1](https://arxiv.org/pdf/1805.04491), related to the probe constructions in [Baldwin, Kalev and Deutsch](https://arxiv.org/abs/1404.2877).

Here is a finite Kraus-operator derivation. Compose the output with U† so that the target is the identity, and write E(ρ)=ΣₐKₐρKₐ† with ΣₐKₐ†Kₐ=I. A pure output equal to ψᵢψᵢ† forces Kₐψᵢ=cₐᵢψᵢ for every a: the expectation on any vector orthogonal to ψᵢ is a sum of nonnegative squared terms, all of which must vanish. The coefficient vector eᵢ=(cₐᵢ)ₐ has norm one. Trace preservation gives

```
⟨ψᵢ,ψⱼ⟩ = ⟨ψᵢ,ψⱼ⟩ ⟨eᵢ,eⱼ⟩.
```

On every graph edge, the nonzero factor cancels and ⟨eᵢ,eⱼ⟩=1. Since both vectors have norm one, ||eᵢ−eⱼ||²=0. Connectivity makes all eᵢ equal. Spanning then implies Kₐ=cₐI for every a, so E(ρ)=ρ. This uses linearity, complete positivity, trace preservation and exact probe-output equations. Those conditions carry the conclusion, rather than the name of the calibration.

For necessity, different graph components span orthogonal subspaces. If there is more than one component, or if the probe span has a nonzero orthogonal complement, dephase between those subspaces: D(ρ)=ΣⱼPⱼρPⱼ, with projectors summing to I. This is a CPTP channel that preserves every probe but removes cross terms of a superposition between two blocks. It is different from identity, and U∘D gives an alternative to the target U. Thus the omitted relation is exhibited by an admitted process, not inferred from a failed search.

For a qubit, two distinct nonorthogonal pure probes span H and form a connected graph. Two orthogonal basis probes permit dephasing. A probe such as (A+B)/√2 connects their phases, and the pair consisting of A and that probe already suffices. Nonorthogonality obstructs certain discrimination of an unknown specimen, yet helps certify preservation by an unknown channel. These are different questions. Exact output states or exact survival probabilities are premises here, not conclusions from observing finitely many successful trials.

### IiS12

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

### IiS13

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

## Cross-page mentions

Labels mentioned here: <doc:interference_is_substitution__positive_channels#IiS16>, <doc:interference_is_substitution__positive_channels#IiS17>, <doc:interference_is_substitution__positive_channels#IiS18>, <doc:interference_is_substitution__global_obstructions#IiS21>, <doc:interference_is_substitution#IiS6>, <doc:learning_is_liquid__medium_contacts#LQ13>, <doc:learning_is_liquid__coordination_blocks#LQ15>, <doc:learning_is_liquid__reconstructed_sides#LQ18>, <doc:permanence_is_resistance__records_entropy#M31>, <doc:permanence_is_resistance__records_entropy#M32>, <doc:permanence_is_resistance__records_entropy#M39>, <doc:permanence_is_resistance__retention#M59>, <doc:permanence_is_resistance__retention#M64>, <doc:permanence_is_resistance__contact_rigidity#M64n>, <doc:permanence_is_resistance__forced_answers#M71>, <doc:permanence_is_resistance__retention#M72>, <doc:verdict_is_invariant__finite_records#VC15>, <doc:verdict_is_invariant__reusable_images#VC45>, <doc:verdict_is_invariant__routing_laws#VC74>, <doc:verdict_is_invariant#VI1>.

Mentions of this page’s labels: <doc:interference_is_substitution__global_obstructions> (IiS10), <doc:interference_is_substitution__global_obstructions> (IiS11), <doc:interference_is_substitution__global_obstructions> (IiS12), <doc:interference_is_substitution__global_obstructions> (IiS13), <doc:interference_is_substitution__global_obstructions> (IiS9), <doc:interference_is_substitution__positive_channels> (IiS10), <doc:interference_is_substitution__positive_channels> (IiS11), <doc:interference_is_substitution__positive_channels> (IiS12), <doc:interference_is_substitution__program_mediator> (IiS10), <doc:interference_is_substitution__program_mediator> (IiS9), <doc:interference_is_substitution__repair_continuation> (IiS12), <doc:interference_is_substitution__repair_continuation> (IiS13), <doc:interference_is_substitution__support_calibration> (IiS10), <doc:interference_is_substitution__support_calibration> (IiS7), <doc:interference_is_substitution__support_memory> (IiS11), <doc:interference_is_substitution__support_memory> (IiS13), <doc:learning_is_liquid__medium_contacts> (IiS10), <doc:permanence_is_resistance__physical_models> (IiS10), <doc:permanence_is_resistance__physical_models> (IiS12), <doc:permanence_is_resistance__records_entropy> (IiS11), <doc:permanence_is_resistance__records_entropy> (IiS12), <doc:permanence_is_resistance__records_entropy> (IiS13).
