# Interference Is Substitution (Wave) — Support calibration

This part contains the original derivations for support calibration.

Family and original section headings: <doc:interference_is_substitution>.

Section setting: <doc:interference_is_substitution#16h-The-residual-witness-has-a-passive-implementation-and-an-acquired-calibration>.

## Detail: §16h. The residual witness has a passive implementation and an acquired calibration

### IiS33

**IiS33 (optimal passive scale, one extra mode, and four calibration preparations).** Use four coherent scalar input amplitudes a∈C⁴ and the residual map

    T = [ −1/√2  −1/√2   1  0 ],
        [ −1/√2  −i/√2   0  1 ]
    M=T†T,     Q(a)=‖Ta‖²=a†Ma.

For IiS31's convention Hᵢⱼ=E[conjugate(aᵢ)aⱼ], this gives E Q(a)=Q(H). The coefficients in each residual are a row acting on a; this convention matters for the imaginary coefficient.

The implementation class is a fixed, single-pass, lossless linear transformation on these four input modes and additional modes prepared with zero field. Two selected output intensities are added with equal unit weights. Other output modes are retained in the energy accounting. For every input a, demand

    J(a)=κQ(a),     κ>0.

Then the largest possible scale and the least number of additional input modes at that scale are

    κmax=1/Λ,     Λ=2+1/√2;       one additional mode.

This is a mode and scale optimum in the stated class, not an optimum over component counts, latency, nonlinear devices, repeated passes, or arbitrarily weighted detector readings.

**Construction and lower bounds.** Set λ=2−1/√2 and ζ=(1−i)/√2. Direct multiplication gives

    TT† = [ 2          (1−i)/2 ],
          [ (1+i)/2     2      ]
    u₊=(ζ,1)/√2,       u₋=(ζ,−1)/√2,
    TT†u₊=Λu₊,         TT†u₋=λu₋.

Define orthonormal input directions

    w₊=T†u₊/√Λ,       w₋=T†u₋/√λ.

A four-mode unitary first extracts b₊=w₊†a and b₋=w₋†a, and two orthonormal coordinates of ker T. An explicit kernel basis is

    k₀=(1/√2,0,1/2,1/2),
    k₁=(0,1/√2,1/2,i/2),
    g=⟨k₀,k₁⟩=(1+i)/4,
    k⊥=(k₁−gk₀)/√(7/8).

Thus rows w₊†, w₋†, k₀†, k⊥† give the required four-mode unitary. Put ρ=λ/Λ. Couple b₋ to the extra empty input e by the lossless mixer

    d₊=b₊,
    d₋=√ρ b₋+√(1−ρ)e,
    h =−√(1−ρ)b₋+√ρ e.

The two kernel coordinates pass unchanged. At e=0,

    J=|d₊|²+|d₋|²
     =|b₊|²+ρ|b₋|²=Q(a)/Λ.

If the two specified residual amplitudes themselves are required, apply the two-mode unitary with columns u₊,u₋ to (d₊,d₋). Its outputs are exactly Ta/√Λ, with the same summed intensity. That last mixer is unnecessary for the question J alone.

For necessity, the selected input-to-output block A of any allowed unitary is a contraction. The demand for all a gives A†A=κM. Since the nonzero eigenvalues of M are Λ and λ, κΛ≤1. With no additional input mode, A consists of two complete rows of a four-mode unitary, so AA†=I₂. Its two nonzero squared singular values are both one, whereas κΛ and κλ are unequal. No positive scale works without an extra mode in this equal-weight class. The displayed five-mode construction attains the bound. QED

There is an exact resource tradeoff: with unequal positive reading weights the four-mode transform alone suffices,

    Q=Λ|b₊|²+λ|b₋|².

The extra mode is needed to put the relative weight into a passive transformation followed by an unweighted sum. Its outgoing amplitude h is generally nonzero; the additional port is not returned empty. No reusable empty-memory or information-erasure claim follows.

**Four preparations certify the answer without identifying the device.** Let an otherwise unknown fixed linear passive device give J(a)=a†Ka, where 0≤K≤I. This includes the selected outputs of a larger unitary with genuinely empty extra inputs. Suppose the four normalized preparations above give

    J(k₀)=J(k⊥)=0,       J(w₊)=1,       J(w₋)=ρ.

Then necessarily K=M/Λ, so the readout is correct for every a∈C⁴. Indeed positivity makes both zero-read directions lie in ker K. Positivity of I−K and J(w₊)=1 give Kw₊=w₊. Hermiticity then leaves only the orthogonal direction w₋, whose eigenvalue is fixed by its acquired reading ρ. Conversely M/Λ has these four readings.

The saturation of passivity does real work. At a smaller scale, four diagonal readings alone need not certify the answer. If 0<κ<1/Λ, the two active eigenvalues κΛ and κλ are strictly between zero and one. Adding a sufficiently small nonzero off-diagonal Hermitian entry between w₊ and w₋ preserves positivity and passivity as well as all four diagonal readings, but changes other answers. For example choose its modulus squared below both κ²Λλ and (1−κΛ)(1−κλ). Further superposition probes would then be needed. No minimality over every possible calibration protocol is claimed.

**Four are necessary for pure-preparation identification in this class.** Suppose a protocol acquires exact scalar readings v†Kv on at most three known vectors, with no additional restriction on 0≤K≤I. Let S be their complex span. Since S is proper, consider its nonzero orthogonal complement. If K has a nonzero off-diagonal block between S and S⊥, conjugate K by a unitary which is identity on S and a nontrivial scalar phase on S⊥. The new positive contraction differs from K and preserves every acquired reading. If that block is zero, replace K's S⊥ block by any different positive contraction. This also preserves the readings. Thus every such transcript leaves an alternative. The same construction preserves a deterministic adaptive protocol's entire transcript, since each subsequent query sees the same earlier answers. The four displayed preparations attain this lower bound for K₀. This is exact identification from the acquired relations, not a claim about probabilistic tests with an allowed failure probability.

The pure-preparation restriction matters. If one admitted query can prepare the known equal mixture of k₀ and k⊥ and return its common averaged intensity, its zero reading forces both kernel readings to vanish. That mixed query and the two bright queries suffice. Preparing and joining the two mixture components is then part of that query's resource; their cost has not disappeared.

**The four tests also give a finite-error certificate.** Assume the true readings on those four preparations differ from their displayed targets by at most ν≥0, including the established measurement error. In the ordered basis (w₊,w₋;k₀,k⊥), write

    K = [ C  B  ],       K₀=M/Λ=diag(1,ρ,0,0).
        [ B† D ]

Then tr D≤2ν and ‖D‖≤2ν. From the positive principal block of I−K,

    |C₁₂|²≤(1−C₁₁)(1−C₂₂)≤ν(1−ρ+ν).

Therefore ‖C−diag(1,ρ)‖≤e, where e=ν+√[ν(1−ρ+ν)]. Positivity of K gives ‖B‖≤√(‖C‖‖D‖)≤√(2ν), using ‖C‖≤1. Since e≥2ν, the block diagonal and off-diagonal parts give

    ‖K−K₀‖ ≤ Δ(ν),
    Δ(ν)=min{1, ν+√[ν(1−ρ+ν)]+√(2ν)},
    |J(a)−Q(a)/Λ|≤Δ(ν)‖a‖²   for every a.

The cap one follows because both effects are positive contractions. This bound is sufficient, not an optimal robustness constant. It is derived from four actual readout constraints, rather than postulating closeness of all device coefficients. Unknown output phases and unobserved output coordinates need not be reconstructed.

The square-root order of a uniform all-input error is unavoidable for these four tests. Conjugate K₀ by a rotation through θ in the plane spanned by w₊ and k₀, leaving w₋ and k⊥ unchanged. This remains a positive contraction with the same spectrum. Its four diagonal errors are sin²θ,0,sin²θ,0 in the corresponding order, whereas ‖Kθ−K₀‖=|sin θ|. The two-dimensional difference has trace zero and determinant −sin²θ. Thus ν=sin²θ permits a √ν change in an input answer; no uniform O(ν) bound follows from these four inexact readings alone.

Linearity, passivity, the prepared directions, the intensity scale and one common device effect across the tests remain the admission conditions. Finite tests do not establish arbitrary nonlinear behavior or unrestricted future stability. With an unknown common detector gain, the scale can instead be supplied by a simultaneous total-power reference which is established to preserve ‖a‖²; calling two detectors identical is not that relation. Preparation errors need their own bound.

**Exactly which unknown unitary motion leaves the answer unchanged.** For a unitary R acting at the specified four-mode input boundary,

    Q(Ra)=Q(a) for all a
      iff R†MR=M
      iff RM=MR.

The three distinct eigenvalues Λ,λ,0 therefore give the complete stabilizer U(1)×U(1)×U(2): arbitrary separate phases on w₊ and w₋, and an arbitrary unitary transformation within ker T. Such motion can change from acquisition to acquisition without changing Q or total power on any of them. It need not preserve each residual amplitude, each input intensity, or the full comparison matrix. Independent phase changes of the original four channels generally do not commute with M. The input boundary matters: an invariant readout does not identify every internal stage with that input.

**A refusal survives unknown common amplitude changes and integration.** Broaden the phase-only family to records aᵢ=c xᵢ, |xᵢ|=1, with an arbitrary shared complex envelope c in each record. Put

    P=Σᵢ|aᵢ|²,       η=(3−2√2)/(4Λ).

IiS31's pointwise bound gives, including a zero-power record,

    Q(a)/Λ≥ηP,       J(a)≥max{0,η−Δ(ν)}P.

The ideal constant η is sharp by the attaining phase record in IiS31. Summing these inequalities with any common nonnegative weights preserves them. A positive unknown gain shared by J and P within each record can be absorbed into those weights. Thus arbitrary common amplitude changes need not be reconstructed to use this refusal. They can still change the numerical integrated ratio by reweighting different records; only the bound is guaranteed.

In the lossless five-mode construction with e=0, P is the sum of all five output intensities. The two witness outputs alone do not provide this total-power reading. If acquired integrated values Ĵ,P̂ have simultaneous absolute error bounds Bⱼ,Bₚ, a sufficient exclusion is

    P̂−Bₚ>0,
    (Ĵ+Bⱼ)/(P̂−Bₚ) < η−Δ(ν).

This rejects the equal-modulus scalar-record explanation under the given contact and error conditions. A nonpositive right side provides no such test. The integrated readings must retain their common weights; unrelated detector histories are not covered. Q=0 by itself also does not supply IiS31's separate unit-diagonal normalization needed to identify H*.

**The particular refusal tolerates more error than uniform reconstruction.** The preceding all-input deviation Δ is not required to be the only route to the equal-modulus question. Keep the same four tests and put

    χ(ν)=ν/ρ+√[ν(1−ρ+ν)/ρ],
    γ(ν)=√[(1−χ(ν))₊],
    F(ν)=[(γ(ν)√η−√(2ν))₊]².

Then every equal-modulus scalar record satisfies

    J(a)≥F(ν)P(a).

To prove it, split a=a_L+a_N into the active plane and ker T. For C₀=diag(1,ρ), the acquired diagonal and off-diagonal bounds give

    ‖C₀⁻¹ᐟ² C C₀⁻¹ᐟ²−I₂‖≤χ(ν),
    C≥γ(ν)² C₀,       D≤2ν I₂.

Write J(a)=‖K¹ᐟ²a‖². The reverse triangle inequality now gives

    √J(a) ≥ [γ(ν)√(a_L†C₀a_L)−√(2ν)‖a_N‖]₊
           ≥ [γ(ν)√η−√(2ν)]₊ ‖a‖.

Here a_L†C₀a_L=Q(a)/Λ≥η‖a‖², and ‖a_N‖≤‖a‖. The square root of K is a proof device; it is not an additional implemented operation or measured output phase. Squaring proves the claim. This bound is sufficient, not an exact worst-case optimization. It has F(0)=η and retains the common-weight integration and detector error reasoning above: F(ν) can replace η−Δ(ν) in the acquired ratio test. Taking the larger of the two valid lower bounds is also permitted.

A fully analytic finite-error example shows the difference. At 0≤ν≤1/1000, use ρ>2/5 and η>1/65. The latter follows from √2<17/12 and η=(3−2√2)/(8+2√2). Then

    χ(ν)<1/400+1/25<1/20,
    γ(ν)√η>√(19/1300)>3/25,
    √(2ν)<1/20,
    F(ν)>49/10000.

For the first inequality, the squared radical in χ is below 601/400000<1/625. All comparisons are rational after squaring positive sides. Thus this calibration accuracy still forces more than 0.49 percent of the total power into the witness outputs under the excluded family. The true integrated output ratio, or a certified upper bound on it, below 49/10000 suffices for refusal. At ν=1/1000 the earlier η−Δ bound is negative, since Δ≥√(2/1000)>η. This improves a sufficient experimental margin without adding probes or contradicting the square-root obstruction for arbitrary inputs. It does not certify the availability of this accuracy on hardware.

**A program of acceptance conditions has a separate reachability cost.** On one common fixed passive effect define the measured configuration loss

    L(K)=J(k₀)+J(k⊥)+[1−J(w₊)]+|J(w₋)−ρ|.

All terms are nonnegative. Hence L=0 iff K=K₀, and L≤ℓ supplies ν≤ℓ for the four-probe bounds. The program may therefore specify these preparations, target replies and tolerances without specifying a unique optical matrix. The same device must underlie the acquired four terms, or their transport to one device must be established. L is a readout loss, not an automatically descending physical energy or a proof that any feedback rule converges.

Its attainability already distinguishes two complete control families. For an arbitrary lossless four-mode unitary with two equally read outputs and no extra input, K is a rank-two orthogonal projection. Write a=J(w₊), b=J(w₋). Since tr K=2,

    L=3−2a−b+|b−ρ|≥1−ρ.

Use a≤1 and |b−ρ|≥b−ρ. Projection onto the span of w₊,w₋ attains equality. Thus the exact minimum over this whole four-mode family is 1−ρ>0: no improvement of its optimizer can meet L=0. The five-mode family with one empty input has minimum zero, attained by the explicit construction above. Extra unobserved loss channels would change the four-mode family rather than evade its proof.

This separates a sufficient acceptance specification from the contact resources that can reach it. Physical self-configuration through orthogonal training fields and local feedback is an established constructive direction; see [Miller, *Self-Configuring Universal Linear Optical Component*](https://arxiv.org/abs/1303.4602). That design's feedback mechanism is additional structure, not a convergence theorem for an arbitrary device equipped with L. A specific controller and its preparation and measurement costs remain to be realized here.

The upper power scale also cannot be manufactured from tested maxima. For example the passive block [[2/5,1/5],[1/5,2/5]] gives 2/5 on each of two orthonormal preparations, but 3/5 on their normalized sum. Dividing by the largest tested reading makes the two replies one while the unseen reply becomes 3/2. It has not established K≤I in the new units. The independent power scale used above is therefore substantive even when the program is expressed as replies.

**Physical scope.** Lossless coherent mode transformations and their beam-splitter/phase-shifter synthesis are an established setting; see [Clements et al., *An Optimal Design for Universal Multiport Interferometers*](https://arxiv.org/abs/1603.08788). The construction here specializes that setting to this witness, derives its restricted resource optimum, and connects it to acquired calibration and an error-tolerant refusal. It does not derive optical linearity from distinction alone. No device has been built, no detector noise model has been experimentally established, and no computational speed advantage is claimed. The scalar fields and summed intensities are a classical coherent-wave model, not individual noiseless photon outcomes. Optical losses or nonempty auxiliary inputs require their effect to be bounded before applying the same certificate.

## Detail: §16i. Compiling the refusal needs a smaller interface than compiling Q

### IiS34

**IiS34 (projection witness, minimal outputs and probes, finite local configuration).** Retain IiS33's residual map T, active plane S=range T† and null plane N=ker T. Write Π=Π_S. A full lossless four-mode unitary can send S to the two read outputs and N to the other two. Its summed read intensity is

    JΠ(a)=a†Πa=|⟨w₊,a⟩|²+|⟨w₋,a⟩|².

This is a different question from exact Q/Λ. It satisfies

    Π≥T†T/Λ,       JΠ(a)≥Q(a)/Λ.

Thus for the equal-modulus scalar family aᵢ=c xᵢ, |xᵢ|=1, the same positive lower bound η=(3−2√2)/(4Λ) holds for JΠ/P. Every input in N remains exactly dark. Four modes suffice without the extra input needed for the unequal coefficients of exact Q/Λ. This preserves a particular refusal and its null examples, not the numerical Q reading or every future question about the source.

**Projection is pointwise maximal among passive readings with this null plane.** If 0≤K≤I and J_K(n)=0 for every n∈N, positivity gives KN=0. Hermiticity leaves K supported on S, where K≤I_S. Hence K≤Π. The projection maximizes the read intensity for every input among all passive effects retaining these exact null examples. This also maximizes any worst-case margin over an excluded input family in that class. The inherited number η need not be the sharp margin of the projection for equal-modulus inputs; that stronger numerical optimization is not asserted. Larger responses to intended inputs outside N still need to be assessed rather than called an improvement.

**Two read modes are necessary for a strictly positive phase-family margin.** One linear scalar output gives a rank-at-most-one effect. If it is nonzero and dark on all N, its coefficient direction w belongs to S. Write w=T†(α,β), so

    w₀=−(α+β)/√2,      w₁=−(α−iβ)/√2,
    w₂=α,              w₃=β.

The first two magnitudes are at most (|α|+|β|)/√2. Conversely,

    α=−[(1+i)w₀+(1−i)w₁]/√2,
    β=−(1−i)(w₀−w₁)/√2,

so |α| and |β| are each at most |w₀|+|w₁|. Thus no one of the four magnitudes |wᵢ| exceeds the sum of the other three. Four planar vectors with lengths lᵢ=|wᵢ| can close: the attainable pair-sum length intervals [|l₀−l₁|,l₀+l₁] and [|l₂−l₃|,l₂+l₃] overlap under exactly those inequalities. Choose the two pair sums to have the same length and opposite directions. Therefore unit phases xᵢ can be chosen with w†x=0.

Every such one-output readout has an equal-modulus input which is also dark; it cannot give a uniform strictly positive separation. The rank-two projection does separate, so two scalar intensity modes are minimal in this single-pass class with all N retained as null. Extra empty input ports do not remove the rank-one obstruction. This is not a lower bound for every adaptive experiment or for a detector which already combines several orthogonal modes.

**Two pure null preparations identify the projection in the admitted class.** For a full four-mode unitary and two equally read outputs, the unknown K is a rank-two orthogonal projection. Acquiring

    J(k₀)=J(k⊥)=0

puts both orthonormal preparations in ker K. Its kernel dimension is exactly two, so ker K=N and K=Π. In this class one pure preparation cannot identify Π: for any probe v, choose unit r∈S∩v⊥ and n∈N∩v⊥. Both intersections are nonzero. A nontrivial rotation in span(r,n) fixes v, conjugates Π into a different rank-two projection, and preserves the acquired reading. Thus two pure scalar-reading queries are necessary and sufficient for this exact calibration. IiS33's four-query lower bound was for the larger class of all positive contractions.

The structural admission is substantive: under mere passivity K=0 passes both null tests. Losslessness of the complete four-mode transformation and the calibrated meaning of power are not proved by its two dark outputs. A known mixed preparation supported on N can also combine the two tests into one acquired average, with the mixture's preparation and common acquisition counted separately.

**Two inexact null probes bound both sides of the discrimination.** Let δ≥0 bound the sum of the two true null readings. For δ<1, write the rank-two projection K in S⊕N blocks C,B,D. Positivity, K≤I and tr K=2 give

    tr D≤δ,       0≤D≤δ I_N,
    tr(I_S−C)=tr D≤δ,       C≥(1−δ)I_S.

For a=s+n, define p=‖s‖²/‖a‖² when a≠0. Since K is a projection, √J=‖Ka‖. The reverse triangle inequality gives

    J(a)/P(a) ≥ [ (√((1−δ)p)−√(δ(1−p)))₊ ]².

The expression before clipping increases with p. Therefore, on the equal-modulus family,

    J/P ≥ B(η,δ),
    B(η,δ)=[(√((1−δ)η)−√(δ(1−η)))₊]².

It is positive exactly when δ<η. The geometric bound based only on p≥η and leakage at most δ is sharp. The exact phase-family minimum μ, derived below, is larger than η and sharpens this use of the bound. To attain the geometric bound when δ≤η, select unit s∈S,n∈N, take a=√η s+√(1−η)n, and rotate just that S,N pair so its measured direction is √(1−δ)s−√δ n. Retain the other S direction. The null leakage is δ and the displayed lower bound is equality. If δ≥η, a rotation with leakage η≤δ makes this a dark.

For every intended input a∈N the same calibration gives J/P≤δ. More generally if p≤ε, then

    J/P≤min{1,(√ε+√δ)²},

by the triangle inequality, ‖Ks‖≤‖s‖ and ‖Kn‖≤√δ‖n‖. This explicitly accounts for departures of an intended input from the null plane; the effect on such inputs is not inferred from the excluded-family bound alone.

If each null probe is at most ν=1/1000, take δ≤1/500. An analytic conservative margin is

    intended N:          J/P≤1/500,
    equal-modulus family: J/P>3/500.

Indeed η>1/65 gives √((1−δ)η)>123/1000, whereas √(δ(1−η))<9/200. The difference exceeds 39/500 and its square exceeds 3/500. These are rational comparisons after squaring. Consequently an additional certified absolute error at most 1/1000 in the final ratio still leaves the two classes on opposite sides of the threshold 1/250: measured ratios are at most 3/1000 for N and greater than 5/1000 for the equal-modulus family. This is a sufficient error budget, not a statement about available detectors. Inputs outside both classes are not automatically classified.

The bounds pass to commonly weighted nonnegative acquisitions, including an unknown positive gain shared by J and total power within each record. Error bounds and input preparation remain tied to those same acquisitions. The ratio's full-power reference must include the other two outputs or be independently established.

**The exact equal-modulus margin of this projection.** The preceding η bound follows from a different quadratic witness. For Π itself, the sharp answer over the entire equal-modulus family is

    μ = min_{|xᵢ|=1} ‖Πx‖²/4 = 1/2 − √(10+√2)/7 > 0.

Here is an analytic maximization of the complementary null-plane power; no phase grid or numerical search is needed. Write

    V = [ 1       0   ],       N=range V,
        [ 0       1   ]
        [ 1/√2    1/√2]
        [ 1/√2    i/√2]
    a₊=1+1/√2,  a₋=1−1/√2,
    Λ=1+a₊,     λ=1+a₋,     ζ=(1−i)/√2.

V†V has eigenvalues Λ,λ with eigenvectors (1,ζ),(1,−ζ). Consequently n₊=V(1,ζ)/√(2Λ) and n₋=V(1,−ζ)/√(2λ) are an orthonormal basis of N. Rephase all four coordinates by D=diag(1,conjugate(ζ),exp(iπ/8),exp(−iπ/8)). This preserves the set of unit-modulus inputs, and gives

    Dn₊=(1,1,√a₊,√a₊)/√(2Λ),
    Dn₋=(1,−1,i√a₋,−i√a₋)/√(2λ).

Parameterize the two pairs of coordinates of y=Dx by

    (y₀,y₁)=exp(iα)(exp(iβ),exp(−iβ)),
    (y₂,y₃)=exp(iγ)(exp(iε),exp(−iε)).

Set u=cos²β and v=cos²ε. Maximizing the relative phase α−γ in |⟨Dn₊,y⟩|²/4+|⟨Dn₋,y⟩|²/4 gives exactly

    f(u,v)=1/2+(h/2)(v−u)+√R,
    R=q uv+r(1−u)(1−v),
    h=2√2/7,  q=(10+√2)/49,  r=(10−√2)/49.

Every u,v in [0,1]² and its maximizing relative phase are available. On the open square R>0 and

    det Hess f = −(q+r)qr/(4R²) < 0.

Thus no interior point is a local maximum. To verify the derivative identity, use Rᵤ=(q+r)v−r, Rᵥ=(q+r)u−r and RᵤRᵥ−(q+r)R=−qr; the affine part of f has zero Hessian. On u=0 or v=0 the maximum is at (0,0), since √r>h. On u=1 or v=1 the maximum is at (1,1), since √q>h. These inequalities follow from h²=8/49<r<q. Since q>r, the full maximum is f(1,1)=1/2+√q. Subtracting it from one proves the displayed μ.

An attaining phase input is

    x*=(1, ζ, (1+ζ)/√(2a₊), (1+iζ)/√(2a₊)).

Equivalently x*=(1,exp(−iπ/4),exp(−iπ/8),exp(iπ/8)). Each coordinate has modulus one, Dx*=(1,1,1,1), and direct projection gives null power fraction (1+√a₊)²/(2Λ)=1/2+√q. For a simple rational enclosure μ>1/58: √2<17/12 and 137/12<(98/29)² imply √(10+√2)<98/29. The earlier η is less than 1/60, since that inequality reduces to √2>86/61, which follows by squaring. Thus μ>1/58>η. By the pointwise Loewner optimality above, μ is also the largest uniform equal-modulus margin among all passive effects retaining the whole of N as null. This is optimality under that null contract, not under every possible measurement or every possible excluded family.

**A sharp calibration boundary for this one scalar decision.** Replace η by μ in the two-probe estimate. For 0≤δ<1 the exact worst-case equal-modulus response, over all rank-two projections with total null leakage at most δ, is

    B(μ,δ)=[(√((1−δ)μ)−√(δ(1−μ)))₊]².

The lower bound was proved above. It is now attained by an actual member of the excluded family: write x*/2=√μ s+√(1−μ)n with unit s∈S and n∈N. For δ≤μ let K project onto √(1−δ)s−√δ n and a unit vector s₂∈S orthogonal to s. Its total null leakage is δ and its response on x*/2 is the displayed value. If δ≥μ, use the same construction with leakage μ; it makes x*/2 dark while meeting the stated upper bound.

The intended family N has response at most δ. Therefore a single uniform threshold separates the two families for all devices allowed by this aggregate certificate exactly when

    δ < δcrit = (1−√(1−μ))/2.

Indeed B(μ,δ)>δ is equivalent to this inequality; on the positive branch, take square roots and use μ=(1−√(1−μ))(1+√(1−μ)). At equality the attaining device gives the same response δ on the excluded input x*/2 and on the intended input n. For δcrit≤δ<μ its restriction to N has eigenvalues δ,0, so an intended input has response B(μ,δ) as well. For δ≥μ both families can have response zero in one admissible device. Thus beyond the boundary even an arbitrary decoder of this sole final power fraction cannot always distinguish the families. The obstruction can occur in the same device, not just in two differently calibrated devices.

This boundary uses the sum of the two calibration readings. A decoder retaining additional individual readings, preparations or subsequent contacts has a different information contract. If the final power fraction has certified absolute error at most e, the strict uniform-threshold condition becomes B(μ,δ)−δ>2e. That last statement is a worst-case bounded-error guarantee, not a statistical model of the detector.

**A finite controller under explicit local contacts.** Admit an arbitrary unknown fixed four-mode unitary U, repeatable orthonormal training inputs k₀,k⊥, intensity readings at the needed individual output modes, and available lossless two-mode controls acting on any of the five pairs listed below. Controls can be set, probed, and returned to their preceding setting. Their action, not their absolute optical phase, is known:

    G(c,s,φ) = [ c             exp(iφ)s ],
               [ −exp(−iφ)s  c        ],
    c,s≥0,      c²+s²=1.

For any unknown pair of scalar output amplitudes x,y, three probe settings acquire the needed local relation. In the identity setting read A=|x|² and B=|y|². In balanced settings c=s=1/√2 read the first-output powers P₀ and Pπ/2 at phases 0 and π/2. Then

    z=conjugate(x)y,
    Re z=P₀−(A+B)/2,
    Im z=(A+B)/2−Pπ/2.

When A,B>0, choose

    c=√[B/(A+B)],       s=√[A/(A+B)],
    exp(iφ)=−conjugate(z)/√(AB).

Scalar coherence gives |z|²=AB. Substitution yields c x+exp(iφ)s y=0, while the second output retains power A+B. If A=0, use the identity; if B=0<A, use c=0,s=1 with any φ. If both vanish, no operation is needed. The rule depends only on the acquired local intensities and their relative quadrature. Unknown common input phase on a repeated training launch cancels from them. An unaccounted gain change between the settings does not cancel.

Designate output modes 0,1 as the final read pair. Starting from the actual unknown U, use the nulling operation in this order:

    training k₀:  (0,3), (1,3), (2,3);
    training k⊥: (0,2), (1,2).

The first three operations put all of Uk₀ in output 3; previously zeroed coordinates are not touched again in that stage. Unitarity and orthogonality then force the transformed k⊥ to have zero component at output 3. The last two operations act only on modes 0,1,2, preserve the first training result and put k⊥ in output 2. Both training inputs now have zero power in the read pair, so the final effect is Π. This proves termination after at most five committed nulling rotations for every initial U under the stated ideal contacts.

The routing proof uses only orthonormality of the two training inputs. The same pair schedule and local rule therefore configure the projection onto the orthogonal complement of any supplied orthonormal pair in C⁴. Different training fields can specify different readouts without a different controller algorithm. A positive phase-family margin for each new null plane still needs its own proof; the specific margin and one-output obstruction above are not inferred from arbitrary orthogonality alone.

At most fifteen training probe settings determine those rotations; each identity setting acquires two intensities, and each balanced setting the indicated intensity. Setting, restoring and physically holding the controls is additional work. Two final null acquisitions then check the retained device. The two-query minimum for a fixed device's certificate is not the total cost of obtaining that device. Training uses repeatable prepared signals, not free copies of an unknown working input. Access to individual training-output powers is stronger than the final two-output sum and is counted as a controller resource. No minimality of the controller's count is claimed.

With control or measurement error, the five-step exact proof is not a guarantee of achieving any prescribed tolerance. The final two acquisitions instead give the δ certificate above for the device actually reached, provided it remains in the projection class. Unbounded drift during or after training requires a new relation; successful acquisition on a previous device does not transfer itself.

This is progressive configuration by local intensity contacts, within the established direction of [Miller's self-configuring optical components](https://arxiv.org/abs/1303.4602), specialized to a sufficient readout rather than a specified full unitary. No new physical apparatus or priority for optical self-configuration is claimed. The admitted local controls, preparations and classical feedback calculations remain part of the implementation. What has been supplied is a finite constructive route from the accepted relations to the target readout, with a separate certificate for the device's acquired tolerance.

**Four committed rotations suffice when the whole null plane is trained.** The five-step controller also fixes the individual training vectors' destinations, which the projection question does not require. With common acquisitions of the known uniform mixture on N, the same available two-mode contacts permit a shorter retained program.

On any triple of current output modes, acquire its 3×3 coherency matrix C from that mixed training input. One identity setting reads its three diagonal powers; balanced settings with phases 0 and π/2 on each of the three pairs read its off-diagonal entries. With Cᵢⱼ=⟨xᵢ conjugate(xⱼ)⟩, these readings are

    Re Cᵢⱼ=P₀−(Cᵢᵢ+Cⱼⱼ)/2,
    Im Cᵢⱼ=Pπ/2−(Cᵢᵢ+Cⱼⱼ)/2.

Each temporary setting is restored before the next acquisition. The mixture has two known orthogonal constituents and the current transformation is fixed and linear, so C is positive with rank at most two. Choose a normalized v∈ker C. The row v† gives zero average power, hence zero on both training constituents. For exact nulling, any positive training mixture with full support on N suffices; uniform weights are used below for the explicit tolerance and preparation-cost bounds, not to create the kernel. This kernel is constructively available from C: at rank two use a nonzero column of its adjugate; at rank one project a coordinate vector off a nonzero column's span; at rank zero choose any coordinate vector. Normalization and branch selection are part of the classical controller, not unmeasured properties of the source.

Any normalized three-component row (a,b,c), up to an irrelevant common phase, is the first row of two permitted G rotations. Take a≥0 by that common phase, put t=√(|a|²+|b|²), and first mix modes (first,second) with cosine a/t and complex sine b/t, then (first,third) with cosine t and complex sine c. The resulting row is (a,b,c). If t=0, take the first rotation as identity and swap into the third mode. Zero sine coefficients need no assigned phase.

Apply this construction first to modes (0,2,3), using committed pairs (0,2),(0,3). The whole trained plane now has zero component at output 0. Repeat on modes (1,2,3), using (1,2),(1,3). Output 0 is untouched and output 1 becomes zero on the whole plane. Unitarity then identifies the two-read-output effect as Π, without requiring k₀ and k⊥ to occupy individually named remaining outputs. This works for every initial U and for every supplied orthonormal training pair.

Four is also the minimum worst-case number of such committed contacts. The possible two-dimensional complex planes in C⁴ have an eight-real-dimensional open chart: the graphs of arbitrary complex 2×2 matrices near zero. A fixed word of at most three G contacts has at most six real continuous parameters. Its smooth image in the space of planes has no eight-dimensional open set. For example, covering a compact six-dimensional parameter region by O(ε^−6) small boxes and using the smooth map's Lipschitz bound gives total eight-dimensional covering volume O(ε²), which tends to zero. There are only finitely many pair choices for words of length at most three, so their union cannot cover the chart. Inverses are also permitted G contacts. Thus some initial planes cannot be returned by three contacts even if completely known. Adaptive acquisition does not enlarge this set of retained words. This proves the lower bound, matched by the construction.

The exact resource statement is four committed two-mode rotations, with no free extra phase screens, multi-mode controls or irreversible resets. A probe rotation that is not restored belongs to the retained word and must be counted. Acquisition is a separate cost: the construction above uses at most fourteen mixed probe settings, seven per triple, followed by final calibration. Realizing every mixture by two separate pure launches uses up to twenty-eight launches before final checks. Therefore fewer committed contacts does not establish lower total acquisition time or energy than the five-rotation pure-training controller. At finite errors, the retained device must still meet an acquired tolerance; the ideal kernel branches alone do not establish noisy-controller convergence.

There is nevertheless a finite robust guarantee when errors are bounded in the acquired relations. Write r=dim N (r=2 here; the same notation applies to the extension below). At stage i let Cᵢ be the true local coherency matrix and let its Hermitian estimate C̃ᵢ satisfy ‖C̃ᵢ−Cᵢ‖≤eᵢ. Choose a normalized vᵢ whose estimated Rayleigh quotient is at most λmin(C̃ᵢ)+tᵢ, where tᵢ≥0 is a certified solver tolerance. Since λmin(Cᵢ)=0,

    vᵢ†Cᵢvᵢ≤2eᵢ+tᵢ.

This follows directly from the two Rayleigh-quotient error bounds; it does not require a nonzero spectral gap or a stable kernel vector. If the actual implemented normalized row differs, up to a common phase, from vᵢ† by norm at most kᵢ, then its mixed training power is at most

    pᵢ≤(√(2eᵢ+tᵢ)+kᵢ/√r)².

Here the uniform rank-r training mixture gives Cᵢ≤I/r. Assume the implemented rotations remain unitary and confined to their admitted mode pairs. Later stages leave already processed read modes untouched, so their contributions accumulate without reintroducing that power. The final total null leakage obeys

    δ≤r Σᵢ (√(2eᵢ+tᵢ)+kᵢ/√r)².

For the four-mode case with exact row synthesis and solver, δ≤4(e₀+e₁). If every acquired diagonal and balanced power has absolute error at most ν, the explicit reconstruction gives diagonal errors at most ν and off-diagonal errors at most 2√2ν. The maximum absolute row sum therefore yields eᵢ≤(1+4√2)ν, and consequently

    δ≤8(1+4√2)ν.

Together with B(μ,δ) this is a finite conditional accuracy guarantee for the four-rotation controller, beyond a check after an unspecified search. The small-matrix solver, repeated preparations, power error bounds and pair-local unitary control errors are substantive resources. Unbounded drift or leakage into other mode pairs is not covered by kᵢ. Independent final admission can verify the reached device and can be sharper than this worst-case propagation bound.

The construction and lower bound extend to a proper r-dimensional trained null subspace in Cᵈ. Let m=d−r outputs be read, leaving r fixed unread modes. For each read mode, acquire the coherency matrix on that mode together with the r unread modes from the uniform null-subspace mixture. It has rank at most r. A kernel row of length r+1 can be implemented by r successive G rotations between that read mode and the unread modes, zeroing the whole trained subspace there. Explicitly, for a normalized row (a₀,…,a_r) with a₀≥0, set t_j=√(Σ_{l=0}^j |a_l|²). At step j use cosine t_{j−1}/t_j and complex sine a_j/t_j when t_j>0; if t_j=0 use identity. Induction gives the normalized prefix row, and t_r=1 gives the required final row. Subsequent stages never touch earlier read modes. The resulting exact retained count is

    r(d−r).

The complex Grassmann chart has 2r(d−r) real dimensions, so the preceding dimension argument forbids a smaller universal count of these two-parameter contacts. This is an exact worst-case control count, under availability of the required pairs and without free extra controls. Direct pairwise coherency acquisition as above uses at most (d−r)[1+r(r+1)] mixed probe settings. If a mixture is implemented by r pure launches, that cost is multiplied by r. The program can therefore minimize retained rotations while being far from optimal in total acquisition resources. Neither this Grassmann-space bound nor the controller asserts a new physical law or priority for subspace elimination by plane rotations.

## Detail: §16j. A power certificate and a coherent continuation

### IiS35

**IiS35 (The downstream question determines whether a local power certificate composes).** Let A:X→Cᵐ be a finite linear amplitude map with K=A†A≠0. Suppose acquisition identifies K, while the output coordinate frame of A remains unspecified. A subsequent passive reading has a known effect 0≤E≤I on Cᵐ. The complete reading on x is

    J_E(x)=x†A†EAx.

Every UA with U unitary has the same local power effect K. Conversely, every other map A′ into the same Cᵐ with A′†A′=K has this form: Ax↦A′x is a well-defined isometry of the two image spaces and extends to a unitary of Cᵐ.

For a fixed x with q=x†Kx, the possible composite readings over this entire compatible family form exactly the interval

    [λmin(E)q, λmax(E)q].

For q=0 the interval is {0}. Otherwise UAx runs through the sphere of squared norm q. Rayleigh quotients reach both eigenvalue extremes and every intermediate value, by superposing orthogonal extremal eigenvectors with the required nonnegative squared weights. Consequently K determines this downstream reading for every input and every freely compatible output frame if and only if E is scalar. The excluded K=0 case determines zero for every E.

If only a smaller family G of output changes is admitted, the exact criterion is instead

    A†(U†EU−E)A=0       for every U∈G.

When the image Y₀=range A is invariant under G and A maps onto Y₀, this is equivalently invariance of E compressed to Y₀ under the restricted group action. A commutant criterion without those range conditions would be stronger than the pullback condition. This is an instance of VI's continuation-scoped sufficiency, already present in IiS7, IiS10 and VC35, here with the complete compatible answer interval for a power-calibrated physical module.

**The projection controller supplies a concrete full-range failure.** Keep its two working output amplitudes available to a subsequent linear optical element. During calibration they may be measured on repeatable training launches; this is not a proposal to recover coherence after destructive detection of the working signal. Put

    A₀=[w₊†; w₋†],      A₁=X A₀,
    X=[0 1; 1 0],       E=[1 0; 0 0].

Both A₀†A₀ and A₁†A₁ equal Π. Both pass every local test of their total two-output power, including the two null preparations. For the same input w₊ the continued readings are respectively one and zero. The new question concerns a selected coherent output direction, which the former sum-of-powers certificate left undetermined. There is no error in that former certificate.

**One joint bright preparation certifies the needed branch.** In this two-output class A†A=Π implies AA†=I₂. Let the subsequent analyzer read E=ee† for a normalized output direction e. Then

    A†EA=zz†,       z=A†e∈S,       ‖z‖=1.

For a desired unit w∈S, one acquired composite reading J_E(w)=1 forces |z†w|=1 and hence zz†=ww†. This proves the complete continued reading |w†x|² for every input x, without identifying A or its other output direction. Zero additional readings cannot suffice in general, by the A₀,A₁ example. Thus one joint scalar reading is necessary and sufficient after the local effect has been identified, within this admitted analyzer class.

There is also a local route to obtain the bright condition. Apply the IiS34 two-mode acquisition and rotation to the normalized field Aw, routing it to e (with a known final relabeling if needed). This uses at most three probe settings for that two-mode contact, then one joint verification at the retained setting. No inference from the number of verification queries to the total training cost is made. For an inexact joint reading at least 1−ε, the two rank-one effects obey

    ‖zz†−ww†‖=√(1−|z†w|²)≤√ε.

The equality follows from the two eigenvalues in span(z,w). It bounds the normalized response error on every input, conditional on the earlier exact projection-class admission.

For a final single coherent scalar output there is an even shorter whole-device certificate. Any passive linear cascade ending in that output has an effect zz† with ‖z‖≤1, regardless of its internal factorization. A unit input w giving output power one forces zz†=ww† directly. No separate calibration of its internal stages is required for that one final question. A reading at least 1−ε still implies ‖zz†−ww†‖≤√ε: writing t=‖z‖² and r=|z†w|², the norm is

    [1−t+√((1+t)²−4r)]/2,

which is nondecreasing with t on r≤t≤1 and is at most √(1−r). The normalized-input and calibrated passivity conditions matter. An unresolved sum over several scalar modes is not a rank-one effect on the basis of its appearance on one detector alone. This narrower one-direction question does not replace IiS34's two-mode readout, which separates a whole equal-modulus family and has a one-mode obstruction.

A coordinated change A↦UA, E↦UEU† leaves A†EA unchanged. Thus preserving the joint reading can allow both parts to change. An independent change of A with E held fixed need not do so. The relation between the changes must be established by the actual contact or by renewed joint acquisition; writing a conjugation formula does not make that acquisition free.

## Detail: §16k. Replacing device admission by acquired support relations

### IiS36

**IiS36 (Two mixed preparations identify a projection among all passive effects, with dimension-dependent tolerance).** Let N and S be orthogonal complementary subspaces of dimensions d_N,d_S>0. The input space and their preparations are admitted; the unknown device is only required to have a positive contraction K on that space. Unlike IiS34's two pure null tests, no rank or complete lossless implementation is assumed. Supply the known mixed inputs

    σ_N=Π_N/d_N,       σ_S=Π_S/d_S.

They mean actual commonly weighted preparations with a calibrated normalized power reading, not labels attached to unrelated records. The two acquired numbers

    j_N=tr(Kσ_N)=0,       j_S=tr(Kσ_S)=1

force K=Π_S. Positivity makes a zero quadratic expectation a kernel relation: K annihilates N. Applying the same argument to I−K and σ_S makes K the identity on S. This proves the claim on the whole input space. Losses and extra unread ports are allowed by the positive-contraction class; the bright condition tests the needed transmission instead of inferring it from a dark output.

Two such scalar expectation queries are minimal when arbitrary known density matrices may be prepared. For any single preparation σ, put p=tr(σΠ_S). The different contraction pI gives the same answer. This includes p=0 and p=1, since Π_S is nontrivial. The count is of mixed expectation queries. Preparing a uniform mixture over d_N or d_S independent directions, or estimating it from separate pure launches, is a real resource and is not counted as one elementary event by this statement.

If a further admission tr K≤d_S is established, one bright mixed query j_S=1 suffices. It fixes K=I on S, already using the entire trace budget; positivity leaves no response on N. For a passive map into d_S scalar output modes the budget follows from AA†≤I_{d_S}. Common nonnegative averages of such effects preserve the budget even when their average has a larger rank. The count concerns scalar coherent modes in the admitted model, not the number of detector packages. This admission is weaker than complete losslessness or a fixed projection rank.

With j_S≥1−ν and δ=d_Sν<1, the same argument gives tr D≤δ and C≥(1−δ)I_S, writing K in S⊕N blocks C,B,D. Thus IiS34's B(μ,δ) bound, intended upper bound δ and their sharpness all apply in the four-mode case. Equivalently, two orthonormal pure bright probes with summed deficit at most δ supply that average. A dark probe and a bright probe do different work under a trace budget: the bright one can acquire the useful transmission instead of assuming the complete device is lossless.

For bounded errors j_N≤ν_N and 1−j_S≤ν_S, write K in S⊕N blocks C,B,D. With

    a=min{1,d_Nν_N},       b=min{1,d_Sν_S},

the trace bounds give D≤a I_N and C≥(1−b)I_S. Hence for an input with active power fraction p=‖Π_Sx‖²/‖x‖²,

    J(x)/P(x)≥[(√((1−b)p)−√(a(1−p)))₊]²,
    x∈N implies J(x)/P(x)≤a.

Use the reverse triangle inequality on K^(1/2)x for the lower bound. For IiS34's excluded family one can substitute p≥μ; the expression is increasing in p. These are sufficient tolerance bounds in the larger passive class. In the matched case a=b=δ, they give precisely B(μ,δ) and the intended upper bound δ. The rotated projections constructed in IiS34 belong to this larger class and attain both the lower bound and its indistinguishability witnesses. Thus δcrit is sharp here too under the two matched trace bounds. This transfer has a new proof and an additional bright acquisition; it is not inferred from the two dark readings.

The uniform mixture is minimax for converting this kind of scalar error to a worst-direction guarantee. For any full-support density matrix σ on a d-dimensional subspace, tr(Dσ)≤ν implies D≤(ν/λmin(σ))I. A rank-one D on a least-weight eigenvector attains that conversion, up to the contraction cap. Since λmin(σ)≤1/d, no choice improves the worst coefficient d; σ=I/d attains it. If σ has deficient support, one direction is completely untested. Thus the exact number of mixed query types can remain two while the necessary accuracy and preparation support scale with dimension. Two displayed averages are not a dimension-independent certificate at a fixed error tolerance.

**Uniform attenuation changes the exact acquisition minimum.** Fix a proper rank-r projection Π_S and a target K₀=γΠ_S with 0<γ<1. In the class of all positive contractions, exactly r²+1 scalar expectation queries with freely chosen known mixed inputs are necessary and sufficient to identify this target effect. The lower bound holds even if γ is supplied and queries are chosen deterministically from earlier answers.

For sufficiency use one full-support mixed input on N to acquire zero, forcing K to annihilate N. On S choose r² normalized pure preparations whose projectors span the real vector space Herm(S). For an orthonormal basis eᵢ, one explicit choice is eᵢ and, for each i<j, (eᵢ+eⱼ)/√2 and (eᵢ+i eⱼ)/√2. Acquiring γ on every one fixes all diagonal entries to γ and all off-diagonal entries to zero. It also acquires γ if that scale was initially unknown.

For necessity, fix the transcript produced by K₀ for at most r² queries σ₁,…,σ_m, and restrict their linear measurement map to Herm(S). If this restriction has a kernel, take a nonzero Hermitian Δ in it. For sufficiently small nonzero ε, K₀+εΔ is another positive contraction with exactly the same answers; γI_S is strictly inside the positive-contraction interval on S. If instead the restriction is injective, then m=r² and it is an isomorphism onto R^m. Choose Δ∈Herm(S) solving

    tr(σⱼΔ)=−tr(σⱼΠ_N)      for all j.

For sufficiently small ε>0,

    K′=γΠ_S+εΔ+εΠ_N

is again a positive contraction with the same transcript. Its null block is now εI_N, so it differs from the target. Adaptive choices do not avoid the witnesses: retaining all answers along the target transcript retains the same later choices. This proves necessity.

In the four-mode rank-two case the exact minimum is therefore five, whereas the unattenuated projection needs only two mixed queries. The discontinuity is in exact identification: saturation of the known upper bound supplies relations that an interior transmission γ does not. At nonzero tolerances the earlier direct question bounds can still be useful; five is not a lower bound for every sufficient family-separation task. Normalizing one bright reading to itself cannot establish isotropic transmission on all of S. The same r²+1 count and face-based mechanism already appear for identifying a fixed rank-r state by POVM outcomes in [Carmeli, Heinosaari, Schultz and Toigo, §5.2](https://arxiv.org/pdf/1611.04388). Their normalized-state/outcome contract and this unknown-effect/ positive-probe contract are different; the explicit proof above establishes the latter and its contrast with γ=1. POVM outcome probabilities also satisfy a normalization relation, so their count is not interchangeable with independent scalar probe queries. The broader role of positivity is also studied by [Kalev, Kosut and Deutsch](https://www.nature.com/articles/npjqi201518). This is a scoped application and comparison, not a claim of priority for the r²+1 count or for the geometry of certification.

**A surviving-power denominator changes the acquired relation.** The preceding admission uses power relative to the input norm, or an independently established equivalent reference. Suppose instead that only a selected fraction of the surviving output power is read:

    j_G(x)=x†Kx/(x†Gx),       0≤K≤G≤I.

Here G describes all retained output power, including the unread part. For mixed preparations the corresponding ratio is tr(Kσ)/tr(Gσ); it is the ratio of the acquired powers, not an unweighted average of per-launch ratios. Assume both training denominators are positive. The same extreme ratios on σ_N and σ_S then force exactly

    K=G_S⊕0_N,       G=G_S⊕G_N,

where the first block refers to S. Zero on N annihilates N for K; one on S annihilates S for the positive operator G−K. Their cross blocks therefore vanish. These relations do not force G_S to be a scalar, or even invertible.

There is an exact failure with perfect ratios. Write the normalized excluded input x*/2=√μ s+√(1−μ)n as above, and choose a unit s₂∈S orthogonal to s. Set

    K=γ s₂s₂†,       G=K+Π_N,       0<γ≤1.

Both training ratios are respectively zero and one, with nonzero denominators. Yet j_G(x*)=0, the same as for intended inputs in N. This construction is passive. It can be implemented by transmitting s₂ and N to the retained ports and losing the active direction s. It is not an additive-noise or rounding effect. For γ=1 even the complete four-mode device can be lossless: route s into an output omitted from G and route s₂,N into the three retained outputs. The missing power is then entirely present elsewhere in the same device. Conservation of the complete field does not make the truncated denominator a full-power reference.

Even insisting on G_S=γI_S, G_N=I_N with γ>0 gives only j_G(x*)=γμ/(γμ+1−μ), which approaches zero as γ decreases. Thus an unknown uniform attenuation of just the working subspace also removes a uniform nonzero error margin from these ratios.

A sufficient additional relation is G_S≥ℓI_S and G_N≤uI_N with ℓ>0,u≥0. Without reconstructing either full block it gives

    j_G(x)≥ℓμ/[ℓμ+u(1−μ)]

on the excluded family, and zero on N whenever its denominator is nonzero. A common unknown positive scale multiplying both bounds cancels; their relative strength does not. Thus rejecting an absolute gain standard is compatible with a precise relational guarantee, but rejecting every relation between the two subspaces' transmissions is not. This is a different denominator contract from the earlier input-power calibration.

**A local control floor can be acquired before further optimization.** IiS34's exact nulling step assumes a scalar coherent pair throughout the three probe settings. More generally let A=⟨|x|²⟩, B=⟨|y|²⟩ and z=⟨conjugate(x)y⟩ refer to one common nonnegative acquisition. The same three settings acquire these relations, with |z|²≤AB. Under an available two-mode rotation with c=cos θ,s=sin θ, first minimize its phase. The output is

    I(θ)=A cos²θ+B sin²θ−2|z|sin θ cos θ.

If the full interval 0≤θ≤π/2 and all relative phases are available, the exact minimum is

    Imin=(A+B−√((A−B)²+4|z|²))/2.

This follows by minimizing the sine and cosine of 2θ, or by diagonalizing the positive 2×2 acquisition matrix. Zero is reachable exactly when AB=|z|², including a zero component. When the determinant is positive, more accurate search through these same controls cannot produce zero: the obstruction is in the common preparation, not in the search algorithm.

If the available mixing angles instead form [θlo,θhi]⊆[0,π/2] while relative phase remains fully available, the optimal angle is the projection of

    θ*=(1/2)atan2(2|z|,B−A)

onto that interval. When A=B and z=0 every angle is optimal. For a nonzero coherent pair, θ*=atan2(√A,√B), and the exact constrained minimum simplifies to

    (A+B) sin² dist(θ*,[θlo,θhi]).

This separates a preparation obstruction from a restricted-control obstruction using acquired relations. It does not assume that a real device has a freely available relative phase or the full ideal angle interval. Imperfect Mach–Zehnder elements have forbidden splitting-ratio regions in the explicit model of [Hamerly, Bandyopadhyay and Englund](https://www.nature.com/articles/s41467-022-34308-3). Their analysis is external evidence that this control admission cannot be replaced by the word “tunable.” The formulas here are direct consequences of the specified local contact and acquisition.

## Cross-page mentions

Labels mentioned here: <doc:interference_is_substitution__models_calibration#IiS10>, <doc:interference_is_substitution__comparison_fluctuations#IiS31>, <doc:interference_is_substitution__models_calibration#IiS7>, <doc:verdict_is_invariant__discovery_acquisition#VC35>.

Mentions of this page’s labels: <doc:interference_is_substitution__acquired_programs> (IiS34), <doc:interference_is_substitution__acquired_programs> (IiS35), <doc:interference_is_substitution__acquired_programs> (IiS36), <doc:interference_is_substitution__support_memory> (IiS34), <doc:interference_is_substitution__support_memory> (IiS36).
