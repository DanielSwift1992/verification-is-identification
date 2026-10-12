# Interference Is Substitution (Wave) — Global obstructions

This part contains the original derivations for global obstructions.

Family and original section headings: <doc:interference_is_substitution>.

Section setting: <doc:interference_is_substitution#12-When-no-internal-remainder-can-complete-the-proposed-change>.

## Detail: §12. When no internal remainder can complete the proposed change

M70 completes every finite local deterministic table when the source's label identity is what must be recovered and the internal remainder can be supplied freely. A specified medium can constrain more than those identities. Here the already declared complex inner-product and tensor model supplies that constraint. No probability distribution over preparations, external reader or finite bound on the remainder enters the following question.

Let ψ₁,…,ψₙ be normalized vectors describing a fixed family of complete prepared inputs to an isometry. They may already include the preparer and its resident record. Let φ₁,…,φₙ be the proposed normalized pure local outputs. Write Aᵢⱼ=⟨ψᵢ,ψⱼ⟩ and Bᵢⱼ=⟨φᵢ,φⱼ⟩. The indices connect each specified preparation to its requested output. They are not an extra readable label supplied to the transformation.

### IiS20

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

## Detail: §13. A whole obstruction invisible in every proper preparation family

### IiS21

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

**Eliminating a station phase need not survive averaging.** This is a measurement-level application of the cycle relation, with a different question from the Gram completion above. At a resolved observation index k let the three oriented correlations have the specified scalar form

    Yᵢⱼ(k)=gᵢ(k) conjugate(gⱼ(k)) Vᵢⱼ.

The three nonzero source correlations V are fixed over the chosen block; the station gains are nonzero and may change arbitrarily. There is no additive noise in this exact statement. Multiplying the three readings from the same index gives

    B(k)=Y₁₂(k)Y₂₃(k)Y₃₁(k)=|g₁(k)g₂(k)g₃(k)|² B_source.

Consequently any nonnegative weighted average of these products with nonzero total weight has the phase of B_source. No station phase or absolute temporal origin has to be determined. Shared endpoint gains do have to refer to the same values in the three occurrences. Literal simultaneity is one sufficient implementation of that relation; known stability or transported endpoint readings can also establish it.

Forming a product after averaging the three baselines is a different operation. For a fixed unit point-source correlation and three equal observation weights, take the station-gain rows

    (1,1,1),  (1,i,1),  (1,i,i).

The corresponding baseline rows (12,23,31) are

    (1,1,1),  (−i,i,1),  (−i,1,i).

Every row product is 1. Their column means are (1−2i)/3, (2+i)/3, (2+i)/3. The product of these means is (11−2i)/27, with a nonzero phase. In particular, (2+i)²=3+4i and (1−2i)(3+4i)=11−2i verify the discrepancy directly. All gains have unit modulus, every row obeys the common-station law, and the averaging weights and times are shared. No thermal fluctuation, changing source, or independent baseline defect is needed.

**Exact normalized cycle preservation restricts the joining kernel.** For N resolved readings, fix weights λ_rst≥0, Σ_rst λ_rst=1 independently of the unknown phases, and consider a weighted join of normalized baseline phases at indices r,s,t. Assume each station phase at each index can vary independently, while the source phases remain fixed. Its output equals the unit source cycle for every such variation if and only if λ is supported on r=s=t.

To prove this, divide by the unit source cycle. A summand becomes

    χ_rst=g₁(r) conjugate(g₁(t))
          g₂(s) conjugate(g₂(r)) g₃(t) conjugate(g₃(s)),

with unit gains. It is identically 1 precisely when all three indices agree. If a positive-weight term is not of this form, choose a phase appearing with a nonzero exponent so that this χ differs from 1. Every term has real part at most 1, so the weighted real part is strictly less than 1. Thus the claimed exact unit reply fails. The diagonal kernel attains it by cancellation. This establishes necessity for the exact complex unit answer, not a classification of kernels preserving only its argument. If some gain occurrences are already constrained equal, the allowed support broadens to the triples whose endpoint occurrences balance within those established classes. Requiring a shared external clock would be stronger than that relation.

Separate baseline averages use λ_rst=a_r b_s c_t. If each factor is a nonnegative distribution, exact preservation throughout the free-phase family therefore requires all three supports to be the same singleton. The diagonal average instead admits any number of joined observations. The difference is which acquisitions are joined, not how many samples are taken.

**A valid averaged correlation matrix does not recover this provenance.** Let v₁=(1,1,1), v₂=(1,i,1), v₃=(1,i,i), and form K=(v₁v₁†+v₂v₂†+v₃v₃†)/3. The variable-gain point source above has exactly this averaged matrix, including its unit diagonal and all reverse baselines. A second realization has ideal fixed instruments and three mutually incoherent source modes with these station responses and equal intensities. Its source correlation is K itself. Positivity follows directly from the displayed factors, so a covariance-consistency check does not distinguish the realizations. Their source closure phases differ, although their entire averaged correlation record agrees.

The second realization need not be an arbitrary matrix called a sky. Within the monochromatic scalar plane-wave model, take three stations at (0,0,0), (L,0,0), (0,L,0). The wavevectors with transverse components (0,0), (π/(2L),0), (π/(2L),π/(2L)) give precisely the three displayed response vectors. Choose their common magnitude κ>π/(√2 L), and use the positive longitudinal component completing that magnitude. Three mutually incoherent equal-intensity waves then give K. This is an ideal model construction, not a claim about M87's sky or its calibrated data.

Thus the source-phase question does not factor through the averaged matrix on this combined source-and-instrument family. Keeping the resolved joint products separates the two realizations. Recovering all individual gains remains unnecessary. The phase lost here is an acquisition relation; no inconsistency of the containing whole is needed.

This is a known practical boundary, not a discovered failure of EHT. [EHT Paper III](https://arxiv.org/pdf/1906.11240), §7.2 and §8.3–8.5, defines closure phase, tests coherence after calibration, and explicitly discusses bias after averaging station-corrected segments. Its Fig. 23 compares measured closure phases across processing pipelines. The counterexample and joining-kernel proof here are exact ideal examples, not a reanalysis of those observations. Additive noise, source variation, and the finite integration used to obtain each Y require their own measurement model; the identity does not provide exact raw-data immunity.

**The phase question admits more than exact complex preservation.** Normalize each nonzero baseline reading to unit modulus and retain the same fixed source phases as above. Choose two resolved acquisitions r,t. The joined triple at r equals the unit source cycle q. The mixed triples with indices (r,r,t) and (t,t,r) equal qχ and qχ⁻¹ respectively, where

    χ=g₁(r) conjugate(g₁(t)) g₃(t) conjugate(g₃(r)).

Here gains also denote their unit normalizations. The station-2 phases cancel within each mixed triple, and the other factors reverse in the second. The inverse relation is derived from the acquired endpoint factors, not inferred from similar final answers. With fixed 0≤d≤1, form

    Z=d q+(1−d)(qχ+qχ⁻¹)/2=q[d+(1−d)Re χ].

This construction preserves the phase of q with a nonzero output for every free unit χ **if and only if d>1/2**. Indeed the real bracket lies between 2d−1 and 1, and χ=−1 attains the lower endpoint. At d=1/2 the output can vanish; below it can have the opposite phase. Thus the diagonal-kernel condition for the full complex unit reply was too strong for this narrower question. This is an exact result within the specified mixed-pair family, not a classification of all phase-preserving kernels. The coefficients express relative weights in this construction, not a new physical constant.

**Two acquisitions admit a better sharp threshold.** Consider all eight triples of indices from {r,t}, with fixed nonnegative weights summing to one. Let d be the total weight on (r,r,r) and (t,t,t). There exists a choice of the other weights giving a nonzero answer with the source phase for every independently free station phase **if and only if d>1/3**. This concerns normalized readings and a phase-only output; the earlier d>1/2 threshold was for just one inverse mixed pair.

For attainment give each of the six mixed triples weight (1−d)/6. Set ηᵢ=gᵢ(r)conjugate(gᵢ(t)). Their six nuisance factors are precisely ηᵢ conjugate(ηⱼ), i≠j. Thus the output is

    q[(3d−1)/2+(1−d)|η₁+η₂+η₃|²/6].

Its real scale is at least (3d−1)/2, which is positive in the stated range. For necessity set (η₁,η₂,η₃)=(1,ω,ω²), where |ω|=1, ω≠1 and 1+ω+ω²=0. Every mixed factor then has real part −1/2. For any distribution of the six weights, the real part after division by q is (3d−1)/2. At or below zero it cannot be a positive real number. No prior symmetry of the proposed weights is required for this refusal.

In particular, a product of two-epoch equal-weight baseline means has d=1/4 and can reverse the phase. Mixing that product with a genuinely joined normalized triple, with weight a on the latter, changes d to (1+3a)/4. The six mixed weights are already equal. The resulting phase is universally preserved, with a nonzero output, exactly when a>1/9; its minimum scale is (9a−1)/8. This repairs the specified output map. It is not an acquisition-cost advantage over using the joined triple directly, nor a noise-optimal estimator or an assertion that one ninth of the information suffices.

For the specified product-of-means pipeline this repair has a general cycle formula. On n≥3 stations, keep two normalized acquisitions and one fixed unit source cycle q. Put ηᵢ=gᵢ(r)conjugate(gᵢ(t)), with cyclic indices. After factoring the joined cycle at t, the product of the baseline means divided by q is

    Pₙ=2⁻ⁿ ∏ᵢ(1+ηᵢ conjugate(ηᵢ₊₁)).

It is real: conjugating every factor divides their product by ∏ᵢηᵢ conjugate(ηᵢ₊₁)=1. Its exact minimum is −cosⁿ(π/n). If a factor vanishes this bound is immediate. Otherwise write each ηᵢ conjugate(ηᵢ₊₁)=e^{iδᵢ} with −π<δᵢ<π. Their sum is 2πm and Pₙ=(−1)ᵐ∏ᵢcos(δᵢ/2). A negative value requires odd m, so |m|≥1. Concavity of log cos on (−π/2,π/2) bounds the positive product by cosⁿ(mπ/n)≤cosⁿ(π/n). Equality is attained by making all phase ratios equal to e^{2πi/n}, which is compatible with their cyclic product being 1. Thus mixing this output with a joined normalized cycle, with weight a, preserves its phase and a nonzero answer uniformly exactly when

    a > cosⁿ(π/n)/(1+cosⁿ(π/n)).

At equality the attaining gains cancel the output; below it they reverse it. For n=3 this is a>1/9. This is a sharp bound for this particular pipeline and one added joined term. It does not optimize all kernels on larger cycles or introduce a geometry-independent physical threshold. The phase-circle model and its composition are the stipulated contact relations, as in the preceding cycle proofs.

The earlier one-inverse-pair construction has the positivity identity:

    d+(1−d)Re χ=(2d−1)+(1−d)|1+χ|²/2.

It follows by expanding the square and using |χ|=1. At d=3/4 the scale is 1/2+|1+χ|²/8, strictly positive without determining χ. Merely pairing two arbitrary unit numbers instead would not supply this real scale; their inverse relation carries the result. Normalizing a zero or noisy baseline requires a separate admission and error analysis.

**A positive margin supports a bounded-error answer.** Let the constructed reply be Z=qA with A≥a₀>0; for example, a₀=2d−1 in the one-pair family or a₀=(3d−1)/2 in the equal-six family. If a final acquired value is Z+e with |e|≤ε<a₀, it is nonzero and its phase differs from q by at most arcsin(ε/a₀). Rotate by q⁻¹: the true point is a real A≥a₀, and the radius-ε disk about it lies inside that angular cone. The tangent gives sin(error)≤ε/A. At ε=a₀, the attaining minimum-scale phases permit exact cancellation. Above it, reversal is possible. This error budget concerns the final complex reading. Deriving it from thermal noise or separately normalized measurements is another task; no independent-noise hypothesis was used to obtain the bound.

**Joint coherence constrains the phase without locating its cause.** Let C=Σ_k w_k z(k)z(k)† for finite w_k≥0 and three-component complex records z(k). The weights and record index are common to all entries. For every vector u, u†Cu=Σ_k w_k|z(k)†u|²≥0. Write Dᵢ=Cᵢᵢ. The three-by-three determinant condition is therefore

    D₁D₂D₃+2 Re(C₁₂C₂₃C₃₁)
      ≥ D₁|C₂₃|²+D₂|C₃₁|²+D₃|C₁₂|².

This form uses no absolute amplitude scale. Multiplying each station record by a fixed nonzero complex calibration multiplies both sides by the same positive |g₁g₂g₃|². For Dᵢ>0 normalize Kᵢⱼ=Cᵢⱼ/√(DᵢDⱼ). If all three off-diagonal moduli rᵢⱼ are nonzero, the closure phase ψ obeys

    cos ψ ≥ (r₁₂²+r₂₃²+r₃₁²−1)/(2r₁₂r₂₃r₃₁).

The underlying obligation is the preceding polynomial inequality; the angle is one way of reading it. If all r equal 1, it forces the cycle to close. A weak right-hand side may give no useful angular restriction. At a zero correlation the cycle phase is undefined.

One can prove the same restriction without introducing an angle or diagonalizing a matrix. Remove the component of each station vector along the first. Cauchy–Schwarz for the two residuals gives

    |K₂₃−K₂₁K₁₃|² ≤ (1−|K₁₂|²)(1−|K₁₃|²).

Thus near-perfect relations to one internal reference constrain the remaining relation. The reference is part of the same acquired object. Common positive weighting suffices; stationarity, a uniform sampling law, and an external clock are unnecessary for this finite identity. This does not derive the complex linear field model from bare distinction.

Both source-and-instrument realizations above satisfy this bound, so it does not identify the cause of an observed phase. Nor may correlations obtained using unrelated integration weights or subtractive noise estimates be treated as this particular Gram construction without establishing the required joint relation.

The averaging bias need not require large phase jumps. Replace i in the three gain rows by z=e^{iθ}. The product of the three baseline means is [12+6z+z²+8z⁻¹]/27, with imaginary part −2 sin θ(1−cos θ)/27. It is nonzero for arbitrarily small nonzero θ. This identity locates a finite-precision issue; it does not make a bias below an instrument's actual error distinguishable in data. **The same two-dimensional family appears on both sides.** The cos(π/n) above and in the earlier residual-record construction are linked by an explicit map. Use the convention ⟨x,y⟩=x†y. For two equal-weight acquisitions choose the second station gains to be 1 and the first gains ηᵢ=e^{2iθᵢ}. Their averaged correlation matrix is

    Kᵢⱼ=(1+ηᵢ conjugate(ηⱼ))/2=⟨fᵢ,fⱼ⟩,
    fᵢ=(e^{−2iθᵢ},1)/√2.

Rephase each fᵢ by e^{iθᵢ} and apply the same unitary matrix

    R = (1/√2) [[1,1],[i,−i]].

Direct multiplication gives R(e^{iθᵢ}fᵢ)=(cos θᵢ,sin θᵢ). The rows of R are orthonormal. The resulting Gram entry is e^{−iθᵢ}e^{iθⱼ}Kᵢⱼ=cos(θᵢ−θⱼ). Individual phases cancel around every closed cycle, so this map preserves the cycle products. With θᵢ=(i−1)π/n these are exactly the real two-dimensional vectors used earlier for the attained record and error bounds. The two constructions share these joint relations, not just a numerical cosine.

Their questions still differ. Each neighboring overlap has modulus cos(π/n), approaching 1, while the full overlap product is −cosⁿ(π/n), tending to −1. In the two-acquisition example, both original cycles equal 1; each adjacent baseline changes by only e^{−2πi/n}. Averaging each baseline separately halves that local phase and gives the negative cycle. Thus arbitrarily good *neighboring* coherence supplies no size-independent small bound on the whole cycle phase. This does not assert that every pair of vertices is nearly identical: distant pairs retain substantial differences. Nor does the Gram correspondence transfer the physical roles of elapsed time, quantum memory, access or cost between the two realizations. An error bound against a target matrix also requires transporting that target and the specified error measure.

**Local halving need not preserve a joint relation.** For unit z≠−1, the normalized mean m(z)=(1+z)/|1+z| obeys m(z)²=z. Nevertheless, for z=e^{2πi/n}, n≥3, one has zⁿ=1 but m(z)ⁿ=−1. All the local means in this example are defined. A closed loop need not remain closed when each edge independently takes this phase midpoint.

More generally no total multiplicative choice h on U(1) can satisfy h(z)²=z. Multiplicativity at −1 would give h(−1)²=h(1)=1, while the required square is −1. This is a prohibition derived from the given two-return relation, not a separate ban on taking roots. It does not rule out choosing a root for one phase or using additional endpoint relations. In particular, it is not a refusal of m at an admitted input: −1 was excluded from that partial mean, whose cycle failure was established separately above.

There is a positive joint construction. On a supplied finite graph with unit edge values rᵢⱼ, inverse values on reversed edges, and product 1 around every cycle, propagate vertex phases pᵢ from an internal root so that rᵢⱼ=pᵢ conjugate(pⱼ). The cycle relations make this consistent. Choose any square root sᵢ of each vertex phase, then put hᵢⱼ=sᵢ conjugate(sⱼ). These edge values square to rᵢⱼ and every cycle still closes. Branch choices are coordinated through shared endpoints. This constructs compatible phase data; an instrument that acquires or implements those roots needs its own access relation. The contrast is between a function of each isolated edge value and a construction using the actual joint graph.

## Detail: §14. A finite refusal before an amplitude scale

### IiS22

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

IiS29 supplies a separate positive route: an extremal score in an established real Gram reading determines the cosine comparisons on its finite preparation family, with dimension two as a conclusion. Its positive reading and saturation conditions are additional relations, not consequences silently assigned to the return diagram here.

The next question must address an actual internal refinement: which intermediate contacts exist, which recombinations of the same retained source agree, and which counted answers those contacts preserve. S32 already shows why mutually consistent returns and unique centres do not establish an arithmetic scale. A useful target here is a new refusal that survives changing the intermediate cut while preserving its actual source and all admitted compositions. Only after that diagram determines the response may a familiar coordinate formula be identified with it. The present result supplies an exact finite restriction for that investigation, rather than interpolating an unproved curve between it.

## Detail: §15. An operation can require a larger address domain

### IiS23

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

## Detail: §16. What local silence and incidence leave undecided

### IiS24

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

## Cross-page mentions

Labels mentioned here: <doc:interference_is_substitution__models_calibration#IiS10>, <doc:interference_is_substitution__models_calibration#IiS11>, <doc:interference_is_substitution__models_calibration#IiS12>, <doc:interference_is_substitution__models_calibration#IiS13>, <doc:interference_is_substitution__positive_channels#IiS14>, <doc:interference_is_substitution__positive_channels#IiS17>, <doc:interference_is_substitution__comparison_fluctuations#IiS29>, <doc:interference_is_substitution__models_calibration#IiS9>, <doc:learning_is_liquid__medium_contacts#LQ13>, <doc:permanence_is_resistance__records_entropy#M35>, <doc:permanence_is_resistance__recovery_remainder#M70>, <doc:permanence_is_resistance__forced_answers#M71>, <doc:verdict_is_invariant__finite_records#VC15>, <doc:verdict_is_invariant__reusable_images#VC46>, <doc:verdict_is_invariant__reusable_images#VC47>, <doc:verdict_is_invariant__finite_records#VC9>.

Mentions of this page’s labels: <doc:interference_is_substitution__comparison_fluctuations> (IiS21), <doc:interference_is_substitution__models_calibration> (IiS21), <doc:interference_is_substitution__program_mediator> (IiS20), <doc:learning_is_liquid__reconstructed_sides> (IiS20), <doc:learning_is_liquid__reconstructed_sides> (IiS21), <doc:permanence_is_resistance__recovery_remainder> (IiS20), <doc:permanence_is_resistance__recovery_remainder> (IiS21).
