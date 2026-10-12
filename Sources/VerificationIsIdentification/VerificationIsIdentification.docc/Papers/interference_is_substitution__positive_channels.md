# Interference Is Substitution (Wave) — Positive channels

This part contains the original derivations for positive channels.

Family and original section headings: <doc:interference_is_substitution>.

Section setting: <doc:interference_is_substitution#7-Why-the-joint-context-constrains-a-local-rule>.

## Detail: §7. Why the joint context constrains a local rule

### IiS14

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

## Detail: §8. Positivity by a retained factorization

### IiS15

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

### IiS16

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

## Detail: §9. A matrix certificate for all untouched-reference contexts

### IiS17

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

## Detail: §10. Which questions survive a channel?

### IiS18

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

## Detail: §11. A stopping certificate for future questions

### IiS19

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

## Cross-page mentions

Labels mentioned here: <doc:interference_is_substitution__models_calibration#IiS10>, <doc:interference_is_substitution__models_calibration#IiS11>, <doc:interference_is_substitution__models_calibration#IiS12>, <doc:permanence_is_resistance__records_entropy#M32>, <doc:permanence_is_resistance__retention#M64>, <doc:verdict_is_invariant__finite_records#VC15>, <doc:verdict_is_invariant__discovery_acquisition#VC38>.

Mentions of this page’s labels: <doc:interference_is_substitution__comparison_fluctuations> (IiS15), <doc:interference_is_substitution__global_obstructions> (IiS14), <doc:interference_is_substitution__global_obstructions> (IiS17), <doc:interference_is_substitution__models_calibration> (IiS16), <doc:interference_is_substitution__models_calibration> (IiS17), <doc:interference_is_substitution__models_calibration> (IiS18), <doc:interference_is_substitution__program_mediator> (IiS17), <doc:learning_is_liquid__atoms_continuations> (IiS19), <doc:learning_is_liquid__medium_contacts> (IiS15), <doc:permanence_is_resistance__forced_answers> (IiS18), <doc:permanence_is_resistance__forced_answers> (IiS19), <doc:permanence_is_resistance__records_entropy> (IiS14), <doc:permanence_is_resistance__records_entropy> (IiS15), <doc:permanence_is_resistance__records_entropy> (IiS16), <doc:permanence_is_resistance__records_entropy> (IiS19), <doc:permanence_is_resistance__recovery_remainder> (IiS14), <doc:permanence_is_resistance__uniform_routing> (IiS18), <doc:permanence_is_resistance__uniform_routing> (IiS19), <doc:verdict_is_invariant__discovery_acquisition> (IiS19).
