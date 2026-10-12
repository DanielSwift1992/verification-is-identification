# Interference Is Substitution (Wave) — Comparison fluctuations

This part contains the original derivations for comparison fluctuations.

Family and original section headings: <doc:interference_is_substitution>.

Section setting: <doc:interference_is_substitution#16d-An-extremal-joint-comparison-forces-a-cosine-profile>.

## Detail: §16d. An extremal joint comparison forces a cosine profile

### IiS29

**IiS29 (a sharp finite comparison determines its real Gram without a dimension premise).** Let n≥3. The admitted real symmetric reading matrix G has G≥0 and Gᵢᵢ=1 for i=0,…,n−1. Its entries refer to the same preparations and the same comparison. Define the signed-chain score

    S(G) = Σᵢ₌₀ⁿ⁻² Gᵢ,ᵢ₊₁ − Gₙ₋₁,₀.

Equivalently, use unit vectors v₀,…,vₙ₋₁ with this real Gram and close the chain at vₙ=−v₀. The last minus sign is a specified opposite comparison, not a directly observable global sign of an isolated quantum state. Then

    S(G) ≤ n cos(π/n),

and equality holds **if and only if**

    Gᵢⱼ = cos((i−j)π/n)    for every i,j.

Thus one extremal scalar reading fixes all the real pair readings on these preparations. In particular their minimal real Gram representation has dimension two. No two-dimensional carrier, smooth parameter, autonomous reduced dynamics, common linear update, preassigned spatial angles or Born probability rule was assumed. Positivity, normalization, the actual signed incidences and attainment of the bound remain premises. Nothing here says that an arbitrary physical process attains that bound. If the shared nonzero self-reading is D instead of 1, apply the result to G/D: the score bound is nD cos(π/n) and the forced entries are D cos((i−j)π/n). The normalization is a ratio within the acquired reading, not a universal physical constant.

*Proof.* On the finite index space, let T act by (Tx)ᵢ=xᵢ₊₁ for i<n−1 and (Tx)ₙ₋₁=−x₀. This is a signed permutation of the index roles, with Tⁿ=−I. Put A=(T+Tᵀ)/2. Directly, S(G)=tr(AG). Vectors with entries exp(i(2k+1)πj/n), j=0,…,n−1, diagonalize A with eigenvalues cos((2k+1)π/n). Its top eigenvalue is c=cos(π/n), and its real eigenspace is spanned by the two columns of

    Fⱼ = (cos(jπ/n), sin(jπ/n)).

Since cI−A≥0 and G≥0, tr((cI−A)G)≥0, while tr G=n. Equality forces range G into that two-dimensional eigenspace: the positive matrix G¹ᐟ²(cI−A)G¹ᐟ² has trace zero, hence is zero. Consequently G=FMFᵀ for some real symmetric M≥0. Its diagonal entries are

    (M₁₁+M₂₂)/2 + (M₁₁−M₂₂)cos(2jπ/n)/2
                       + M₁₂ sin(2jπ/n).

On n≥3 equally indexed positions, the three displayed functions 1, cos(2jπ/n), sin(2jπ/n) are independent and orthogonal under the finite sum. Requiring every diagonal entry to be 1 therefore gives M=I. Conversely FFᵀ has unit diagonal and attains the stated bound. QED

The trigonometric coordinates diagonalize an already specified finite incidence matrix. They were not obtained by fitting the acquired answers and defining their control parameter with an inverse cosine. The number n counts actual roles. Its connection to a physical angle, clock or path length still needs a contact relation.

**Three preparations make the obstruction visible without trigonometry.** Write a=⟨v₀,v₁⟩, b=⟨v₁,v₂⟩, c=⟨v₀,v₂⟩. Then

    3−2(a+b−c) = ‖v₀−v₁+v₂‖² ≥ 0.

At the maximum a+b−c=3/2, the residual is zero, so v₁=v₀+v₂. The three unit self-readings give c=−1/2 and a=b=1/2. These individual answers were not separate premises. More generally, without equal normalization, put Dᵢ=‖vᵢ‖². Saturation of a+b−c≤(D₀+D₁+D₂)/2 forces

    2a=D₀+D₁−D₂,   2b=D₁+D₂−D₀,   2c=D₁−D₀−D₂.

The common scale can remain unknown. Reading a ratio or a probability is an additional question; the linear map p=(1+a)/2 is not derived by this norm identity.

**A sharp finite-precision statement for the three-preparation case.** If S≥3/2−ε with 0≤ε≤1/2, each signed edge t∈{a,b,−c} lies in

    1/2−√(2ε)−ε ≤ t ≤ 1/2+√(2ε)−ε.

For t=a, maximize the other two contributions at fixed v₀,v₁: b−c=⟨v₁−v₀,v₂⟩≤√(2−2a). Writing u=√(2−2a) gives S≤a+u=3/2−(u−1)²/2. Hence |u−1|≤√(2ε), which yields both bounds. They are attained by choosing u=1±√(2ε) and v₂ along v₁−v₀; the u=0 endpoint is immediate separately. Relabeling and reversing the appropriate vectors applies the same argument to b and −c. Thus the square-root precision cost is real, not an artifact of an uncontrolled approximation. Error intervals in acquired comparisons must first establish the stated lower bound on S.

**Four preparations give two unmeasured answers and a sharp error bound.** For n=4 the score uses four of the six pair readings. At S=2√2, the other two are forced to G₀₂=G₁₃=0. This also follows directly from

    2√2−S = [‖v₀−(v₁−v₃)/√2‖²
                    + ‖v₂−(v₁+v₃)/√2‖²]/√2.

If a certified score lower bound L satisfies 2≤L≤2√2, then

    |G₀₂|, |G₁₃| ≤ (L/4)√(8−L²).

Both bounds are separately sharp. For t=G₁₃, Cauchy–Schwarz gives S≤‖v₁−v₃‖+‖v₁+v₃‖=√(2−2t)+√(2+2t). Squaring and rearranging with S≥L≥2 gives the bound. Grouping the score around v₀ and v₂ instead proves the same statement for G₀₂. For attainment at a fixed t, choose v₀ along v₁−v₃ and v₂ along v₁+v₃; the zero-sum endpoints at |t|=1 are treated by freely choosing the unused unit vector.

For example, L=14/5 forces both unmeasured absolute readings to be at most 7/25. Equality for G₁₃ is attained by the rational unit vectors

    v₀=(3/5,−4/5),  v₁=(1,0),
    v₂=(4/5,3/5),   v₃=(7/25,24/25).

Their signed edge readings are 3/5,4/5,4/5,3/5, and G₁₃=7/25. This is an exact attaining construction, not a numerical fit. If each of the four acquired edge readings has absolute error at most η, their recorded score Ŝ supplies L=Ŝ−4η. The theorem applies only when this lower bound reaches its stated range. A standard error alone is not a deterministic simultaneous error bound.

**The two sharp intervals are not a joint rectangle.** Put a=G₁₃ and b=G₀₂. For prescribed a,b∈[−1,1], the exact maximum is

    Smax(a,b)=2√(1+√((1−a²)(1−b²))).

To prove this, the ordered vector pairs X=(v₀,v₂), Y=(v₁,v₃) have Grams A_b=[[1,b],[b,1]] and A_a=[[1,a],[a,1]]. With D=[[1,−1],[1,1]], the score is Σᵢⱼ Dᵢⱼ⟨Xᵢ,Yⱼ⟩. Factoring the pairs through orthonormal two-frames reduces the maximum to the sum of singular values of M=A_b¹ᐟ² D A_a¹ᐟ². Their squares sum to ‖M‖F²=4, and their product is |det M|=2√((1−a²)(1−b²)). The relative two-frame is a contraction, so the singular-value sum is an upper bound; choosing its orthogonal polar factor attains it in a common real plane. This argument also covers singular A_a or A_b by extending the unused frame direction. Squaring the sum proves the formula.

Consequently, for 2≤L≤2√2, existence of a unit Gram with these a,b and S≥L is equivalent to

    (1−a²)(1−b²) ≥ (L²/4−1)².

At L=14/5, |a|=7/25 forces b=0, and conversely. If |a|=|b|, each is at most 1/5. These endpoints are attainable. Keeping the two individual intervals but dropping this relation would admit joint answers excluded by the same acquired score.

For general n, let P project onto the top eigenspace above, and let γ=cos(π/n)−cos(3π/n)>0. With ε=n cos(π/n)−S and r=tr((I−P)G), the spectral gap gives r≤ε/γ. In particular, an almost maximal score bounds how much of this reading lies outside the fundamental two-dimensional index profile. One explicit, not claimed sharp, bound on the entire real matrix is

    ‖G−FFᵀ‖F ≤ (1+√n) √(2n min(n,ε/γ)).

Indeed, for E=G−PGP, blockwise positivity gives ‖E‖F²≤2(n−r)r+r²≤2nr. The matrix N=PGP−FFᵀ is supported on P, and the same three finite Fourier components of its diagonal give ‖N‖F≤√n‖diag N‖₂. Since diag N=−diag E, the bound follows by the triangle inequality. No statistical independence is used. Larger n does not automatically make certification easier: γ shrinks.

No positive score tolerance forces exact rank two. For 0<δ<1, Gδ=(1−δ)FFᵀ+δI has unit diagonal, rank n, and score (1−δ)n cos(π/n). Its score approaches the maximum as δ approaches zero. The preceding estimate bounds the remaining contribution; it does not assert its absence.

**Cosine real readings do not determine complex phase.** If the source profiles belong to a complex Hilbert space and the acquired G reads only Re⟨vᵢ,vⱼ⟩, the conclusion above determines that real Gram. It must not be strengthened to the full Hermitian Gram. At saturation there are real-orthonormal profiles e,f with

    vⱼ = cos(jθ)e + sin(jθ)f,      θ=π/n,
    ⟨e,f⟩=iκ,                    −1≤κ≤1.

Using the convention ⟨x,y⟩=x†y, the full family of compatible complex Grams is

    Hᵢⱼ = cos((j−i)θ) + iκ sin((j−i)θ).

Necessity follows by expressing the vectors in the forced real plane; Cauchy–Schwarz gives |κ|≤1. Every κ is attained by e=(1,0), f=(iκ,√(1−κ²)). At |κ|=1 the complex span is one-dimensional; for |κ|<1 it has dimension two. The real comparison did not decide this complex dimension or the rest of the physical carrier.

For n=3, the oriented closure product is

    H₀₁H₁₂H₂₀ = −(1/2+iκ√3/2)³.

At κ=0 it is −1/8; at κ=1 it is 1. More strongly, κ=±1/2 gives the same complete real Gram **and** every overlap magnitude, yet the closure products are (10∓9i√3)/64. Their phases differ. Thus even these combined readings do not determine the oriented closure phase.

Without the extra magnitude readings, the ambiguity covers the entire phase circle, for every n≥3. Write zκ=cos θ+iκ sin θ. The full oriented cycle is

    B(κ)=H₀₁H₁₂···Hₙ₋₂,ₙ₋₁Hₙ₋₁,₀=−zκⁿ.

Here zκ never vanishes, since cos θ>0. A continuous phase lift is Φ(κ)=π+n arctan(κ tan θ). It runs from 0 to 2π as κ runs from −1 to 1. Thus the exact maximal real comparison is compatible with every closure phase. Fixing |H₀₁| instead fixes |κ| through |H₀₁|²=cos²θ+κ²sin²θ, generally retaining the sign ambiguity above.

This ambiguity has an acquisition realization inside IiS21's ideal station-gain model. For a unit point source, use two gain configurations gⱼ⁺=exp(−ijθ) and gⱼ⁻=exp(ijθ) with nonnegative weights p and 1−p. Their averaged matrix is

    Hᵢⱼ=p exp(i(j−i)θ)+(1−p)exp(−i(j−i)θ),   κ=2p−1.

Every cycle before averaging is 1. Nevertheless every value of p gives the same maximal real score, while the three-station averaged cycle has the different phases just exhibited. A real cosine profile, even exactly extremal, therefore cannot certify that the unresolved gain changes preserved closure phase. This is an explicit ideal countermodel, not a finding of this error in EHT data.

One additional scalar reading suffices within this exact family. A calibrated relative quarter-turn Q on the actual second preparation, Qv₁=i v₁, gives

    h = Re⟨v₀,Qv₁⟩ = −κ sin θ.

Since sin θ≠0, κ=−h/sin θ reconstructs the remaining Gram. The two κ alternatives prove that the earlier readings alone cannot do so; the displayed contact supplies an attaining one-query construction. Its control relation and shared source must be available to the executor. Calling an arbitrary new measurement a quarter-turn does not establish them. With the real Gram exact, |δh|≤η gives |δκ|≤η/sin θ; uncertainty in that Gram or control needs an additional bound. This recovers the acquired Hermitian Gram. It does not undo earlier averaging or identify the intrinsic source phase over IiS21's larger joint family of unknown sources and instruments. If the retained record already includes the complex entries, its imaginary part supplies this extra reading without a fresh physical acquisition. The worst-case one-contact bound concerns an interface initially exposing only the real comparisons and magnitudes, with the stated quarter-turn available.

**Finite saturation still leaves unmeasured contacts free.** On the regular grid tⱼ=jπ/n, both kernels C₀(t)=cos t and

    Cα(t)=(1−α)cos t + α cos((2n+1)t),      0<α<1,

give every same pair reading and the same maximal signed-chain score. Both are normalized positive comparison kernels, continuous and even, with period 2π and C(t+π)=−C(t). For the second, an explicit unit profile is

    vα(t)=(√(1−α)cos t, √(1−α)sin t,
           √α cos((2n+1)t), √α sin((2n+1)t)).

At t=π/(2n), however, Cα(t)=(1−2α)cos t. For α=1/2 the new reply is zero while C₀(t)>0. The whole finite acquired Gram was correct; the missing intermediate contact, not a defective old datum, separates the realizations. A continuum claim needs further coverage or a justified restriction on possible modes. One grid, however accurately measured, supplies neither. This also distinguishes the forced real plane on the acquired family from a dimension bound on every future preparation.

**New preparations can be admitted through their actual anchor readings.** In the exact n=4 case, e=v₀ and f=v₂ are orthonormal in the real comparison space, with v₁=(e+f)/√2 and v₃=(f−e)/√2. For a new unit preparation w, acquire a=⟨e,w⟩ and b=⟨f,w⟩ under the same comparison contract. Joint positivity then gives

    w=ae+bf+r,       r⊥e,f,       ‖r‖²=1−a²−b²,
    ⟨v₁,w⟩=(a+b)/√2,            ⟨v₃,w⟩=(b−a)/√2.

The two anchor readings determine every old-to-new comparison even when r remains unknown. The equality a²+b²=1 forces r=0; membership in the old plane is then a conclusion. For another unit z with anchor readings c,d, the exact possible interval is

    |⟨w,z⟩−(ac+bd)| ≤ √((1−a²−b²)(1−c²−d²)).

Cauchy–Schwarz gives necessity, and residuals with any prescribed allowed inner product give sufficiency when their dimension is free. If either residual vanishes, the new mutual comparison is exact.

For several new preparations the intervals are again insufficient jointly. Put their anchor columns in a 2×m matrix A, and let K be their proposed real comparison matrix, with Kⱼⱼ=1. The exact extension criterion, including all comparisons to the old family, is

    R=K−AᵀA ≥ 0.

Necessity reads R as the common residual Gram. For sufficiency, factor R as such a Gram in a space orthogonal to e,f and append those residuals to the specified projections. For example, three zero projections allow each separate new pair to have comparison −1. Assigning −1 to all three pairs is impossible: their residual Gram has diagonal 1 and the all-ones vector has quadratic value −3. The least additional real dimension for a fully specified feasible K is rank R. No bound on all future preparations follows. These extension statements concern real readings; complex quadratures remain separate acquisitions.

The familiar alternative cos³t=(3cos t+cos 3t)/4 is itself a positive comparison kernel, with a periodic form. On the three preparations 0,π/3,2π/3 it gives S=3/8 instead of 3/2; its Gram determinant is 1−3/64−2/512=243/256>0. Thus positivity and the return symmetries admit it, while saturation excludes it on that family.

The other premises also have explicit boundaries. For n=4, dropping joint positivity admits G=I+2A: every two-by-two principal block is positive, but S=4 and G has a negative eigenvalue 1−√2. Valid isolated pairs therefore do not supply the joint contract. Replacing the closing minus by a plus instead admits the all-ones rank-one Gram with score n; the opposite endpoint is substantive. At n=2 the two signed terms cancel for every Gram, so no uniqueness conclusion follows. These are failures of the proposed inference under weakened premises, not failures of reality.

**Scope and external comparison.** Extremal correlation rigidity and sum-of-squares self-testing are established mathematical methods; see [Šupić et al., introduction and §3](https://arxiv.org/pdf/1511.09220) and [Bharti et al., §III.3](https://arxiv.org/html/2104.13035). This is an explicit finite Gram application in VI, not a priority claim for cosine rigidity or a new Bell theorem. There is no assumed division into two distant parties or derivation of a quantum state from Bell statistics here. In particular, a real Gram cannot be inferred from arbitrary separately acquired binary probability tables by naming them comparisons. A Gram factorization such as IiS15, or an independently established physical reading relation, supplies the positive domain. IiS30 below classifies one finite acquisition and averaging mechanism that supplies it, including necessary conditions on its shared weights. Projecting an observed noisy table to the positive cone changes its reading and requires an error bound. EHT's comparison of J and P does not by itself establish this extremal contract.

The proof above is finite mathematics, independent of a runtime search. No open Swift conformance named after its conclusion is used as a proof of positivity or an inequality on unknown real readings. The result removes a dimension premise for the acquired real question, identifies its remaining complex ambiguity, and supplies a distinguishing contact. It does not derive the positive reading or the Born rule from the bare existence of a distinction.

## Detail: §16e. Which acquisition preserves a joint positive comparison?

### IiS30

**IiS30 (fixed pair averaging has a finite test for universal joint positivity).** There are n≥3 channels and m≥1 acquisition indices. A record supplies unit complex values xᵢ(k), independently free at every i,k. The proposed processing has fixed real coefficients aᵢⱼ(k)=aⱼᵢ(k), independent of those values, and reads

    Hᵢᵢ=1,
    Hᵢⱼ=Σₖ aᵢⱼ(k) conjugate(xᵢ(k)) xⱼ(k),     i≠j.

Assume Σₖ aᵢⱼ(k)=1 on every pair: a constant comparison is preserved. The coefficients are not initially required to be nonnegative. The following are equivalent:

1. H is positive semidefinite for every admitted array of unit values.
2. H is positive semidefinite on the nm arrays obtained from all +1 records by changing just one channel at one acquisition to −1.
3. In each of those sign probes, the flipped channel has the same real comparison against every unchanged channel, and this answer is in [−1,1].
4. There are common λₖ≥0, Σₖλₖ=1, such that aᵢⱼ(k)=λₖ for every off-diagonal pair i,j.

*Proof.* (1) implies (2). For (2)⇒(3), flip channel i at index k. Two other channels j,l still have Hⱼₗ=1. In a unit Gram, that forces their vectors to coincide, hence Hᵢⱼ=Hᵢₗ, and a positive two-by-two block bounds each real comparison by one in absolute value. For (3)⇒(4), the actual processing gives 1−2aᵢⱼ(k) and 1−2aᵢₗ(k). Their equality makes all weights incident to i agree at k. Apply the same argument at each channel. Symmetry and connectedness of the complete pair graph give a common λₖ on all edges. The interval in (3) gives |1−2λₖ|≤1, so 0≤λₖ≤1. Pair normalization gives their sum one. Finally (4) gives the explicit profiles

    vᵢ=(√λ₁ xᵢ(1), …, √λₘ xᵢ(m)),     Hᵢⱼ=⟨vᵢ,vⱼ⟩.

Their Gram is positive for every unit record, including arbitrary complex phases. This proves (1) for all those records, beyond the tested sign cases. QED

No optimization over unknown hidden carriers is needed for this criterion. In each sign probe it is enough to check that the flipped channel has the same reply against all the unchanged channels, and that this real reply lies in [−1,1]. These finite equalities and bounds already imply common weighting, and therefore universal positivity in the stated processing class. The nm count is a sufficient test set, not a claimed minimum. The coefficients may be unknown to the tester; their fixed linear form, pair normalization and the actual sign preparations must still be established. Data-dependent weighting or an unadvertised input is outside this inference. Exact tests do not supply a tolerance theorem for noisy or imperfectly prepared probes; the local spectral margin below keeps their preparation relations exact.

The three-channel obstruction has an elementary determinant certificate. For a sign probe, the principal matrix on the flipped channel and two unchanged channels is

    [[1,r,s], [r,1,1], [s,1,1]],      det=−(r−s)².

Thus positivity forces r=s, and the two-by-two minors force |r|≤1. The third channel removes the independent choice of two averaging weights without adding an external controller.

**Group probes reduce the sufficient preparation count.** At index k, flip a nonempty proper subset of the channels, leaving every other record +1. Inside each of the two groups all comparisons equal one. Positivity therefore makes every comparison across that cut the same real number in [−1,1]. All crossing weights at k coincide. Assign the n channels distinct binary labels of length r=⌈log₂ n⌉; each bit supplies a nontrivial cut. Every pair crosses some cut, and any two nontrivial cuts of a complete graph share a crossing edge. To see the latter, absence of a common edge would force the second cut's labels to agree across every pair separated by the first, hence everywhere. The shared edges make all cut weights agree. Thus m⌈log₂ n⌉ group preparations suffice to replace the nm individual flips in IiS30. For n=4, (1,1,−1,−1) and (1,−1,1,−1) at each index suffice. This counts preparations followed by acquisition of the joint matrix, not individual pair readings. It assumes group flips are available and claims no optimality or equal physical cost of different probes.

**A local tolerance bound retains a square-root dependence.** Suppose a specified individual-flip matrix satisfies H≥−εI, ε≥0, while its diagonal and the unchanged comparison Hⱼₗ=1 remain exact. Positivity of H+εI, applied to coordinate vectors eᵢ and eⱼ−eₗ, gives

    |Hᵢⱼ−Hᵢₗ|² ≤ 2ε(1+ε),
    |aᵢⱼ(k)−aᵢₗ(k)| ≤ √(ε(1+ε)/2),
    −ε/2 ≤ aᵢⱼ(k) ≤ 1+ε/2.

The last line follows from a two-by-two principal block of H+εI. The difference bound is sharp for this single three-channel condition: take the displayed r,s matrix with s=−r and r²=ε(1+ε)/2. Its eigenvalues are 2, 1+ε and −ε. This is a local certificate, not a simultaneous optimal bound for the entire set of probes. Errors in normalization, the unchanged comparison or actual sign controls must enter separately; a numerical eigenvalue tolerance alone does not establish a physical error budget.

This makes common weighting a consequence of a preservation obligation, rather than an extra preference for a tidy data format. It does not require a known external clock, stationary channels, independent samples or a calibrated absolute phase. The acquisition index binds products to actual shared records. Calling unrelated records the same index does not create that relation.

**A false joint geometry can be manufactured from exact unit records.** Use just two records x(1)=(1,1,1), x(2)=(−1,1,1). Read pairs 01 and 12 from the first, and pair 20 from the second. Every pair has a normalized nonnegative weight and an exactly acquired product. Yet

    H = [[1,1,−1], [1,1,1], [−1,1,1]].

Every two-by-two principal block is positive. But for c=(1,−1,1), cᵀHc=−3. The three-position score is 3, exceeding IiS29's positive Gram bound 3/2. The contradiction is in treating the assembled table as one Gram, not in any individual record or in reality. This is a counterexample to a processing contract, not evidence of an error in an actual astronomical pipeline.

**The unrestricted-amplitude criterion identifies the exact wider class.** For arbitrary real or complex xᵢ(k), now let the self-readings also be computed by the kernel. Put Wₖ=(aᵢⱼ(k)), real symmetric, and

    C(x)=Σₖ D(x(k))† Wₖ D(x(k)),

where D puts the channel values on a diagonal. Then C(x)≥0 for every array x if and only if Wₖ≥0 separately for every k. Sufficiency follows by positive congruence and addition. For necessity, set all records to zero except the k-th, whose channel values are all one. The output is exactly Wₖ.

If this processing also preserves every constant channel profile, then ΣₖWₖ=J, the all-ones matrix. For u⊥1, positivity gives 0=uᵀJu=ΣₖuᵀWₖu, so Wₖu=0 for every k. Each Wₖ is therefore λₖJ with λₖ≥0 and Σₖλₖ=1. Here common weights also include the self-readings. In the preceding unit-record contract individual diagonal weights cannot be identified this way: every |xᵢ(k)|² is already one.

Without preservation of constant comparisons, common weights are not necessary. Any collection Wₖ≥0 provides a positive output, with explicit factors obtained from the Wₖ. For example, keeping only diagonal entries always preserves positivity but discards all cross comparisons. This is a different reading. The general factor argument is an application of established matrix positivity and Schur products, not a priority claim; see [Khare's account of the Schur product theorem](https://arxiv.org/abs/1910.03537).

**Missing records and the declared question matter.** In a pipeline that uses only actually available same-index pair products, with no imputation, a positive common λₖ requires all pairs of the declared channel family to be available at k. Otherwise the unavailable pair has zero weight there, and commonality forces λₖ=0. Thus, within this processing class, using partially observed records through independent pair renormalization cannot guarantee both an unchanged constant comparison and positivity for every source. A smaller declared family may have usable common records; nothing here requires discarding it because unrelated channels were missing. Model-based completion or altered kernels are possible, but must establish their own relation to the requested source reading. The familiar loss of positivity under pairwise deletion is already documented in the [R statistics manual](https://www.stat.ethz.ch/R-manual/R-devel/library/stats/html/cor.html). The theorem concerns uncentered fixed linear product averaging, and is not a general characterization of centered covariance estimators.

Finally, supplying positivity does not supply IiS29's extremum. If the entire actual preparation family consists only of real sign records, each signed cycle has product −1 and therefore at least one negative edge. Its score is at most n−2, as is any common positive average. That is strictly below n cos(π/n) for n≥3. The sign probes above certify the processor on a richer unit-phase family only because its fixed formula applies there; they do not prove that those richer physical preparations are available. Admission of the comparison, attainment of its bound, and extension to new preparations remain different relations.

**A maximal average also constrains every used phase record.** In IiS30's common positive mixture, write G=Re H=ΣₖλₖG⁽ᵏ⁾ and M=n cos(π/n). Each G⁽ᵏ⁾ is a unit real Gram, so Sₖ≤M. If S(G)=M, nonnegative deficits sum to zero and Sₖ=M whenever λₖ>0. IiS29 fixes every such G⁽ᵏ⁾ to the same cosine Gram. A scalar unit-phase record is a planar real configuration, so its only possibilities are

    xⱼ(k)=exp(iγₖ) exp(iσₖjπ/n),     σₖ∈{−1,+1}.

Indeed its first two noncollinear positions fix a real orthogonal map from the cosine plane; that map is a rotation or a rotation with reflection. The common phase γₖ cancels in comparisons. Consequently the full acquired Gram has IiS29's parameter κ=Σₖλₖσₖ. The freedom of the averaged closure phase persists even though every contributing record is individually extremal. A deficient record cannot be hidden by an above-bound compensating record.

More generally, if S(G)≥M−ε for ε≥0, the total weight of records with Sₖ≤M−δ is at most ε/δ for δ>0, or one if that quotient is larger. This is the finite inequality δΣ_bad λₖ≤Σₖλₖ(M−Sₖ)≤ε. It gives no uniform closeness of every low-weight record and assumes the same established nonnegative mixture.

## Detail: §16f. A positive comparison can exclude every scalar-phase mixture

### IiS31

**IiS31 (four channels are the first obstruction, with a sharp residual witness).** Let Pₙ consist of matrices with a finite representation

    Hᵢⱼ=Σₖλₖ conjugate(xᵢ(k)) xⱼ(k),
    λₖ≥0,    Σₖλₖ=1,    |xᵢ(k)|=1.

The number of records and the common weights are unrestricted. Every such matrix is positive with unit diagonal. The converse holds for n≤3, but fails at n=4. This compares realizations of an acquired matrix. IiS30 instead classifies processing rules which remain positive for every input; its quantifiers do not assert the converse here.

**The four-channel witness.** Use the unit profiles

    v₀=(1,0),    v₁=(0,1),
    v₂=(1,1)/√2,    v₃=(1,i)/√2,

and let H*=Gram(v₀,v₁,v₂,v₃), with ⟨u,v⟩=u†v. The two exact relations v₂=(v₀+v₁)/√2 and v₃=(v₀+iv₁)/√2 have zero squared residual. In a positive scalar-phase mixture these zero residuals would have to hold in every record of positive weight. With z=conjugate(x₀)x₁, the first requires Re z=0, the second Im z=0, contradicting |z|=1. Thus H*∉P₄, irrespective of the number of hidden records. Positivity of H* itself follows from its given vectors.

The exclusion has an exact positive margin. Put

    c₂=(−1/√2,−1/√2,1,0)ᵀ,
    c₃=(−1/√2,−i/√2,0,1)ᵀ,
    Q(H)=c₂†Hc₂+c₃†Hc₃,     d=3−2√2.

Then

    Q(H)≥d    for every H∈P₄,       whereas Q(H*)=0.

For one scalar record, minimize each residual over x₂ and x₃ at fixed x₀,x₁. Set u=Re z and v=−Im z, so u²+v²=1. The reverse triangle inequality gives

    Q ≥ (√(1+u)−1)²+(√(1+v)−1)².

For −1≤t≤1,

    (√(1+t)−1)²=t²/(1+√(1+t))² ≥ t²/(1+√2)².

Adding proves Q≥d. The record (x₀,x₁,x₂,x₃)=(1,1,1,(1+i)/√2) attains d: its second residual is zero and its first has squared modulus (√2−1)². Linearity in H extends the sharp bound to all positive mixtures. The pointwise proof also excludes arbitrary probability distributions of scalar phases, not only finite mixtures.

**Zero residual identifies the matrix, including the unread pair.** For any positive unit-diagonal H, Q(H)=0 implies both vector residuals are zero. The unit norms of v₂=(v₀+v₁)/√2 and v₃=(v₀+iv₁)/√2 give Re H₀₁=0 and Im H₀₁=0. Thus v₀,v₁ are orthonormal and H=H*, in particular

    H₂₃=(1+i)/2.

The same witness therefore has two distinct conclusions: Q<d excludes the scalar-phase family, while Q=0 together with joint positivity and unit diagonal identifies the full comparison matrix. It does not identify one physical realization of that matrix.

For an inexact residual q=Q(H)≥0, a direct bound on the unread pair is

    |H₂₃−(1+i)/2|
      ≤ (2+√2)√q + (1+√2)q/2.

This constant is not claimed optimal. Put E=(v₀+v₁)/√2, F=(v₀+iv₁)/√2, r=v₂−E, s=v₃−F, ρ=‖r‖ and σ=‖s‖; then ρ²+σ²=q. For H₀₁=u+iv and c=(1+i)/2,

    ⟨E,F⟩=c(1+u−v),
    u−v=q−2 Re⟨v₂,r⟩−2 Re⟨v₃,s⟩,
    H₂₃−⟨E,F⟩=⟨r,v₃⟩+⟨v₂,s⟩−⟨r,s⟩.

Consequently the absolute deviation is at most (1+√2)(ρ+σ)+q/√2+ρσ. Use ρ+σ≤√(2q) and ρσ≤q/2. The unit-Gram bound |H₂₃|≤1 also caps the deviation by 1+1/√2. The square-root order cannot be replaced uniformly by O(q): replacing only v₂ of H* by exp(it)v₂ gives q=|exp(it)−1|² and deviation √(q/2). A certified upper bound q≤ε supplies the same displayed bound with ε, without acquiring the pair 23. Positivity and actual unit normalization remain necessary for that prediction.

**Only five pair locations enter this witness.** With unit diagonal,

    Q(H)=4+Re H₀₁−Im H₀₁
             −√2(Re H₀₂+Re H₁₂+Re H₀₃+Im H₁₃).

The pair 23 is unused. This requires six real component readings; no claim of minimal measurement count is made. With individual absolute error bounds on just those components, a sufficient total error is

    B=η₀₁,R+η₀₁,I+√2(η₀₂,R+η₁₂,R+η₀₃,R+η₁₃,I).

Alternatively, let Ĥ denote acquired values with simultaneous bounds |Ĥᵢⱼ−Hᵢⱼ|≤ηᵢⱼ on these five complex entries. Then, keeping the true unit diagonal,

    |Q(Ĥ)−Q(H)| ≤ √2(η₀₁+η₀₂+η₁₂+η₀₃+η₁₃)=B.

For the 01 entry, the coefficient Re−Im has Euclidean norm √2; each other selected component has the same norm. Hence Q(Ĥ)+B<d certifies exclusion of every scalar-phase mixture. This bound concerns actual entry errors, not unqualified standard deviations. If measured self-readings are used instead of a known unit normalization, add their four absolute error bounds: each diagonal coefficient of Q is one. The measurement and normalization relations must still address the same underlying matrix.

As one illustrative perturbation, H_t=(1−t)H*+tI, 0≤t≤1, remains positive with unit diagonal and Q(H_t)=4t. It is excluded for t<d/4. This is a sufficient exclusion interval from this witness, not the exact membership threshold of the entire one-parameter family.

**Why fewer than four channels cannot have this obstruction.** For n≤3 factor a positive unit-diagonal H as Gram(vᵢ) with spanning profiles in Cʳ. If r≥2, the r²-dimensional real space of Hermitian r×r matrices contains a nonzero T solving vᵢ†Tvᵢ=0 for all n profiles, because r²>n. T has both eigenvalue signs: a semidefinite T with these zero forms would annihilate every spanning vᵢ. Choose t₊,t₋>0 so I+t₊T and I−t₋T are positive and singular. Their Gram matrices still have unit diagonal and lower rank. Mixing them with weights t₋/(t₊+t₋) and t₊/(t₊+t₋) recovers H. Repeat on each lower-rank term. The finite recursion ends at rank-one unit-diagonal Grams, precisely scalar-phase records. Thus every n≤3 positive unit Gram has a finite phase mixture. In particular every three-channel restriction of H* has such a realization, while the four restrictions cannot all be explained by one shared mixture.

This rank argument belongs to the established geometry of extreme correlation matrices; [Li and Tam, Theorem 1 and Corollary 2, p. 904](https://people.wm.edu/~cklixx/corr.pdf) give the general characterization and the complex bound r²≤n for extreme points. No priority for the four-channel threshold is claimed. Its minimality allows arbitrary weights and record count. Fixing those resources, or restricting the allowed phases, changes the question.

**The refused mechanism is specifically phase-only.** H* has an explicit two-record scalar realization as soon as amplitudes may vary. Give weight 1/2 to each record

    (√2,0,1,1),     (0,√2,1,i).

Their weighted complex Gram is H*, with every averaged self-reading equal to one. Individual record amplitudes are not unit. Thus unit diagonal after averaging does not establish phase-only fluctuations before averaging. Classical vector modes also realize the four supplied profiles. The witness is not a quantum-versus-classical test and cannot be applied to arbitrary unknown EHT gains by normalization alone.

The finite joint matrix is also not an identified history. Under a simultaneous rephasing vⱼ↦dⱼvⱼ, |dⱼ|=1, put D=diag(dⱼ). Then H↦D†HD and c₂,c₃↦D†c₂,D†c₃ preserve Q. Their relative quadratures must be supplied by the actual comparison, as in IiS29. No absolute external phase reference is established by the numerical form of the witness.

## Detail: §16g. A mean comparison forces hidden intensity fluctuations

### IiS32

**IiS32 (the scalar realization of H* has a sharp minimum intensity variance).** Retain one common positive scalar-record acquisition

    Hᵢⱼ=E[conjugate(aᵢ)aⱼ]=H*ᵢⱼ,     i,j=0,…,3,

where E is a finite normalized nonnegative weighted sum. Amplitudes are now unrestricted. Put Iᵢ=|aᵢ|², so E Iᵢ=1, and define the sum of normalized intensity variances

    V=Σᵢ E[(Iᵢ−1)²].

Then the exact minimum over all such scalar realizations is

    Vmin=(√17−3)/2.

It is attained by two explicitly given records below. In particular, the previously exhibited equal-weight records (√2,0,1,1) and (0,√2,1,i) have V=2; they demonstrate possibility but do not minimize the required fluctuations. The new conclusion concerns fourth moments not contained explicitly in the mean comparison matrix. Q=0, with IiS31's positive normalized reading, already supplies H=H* and hence this implication for any proposed scalar realization.

*Proof.* The two zero residuals force, in every positive-weight record,

    a₂=(a₀+a₁)/√2,      a₃=(a₀+ia₁)/√2.

Let t=(|a₀|²+|a₁|²)/2. At t>0 define

    x=Re(conjugate(a₀)a₁)/t,
    y=Im(conjugate(a₀)a₁)/t,
    z=(|a₀|²−|a₁|²)/(2t).

Scalarity gives x²+y²+z²=1. The four intensities are t(1+z), t(1−z), t(1+x), t(1−y). Therefore, with u=(x−y)/√2,

    F=Σᵢ Iᵢ²=t²[5+z²+2√2u],     −1≤u≤1.

Set s₊=√(5+2√2), s₋=√(5−2√2), α=(s₊+s₋)/2 and β=(s₊−s₋)/2. Concavity of the square root places it above the chord between u=−1 and u=1, so pointwise

    √F ≥ t√(5+2√2u) ≥ t(α+βu).

At t=0 every aᵢ is zero by the residual equations, and the inequality continues as zero≥zero. The mean Gram gives E t=1 and E(tu)=(Re H₀₁−Im H₀₁)/√2=0. Hence E√F≥α. Cauchy–Schwarz for the normalized weights gives E F≥(E√F)²≥α². Since all four mean intensities equal one,

    V=E F−4 ≥ α²−4=(√17−3)/2.

For attainment let ζ=(1−i)/√2, and for σ∈{+1,−1} put

    λσ=sσ/(2α),       tσ=α/sσ,
    a⁽σ⁾=√tσ (1, σζ, (1+σζ)/√2, (1+iσζ)/√2).

The weights sum to one and λσtσ=1/2. Thus the first two channels have mean squared amplitudes one and mean mutual comparison zero; the residual equations supply every other entry of H*. Each record has z=0, u=σ and √F=tσsσ=α, so both inequalities are equalities. This proves necessity and attainment over arbitrary finite record counts. The same expectation proof holds for general probability distributions with finite fourth moments; an infinite V cannot evade the lower bound. QED

The variables x,y,z are derived coordinates of the two scalar amplitudes, not an assumed physical sphere or a qubit interpretation. The normalization makes V a sum of relative intensity variances. If the original mean intensities Dᵢ are known and nonzero, normalize aᵢ by √Dᵢ first; the corresponding quantity is Σ Var(Iᵢ)/Dᵢ². The bound is tied to the particular acquired normalized Gram H*. It is neither a universal physical constant nor a statement that each individual channel must fluctuate by the same amount.

**A weaker finite-error bound works before full identification.** For any common scalar acquisition with E|aᵢ|²=1, let q=Q(H). Then

    V ≥ [(√2−1−√q)₊]²/(2+1/√2),

where t₊=max(t,0). To prove it, replace each aᵢ mathematically by a unit phase pᵢ in the same direction, choosing any phase when aᵢ=0. Its common phase Gram lies in P₄. The residual map

    T a=(a₂−(a₀+a₁)/√2, a₃−(a₀+ia₁)/√2)

has squared operator norm 2+1/√2. In the weighted record norm,

    √d ≤ ‖T p‖ ≤ √q+√(2+1/√2)‖a−p‖,
    ‖a−p‖²=Σ E[(|aᵢ|−1)²] ≤ V.

The last inequality uses (|aᵢ|²−1)²=(|aᵢ|−1)²(|aᵢ|+1)². Rearrange, using √d=√2−1. This is a valid but nonoptimal bound; at q=0 the preceding sharp result is stronger. An acquired upper bound q≤ε can replace q here. The phase replacement is a device in the proof, not a newly assumed available physical operation.

These are predictions conditional on a scalar-record explanation. Four fixed vector-valued profiles realize H* with constant norms and need not have this scalar intensity variance. Thus a simultaneous measurement below both the geometric and applicable variance bounds would reject the shared scalar-record account or another used contact assumption; it would not by itself identify a unique physical cause. No intensity records or new physical experiment were acquired here.

## Cross-page mentions

Labels mentioned here: <doc:interference_is_substitution__positive_channels#IiS15>, <doc:interference_is_substitution__global_obstructions#IiS21>.

Mentions of this page’s labels: <doc:interference_is_substitution__acquired_programs> (IiS32), <doc:interference_is_substitution__global_obstructions> (IiS29), <doc:interference_is_substitution__support_calibration> (IiS31), <doc:interference_is_substitution__support_memory> (IiS32).
