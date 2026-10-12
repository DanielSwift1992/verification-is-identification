# Interference Is Substitution (Wave) — Support memory

This part contains the original derivations for support memory.

Family and original section headings: <doc:interference_is_substitution>.

Section setting: <doc:interference_is_substitution#16o-A-finite-reading-of-whether-classical-environmental-correction-can-suffice>.

## Detail: §16o. A finite reading of whether classical environmental correction can suffice

### IiS40

**IiS40 (A robust witness against mixtures of unitary channels).** Use a declared four-dimensional trace-preserving quantum channel Φ, with the same channel applying to the compared preparations. Let

    s=(1,1,1,1)ᵀ/2,
    b_j=⟨j|Φ(|j⟩⟨j|)|j⟩,
    ε=Σ_{j=0}^3(1−b_j),
    q=tr(Π Φ(|s⟩⟨s|)).

Here Π and its exact phase-family margin μ are those of IiS34. Every mixture of unitary channels, with arbitrary unitaries rather than only diagonal phase actions, satisfies

    q≥[(√μ−√(2ε))_+]².                         (40a)

Thus upper acquired bounds q≤q_U, ε≤ε_U certify that Φ is not a mixture of unitaries whenever

    q_U < [(√μ−√(2ε_U))_+]².

This is a sufficient witness from four basis-return preparations and one coherent preparation with a Π reading. It is not full channel tomography, nor a claim that five is a minimum acquisition count. No exact Schur or basis-preserving form is assumed in (40a).

*Proof.* First consider one four-by-four unitary U. Choose a diagonal unitary D whose diagonal phases agree with the nonzero diagonal entries of U; choose any phase at a zero entry. Put ε_U=Σ_j(1−|U_jj|²). Then

    ‖U−D‖_F² = 2Σ_j(1−|U_jj|) ≤ 2ε_U.

Since Ds is an equal-modulus phase input, ‖ΠDs‖≥√μ. For a mixture Φ=Σ_a p_a U_a(·)U_a†, use the Hilbert-space norm that is the square root of the weighted sum of squared vector norms. The triangle inequality, contraction by Π and the displayed bound give

    √q ≥ (√[Σ_a p_a‖ΠD_a s‖²]
                −√[Σ_a p_a‖(U_a−D_a)s‖²])_+
        ≥ (√μ−√[2Σ_a p_a ε_{U_a}])_+.

The last weighted sum is exactly the acquired ε. Squaring proves (40a). The same proof holds for an admitted probability distribution of unitaries. ∎

For every t>0 a simpler linear consequence is

    q+(2/t)ε ≥ μ/(1+t).

Indeed √q+√(2ε)≥√μ, and weighted Cauchy-Schwarz gives (√q+√(2ε))²≤(1+t)q+2(1+1/t)ε. At t=1 the condition q_U+2ε_U<μ/2 is a convenient, more conservative certificate.

**An admitted sufficient reading can replace the exact Π.** More generally suppose the actual effect K satisfies 0≤K≤I and an acquired uniform phase-family floor

    ⟨Ds|K|Ds⟩≥ℓ  for every diagonal unitary D.

For q_K=tr(K Φ(ss†)), the same proof with K^(1/2) in place of Π gives q_K≥[(√ℓ−√(2ε))_+]² for every random-unitary channel. Full identification of K as Π is unnecessary. In particular IiS34's admitted controller has ℓ=B(μ,δ) and response at most δ on N. Applied to the example below, whose ε is zero and whose output is supported on N, it still violates the channel inequality whenever B(μ,δ)>δ, precisely the already established δ<δcrit region. The physical reading's old sufficient admission therefore transfers directly to this new question; one need not first pay the more conservative error of reconstructing its full operator. General passive two-sided bounds from IiS36 can supply their corresponding ℓ and intended upper response instead.

The channel's five preparation/reading combinations do not include the separate work required to admit K, the basis preparations and their detectors. The compared statistics must retain those actual links; an ideal effect named Π in a calculation does not calibrate an unexamined physical analyzer.

Only the sum of basis-return deficits is used. It can also be acquired by uniformly preparing a classical label j, sending |j⟩ and checking whether the output label equals that same j. If the return probability of this joined protocol is b̄, then ε=4(1−b̄). The label remains part of the acquisition. Discarding it first leaves the unlabelled state I/4, whose unchanged output under every mixture of unitaries does not determine b̄. This is one joint protocol with four preparation branches, not a replacement by one unlabelled mixed-state expectation.

**The existing matrix supplies an explicit violating channel.** Let V₀ have the rows used in IiS39 and set C_*=V₀V₀†. The map

    Φ_*(ρ)=C_* ∘ ρ

uses entrywise multiplication. It has diagonal Kraus operators

    A₀=diag(1,0,1/√2,1/√2),
    A₁=diag(0,1,1/√2,i/√2),

with A₀†A₀+A₁†A₁=I. It is therefore a completely positive trace-preserving channel. Every basis state is preserved, so ε=0. The coherent input gives Φ_*(ss†)=C_*/4=ρ_*, supported on N, so q=0. This violates (40a) by the nonzero margin μ.

The same correlation matrix, in the transposed Heisenberg convention, already appears in [Buscemi, Chiribella and D'Ariano, Eq. (9)](https://arxiv.org/pdf/quant-ph/0504195). Their work establishes the decoherence/correction setting and the four-dimensional counterexample. This is not a new channel or a new discovery of the failure of classical environmental correction. The present calculation supplies the displayed finite witness and its population-error tolerance using the already constructed Π. No claim of priority for this witness is made without a dedicated literature comparison.

**What the witness says about recovery.** In the standard scheme, one measures the entire output environment of an initially pure environmental dilation, transmits its classical outcome to the system and applies an outcome-dependent trace-preserving recovery on the system. Exact deterministic recovery of every unknown input on the full four-dimensional space is possible only for a channel that is a mixture of unitaries. This is [Gregoratti and Werner's Proposition 2 and its equal-dimension consequence](https://arxiv.org/pdf/quant-ph/0209025). A violating acquired pair (q_U,ε_U) therefore excludes every correction scheme of that form, without reconstructing the full channel or searching through all environmental measurements.

**Every chosen three-path code can be correctable although the four-path space is not.** For Φ_*, restrict the unknown input in advance to any selected three of the four basis paths. Their three environmental qubit Bloch vectors lie in an affine plane, so choose a unit normal n with n·r_j=c constant on those selected paths. Measuring the environment along n then has probabilities

    p_±=(1±c)/2

independent of the unknown path label within this code. Each conditional diagonal Kraus operator therefore has equal entry moduli √p_± on the code. For a nonzero branch it is a scalar times a diagonal unitary, and the corresponding phase correction restores every superposition in the selected three-path space. Zero-probability branches are irrelevant. The choice of code and its correction interface must be fixed for that use.

For all four paths, the Bloch vectors are (0,0,1), (0,0,−1), (1,0,0), (0,1,0), which are not coplanar. The already proved random-unitary exclusion rules out every general environmental measurement and conditional trace-preserving recovery on the whole four-dimensional input, beyond measurements along one axis. Thus separately available corrections for every proper three-path code do not supply one correction for an arbitrary four-path input. This is the known qubit/qutrit versus four-level boundary of the cited decoherence work, now expressed by the same environmental profiles as the optical witness; no new priority is claimed for that boundary.

The complete state can nevertheless be recoverable through coherent joint access. One explicit dilation of Φ_* is

    |j⟩|0⟩_E ↦ |j⟩|v_j⟩_E,

where v_j are the two-component rows of V₀ read as environmental kets. The map is an isometry and extends to a unitary on the joint system. Its inverse restores the input when that joint coherent operation is available. All the diagonal classical labels already survive Φ_* unchanged. The obstruction concerns simultaneous recovery of arbitrary superpositions by the specified classical environment-to-system interface. It does not assert loss of the global state, impossibility of probabilistic filtering, failure on every smaller code or impossibility under unrestricted joint access.

**The exclusion is separated from the whole random-unitary set.** As a further conservative consequence, use the convention

    h=(1/2)‖Φ_*−Ψ‖_diamond

for any random-unitary channel Ψ. Each output event probability differs by at most h, so Ψ has q≤h and ε≤4h. Substitution in (40a) gives

    h ≥ μ/(1+2√2)² = μ/(9+4√2).

For h<μ/8 take square roots and rearrange √h≥√μ−√(8h); for h≥μ/8 the stated smaller lower bound already holds. This is not asserted to be the exact distance or a formula for the optimum approximate recovery fidelity. It does show that the obstruction is not only a distinction at one exactly specified matrix.

**A randomized witness can tolerate changing channels.** Separate blocks of the five preparations cannot by themselves establish a common channel. A setting-aware source can apply I on every basis probe and a unitary R with Rs∈N on every coherent probe. It then gives ε=q=0 although each applied transformation is unitary. Randomly permuting those acquired records afterwards cannot repair the missing relation between preparation and applied transformation.

There is a positive extension that does not require one stationary channel. In round k, conditional on the admitted preceding history, let Φ_k be a trace-preserving random-unitary map on a fresh input. It may depend arbitrarily on that history. The current preparation choice is sampled independently of this conditional map and is not an additional control input to it. The actual quantum state remains its input; independence does not mean the device is unable to respond to that state. K is one admitted effect with phase-family floor ℓ.

Fix t>0 before acquisition. Choose the coherent preparation s with probability t/(t+8), and each basis preparation |j⟩ with probability 2/(t+8). Give each round a binary flag X_k:

- on the coherent branch, X_k=1 when the K event occurs;
- on basis branch j, X_k=1 when the output fails its j-return test.

All admitted trials are counted. Under the conditional random-unitary hypothesis, the linear form of (40a) gives

    Pr(X_k=1 | preceding history)
      =[t q_k+2ε_k]/(t+8)
      ≥ p₀(t):=ℓ t/[(1+t)(t+8)].                 (40b)

No temporal stationarity or independence of the output flags was used. The common relation is between the five possible preparations and the conditional map in this round. A classical preparation tag that controls Φ_k destroys this premise, as the example above shows. Trusted randomization is an experimental relation, not a conclusion from the acquired frequencies or the absence of a declared wire.

The greatest guaranteed floor in this family is obtained at t=√8=2√2:

    p₀=ℓ/(9+4√2).

Indeed the derivative of t/[(1+t)(t+8)] has the sign of 8−t². This optimizes the displayed family of linear-witness sampling rules. It does not compute the exact random-unitary boundary or the best possible channel-testing protocol. For K=Π and Φ_* every flag is zero in the ideal experiment, whereas every conditional random-unitary explanation has the stated positive floor. The same constant as the preceding diamond-distance lower bound appears because both balance one coherent test against four return tests.

**A finite recorded result.** For a batch length n fixed in advance, under (40b),

    Pr(Σ_{k=1}^n X_k≤c)
      ≤ Σ_{j=0}^c binom(n,j) p₀^j(1−p₀)^(n−j)   (40c)

for integers 0≤c≤n. To see this without an iid assumption, realize each conditional Bernoulli flag from a fresh uniform random number using its conditional probability p_k≥p₀. The same uniforms with threshold p₀ produce independent Bernoulli variables bounded above by X_k. This supplies a coupling and proves (40c). Equivalently, backward induction on the remaining number of rounds proves the same stochastic domination.

In particular an all-zero batch has probability at most (1−p₀)^n. Taking n≥⌈log(α)/log(1−p₀)⌉ makes this particular rejection rule have false-rejection probability at most α under the stated null. This is an upper error probability conditional on that hypothesis, not its posterior probability after seeing the data. Rejection excludes the hypothesis that every conditional map remained in the random-unitary class; it does not identify a stationary channel, locate the exceptional round, or guarantee future behavior.

The counting rule uses actual acquisition randomization, joined basis labels, and admitted event probabilities. It is not obtained by shuffling a previously measured block experiment. Stopping or repeating batches after favorable data requires the separately allocated significance budget described above, or a justified time-uniform rule. General witness games with correlated noise and imperfect random choices are established methods; see [Dirkse et al., Sections II–III and Appendix B](https://arxiv.org/pdf/2002.12400). Here the explicit flag and its floor come from the present channel inequality, rather than a new statistical principle.

**Finite calibration has to preserve a positive floor.** Suppose the recorded coherent-event probability differs from its admitted model probability by at most ζ_s, and each recorded basis-failure probability by at most ζ_j, uniformly conditional on the preceding history. With exact sampling probabilities, (40b) becomes

    p_eff(t)=max(0,
      [tℓ/(1+t)−tζ_s−2Σ_j ζ_j]/(t+8)).

If the conditional distribution of the five settings additionally differs from its prescribed distribution in total variation by at most ξ, replace this by max(0,p_eff(t)−ξ). The latter bound follows because each branch event probability lies in [0,1]. Apply (40c) using the remaining floor, if it is positive. Systematic errors that reduce the floor to zero are not repaired by increasing n. These error bounds must include the relation between preparation, detection, missing events and their denominator; postselection on successful transmission is not automatically the declared channel.

**An acquired analyzer can be admitted before the channel game.** Learning may use an arbitrary procedure. Freeze its resulting K and use a separate, valid admission experiment to produce δ_U with

    Pr(δ>δ_U)≤α_cal

in the admitted projection class. On its valid branch, the already proved relation supplies ℓ=B(μ,δ_U), since B is nonincreasing in δ over the relevant small-leakage range. It is unnecessary to reconstruct K or the learning trajectory. If the resulting floor is not useful, this acquisition gives no channel certificate.

Choose the channel-test parameters and its batch size from that record before the new batch. Let its conditional false-rejection budget be α_test. Under the conditional random-unitary hypothesis, the probability of a false final exclusion is at most

    α_cal+α_test.

Indeed split failure into an invalid analyzer certificate and a rejection on a valid calibration history. The first has probability at most α_cal; on every valid history (40b)–(40c) bound the second by α_test. If another instrumental relation is only statistically admitted, its own failure budget must also be included or justified jointly. A final data-dependent restart cannot silently reset them.

This closes a sufficient path from learning through independent analyzer admission to a finite channel test. It still requires the actual K used during the test to be the admitted K, or to have an acquired transfer relation supplying the same floor. IiS38's question-preserving V→W normalization gives one such exact relation; its approximate form supplies a correspondingly weakened δ bound. An analyzer replaced without that relation is a new unknown, even if all past calibration records remain intact.

**A concrete carrier specification, not an experiment.** A direct dilation uses four path modes as the system and polarization as a two-dimensional environment. Starting with environmental H, apply path-conditioned polarization rotations to prepare respectively

    H, V, (H+V)/√2, (H+iV)/√2.

Tracing polarization gives precisely Φ_*. An analyzer that acts identically on both polarizations and sums their detections reads K⊗I_E and thus q_K. The per-path inverse rotations restore any path superposition before the polarization is discarded. This specifies the contrast between coherent joint recovery and the excluded classical environmental-feedback interface.

The path analyzer must actually satisfy the common-polarization contract; otherwise the purported system-only measurement can use the environmental degree of freedom that the question excluded. Classical vector light also realizes the corresponding first-order coherency equations. Single-photon preparation and the quantum channel interpretation require their own experimental admission. No chip, optical bench or quantum recovery test was run here. The use of a qubit environment for non-random-unitary phase damping has precedents, including [Helm and Strunz, Sections II–III](https://arxiv.org/pdf/0910.5364); this specification asserts no experimental priority.

All quantum conclusions here require the channel, preparation and measurement contracts just stated. The earlier classical-wave coherency experiment alone does not establish a quantum channel or exclude amplitude-varying classical fields; IiS32 explicitly supplies such an amplitude-varying realization. The new physical meaning is conditional on a separately admitted channel experiment, not inferred from the word "phase" or from the mathematical matrix alone.

## Detail: §16p. Joint acquisition can certify support without identifying the analyzer

### IiS41

**IiS41 (A sharp support certificate and an optimal two-branch acquisition).** Fix a projector P with 0<rank P<d on a d-dimensional input space. Put Q=I−P and r=rank Q>0. The question about an unknown density matrix σ is its leakage a=tr(Qσ). A binary analyzer has an unknown effect 0≤K≤I; its event probability is q=tr(Kσ). All probabilities use the complete admitted trial population. The reference preparation and the actual source must enter the same input space of the same analyzer in each compared use. An extra preparation label supplied to the analyzer, or a joint quantum register correlated with the source but absent from the declared input, changes this contract.

IiS37 used an admitted approximation to Q to acquire leakage. Full analyzer identification is a sufficient way to establish that relation, but it is unnecessary for this particular question.

**One bright reference gives a sharp inverse bound.** Suppose the reference τ=Q/r acquires a bright deficit

    b=r[1−tr(Kτ)]=tr(Q(I−K)) ≤ b_U <1.

For 0≤q_U<1−b_U and an acquired q≤q_U,

    a≤R(b_U,q_U)
      :=[√((1−b_U)q_U)+√(b_U(1−q_U))]².       (41a)

Set R=1 if b_U≥1 or q_U≥1−b_U. Thus R(b,0)=b and R(0,q)=q. These are upper bounds on true probabilities, not frequencies treated as exact expectations.

For a proof, first purify σ to |ψ⟩ and put |w⟩=(Q⊗I)|ψ⟩/√a when a>0. Since Q(I−K)Q is positive with trace at most b_U, ⟨w|K⊗I|w⟩=x≥1−b_U. Splitting the overlap through K and I−K and applying Cauchy–Schwarz,

    √a=|⟨w|ψ⟩|
       ≤√(xq)+√((1−x)(1−q)).

For q<1−b_U, the right side is largest over x≥1−b_U at x=1−b_U. Its square increases with q until q=1−b_U. This proves (41a), including mixed σ. The case a=0 is immediate.

The bound is attained in a two-dimensional plane. Choose unit u∈range Q, v∈range P, and

    k=√(1−b)u+√b v,     k_perp=√b u−√(1−b)v,
    K=|k⟩⟨k|+Q−|u⟩⟨u|,
    ψ=√q k+√(1−q)k_perp.

Then K is a projection, its bright deficit is exactly b, the source event probability is q, and tr(Q|ψ⟩⟨ψ|)=R(b,q). For q≥1−b, leakage one is possible under the same upper calibration bound, by taking σ=|u⟩⟨u| and giving K eigenvalue q on u and eigenvalue one on the other Q directions. When b_U≥1, one entire Q direction can remain dark.

Only the bright reference was used. No zero response on P, rank bound on K, full unitarity, or equality K=Q was assumed. For example K=I passes the reference perfectly but never yields a useful small source response. Soundness of a conditional certificate does not require every admitted analyzer to accept a good source. Conversely, without any relation between K and Q, K=0 hides arbitrary leakage. Additional source trials alone cannot repair it.

The defect b is an operational floor for this calibration record: even an exactly zero source probability cannot exclude leakage b. This is a joint compatible realization, not an imperfection of the decoder. Improving that conclusion requires stronger calibration or an additional distinguishing contact.

**The same relation can be acquired jointly.** There is no need to separate a calibration block from a source block. Fix 0<π<1. In each trial secretly choose the actual source with probability π or the known reference Q/r with probability 1−π. The analyzer receives the chosen quantum state, but not an additional branch label. Score a flag X=1 for a K event on the source branch or an I−K event on the reference branch. Thus

    p=Pr(X=1)=πq+(1−π)b/r.

Both events are failures of the desired discrimination, but neither identifies the guilty component on its own. Put t=(1−π)/(rπ). For every σ and every positive contraction K,

    q+t b≥h_t(a)
      :=[1+t−√((1+t)²−4ta)]/2.                 (41b)

For a pure σ=|ψ⟩⟨ψ| with leakage a, minimize

    q+t b=tr(K(σ−tQ))+tr(tQ)

over 0≤K≤I. An effect supported on the negative eigenspaces of σ−tQ attains the minimum. In span(Qψ,Pψ), its two potentially nontrivial eigenvalues are

    [1−t±√((1+t)²−4ta)]/2.

The other r−1 Q directions have eigenvalue −t. Summing the negative eigenvalues and adding tr(tQ)=t·r gives (41b). Endpoint cases follow by continuity. For a mixed state, apply the pure-state bound to a decomposition using the same K. The function h_t is increasing and convex in a, so Jensen's inequality gives the same bound at tr(Qσ). This is the elementary spectral argument behind binary quantum minimum-error discrimination, applied to the present question.

In particular a≥ε implies the exact single-trial floor

    p≥f_π(ε)
      =[x+y−√((x+y)²−4xyε)]/2,
    x=π,     y=(1−π)/r.                         (41c)

Every value of this lower boundary is attainable by a pure source with leakage ε and a projective analyzer as above. The minimization already permits arbitrary positive effects, so the result does not rely on knowing that a laboratory analyzer is lossless.

**The best mixing probability is explicit.** For 0<ε≤1, define s=√(r(1−ε)). The maximal guaranteed flag probability over this particular two-branch, one-flag protocol is

    p_* = ε/[r+1+2s],
    π_* = (1+s)/[r+1+2s].                       (41d)

For an algebraic proof, let z=f_π(ε) and eliminate y=(1−x)/r. The defining equation z(x+y−z)=εxy becomes

    εx²−[ε−z(r−1)]x+z−rz²=0.

The largest value of the lower root z is at a double root in x; its discriminant is

    ε²−2ε(r+1)z+[(r−1)²+4rε]z².

The smaller zero is precisely p_*, and its x is π_*. Substitution shows p_*≤min(x,y); it is therefore the relevant lower root. Since f_π is the infimum of affine functions of π, it is concave; this attained stationary maximum is global. At ε=1 the formula gives x=y=1/(r+1) directly. No optimization by numerical search is used.

As ε tends to zero,

    p_*/ε → 1/(1+√r)².

For the previous four-mode, rank-two question r=2, the exact floor is ε/[3+2√(2(1−ε))]. This is a probability per complete trial, not a number of optical contacts. The preparation and control cost of supplying Q/r is still a separate resource. Optimality in (41d) concerns this specified score and these two preparation branches; it is not a lower bound for all conceivable state-verification experiments.

**Uniform reference is minimax within its support.** More generally let a known reference τ have support Q and least eigenvalue λ>0 on Q. Since τ≥λQ, its reference-failure probability is at least λb. The same proof gives a floor with y=(1−π)λ. It is sharp: choose u to be a least-weight eigenvector, use a pure source in span(u,v), and let the analyzer be the identity on the other Q directions. The optimized floor is

    p_{*,λ}=λε/[1+λ+2√(λ(1−ε))].               (41e)

For fixed π the bound increases with λ. Since λ≤1/r, Q/r maximizes the worst-case floor among all references supported on Q. A rank-deficient reference has λ=0: choose a hidden unit u∈Q in its kernel, σ=|u⟩⟨u|, and K equal to the projector onto the reference support. Both flag probabilities are zero.

Complete knowledge of τ is not necessary for a valid, possibly nonsharp floor. The established relation τ≥λQ alone suffices for (41e)'s fixed-π precursor, even if τ also has support on P. Attainment and the reference-optimality claim above concern the stated exact-support class. A claimed numerical λ must follow from the preparation relation; a full-support name is not a lower eigenvalue bound.

**A question-preserving action can improve the guarantee.** The square-root calibration floor is caused by unknown cross action between P and Q. If a further established relation gives [K,Q]=0, then

    q≥(1−b)a,     a≤min(1,q/(1−b))  for b<1.  (41h)

Indeed the positive Q block is at least (1−b)Q, and the P block contributes nonnegatively. With the same two-branch score, minimization in this commuting class gives

    p≥min(πε,(1−π)/r)  whenever a≥ε.

To attain it, put the source's entire Q component on one direction u, set K=I on the other Q directions and zero on P, and choose the eigenvalue on u to be either zero or one. The optimal mixing and exact single-trial floor for this restricted class are

    π_c=1/(1+rε),       p_c=ε/(1+rε).           (41i)

This improves (41d), except at ε=1 where they coincide. It does not follow from the two observed numbers alone: the rotated projectors attaining (41a) generally fail to commute with Q.

There is a constructive way to supply the relation without learning K. If the exact reflection Z=P−Q is an admitted control, apply it with probability one half before the analyzer, independently of the probe branch and of the analyzer's current effect. Averaging this actual physical action gives the pinching channel

    D(σ)=(σ+ZσZ)/2=PσP+QσQ.

It preserves a=tr(Qσ) and leaves Q/r unchanged. The effective effect is

    K_eff=(K+ZKZ)/2=PKP+QKQ,

so it commutes with Q irrespective of the unknown K. Thus the improved score floor applies to the original leakage question. The ratio of its exact floor to (41d) is

    p_c/p_*=[r+1+2√(r(1−ε))]/(1+rε),

which tends to (1+√r)² as ε decreases to zero for fixed r. This compares guarantees per trial, not total implementation cost. The reflection and its randomization are additional resources.

A trusted reflection is a relation to the independently fixed P; it is not supplied by writing the nominal inverse of an unadmitted analyzer. In the earlier controlled optical interface, an admitted W with W†D_out W=Q realizes it as W†(I−2D_out)W. If W needs four G, this gives an upper bound of eight G plus the phase screen; no minimality of that realization is asserted. The extra control could outweigh a saving in acquired events. A wrongly aligned W has the same defect as the reference counterexample below.

If the actual pinching channel is at most ν from this ideal map in half diamond norm, every branch event probability changes by at most ν. Hence max(0,p_c−ν), with other admitted errors also included, remains a sufficient flag floor. Requiring this control accuracy is explicit; it is not inferred from successful counts.

Pinching destroys cross coherences. It preserves this population question and the target P/2, but it need not preserve a later question sensitive to those coherences. Using it on fresh destructive validation trials does not justify modifying an untested retained state. This is an instance of making the acquisition simpler by an action that preserves the specified question, not by declaring all removed relations physically absent.

**Finite trials and changing analyzers.** Fix the candidate P, the mixing probability and batch length before the validation batch. Conditional on the admitted previous history, each fresh source probe and the reference must be tested by one common effect K_k. K_k may change arbitrarily with that history. Under the null that every conditional source has leakage at least ε, (41c) gives Pr(X_k=1|history)≥f_π(ε). The coupling from IiS40 therefore proves, for 0≤c≤n,

    Pr(ΣX_k≤c)
      ≤Σ_{j=0}^c binom(n,j) f_π(ε)^j
                          (1−f_π(ε))^(n−j).    (41f)

At π=π_* an all-zero batch accepts the source despite the persistent-bad null with probability at most (1−p_*)^n. Thus

    n≥ceil(log α / log(1−p_*))

suffices for this rule. A fixed pure source and fixed minimizing analyzer attain the bound, with iid trials. This is the exact worst-case sample requirement of the stated all-zero rule at that mixing probability, not a universal verification lower bound.

For a fixed conditional source state σ on each fresh source trial, invert these tests to bound its leakage. If u is the ordinary one-sided binomial upper endpoint computed from the count c and confidence budget α, put

    A_π(u)=[(x+y)u−u²]/(xy),  if u<min(x,y),
    A_π(u)=1,                otherwise.         (41g)

Then a≤A_π(u) is a valid one-sided confidence statement even when K_k changes by history. The justification is inversion of (41f); u is not asserted to bound every actual conditional flag probability. For c=0, u=1−α^(1/n). For a varying source, rejection only excludes the persistent-bad null. It does not by itself certify the next source state or the quality of an untested retained copy.

A candidate chosen by learning is allowed: condition on that learning record and validate on fresh trials. This does not make initial compressed readings valid for a later changed source. To apply IiS37's state-distance bound to a fixed σ, that same-state or transferred-reading relation remains necessary. With an admitted compression error κ and leakage confidence endpoint a_U from (41a) or (41g), its bound becomes

    (1/2)‖σ−P/2‖_1≤min(1,3√a_U+2κ).

The reference query is an additional preparation resource; it is not silently included in IiS37's count of source expectations. Failure budgets for compression and reference admission must be combined with α. For a particular question, (37b) can use a_U without requiring full-state identification.

**Classical shared information has an intermediate price.** The unpinched bound has a useful extension beyond one common effect on the averaged source. Let an unobserved classical variable ℓ have the same distribution w_ℓ on both current branches, independently of the current random choice. Conditional on ℓ the source is σ_ℓ and the analyzer uses K_ℓ. They can be correlated. The reference remains Q/r in every ℓ. No value of ℓ need be acquired.

Writing a_ℓ=tr(Qσ_ℓ), the flag probability satisfies

    p≥Σ_ℓ w_ℓ f_π(a_ℓ)
      ≥f_π(Σ_ℓ w_ℓ a_ℓ),

because f_π is convex. Thus (41c) and its optimized floor remain valid for the actual average input leakage. A fixed pure source and analyzer still attain the lower boundary, so the larger classical class has not weakened this particular guarantee.

The stronger pinched price (41i), however, does not survive the same extension unchanged. Conditional on ℓ its floor is min(πa_ℓ,y), where y=(1−π)/r. This function is concave, but min(πa_ℓ,y)≥a_ℓ min(π,y). Consequently the exact classically correlated pinched floor and optimal mixing are

    p_corr=ε/(r+1),        π_corr=1/(r+1).       (41j)

For attainment let ℓ be freshly drawn with probabilities 1−ε and ε. In the first branch set σ_ℓ to a pure P state and K_ℓ=Q, giving no flag. In the second set σ_ℓ=|u⟩⟨u| for u∈Q. If π≤y choose K_ℓ=Q, giving flag probability π; otherwise choose K_ℓ=Q−|u⟩⟨u|, giving probability y. All these effects commute with Q. The average source has leakage ε, and the total flag probability is ε min(π,y). Maximizing this expression proves (41j). A prior that fixes only the marginal input state cannot justify the larger price in (41i).

Thus the independent-source commuting contract, a classically correlated source and analyzer, and a joint quantum register are three different acquired situations. Formula (41j) still improves the unpinched floor, while the quantum-register example below can violate both corresponding local-input bounds. No information is called irrelevant solely because its classical label was not read.

**The reference and actual branch relationship still do work.** If the actual reference differs from Q/r in trace distance by at most ν_R, its contribution changes the flag floor by at most (1−π)ν_R. A bounded source-routing error ν_S adds at most πν_S. A total-variation error ξ in the intended branch choice subtracts at most ξ. Thus a sufficient remaining floor is

    max(0,f_π(ε)−(1−π)ν_R−πν_S−ξ).

Use it in (41f), if positive. Unknown detector efficiency or a common binary reporting error can be absorbed into K_k itself; no separate close-to-Q assumption on that effect is needed. The outcome and trial-denominator relation still must be admitted.

Three explicit failures locate the remaining obligations.

1. A wrong reference can agree perfectly with the analyzer. In a two-dimensional plane take P=|0⟩⟨0|, Q=|1⟩⟨1|, k=cosθ|1⟩+sinθ|0⟩, K=|k⟩⟨k|, and prepare the actual reference |k⟩ instead of |1⟩. The orthogonal source cosθ|0⟩−sinθ|1⟩ gives q=0, while the reference is bright with probability one. Its leakage is sin²θ. Preparing and reading through the same wrongly aligned inverse controls can create this agreement. A common change of the question P as well is a different, covariant statement; here P was fixed.

2. If the current branch label is available separately, K=0 on source trials and K=I on reference trials make every flag zero for any source. The actual quantum input may inform the analyzer in the usual way; the minimization over K already includes that possibility. What is excluded is an additional perfectly readable source/reference label or other unmodelled degree of freedom carrying it.

3. Postselection can give perfect retained results at equal keep rates. In two dimensions let ψ=√(1−a)|0⟩+√a|1⟩ with 0<a<1, and reference |1⟩. Use the three-outcome measurement E_0=|0⟩⟨0|/2, E_1=|ψ_perp⟩⟨ψ_perp|/2, and E_?=I−E_0−E_1≥0. Interpret outcomes 0 and 1 as the desired source/reference answers and discard ?. No retained answer is wrong, while both branches retain exactly (1−a)/2 of their trials. Keeping those equal detection fractions does not repair the invalid renormalization. All complete trials were essential to (41f).

There is a quantum-context limit as well. For r=2, let a source be maximally entangled between Q and an extra two-dimensional register R available to the analyzer. Its leakage is one. Replace only the input on reference trials, so that the joint reference is (Q/2)⊗(I_R/2), and choose the joint effect K_joint=I−|Φ_2⟩⟨Φ_2|. The source event is zero and the reference failure probability is 1/4. At π=1/3 the flag probability is 1/6, below (41d)'s claimed local-input floor 1/3. This does not refute (41d): no single effect on the declared input alone describes both uses. Fresh probes independent of the analyzer's quantum memory, or an enlarged admitted input contract, are needed. Classical history dependence and the correlated classical extension above were permitted; arbitrary unmodelled quantum side information was not.

An admitted finite quantum context can restore a bound. Suppose R has dimension m and, conditional on the admitted history, its marginal ω_R satisfies ω_R≥λ_R I_R with λ_R>0. On a reference trial replace only H by Q/r, leaving the same marginal on R. The joint reference is then

    τ_HR=(Q/r)⊗ω_R≥(λ_R/r)(Q⊗I_R).

Apply the reference bound above on the enlarged, explicitly declared input H⊗R, with Q'=Q⊗I_R and λ=λ_R/r. This gives

    p≥[x+y−√((x+y)²−4xyε)]/2,
    x=π,     y=(1−π)λ_R/r,

for a joint source with tr(Q'σ_HR)≥ε and any common joint effect. The bound is valid without accessing R for measurement. It uses its acquired marginal lower bound and the reference-replacement relation, not a claim that all external memory has been described. Additional marginal constraints can make this sufficient bound nonsharp; no universal optimum under all such constraints is claimed.

For a uniform marginal ω_R=I_R/m, the earlier formula uses the effective reference rank rm. In the explicit r=m=2 example, at ε=1 it supplies the floor 1/5 with source probability 1/5. The maximally entangled source and K_joint above attain it. Thus admitting that particular extra register changes the attainable verification price instead of making verification impossible. Unknown or unbounded additional quantum context remains outside this repaired contract.

**Relation to existing verification work.** Quantum state verification already connects expectation gaps to finite sample requirements; [Pallister, Linden and Montanaro](https://arxiv.org/abs/1709.03353) is one primary source. [Chen et al., PRX Quantum 6, 040353, §II](https://journals.aps.org/prxquantum/pdf/10.1103/fyw6-lq1l) explicitly study subspace overlap and combine its verification with further logical-state estimation. Their given verification-operator construction differs from the unknown-effect joint acquisition here. Trusted preparation with uncharacterized measurement is also an established research direction; [Pusey, §I](https://arxiv.org/pdf/1502.03010) treats channel quantumness, a different question. These are primary comparisons, not evidence of priority for the present formulas.

The contribution to this chain is a complete relation between a partially specified reference, an unknown analyzer, the desired support question, optimal two-branch mixing, and finite acquisition. It removes a need to identify K, but retains and tests the consequences of the actual relations that replaced that need. No optical apparatus or quantum experiment was run for this result.

## Detail: §16q. Local replacement and private control admit arbitrary correlated memory

### IiS42

**IiS42 (Sharp support testing with arbitrary correlated memory).** IiS41's finite-register repair is sufficient, but a dimension cutoff and a lower eigenvalue bound on the memory are unnecessary under genuine local replacement. This continuation audits the supplied analytical note, retains its question and score, and proves three sharp guarantees. Memory can have any finite dimension, without a common upper bound. No assertion about arbitrary infinite-dimensional operator domains is needed.

Let S be finite dimensional, P a nonzero proper projector, Q=I−P, and r=rank Q. The analyzer can access an arbitrary register R correlated with the source. Before the current private branch choice the joint state is ω on S⊗R. Write

    Ω=(Q⊗I_R)ω(Q⊗I_R),     a=tr Ω,
    ω_R=tr_S ω,             τ=Q/r.

The source branch supplies ω. The reference branch replaces only S and supplies

    θ=τ⊗ω_R.                                      (42a)

The same marginal R remains available. The old S can move into an inaccessible internal reserve; local replacement does not require destruction of global history. Supplying that reserve or an extra preparation label to the analyzer would change (42a). The branch choice, with source probability π, is independent of the pre-existing joint state and unavailable separately to the analyzer. One common effect 0≤K≤I acts on its complete declared input. A flag is the K event on the source branch or its complement on the reference branch:

    p=π tr(Kω)+(1−π)tr[(I−K)θ].

All trials are counted. The null is a≥ε, where 0<ε≤1. Conditional past history is permitted, provided these relations hold afresh at each current trial. The state and K need not be identified.

The exact optimized lower flag probabilities are

| Common local preprocessing before K | Sharp floor under a≥ε |
|---|---|
| Identity | ε²/[r²+ε+2r√(ε(1−ε))] |
| P–Q pinching | ε/(r²+1) |
| Pinching and depolarization within Q | ε/2 |

These optimize the branch probability within the stated experiment; they do not optimize all physical experiments or their total costs. The last row also attains a ceiling for the common local channel class specified below.

**The joint relation supplies a dimension-independent inequality.** For every source in (42a),

    Ω≤r(Q⊗ω_R),          θ≥Ω/r².                  (42b)

For an unnormalized vector χ supported in Q⊗R, write its Schmidt decomposition χ=Σ_{j=1}^k √s_j u_j⊗v_j, with k≤r. For every z,

    |⟨χ,z⟩|²≤k Σ_j s_j |⟨u_j⊗v_j,z⟩|²
              ≤r⟨z,(Q⊗tr_S|χ⟩⟨χ|)z⟩.

Summing over a pure decomposition proves Ω≤r Q⊗B for B=tr_S Ω. The partial traces of P–Q cross blocks vanish. Hence ω_R=B+tr_S[(P⊗I)ω(P⊗I)]≥B, proving (42b). Neither an inverse of ω_R nor its least eigenvalue occurs. The relationship of the two inputs replaces that spectral assumption.

**The unprocessed boundary is sharp, including for mixed sources.** Set x=π and c=(1−π)/r². For 0<π<1,

    p≥g_π(a)
     =[x+ca−√((x+ca)²−4xc a²)]/2.               (42c)

Indeed, (42b) bounds p below by x tr(Kω)+c tr[(I−K)Ω]. For ω=|ψ⟩⟨ψ| and a>0, put Ω=a|w⟩⟨w|. Then |⟨w,ψ⟩|²=a. Minimizing over effects is the spectral minimum of x|ψ⟩⟨ψ|−ca|w⟩⟨w|, plus ca. On their two-dimensional span its trace is x−ca and its determinant is −xc a(1−a). The resulting minimum is (42c). At a=0,1 the same expression holds by continuity.

For a mixed decomposition with leakages a_j and weights t_j, the same fixed K gives a lower bound Σ_j t_j g_π(a_j). Writing R(a)=(x+ca)²−4xc a², differentiation gives

    g_π''(a)=2x³c/R(a)^(3/2)>0,     g_π'(0)=0.

Thus g_π is convex and nondecreasing. Endpoint degeneracies are handled by continuity. Jensen's inequality proves (42c) at the actual mean leakage. The cases π=0,1 have the zero lower bound.

For attainment choose a unit vector u in P, a basis q₁,…,q_r of Q, and orthonormal memory vectors 0,1,…,r. Prepare

    ψ_a=√(1−a)|u,0⟩+√(a/r)Σ_j |q_j,j⟩,
    Φ_r=(1/√r)Σ_j |q_j,j⟩.

Then Ω=a|Φ_r⟩⟨Φ_r| and ω_R=(1−a)|0⟩⟨0|+(a/r)Σ_j|j⟩⟨j|. The reference has eigenvalue a/r² on Φ_r. The positive remainder θ−Ω/r² is orthogonal to span{|u,0⟩,Φ_r}. Set K=I on that remainder and use the minimizing spectral projector on the span. Every inequality in (42c) is an equality. The source itself works for every π; only the minimizing effect changes. For 0<a<1 this uses dimension r+1 of R, and at a=1 dimension r suffices. Sharpness is over the allowed memory class, not every separately fixed smaller R.

Monotonicity reduces a≥ε to a=ε. The optimal branch choice is

    D=r²+ε+2r√(ε(1−ε)),
    π_mem=[ε+r√(ε(1−ε))]/D,
    p_mem=ε²/D.                                  (42d)

One explicit optimization check is to put z=g_π(ε). Its quadratic identity, with the smaller spectral root understood, is

    ε²π²+[z(r²−ε)−ε²]π+εz−r²z²=0.

At (42d) the quadratic in π has zero discriminant. For 0<ε<1, substitution gives the smaller root and ∂g_π(ε)/∂π=0. Concavity in π follows independently: for the fixed attaining source the score is the infimum over K of affine functions of π. Thus this stationary point is a global maximum. At ε=1, g_π(1)=min(π,(1−π)/r²), giving π_mem=p_mem=1/(r²+1). For fixed r and small ε, p_mem is asymptotic to ε²/r². For r=2, a=1, π=1/3, (42c) gives 1/6, exactly IiS41's quantum-memory counterexample; optimizing π gives 1/5.

A useful sharp corollary concerns an exactly dark source. If tr(Kω)=0 and z=tr[(I−K)θ], then

    a≤min(1,r√z).                                (42e)

Let E be the support projector of ω. Darkness and positivity give KE=0 and I−K≥E. Thus z≥tr(EΩ)/r². Hilbert–Schmidt Cauchy–Schwarz applied to √ω and E(Q⊗I)√ω gives a²≤tr(EΩ), because their inner product is a and the first squared norm is one. The pure family above with K=I−|ψ_a⟩⟨ψ_a| attains z=a²/r². Darkness alone cannot remove this context cost.

**Removing cross coherence changes the exact memory price.** Apply D_PQ(ρ)=PρP+QρQ locally on both branches. It preserves a and fixes τ. The source is the sum of its two positive diagonal blocks. Dropping its nonnegative P contribution and using (42b),

    p≥π tr(KΩ)+(1−π)tr[(I−K)Ω]/r²
      ≥a min(π,(1−π)/r²).

Pinching ψ_a gives the mixture of |u,0⟩ and Φ_r. Choose K=0 on the first, K=I on extra reference support, and K=0 or I on Φ_r according to the cheaper coefficient. This attains the bound. Consequently

    π_deph=1/(r²+1),       p_deph=ε/(r²+1).       (42f)

IiS41's ε/(r+1) for correlated classical memory remains a different theorem on a smaller class. No classical and quantum memory bounds are silently identified.

**A stronger local action preserves all of P.** Define

    T_Q(ρ)=PρP+tr(Qρ)Q/r.                        (42g)

On the full input it gives

    (T_Q⊗id_R)(ω)=ω_PP+(Q/r)⊗B,
    B=tr_S Ω≤ω_R,       tr B=a.

It fixes τ and preserves the original leakage. It is exactly the identity on every state supported in P, including entangled states with R. It need not preserve cross coherence or information within Q.

There is an explicit unitary implementation without first measuring P versus Q. Let W_jk be the r² Weyl unitaries on Q. Uniformly and privately select one of

    U_sjk=P+(−1)^s W_jk,      s∈{0,1}.           (42h)

Here W_jk is zero outside Q. Averaging over s cancels the cross blocks. Weyl averaging sends every Q block to its trace times Q/r, including operator-valued blocks on R. This proves (42g). One trial uses one selected unitary, not 2r² sequential trials. This is an upper construction for the ensemble size, with no minimality claim. The fresh seed must be independent of the conditional input and unavailable to the analyzer until its recorded outcome. The controller may retain it internally; global information need not be erased.

For any joint K define the memory effect

    M=tr_S[(Q⊗I)K(Q⊗I)]/r,       0≤M≤I_R.

The flag probability after (42g) obeys

    p≥π tr(MB)+(1−π)tr[(I−M)ω_R]
      =π tr(MB)+(1−π)tr[(I−M)B]
        +(1−π)tr[(I−M)(ω_R−B)]
      ≥a min(π,1−π).

The last discarded term is nonnegative: both factors are positive, though they need not commute. Therefore

    π_twirl=1/2,             p_twirl=ε/2.         (42i)

For equality it suffices to use classical memory:

    ω=(1−a)ρ_P⊗|0⟩⟨0|+aτ⊗|1⟩⟨1|,
    θ=τ⊗[(1−a)|0⟩⟨0|+a|1⟩⟨1|],

with ρ_P supported in P. On memory label 0 the two states are orthogonal and have zero minimum flag score. On label 1 they are identical τ and give a min(π,1−π). No quantum entanglement is required to attain this boundary.

This also proves a ceiling for every common local CPTP channel F on S satisfying

    F(τ)=τ,                  F*(Q)=Q.            (42j)

The second condition keeps F(ρ_P) in P, by positivity and its zero Q expectation. The first leaves the shared τ component unchanged. The same classical construction still attains the minimum a min(π,1−π) after F. Hence no such F in this same two-branch, one-terminal-flag protocol can guarantee more than ε/2 for arbitrary shared memory. T_Q attains the ceiling. This does not constrain protocols with further trusted measurements, different accessible outputs, or a different reference question.

For comparison, if the source and analyzer memory are independent, the Q block after T_Q is aτ times that same independent memory. Direct minimization gives min(πa,1−π), optimized to ε/(1+ε). The remaining penalty in (42i) is already forced by classical correlation. None of these soundness guarantees forces an arbitrary badly functioning analyzer to accept a good source. For good P states a zero-flag analyzer exists, K=Q⊗I; arbitrary K may reject them. No completeness guarantee for an unknown apparatus is inferred.

**The preserved question and failed extensions are explicit.** The adjoint is

    T_Q*(O)=POP+[tr(QO)/r]Q.

Consequently its fixed observable space is exactly

    { PAP+cQ : A acts on P, c is a scalar }.      (42k)

This follows in both directions by comparing diagonal and cross blocks. All observables internal to P survive. An arbitrary later operation that converts discarded coherence into a population changes the requested question. A family of later readings requires F*(O)=O for each O that is actually reused.

Two short counterexamples show why the input relationships cannot be replaced by nominal device names.

1. **Disclosed random seed.** For r=2 take source Φ₂ supported in Q⊗R, leakage one, and θ=τ⊗I_R/2. If the selected U in (42h) is disclosed, the analyzer can undo it and use K₀=I−|Φ₂⟩⟨Φ₂|. Equivalently it uses the seed-dependent effect (U⊗I)K₀(U†⊗I). The source event is zero and reference failure is 1/4. At π=1/2 the score is 1/8, below (42i)'s 1/2. Every U fixes τ; revealing its value is enough to break the averaged-input guarantee.
2. **Changed memory on replacement.** Let the source be σ⊗|0⟩⟨0|, even with leakage one. If the actual reference is τ⊗|1⟩⟨1|, K=I_S⊗|1⟩⟨1| gives zero flags on both branches. This is a perfectly readable extra branch label and violates (42a). More source trials do not repair that violation.

**A concrete control cost in the admitted four-mode interface.** For r=2 use the already admitted W satisfying W†D_out W=Q, with at most four G contacts, and its actual inverse. The controls in (42h) are

    W†[I_{P bank} ⊕ (−1)^s σ_j]W,
    σ_j∈{I,X,Y,Z}.

I and Z in the Q bank require diagonal phases only; X and Y require at most one G plus diagonal phases. For example the G with c=0,s=1,φ=π/2 is iX, and with φ=0 is iY; a block phase supplies the remaining scalar. Thus a selected control needs at most nine G plus phase screens. Pinching needs at most eight G plus a phase screen, as in IiS41. These are constructive upper counts, not minima, and phase screens are additional admitted controls. Reciprocal propagation cannot be substituted for W† without an established inverse relation.

The channel is invariant under a change of basis within Q, so W need only establish the P/Q banks. Knowing every internal Q basis coordinate is unnecessary. But a wrongly aligned splitter changes the original question and is not repaired by internal averaging.

For fixed false-acceptance allowance 0<α<1, the all-zero rule uses the sufficient exact worst-case count

    N(p₀,α)=ceil[log α/log(1−p₀)].                (42l)

Under a specified additive cost model with common trial cost C₀, G cost C_G and additional admitted phase/seed costs C_φ,D and C_φ,T, sufficient execution budgets are respectively

    N(p_mem,α) C₀,
    N(p_deph,α)(C₀+8C_G+C_φ,D),
    N(p_twirl,α)(C₀+9C_G+C_φ,T).

Reference preparation, reference fractions, acquisition of W, and label-hiding delays must be included in the actual C₀ or added explicitly; branch-dependent costs must be weighted using that row's π. The displayed common C₀ may instead be a common upper bound. Comparing upper budgets alone does not establish an actual runtime advantage. If C_D and C_T are actual comparable per-trial costs, then for r=2 and small ε the leading total costs are 5C_D log(1/α)/ε and 2C_T log(1/α)/ε. Twirling is cheaper in that limit precisely when C_T<(5/2)C_D. This isolates a resource question instead of calling randomization free. Variable control routes must not disclose the seed or source/reference branch.

**Errors, repeated use and instruments.** If the actual joint source and reference inputs to K have trace distances at most δ_S,δ_R from their ideal processed inputs, then

    p_actual≥p_ideal−πδ_S−(1−π)δ_R.              (42m)

At (42i) the floor is ε/2−(δ_S+δ_R)/2, if positive. A half diamond-norm bound on the implemented local channel is sufficient uniformly over entangled R. A directly acquired bound on the actual joint inputs also suffices. Reduced S-state accuracy alone does not. For a composed implementation, half diamond errors add by telescoping and contraction; the nine-contact construction has the sufficient control error bound 9ν_G+ν_phases when each G has error at most ν_G. Preparation, private-choice and routing errors are separate. A zero remaining certified floor is inconclusive, not proof that all physical protocols fail.

If every conditional trial under the null a_k≥ε has a positive floor p₀, conditional multiplication gives

    Pr(no flags in n trials)≤(1−p₀)^n.

The constructions above can be freshly repeated to attain this bound, so (42l) is sharp for that declared rule and ideal class. Adaptive history and arbitrarily large admitted quantum memory do not require an iid assumption. Fresh branch/seed independence and the local-replacement relation remain required on every trial. This rejects persistently bad conditional input leakage; unrestricted drift does not permit certification of the next untested state or a retained copy. Optional restarts still need a total failure budget.

Finally, an effect does not determine a measurement instrument. For any unitary V, the instrument

    I₀(ρ)=VPρPV†,           I₁(ρ)=QρQ

has effects P,Q and is trace preserving in sum, while V can move a good state out of P after the non-event. T_Q's preservation of P does not establish nondisturbance of the unknown final analyzer. Reuse of a measured output therefore needs its own continuation relation.

**Relation to prior results and scope of the audit.** The spectral minimization is the standard binary discrimination geometry; see [Watrous, Theorem 3.4](https://cs.uwaterloo.ca/~watrous/TQI/TQI.3.pdf). For normalized inputs its minimum is [1−‖πρ−(1−π)θ‖₁]/2. A common channel cannot decrease this minimum, by trace-norm contraction. Here that helps soundness by removing distinctions that let a leaking source avoid the flag, while preserving the question. Private random unitary channels are an established resource; [Mosca, Tapp and de Wolf, §4](https://arxiv.org/html/quant-ph/0003101) give the Pauli construction. Their full-register encryption problem differs from preserving P while randomizing Q. Sequential memory and connected instruments also have an established framework in [Chiribella, D'Ariano and Perinotti](https://arxiv.org/html/0904.4483). These comparisons do not establish priority of the present minimax formulas or an experimental implementation.

The supplied continuation's operator inequality, pure attainers, mixed convexity, optimal priors, preprocessing bounds and ceiling were independently rederived analytically. The explicit failure constructions and four-mode control budget locate their physical obligations. No numerical matrix script, Swift compiler, judge or apparatus was run for this result. IiS41's finite-memory argument remains valid on its original scope; (42a–m) supplies the stronger scope through the actual source/reference relationship.

## Detail: §16r. A support-preserving test can destroy a recoverable continuation

### IiS43

**IiS43 (A reusable repair construction and its continuation boundary).** IiS42's channel T_Q preserves support leakage and every state wholly inside P. It is an intervention for a stated test, not an error corrector. An input outside P can still carry perfectly recoverable logical information. The following finite construction specifies when that information can be restored, what T_Q makes impossible, and which resources a repeated execution must retain.

Let H=L⊗S, dim L=d≥2 and dim S=2. S is a syndrome register, not the entire physical input S used in IiS42. Put

    P=I_L⊗|0⟩⟨0|,       Q=I_L⊗|1⟩⟨1|,
    Enc(ρ)=ρ⊗|0⟩⟨0|,    V=I_L⊗|1⟩⟨0|.

Thus rank P=rank Q=d. The tensor coordinates represent an admitted correspondence between two physical mode banks. Equivalently, given orthogonal equal-rank P,Q and an admitted partial isometry V with V†V=P and VV†=Q, use these formulas in that frame. For d=2 the carrier has four modes. A bank splitter alone need not determine V's internal correspondence.

**A constructor restores the data and the syndrome.** Define

    C(σ)=PσP+V†σV
        =tr_S(σ)⊗|0⟩⟨0|.                       (43a)

The Kraus operators P,V† satisfy P+VV†=I, so C is CPTP. For a channel E with Kraus operators E_j, this particular C corrects every encoded input exactly iff

    E_j P=α_j P+β_j V   for every j.            (43b)

Sufficiency is constructive: PE_jP=α_jP and V†E_jP=β_jP, so C E Enc(ρ)=Σ_j(|α_j|²+|β_j|²)Enc(ρ)=Enc(ρ). Trace preservation supplies the coefficient sum one. Equality of channels also preserves correlations with every untouched reference. For necessity, every Kraus operator of the identity channel on the code must be a scalar multiple of identity there. To see this, a pure input has a pure identical output, so each Kraus image is collinear with that input; linearity on superpositions makes the coefficient independent of the input. Apply this to the composite Kraus operators PE_jP and V†E_jP. Adding their P and Q components yields (43b).

This is a special instance of the established Knill–Laflamme conditions: P E_i†E_j P=(α_i*α_j+β_i*β_j)P. The construction does not provide protection against arbitrary errors on the logical register. It makes the relation needed by this particular repair explicit; see [Knill and Laflamme, Theorems 3.2–3.5](https://arxiv.org/html/quant-ph/9604034).

For example, E may apply any channel to S alone. It may also give a coherent syndrome rotation, rather than a classical error flag. Let J=V+V†=I_L⊗X. Both an arbitrary mixture of I,J and exp(iθJ), with unknown θ, satisfy (43b). C corrects them without acquiring their mixture probability or θ. With a working implementation of C available at each step, repeated noise–repair cycles return the same encoded logical state by induction. Supply and reset of that implementation's resources are addressed below.

**The subspaces do not specify the repair map.** If the actual transfer is VU for an unknown logical unitary U, the nominal repair V† returns UρU†, wholly in P. All P/Q population readings of VρV† and VUρU† report the same complete transfer. For a logical qubit, U=Z sends |+⟩ to |−⟩ after nominal repair, although the post-repair leakage is exactly zero.

There is no common universal repair for all such U: one available input V|ψ⟩ can arise from logical ψ with transfer V or from logical U†ψ with transfer VU. A decoder would have to give two different answers on the same input. Thus a relative logical correspondence, or some weaker relation sufficient for the selected question, is needed in addition to the bank geometry. IiS42's basis independence within Q is useful for its test, but it cannot be silently borrowed for restoration of arbitrary logical data.

**What happens when the test preprocessing is reused on the data.** Consider the correctable noise, with 0≤η≤1,

    N_η(ρ)=(1−η)ρ⊗|0⟩⟨0|+ηρ⊗|1⟩⟨1|,

as a channel from L to H. Its leakage is η and C N_η=Enc. Applying IiS42's full randomization on Q instead gives

    A_η(ρ)=T_Q N_η(ρ)
          =(1−η)ρ⊗|0⟩⟨0|+η(I_L/d)⊗|1⟩⟨1|. (43c)

For an entangled input ρ_LR the second component becomes (I_L/d)⊗|1⟩⟨1|⊗ρ_R. Logical correlations on that component are absent from the available output. The statements below give the recovery access to H only, with arbitrary fixed ancillary resources independent of the unknown input. They exclude the private random seed and complementary environment containing the discarded information. That access restriction is essential.

Three execution tasks now have distinct exact answers.

**A deterministic unknown-state output has an unavoidable error.** Over all CPTP recoveries R:H→L,

    inf_R (1/2)‖R A_η−id_L‖_diamond
          =η(1−1/d²).                            (43d)

Any such recovery produces a logical channel Λ=(1−η)R₀+η Rep_τ, where R₀ is CPTP and τ is a fixed state. On a normalized maximally entangled input Φ_d, its overlap with the desired Φ_d is at most 1−η+η/d²: the first component has overlap at most one, and τ⊗I/d has overlap exactly 1/d². The binary measurement {Φ_d,I−Φ_d} gives the lower trace-distance bound in (43d), and hence a lower diamond bound for every R.

For attainment decode by tr_S, giving Λ=(1−η)id+ηD with D(ρ)=I/d. Weyl averaging writes D=d⁻²Σ_j Ad_{W_j}, with one W_j=I and the other d²−1 unitaries traceless. The triangle inequality gives (1/2)‖id−D‖_diamond≤1−1/d², since a difference of two channels has diamond norm at most two. Φ_d attains equality. This proves both the optimization and its attaining recovery. For the four-mode case the bound is 3η/4. The noise was exactly correctable before T_Q; this floor is introduced by that action.

**An exact heralded output has a sharp success price.** A trace- nonincreasing success map may return the correct unknown state only when it declares success. Its success probability, uniformly over all logical states, is at most

    1−η.                                        (43e)

For a pure input ψ write its successful unnormalized output as (1−η)S₀(ψ)+ητ=p_ψ ψ, where τ≥0 is the image of the fixed Q component. If η>0, positivity forces the support of τ inside the ray of every ψ. Since d≥2 this requires τ=0. Thus p_ψ≤1−η for every ψ. When η<1, exactness on every pure input forces each Kraus operator of S₀ to be a scalar identity, so S₀=q id with q≤1 and success probability (1−η)q independent of the input. Keeping P and decoding attains (43e). At η=1 there is no nonzero universal exact success branch. Discarding failed specimens cannot be reported as a deterministic repair.

**Some binary questions remain exactly implementable.** Let 0≤A≤I_L be a desired logical effect. A single effect 0≤M≤I_H on A_η(ρ) reproduces tr(Aρ) for every logical ρ iff

    λ_max(A)−λ_min(A)≤1−η.                      (43f)

Indeed, A_η*(M)=(1−η)M₀₀+ηb I_L, with b=tr(M₁₁)/d∈[0,1] and 0≤M₀₀≤I. Necessity follows from the spectral spread. For 0<η<1 and the stated inequality, choose any t in the nonempty interval

    max(0,λ_max(A)−(1−η))≤t≤min(η,λ_min(A)),

then set M₀₀=(A−tI)/(1−η) and M₁₁=(t/η)I, with zero cross blocks. This is an effect giving the required reading. At η=0 every effect is possible; at η=1 precisely scalar effects are possible. Every nontrivial projector has spectral spread one, so a nonzero η excludes its exact single-trial reproduction. Weaker contrast can still be read exactly by the displayed construction.

For η<1, A_η is nevertheless injective: its P block is (1−η)ρ. Knowing that entire output density operator would determine ρ by a linear formula. Repeated preparations with a justified common η can also support statistical inversion. Such inversion is not a CPTP map producing one unknown quantum specimen and is not automatically a binary effect with outcomes in [0,1]. The mathematical availability of a decoder and its admissible physical execution are separate questions. Equations (43d–f) give exact differences between them; multiple-use coding is outside this model.

The effect synthesis in (43f) uses the actual η. If two distinct rates remain possible and one fixed M must implement A for both, subtracting the two equations A=(1−η)M₀₀+ηbI forces M₀₀=bI and hence A=bI. Thus only scalar effects work uniformly without resolving that rate ambiguity in this single-trial format. In contrast, the deterministic and heralded attaining state recoveries above do not need η as an execution input. A parameter known to the proof is not thereby available to the executor. A full output density description would include η as its Q population; finite acquisition is another task.

**The preserved question must include its continuation.** For a later channel F and final observable O, inserting a preprocessing T leaves that same execution's answer unchanged for every input iff

    T*F*(O)=F*(O).                              (43g)

For inputs restricted to a subspace K with projector Π_K, the condition is equality of the compressions Π_K(·)Π_K instead. This follows by the trace pairing and testing all pure states in the declared domain. It permits a question-relative replacement; it does not identify the two processes on every future use.

Here C*(O)=O₀₀⊗I_S, so Fix(C*)=B(L)⊗I_S. In contrast, IiS42 gives Fix(T_Q*)=B(P)⊕C Q. Their intersection with the lifted logical algebra consists only of scalar identities. For example O=A⊗|0⟩⟨0| is itself fixed by T_Q*, but the repair continuation pulls it back to C*(O)=A⊗I_S, which is fixed only for scalar A. On N_η(ρ), the difference in the same repaired reading is

    η[tr(Aρ)−tr(A)/d].

Thus preservation of the endpoint observable by itself is too weak. This does not contradict (43f): that theorem permits constructing a different measurement M for the individual question. The specific old continuation, existence of another reading, and production of an unknown quantum state are three distinct execution contracts.

**The missing phase relation has a finite admission construction.** For d=2, take the actual composed device F=C E Enc, with target Enc. If one common CPTP process satisfies

    F(|0⟩⟨0|)=Enc(|0⟩⟨0|),
    F(|+⟩⟨+|)=Enc(|+⟩⟨+|),                   (43h)

IiS11 forces F=Enc on the whole logical qubit, including entangled references. The proof applies equally to this isometric target: each pure output forces each Kraus image into its target ray; the nonzero overlap makes the two environment coefficient vectors equal, and the probes span the input. Two orthogonal basis probes would still permit dephasing. A support check against the larger P alone would permit the logical Z counterexample above.

This gives a sufficient acquired bridge for the composed action, without reconstructing the entire E or V. At finite errors the existing IiS13 constructor applies to these same probes: use their overlap 1/√2 and input-column least singular value √(1−1/√2) in its bound. If survival on each named pure output is at least 1−ε_i, put δ_i=√(2−2√(1−ε_i)), w=min(2,√(2(δ₀+δ₊)/(1/√2))). A sufficient half diamond error from Enc is

    min(1, √(δ₀²+(δ₊+w)²)/√(1−1/√2)).           (43i)

This is a conservative composition of an existing bound, not a new optimal estimate. IiS42 can supply statistical upper bounds on these two output leakages when each exact target ray, its corresponding reference preparation and the local-replacement contract are admitted. Apply that test on sacrificial calibration outputs, not on the payload that must continue coherently. Combine failure allowances for the two tests and other admitted errors. The same-channel or justified drift relation across the two probe families and later use remains required. Finite successful trials do not supply the exact equalities (43h).

**Repeated restoration consumes or exports a record.** A unitary implementation on H alone cannot realize C. For the same logical ψ, the orthogonal states |ψ,0⟩ and |ψ,1⟩ would both have to become |ψ,0⟩. A unitary preserves their inner product. In particular, the four-mode lossless G interface alone does not provide this reset from its P/Q splitter alone.

A unitary implementation with a supplied clean ancillary register A is explicit: swap S with A initially in |0⟩ and leave L untouched. The syndrome becomes zero and the logical state is preserved; the old syndrome, with any correlations, moves to A. The working module's logical and syndrome outputs are ready for another cycle, but its clean ancillary resource has been spent.

More generally, suppose a reversible realization resets n freely supplied binary syndrome registers to the same standard state, returns all work registers to their fixed joint pure initial state, starts with a fixed pure reserve, and leaves the logical data unchanged. If a declared reserve B is the only output allowed to distinguish the 2^n orthogonal syndrome histories, then

    dim B≥2^n.                                  (43j)

Fix a pure logical input and the standard initial work/reserve state. Unitarity preserves orthogonality of the 2^n histories. All final factors except B are the same, so B must contain that many orthogonal states. Swapping each syndrome into a fresh binary reserve attains the dimension count. The theorem presupposes those freely supplied histories and no other record-bearing output; it is not a claim that every physically possible noise history is independent. If records go elsewhere, that place is part of the enlarged resource interface. Restoring individual mixed marginals while allowing correlations to retain the histories is a different contract. No temperature, heat-per-bit law or absolute clock is inferred from this dimensional argument.

This is why a repeatable logical channel is weaker than a fully renewed physical implementation. A supplied reservoir, spare register, or an established reversible uncomputation may close the next step. The correctness of the present output does not produce those resources. The same distinction underlies Matter's admitted renewal interfaces, but its finite primary-record reserve is a different theorem.

The random seed has the complementary role. If the controller retains the seed of T_Q and the randomized system is still undisturbed, it can undo the selected unitary. Then the effective input for the continuation includes that record and (43d–f) do not apply. After an arbitrary unknown analyzer acts, seed disclosure alone cannot invert its instrument. IiS42 fixes outcome statistics, not that instrument. Neither local erasure nor the existence of a global record establishes a presently available recovery.

**Support restoration is not contraction of every logical error.** C has output leakage zero for every input, but acts identically on all states in P. Two different states in P keep their trace distance, so C cannot satisfy a uniform strict contraction toward every unknown logical target. A repeated small logical rotation diag(1,e^{iδ}) keeps leakage zero at every cycle; starting from |+⟩ its X expectation after n cycles is cos(nδ). Neighboring support certificates alone therefore allow accumulated logical drift. A relation e_{k+1}≤κe_k+ξ must specify which error it contracts and derive κ from the actual dynamics. It does not supply the missing logical relation in (43b) or (43h).

**What can already be reused by a planner.** The formulas constitute a finite constructive rule, rather than a nominal `CorrectBackend`: given P,Q,V and an admitted error relation, (43a) builds the repair; (43h–i) builds a sufficient admission task for its composite action; (43g) checks a proposed preprocessing against the actual continuation; (43d–f) select between approximate state output, exact heralded output and a single-effect reading; (43j) states a resource obligation for repetition. The same constructions transport through an admitted change of frame and do not require a new proof for each basis. This is one worked rule family for HORN's finite-generation idea, not an implemented universal planner, quantum compiler or claim of quantum acceleration.

The distinction between correcting a subsystem and correcting observables is established in [operator quantum error correction](https://arxiv.org/abs/quant-ph/0412076) and [Bény, Kempf and Kribs](https://arxiv.org/abs/0705.1574). The present calculation connects those distinctions to IiS42's particular useful but destructive preprocessing; priority is not claimed. An experimental counterpart to the need for a logically indistinguishable error record appears in [Gertler et al., Fig. 1 and the recovery construction](https://arxiv.org/html/2004.09322): their reservoir-driven correction requires matched transition paths and reservoir emission that does not reveal the logical path. That experiment uses engineered drives and a reservoir; it does not demonstrate this four-mode construction or autonomous rebuilding of its controller.

The result supplies a coherent repair cycle under declared error and resource relations, a sharp obstruction when the wrong test operation is reused, and an explicit acquisition task for the missing logical bridge. It does not show that a module manufactures its own successor, its own error model or an inexhaustible supply of clean resources. No apparatus, numerical simulation, Swift compiler or judge was run for this analytical continuation.

## Cross-page mentions

Labels mentioned here: <doc:interference_is_substitution__models_calibration#IiS11>, <doc:interference_is_substitution__models_calibration#IiS13>, <doc:interference_is_substitution__comparison_fluctuations#IiS32>, <doc:interference_is_substitution__support_calibration#IiS34>, <doc:interference_is_substitution__support_calibration#IiS36>, <doc:interference_is_substitution__acquired_programs#IiS37>, <doc:interference_is_substitution__acquired_programs#IiS38>, <doc:interference_is_substitution__acquired_programs#IiS39>.

Mentions of this page’s labels: <doc:interference_is_substitution__acquired_programs> (IiS40), <doc:interference_is_substitution__repair_continuation> (IiS42), <doc:interference_is_substitution__repair_continuation> (IiS43).
