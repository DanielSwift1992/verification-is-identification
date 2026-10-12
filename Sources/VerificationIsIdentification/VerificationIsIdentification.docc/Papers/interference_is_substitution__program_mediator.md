# Interference Is Substitution (Wave) — Program mediator

This part contains the original derivations for program mediator.

Family and original section headings: <doc:interference_is_substitution>.

Section setting: <doc:interference_is_substitution#16a-A-finite-contact-can-determine-the-programmed-operation>.

## Detail: §16a. A finite contact can determine the programmed operation

A program is another physical input, with its own contact geometry. Exact deterministic execution of distinct unitary channels requires orthogonal complete program states in the usual product-input model. The [Nielsen–Chuang no-programming theorem](https://arxiv.org/html/quant-ph/9703032v1) follows from the same preservation used in IiS20: if a fixed isometry executes U and V, its residual vectors e_p,e_q are independent of the data, and

    ⟨p,q⟩ I = ⟨e_p,e_q⟩ U†V.

A nonzero program overlap therefore makes U†V a scalar multiple of I. Distinct channel names cannot supply the orthogonality of their actual program carriers. A program-dependent record elsewhere in the apparatus belongs to that complete input. A common blank workspace alone does not change its overlap. This is a specified quantum-model restriction, not a consequence of closure alone.

Permitting a heralded successful branch changes the contract. [Vidal, Masanes and Cirac](https://arxiv.org/html/quant-ph/0102037v1) construct a one-qubit phase program with success probability one half and retain a distinguishable failure branch. The following finite calibration derives the whole successful map and its bound directly, without sampling a continuum of phases or prescribing that circuit.

### IiS25

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

## Detail: §16b. The retained program determines the next contact

### IiS26

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

### IiS27

**IiS27 (Finite-copy exact use is possible precisely for a faithful phase program).** For a finite occupied support J with positive weights, choose j₀∈J and put g=gcd{j−j₀:j∈J}. A single occupied power has g=0. The following three properties are equivalent:

1. Every distinct phase z gives a distinct program ray.
2. g=1.
3. Some finite number N of copies in the specified product preparation with the same source phase permits exact U_z with a uniform nonzero heralded success probability.

*Proof.* Two phase preparations have the same ray exactly when their phase ratio ξ obeys ξ^(j−j₀)=1 for all j∈J. This permits no ξ≠1 exactly when g=1. The N-copy support NJ consists of sums of N occupied powers. Its adjacent-power criterion is that NJ contains two sums differing by one. If such sums exist, their difference is an integer combination of the original differences, so g=1. Conversely, Bézout's identity for g=1 supplies integer coefficients a_j with Σ_j a_j=0 and Σ_j a_j j=1. Split their positive and negative parts. Each part contains the same finite number N of terms, producing two actual sums in NJ that differ by one. Both have positive preparation weight. IiS26 then supplies positive exact success. QED

This characterizes eventual access to this operation in the specified preparation family. It does not construct extra copies from one unknown specimen. The N preparations must actually be available from the same source, with the stated product relation. The index N is not a number of times one unchanged program can be reused. Two occupied powers cannot exhibit activation from zero one-copy capacity: either their difference is one and one copy already works, or g≠1 prevents every N. Three occupied powers suffice, as {0,2,5} shows. This minimality concerns this phase-program contract, not a universal number of bits for reality.

## Detail: §16c. A returned mediator has different permissions along the word

### IiS28

**IiS28 (exact interleaving conditions for a borrowed qubit).** Fix the usual finite-dimensional complex quantum model, two working qubits A,B, a borrowed qubit C and an arbitrary finite register R. The coherent implementations P=CX_(A→C) and Q=CZ_(B,C) are supplied contacts. Their availability is not inferred from phase-blind calibration of X and Z; IiS10 explains that distinction. Execute P,Q,P,Q in that order. Products below use the conventional rightmost-first operator notation.

On a control branch ab, the borrowed action is

    ZᵇXᵃZᵇXᵃ = (−1)^(ab) I_C.

Thus the complete word F=QPQP is CZ_(A,B)⊗I_C, also tensored with I_R. This operator identity applies to arbitrary joint input states, including entanglement with R. C need not be prepared, measured or reset. Borrowing unknown ancilla states is an established circuit resource; see [Khattar and Gidney](https://quantum-journal.org/papers/q-2025-05-21-1752/). The present question is which additional action can occur *during* this particular word without changing either process's specified effect.

Let a fixed CPTP channel M act on CR in the gap after j contacts, independently of the control values. The required combined channel is the same as F together with M on CR; these two complete operations commute. Require equality on every joint ABCR input. For any Kraus representation M(ρ)=Σ_μ M_μρM_μ†, the exact conditions are:

| Gap j | Executed prefix L_j | Necessary and sufficient condition |
|---|---|---|
| 0, before the word | I | Any channel M on CR |
| 1, after P | P | Every M_μ commutes with X_C⊗I_R |
| 2, after P,Q | QP | M=id_C⊗N_R for a channel N on R |
| 3, after P,Q,P | PQP=FQ | Every M_μ commutes with Z_C⊗I_R |
| 4, after the word | F | Any channel M on CR |

*Proof.* The suffix is F L_j†. After removing the common complete unitary F, the inserted channel has Kraus operators

    L_j† (I_AB⊗M_μ) L_j.

It must equal the channel with Kraus operators I_AB⊗M_μ. Choose a linearly independent minimal Kraus list. The two minimal lists for the same channel differ by a unitary mixing of their indices, by factorization of their common Choi matrix. Every L_j is identity in the control block 00. Restricting the mixing equation to that block gives M_μ=Σ_ν u_μν M_ν. Linear independence forces u=I. Consequently every I_AB⊗M_μ must commute with the *controlled prefix itself*. Conversely those commutations immediately establish channel equality. Changing Kraus representation only takes linear combinations, so the criterion is representation independent.

For L₁ the nontrivial control blocks are X. For L₂ the 10 and 01 blocks are X and Z; commuting with both also handles the 11 block ZX. For L₃ the nontrivial blocks are Z and −Z. Commuting with Z forces a matrix on CR to be block diagonal in C's computational basis; commuting with X equates its two diagonal blocks. Thus the common commutant is exactly I_C⊗End(R). At j=2, each Kraus operator is I_C⊗N_μ, and trace preservation gives Σ N_μ†N_μ=I_R. At j=0,4 the prefix acts trivially on CR up to its independent working action. This proves the table. QED

The proof uses the established quantum-channel model and its joint extension, as in [IBM's formulation](https://quantum.cloud.ibm.com/learning/en/courses/general-formulation-of-quantum-information/quantum-channels/quantum-channel-basics) and IiS17. It does not derive that model from closure. R and any records omitted by the channel description can be parts of the same whole.

For a unitary on C alone, the first internal gap allows arbitrary rotations about X (and a common phase), while the last internal gap allows rotations about Z. The middle gap permits only a common phase. For channels, dephasing in the X basis is allowed in the first gap, and dephasing in the Z basis is allowed in the third. Arbitrary action on R alone remains allowed throughout. A resource can therefore admit some uses while being unavailable for other uses at the same stage.

**Standalone channel covariance is insufficient.** The channel D_Z(ρ)=(ρ+ZρZ)/2 commutes with conjugation by X and by Z on C alone. Nevertheless its Z Kraus operator does not commute with the controlled prefix QP, so it fails the middle-gap condition. Likewise an inserted unitary Z_C produces the complete operator

    F (Z_A⊗Z_C),

and an inserted X_C produces F (Z_B⊗X_C), with identities on omitted factors. For B=0 and C=0, an inserted Z leaves C fixed but changes an A=+ control to A=−. D_Z in that gap dephases this control instead of leaving it at +. The mediator's unchanged local output in this example does not certify the working action. If the inserted Pauli operation is known, the displayed Z_A or Z_B correction repairs the specified joint effect. That knowledge is additional to an unknown disturbance.

Several fixed channels may be inserted: if each satisfies the condition at its actual gap, move it through its prefix and compose the resulting CR channels in their original order. Their mutual commutation is not needed. This gives the same complete F with that ordered CR action. It does not give a policy access to an unobserved outcome or gap. If an executor cannot distinguish the three internal gaps and must choose one channel valid in all of them, their common allowed family is only id_C⊗N_R. Acquiring the relevant prefix relation can therefore permit a use that an undifferentiated busy/idle description cannot. The stages here are positions in the executed contact order, not measurements against an exterior clock.

`BorrowedPhase.swift` reuses IiS9's signed-field operations. It derives the complete-word and middle-Pauli identities in all four control branches, generically in the four amplitude terms of each branch. Those branch equations can be applied independently to arbitrary control blocks; complex linear interpretation gives the stated operator identities and their untouched-reference extension. No probability, norm or interpretation of an arbitrary type as a qubit follows from the field grammar. The general CPTP classification is the proof above, not a compiler enumeration of quantum channels. The finite checks reject an empty complete action and unmodified middle-gap interleaving. No hardware experiment or quantum scheduling implementation is claimed.

## Cross-page mentions

Labels mentioned here: <doc:interference_is_substitution__models_calibration#IiS10>, <doc:interference_is_substitution__positive_channels#IiS17>, <doc:interference_is_substitution__global_obstructions#IiS20>, <doc:interference_is_substitution__models_calibration#IiS9>, <doc:permanence_is_resistance__cost#M25a>, <doc:permanence_is_resistance__recovery_remainder#M70>.
