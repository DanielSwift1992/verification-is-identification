# Interference Is Substitution (Wave) — Repair continuation

This part contains the original derivations for repair continuation.

Family and original section headings: <doc:interference_is_substitution>.

Section setting: <doc:interference_is_substitution#16s-Acquired-uncertainty-can-select-an-optimal-repair-without-identifying-the-fault>.

## Detail: §16s. Acquired uncertainty can select an optimal repair without identifying the fault

### IiS44

**IiS44 (A coherent probe chooses a minimax continuation).** IiS43 requires an admitted correspondence between the P and Q banks. The bank address alone does not establish its logical phase. Here a partially acquired correspondence is sufficient to construct an optimal repair. The objective is preservation of an unknown logical qubit, including its entanglement with an untouched reference. The result is not a claim that every unknown channel has this form.

Use IiS43's H=L⊗S with dim L=dim S=2 and its declared bank frame. For a complex number |z|≤1 define the qubit channel

    D_z([[a,c],[c*,d]]) = [[a,z c],[z* c*,d]].       (44a)

The convention is that z multiplies the upper-right matrix entry. These are exactly the CPTP qubit channels that fix both basis pure states. Indeed, if E fixes |i⟩⟨i|, positivity and purity make every Kraus operator send |i⟩ into its own ray. Both fixed rays make all Kraus operators diagonal. Their normalized diagonal columns have an inner product z with |z|≤1. Conversely (44a) is a phase rotation composed with a mixture of I and Z. This reuses the fixed-ray argument of IiS12; it does not infer a unitary fault from correct basis outputs.

The faulty contact in the present scope is

    N_{η,z}(ρ)=(1−η)ρ⊗|0⟩⟨0|
                    +η D_z(ρ)⊗|1⟩⟨1|,          (44b)

where 0≤η≤1 and z belongs to an acquired nonempty compact set K in the closed unit disk. The branch is classical, the good branch is identity, and its weight is independent of the logical input. An arbitrary coherent coupling of logical data, syndrome and environment is a different class. All controls below use the admitted logical frame; a change of that frame requires the corresponding transport.

The whole form (44b) has a finite relational foundation, rather than requiring a nominal promise about input-independent η. Let F_0,F_1 be the raw, subnormalized CP branch maps in the admitted bank frame, with F_0+F_1 trace preserving. Suppose each branch sends each basis input into its own ray, with arbitrary nonnegative weights, and

    F_0(|+⟩⟨+|)=q|+⟩⟨+|.

All branch Kraus operators are diagonal. Comparing the two diagonal entries and the coherence of the last relation forces F_0=q id. Trace preservation then fixes both F_1 basis weights to 1−q; its remaining coefficient gives F_1=(1−q)D_z. Thus η=1−q and (44b) follow, including zero-weight endpoints. Separate equality assumptions for the two branch probabilities would be redundant here. These are raw relations, including occurrence weights. Normalized basis outputs alone do not suffice: F_0(ρ)=|0⟩⟨0|ρ|0⟩⟨0| and F_1(ρ)=|1⟩⟨1|ρ|1⟩⟨1| preserve every surviving basis output, but the branch probability depends on the input and the discarded branch leaves complete dephasing. This example fails the additional good-branch coherent relation. Exact relations and their finite-data approximations must still be distinguished, as below.

That foundation also has a quantitative part. With exact basis-ray preservation, write F_0's two basis weights as p_0,p_1 and its coherence multiplier as c, so |c|²≤p_0p_1. A coherent input has raw good-branch weight q=(p_0+p_1)/2 and wrong-ray mass t=tr[|−⟩⟨−|F_0(|+⟩⟨+|)]=(q−Re c)/2. Positivity gives

    ((p_0−p_1)/2)²+(Im c)² ≤ 4t(q−t),
    |p_0−p_1| ≤ 4√(t(q−t)).                     (44b′)

Indeed p_0p_1=q²−((p_0−p_1)/2)² and Re c=q−2t. At t=0 the exact input-independent branch follows. This bounds an otherwise hidden dependence of the branch probability on the input; it is not by itself the full channel bound (44g). For uncertain q,t, maximize over their compatible region. Substituting only an upper bound on t is not valid past the maximum at t=q/2.

Write d_⋄(A,B)=½||A−B||_⋄. A recovery R:H→L is one fixed CPTP map, independent of the actual z. It may have fixed auxiliary resources, but it receives neither the unknown phase nor an environment record that supplies it. A re-encoding into P can be appended without changing the distance. Reset and reserve costs remain those separated in IiS43. Further queries to the unknown fault are new acquisition, not fixed auxiliary inputs hidden in the optimization over R.

**All recovery maps reduce to one scalar optimization.** Put

    h(K)=min_{|b|≤1} max_{z∈K}|1−b z|.

Then the exact worst-case recovery error is

    inf_R sup_{z∈K} d_⋄(R N_{η,z},id)=η h(K)/2.   (44c)

An attaining R leaves the good logical branch alone and applies D_b on the faulty branch, for a minimizing b. It then discards or resets the syndrome as declared. Compactness gives a minimizer. If only η≤η̄ is available, the same construction is optimal for the enlarged family with value η̄ h(K)/2. The control b does not require η as input. Refining the evidence cannot worsen this optimum: K'⊆K implies h(K')≤h(K), since the old action remains available. A later example of a worse composed action is about a changed continuation question, not an advantage of possessing less information.

This is an explicit channel constructor. For b=t e^{iβ}, choose U_β=diag(e^{iβ},1); at b=0 take β=0. Its Kraus operators H→L are

    A_0=I_L⊗⟨0|,
    A_1=√((1+t)/2) U_β⊗⟨1|,
    A_2=√((1−t)/2) Z U_β⊗⟨1|.

They satisfy Σ_j A_j†A_j=I_H directly. The coefficient b comes from the acquired set, not from a hidden copy of z. Implementing these Kraus operators still uses the admitted bank controls and a record/discard resource; the constructor does not manufacture them. If an implementation realizes b' with |b'|≤1 and |b'−b|≤δ, its worst-case error is at most η[h(K)+δ]/2. This follows from |z|≤1 and (44d); precise real-valued control is not free, and a finite control tolerance has an explicit charge. More general half-diamond implementation errors add by channel contraction.

Here is a lower bound against all CPTP recoveries, not just mixtures of phase gates. Since (44b) is block diagonal, R induces two qubit channels R_0,R_1. Average them under simultaneous conjugation by all logical diagonal phase rotations. Every D_z commutes with these rotations; convexity and unitary invariance of the diamond norm show that this averaging cannot increase any worst-case error. The resulting channels multiply the upper-right entry by some a,b with |a|,|b|≤1. They can still move populations; on input |+⟩ that adds to, rather than removes, the trace-distance lower bound

    ½|1−(1−η)a−η b z|.

For η>0 set c=1−(1−η)a and r=ηb. Then |c|≥η, |r/c|≤1, and

    max_K |c−r z| = |c| max_K |1−(r/c)z| ≥ η h(K).

The case η=0 is immediate. For the upper bound use the displayed recovery, which gives D_γ with γ=1−η+η b z. For every |γ|≤1,

    d_⋄(D_γ,id)=|1−γ|/2.                         (44d)

To verify reference-uniformity, the difference is |1−γ| times a diagonal unitary conjugation of the off-diagonal projection (id−Ad_Z)/2. That projection has diamond norm one: the triangle inequality gives the upper bound, attained on |+⟩. This proves (44d) and (44c). No absence of an entangled input was assumed.

**One coherent probe family suffices for a strict improvement.** Once both basis-output relations are admitted, prepare |+⟩ through the faulty branch and acquire a lower bound f≥f₀ on

    f=⟨+|D_z(|+⟩⟨+|)|+⟩=(1+Re z)/2.

For ½≤f₀≤1 put κ=2f₀−1. The exact compatible family is

    K_κ={z:|z|≤1, Re z≥κ}.

Its optimal recovery and its exact error are

    b=κ,
    h(K_κ)=√(1−κ²),
    error=η√(1−κ²)/2=η√(f₀(1−f₀)).              (44e)

The upper bound follows from |1−κz|²=1−2κ Re z+κ²|z|²≤1−κ². For a lower bound the two possible faults

    z_±=κ±i√(1−κ²)

give exactly the same coherent survival f₀ and the same two basis outputs. For every complex b,

    (|1−b z_+|²+|1−b z_-|²)/2
        =|b−κ|²+1−κ².

Thus no fixed recovery can beat (44e) using only these relations. The witness average is a mathematical certificate of a worst case; it is not a prior probability assigned to the physical fault.

The action D_κ on Q is particularly explicit: choose logical I with probability f₀ and logical Z with probability 1−f₀. This preserves logical populations and attenuates only their coherence. It is not IiS42's full depolarization within Q. The private random choice in IiS42 served test soundness; this random choice serves a declared recovery objective. Its physical preparation and control are resources. For example, m≥1 admitted fair bits, independent of one another and of the incoming data and fault, give a uniform integer J∈{0,…,2^m−1}. Apply I when J<floor(2^m f₀), and Z otherwise. The resulting probability differs from f₀ by less than 2^{-m}; the recovery error increases by at most η 2^{-m}. This is a finite control construction relative to a declared random-bit source, not a proof that an arbitrary physical generator supplies those bits.

For example f₀=4/5 gives κ=3/5, the two witnesses z_±=(3±4i)/5, and the exact error 2η/5. On them the recovered faulty multiplier is (9±12i)/25, at distance 4/5 from one. The control receives the bound 4/5, not the unavailable choice between the two phases.

With basis probes alone, every z in the disk is compatible, including z=0. The optimal error is η/2. Therefore a coherent lower bound strictly above 1/2 buys a strict improvement without identifying z. For f₀≤1/2, the family still contains zero, and complete dephasing b=0 remains optimal with error η/2. This does not infer Re z≥0. “One probe” means one additional preparation/reading family, usually many actual trials. It is not one-shot identification of a probability or a general lower bound on the number of all conceivable experiments.

Nor does minimax optimality mean improvement on every individual device. If z is subsequently identified, its optimal error is η(1−|z|)/2: choose b=e^{-i arg z} when z≠0. A known unit-modulus fault is exactly correctable; a known z strictly inside the disk need not be. Partial phase ignorance and loss of coherence in the channel are different obstructions, although the acquired family can contain both.

**For pure phase uncertainty, the nearest convex-hull point is enough.** There is also a geometric form of (44c). If Z is compact in the unit circle and w is the nearest point to zero in conv Z, then

    b=conj(w),       h(Z)=√(1−|w|²).              (44f)

The projection condition Re(conj(w)z)≥|w|² proves the upper bound. For the lower bound choose a convex representation Σ_j λ_j z_j=w. For any b,

    Σ_j λ_j|1−b z_j|²
      =|b−conj(w)|²+1−|w|² ≥ 1−|w|².

At most three phases suffice as witnesses by planar convexity. When w≠0, every positive-weight witness lies on the supporting line Re(conj(w)z)=|w|², which meets the circle in at most two points. Thus a continuum of unknown phases can admit a recovery construction and a finite lower-bound witness without selecting its actual phase.

For the arc z=e^{iθ}, |θ|≤Δ≤π, the answer is b=cos Δ and error (η/2)sin Δ when Δ≤π/2; for Δ≥π/2 it is b=0 and error η/2. A known central phase multiplies b by its inverse. Correcting only to the central phase, with |b|=1, would have error η sin(Δ/2) on the short arc and is strictly worse for 0<Δ<π/2. The useful extra attenuation is not an estimate of the unknown phase; it is the action selected by its remaining ambiguity.

**Finite data need not postulate exact fixed rays.** Suppose an admitted common CPTP qubit channel E has basis survival at least 1−ε_i for i=0,1, with 0≤ε_i≤1. Let

    δ_i=√(2−2√(1−ε_i)),
    s=min(1,√(δ_0²+δ_1²)).

There exists D_z with d_⋄(E,D_z)≤s. To prove this, take a Stinespring isometry V. Its component on the desired output |i⟩ defines a normalized environment vector e_i, chosen arbitrarily if that component is zero. Then

    ||V|i⟩−|i⟩e_i||≤δ_i.

The map V₀|i⟩=|i⟩e_i is an isometry even when e_0,e_1 overlap. The operator norm ||V−V₀|| is at most √(δ_0²+δ_1²). The two-isometry estimate of IiS13, or its direct pure-input proof with an arbitrary reference, gives the stated half-diamond bound. Tracing the environment of V₀ produces a channel of form (44a).

If E's coherent survival is at least f_L, then the same D_z obeys Re z≥ℓ=2f_L−1−2s. When ℓ≥0 choose κ=ℓ; when ℓ<0 choose κ=0 and use complete dephasing without claiming a nonnegative real part. The resulting fixed repair has the sufficient bound

    error ≤ η min{1, s+½√(1−κ²)}.                (44g)

This is a stability estimate, not a claimed sharp minimax theorem for approximate basis data. It assumes a qubit-to-qubit faulty map after the declared routing. Leakage outside that output bank and errors in the good branch require additional channel bounds; discarding such outputs and renormalizing silently would change the question. Finite input-state bounds are also the subject of [Mayer and Knill](https://arxiv.org/abs/1805.04491); the elementary two-ray estimate here is proved explicitly.

**Acquisition has a finite rule and an explicit applicability boundary.** IiS42 can test the leakage u of each disposable calibration output from its desired target ray. Under its actual local-replacement, hidden-choice and conditional-trial relations, the ideal flag floor is u/2. For a fixed common faulty channel and predeclared n≥1, 0<α<1, an all-zero record gives the confidence upper bound

    u_U=min{1, 2[1−α^(1/n)]}.                    (44h)

Precisely, for every fixed u>u_U the probability of that accepted record is at most α. This does not assign posterior probability to u. The three target families |0⟩,|1⟩,|+⟩ provide ε_0,ε_1 and f_L=1−u_{+,U} for (44g); a union bound charges the sum of their allocated failure allowances. If exact basis preservation is already structurally admitted, only the coherent family is additional.

For that exact-basis case, a target error 0<e<η̄/2 can be certified by establishing u≤u_req, where

    u_req=(1−√(1−(2e/η̄)²))/2,
    n≥ceil[log α/log(1−u_req/2)].                 (44i)

Accept after n zero flags and use b=1−2u_req. For any compatible channel satisfying the bound, the error is ≤e. The finite test can falsely accept an incompatible channel only within the allocated allowance. This is the sharp worst-case count of this particular all-zero support test in the ideal IiS42 class, not an optimum over all possible acquisition policies. For small e/η̄ its leading count is 2η̄² log(1/α)/e². Nonzero preparation/control errors reduce the flag floor as in (42m); the ideal count cannot be reused without accounting for those errors.

These are trials on the faulty logical output. Access to them is not automatic from the existence of N_{η,z}. One may have an admitted prepared invocation of the faulty branch. Otherwise the syndrome must be read on actual calibration launches and the Q outputs retained; all discarded launches and all test branches still count as physical work. Under independent stationary fault flags with η>0, obtaining n such outputs costs n/η launches in expectation, before other test resources. A finite launch deadline needs a separately admitted yield bound or an explicit chance of failing to gather the batch. At η=0 there is no faulty output to calibrate and no error to correct.

The analyzer may retain the arbitrary correlated memory admitted by IiS42. This does not certify a common logical source channel: a channel changing between calibration families or between acquisition and data can invalidate (44g–i). For the stated inference, the same E must apply on the declared conditional trials, or an acquired transport/error bound must replace that relation. Calibration tests consume disposable outputs; their unknown instruments are not passed the data whose continuation is being preserved. Repeated attempts or adaptive stopping need a total false-acceptance budget.

**Renewal preserves a bound only through an admitted change law.** For a pure phase, suppose an acquired arc has center θ₀ and half-width Δ₀, and each counted contact changes phase by at most ν in circular distance. After h contacts a sufficient arc has half-width Δ_h=min(π,Δ₀+hν). Formula (44f) then constructs the new one-step optimal action for that admitted arc. For a demanded one-step error e<η̄/2, its permitted horizon satisfies

    Δ₀+hν ≤ arcsin(2e/η̄).                       (44j)

This uses a relation between contacts, not a claim about absolute physical time. The drift bound ν is an additional acquired or otherwise established relation; it is not proved by the previous finite record. Without any such restriction the next fault can be any phase, and the old calibration gives no smaller worst-case floor than η/2. As a concrete failure, z=1 during every calibration and z=−1 during use leaves every old record unchanged; the old b=1 then has error η.

Per-step guarantees also do not provide an indefinitely preserved unknown qubit. When the reduced logical maps really compose without retained side records or environment feedback, n repaired contacts give D_{γ_n⋯γ_1}, with γ_k=1−η_k+η_k b_k z_k. Hence

    total error=½|1−∏_k γ_k|
               ≤½Σ_k η_k|1−b_k z_k|.            (44k)

Acquiring a better control for the next step does not invert earlier discarded loss of coherence. If random choices or other side records are retained and available for later action, that joint continuation must be analyzed instead of composing its reduced channels. IiS43's distinction between a restored marginal and a restored usable joint state remains in force.

**An optimal intermediate repair can spoil an exact final answer.** There is a sharp instance of this distinction within the same model. Let η=1 and let two successive faults have the admitted relation D_z followed by D_conj(z), for one fixed unknown z=e^{iθ}, |θ|≤Δ and 0<Δ<π/2. Return the syndrome bank after each contact, but leave the logical phase alone. At the final boundary,

    D_conj(z) D_z = id   for every allowed z.     (44l)

No phase acquisition is needed for that final-only question. In contrast, inserting the one-step minimax D_b, b=cos Δ, after each contact gives

    D_b D_conj(z) D_b D_z=D_{cos² Δ},
    final error=sin²(Δ)/2 > 0.                    (44m)

These are compositions of reduced channels, with the randomization records unavailable for the next action. If the records are retained, their own phase gates can be undone and the comparison has a different available interface. If an accurate intermediate output is itself required, (44l) does not meet that earlier requirement automatically. The failure is therefore precise: one-step minimax optimality is not a certificate of optimality for a later-only question under an established relation between successive faults. The inverse-pair relation does the work that separate phase identification would have done. [Danageozian's multi-cycle analysis](https://quantum-journal.org/papers/q-2023-12-04-1195/) likewise motivates retaining relationships between recovery cycles; (44l–m) are the direct elementary calculation for the present family.

The cancellation relation itself has a direct acquisition in this family. Pass a coherent |+⟩ preparation through the actual two-contact sequence D_{z_2}D_{z_1}, rather than combining separate average records. Its survival is f_pair=(1+Re w)/2, where w=z_2z_1 and |w|≤1. Exact f_pair=1 forces w=1 and hence |z_1|=|z_2|=1 and z_2=conj(z_1). Neither individual phase has been identified. For an acquired lower bound 0≤f_L≤1 the final-only answer instead has

    d_⋄(D_w,id)=|1−w|/2 ≤ √(1−f_L).             (44n)

This follows from |1−w|²≤2−2Re w and is tight on the unit circle. Finite agreement does not imply exact unitary factors. It can still admit the whole continuation at a demanded error without calibrating either contact separately. When f_L≥1/2, formula (44e) can alternatively choose a repair at that final boundary; below it, the stated complete-dephasing case applies. The actual composition and its transfer from calibration to use remain required; separate marginal readings do not supply that relation.

**Status and contribution.** Robust recovery against an uncertain channel is an established optimization problem; [Kosut, Shabani and Lidar](https://qserver.usc.edu/wp-content/uploads/2013/07/physrevlett_100_020502.pdf) explicitly consider uncertain noise families and worst-case objectives. Their framework is external context, not a proof of (44c) or of the present acquisition contract. Here the analytical contribution to the current chain is a closed-form recovery from one acquired coherent bound, witnesses against every CPTP alternative, a finite acquisition route, and an explicit limit on reuse. No priority claim, hardware experiment, quantum speedup or new physical law is asserted. The constructor uses established bank/ray relations and actual acquired bounds; it does not receive a nominal assertion that the backend is correct. Exact mathematics, statistical admission, physical access and continued applicability remain distinguishable obligations.

## Detail: §16t. A retained control relation can carry and then release a continuation

### IiS45

**IiS45 (Orthogonal recorded actions turn recovery into discrimination).** IiS44's loss from two independently randomized repairs does not apply when one control record remains available. The supplied continuation suggests reusing that record. The construction below proves its joint return, characterizes exactly what a compressed record must retain, and gives a sharp error for partially distinguishable memory. The question is preservation of a full unknown logical qubit, including its correlations with an untouched reference, not arbitrary history.

Write Ad_U(ρ)=UρU† and d_⋄(A,B)=½||A−B||_⋄. All registers are finite dimensional. The logical bank returns and the actual phase-pair correspondence are those admitted in IiS44. No record or complementary environment beyond the stated input is available to the recovering operation.

**A control bit can return jointly, not just in its marginal.** Use the η=1 paired-phase case of (44l–m). Let U_φ be a diagonal qubit unitary, with its actual inverse U_φ† later in the sequence. Let p=(1+c)/2, 0≤c≤1, and prepare a bit R in τ_p=p|0⟩⟨0|+(1−p)|1⟩⟨1| independently of the incoming data. Apply Z^s after each of the two contacts, using the same retained value s. For every s and φ,

    Z^s U_φ† Z^s U_φ=I.                         (45a)

This follows from Z²=I and [Z,U_φ]=0. Thus the full controlled unitary is I_R⊗I_L. For every input ρ_LE, including entangled data and reference, the final state is τ_p⊗ρ_LE. After the first contact the reduced data channel is D_c Ad_{U_φ}, exactly the local mixture used in IiS44. After the second it is identity. The same controlled identity holds for a coherent initial control state; τ_p specifies the desired reduced first-step mixture.

For c=cos Δ, 0<Δ<π/2, this attains IiS44's first-boundary minimax error and exact return at the second boundary in the stated closed sequence. Two independent bits instead give D_{c²} after the phase pair and final error (1−c²)/2. The separately tested control channels are identical in these two implementations; their multi-contact processes differ. This is an instance of the distinction between channels and networks with memory studied by [Chiribella, D'Ariano and Perinotti](https://arxiv.org/abs/0904.4483).

One bit can serve any number of completed pairs, with different unknown paired phases and with incoming data entangled across pairs. Every completed pair restores the joint factor τ_p and acts as identity on its data. This is not a new bit of uncontrolled error history entering a reset reserve at each cycle. Gate control, reliable storage, and the physical bank-return resources of IiS43 are still required. Intermediate measurement, record leakage or an unadmitted interaction changes the sequence; reduced first-step accuracy is not permission for arbitrary interventions between its two boundaries. Reuse here does not provide the fresh independent secret choices required in IiS42's statistical tests.

**Same marginals can permit either exact recovery or a strict error.** There is a direct obstruction to replacing this joint relation by separate checks on data and memory. Compare the channels

    A(ρ)=pρ⊗|0⟩⟨0|+(1−p)ZρZ⊗|1⟩⟨1|,
    B(ρ)=[pρ+(1−p)ZρZ]⊗τ_p.                    (45b)

Their data marginals agree on every input, including entangled inputs. Their memory marginals are both τ_p. A is exactly repaired by controlled Z. For B, the best recovery error is min(p,1−p), as follows from (45d) below. Thus complete separate knowledge of the two reduced channels still does not establish the ability to recover. The missing content is their actual association with the same control occurrence.

**Exact price of a partially distinguishable quantum record.** Suppose the available record for s=0 or s=1 is respectively a density operator σ_0 or σ_1 on M. For a fixed input-independent choice probability p, the actual available channel is

    N(ρ)=pρ⊗σ_0+(1−p)ZρZ⊗σ_1.                 (45c)

The record states are fixed in the declared use; they are not additional functions of the unknown payload. For every deterministic CPTP recovery R:L⊗M→L, the exact optimum is

    inf_R d_⋄(R N,id)
      = e_* = (1−||pσ_0−(1−p)σ_1||_1)/2.       (45d)

The right side is the binary Helstrom error of distinguishing the two record states with their actual preparation probabilities, an established state-discrimination formula (see [Qiu](https://arxiv.org/abs/0707.3970)). The equality with the optimum recovery error is proved below. It is not a prior over an unknown phase, as in the worst-case witnesses of IiS44.

An explicit attainer measures M with the binary minimum-error test, guesses s, then applies Z^s to the data. If the guess is wrong, one Z remains; if correct, identity remains. The corrected channel is (1−e_*)id+e_* Ad_Z and has half-diamond error e_* by (44d). The test itself follows from D=pσ_0−(1−p)σ_1: choose the positive spectral subspace of D for outcome zero. Its success is (1−p)+tr D_+=(1+||D||_1)/2. A tie subspace may be assigned either way.

For a lower bound against all CPTP recoveries, expand each Kraus operator A_k:L⊗M→L in the Pauli basis:

    A_k=Σ_{μ∈{0,x,y,z}} σ_μ⊗⟨v_{kμ}|,
    Σ_{k,μ}|v_{kμ}⟩⟨v_{kμ}|=I_M.

The second equality follows by taking the partial trace over L in Σ_k A_k†A_k=I_L⊗I_M. Set M_0=Σ_k|v_{k0}⟩⟨v_{k0}| and M_1=Σ_k|v_{kz}⟩⟨v_{kz}|. They obey M_0+M_1≤I_M. The overlap F_e of the recovered half of a maximally entangled input with its ideal return is

    F_e=p tr(σ_0 M_0)+(1−p)tr(σ_1 M_1).

Completing these two operators to a binary test cannot decrease this expression, so F_e≤1−e_*. The ideal entangled-state projector then witnesses trace distance at least 1−F_e≥e_*. Together with the attainer this proves (45d), including arbitrary fixed ancillary systems and arbitrary untouched references.

The operative feature is orthogonality of the possible actions, not their names I and Z. On a d-dimensional full input space let a finite unitary family obey tr(U_j†U_k)=dδ_jk. For the actual mixed channel N_U(ρ)=Σ_j p_j U_jρU_j†⊗σ_j, with fixed input-independent probabilities and retained record states, the same argument gives

    inf_R d_⋄(R N_U,id)=1−P_guess({p_j,σ_j}).     (45d′)

Here P_guess=max_{M_j≥0, Σ_jM_j=I}Σ_j p_j tr(σ_j M_j). To prove the lower bound, complete {U_j†} to an operator basis {B_μ} with tr(B_μ†B_ν)=dδ_μν and expand each recovery Kraus operator as A_k=Σ_μ B_μ⊗⟨v_{kμ}|. The basis completion need not consist of unitaries. Taking the input partial trace of the trace-preserving constraint gives Σ_{kμ}|v_{kμ}⟩⟨v_{kμ}|=I_M. The coefficients on U_j† induce a sub-POVM M_j, and the ideal entanglement overlap is Σ_j p_j tr(σ_jM_j)≤P_guess. For attainment, use an optimal record measurement and invert the guessed U_j. Every wrong residual U_ℓ†U_j has zero trace. Its Choi vector is therefore orthogonal to the ideal maximally entangled vector. The total wrong-guess mass gives trace distance exactly 1−P_guess on that input, and convexity bounds the diamond distance by the same value. This proves the claimed equality in both directions.

For a uniform complete family of d² orthogonal unitary actions and identical retained records, P_guess=1/d². The resulting error 1−1/d² recovers IiS43's complete-mixing obstruction. If this loss occurs in a separately flagged branch of probability η, while the other branch is identity, its exact contribution is η(1−1/d²). Retaining distinguishable records reduces that same obstruction; the two results concern different available joint inputs.

Without action orthogonality, recovery need not require identifying the action to this accuracy. Take equal probabilities, identical records, U_0=I and U_1=exp(−iαZ), with 0<α<π/2. Record discrimination error is 1/2. Yet the midpoint correction exp(iαZ/2) leaves D_{cos α}, with error (1−cos α)/2<1/2. Thus (45d′) is a theorem for a specified relation between actions, not an identification postulate about arbitrary recovery.

Returning to the I/Z pair, for 0<p<1 exact recovery holds iff σ_0 and σ_1 have orthogonal supports. Identical states give error min(p,1−p). For pure records with overlap t=|⟨r_0|r_1⟩|, the two-dimensional spectral calculation gives

    e_*=[1−√(1−4p(1−p)t²)]/2.                  (45e)

For example, p=4/5 and t=3/4 give e_*=1/10; an absent record would give 1/5, and an orthogonal record gives zero. These values follow from exact algebra, not a numerical optimization.

Formula (45c) is a mixture with specified retained memory states. It does not include off-diagonal terms of a full coherent dilation. Keeping the entire unitary interaction and its environment can allow direct inversion; it is a different input from (45c). In particular, reading a program state and coherently undoing a recorded unitary must not be silently treated as the same physical operation.

**Classical corruption and a test that need not identify the memory.** If M is a classical record r with probabilities P(r|s), put a_r=pP(r|0), b_r=(1−p)P(r|1). Then (45d) becomes

    e_*=Σ_r min(a_r,b_r).                        (45f)

Choose the more likely s for each actual record r and invert it. For p≥1/2 an independently flagged erasure with probability ε gives e_*=ε(1−p). A binary symmetric corruption with 0≤ε≤1/2 gives e_*=min(ε,1−p). When ε>1−p, ignoring the received bit is optimal. An unreliable reading is not necessarily useful because it is present. Bit-dependent erasure probabilities ε_0,ε_1 give min(pε_0,(1−p)ε_1), not an unweighted mean erasure rate.

Knowing the full matrices σ_s is sufficient to construct the optimal test but is unnecessary for a useful upper guarantee. Fix an actual binary memory reading. If its acquired misclassification probabilities are u_0 and u_1 on the two actually labelled preparations, then the resulting recovery has exact error

    e_read=p u_0+(1−p)u_1.                      (45g)

Thus an acquired upper bound on that weighted disagreement already certifies a recovery with the same error bound, even if optimality and the full memory channel remain unknown. The label must be tied to the control that was really applied, and the prepared memory must traverse the same admitted storage/readout path. Separate unlabelled memory marginals, or averages from a changed path, do not establish (45g). Finite confidence, drift and control errors require their own budgets. Data need not be measured to test this memory reading. If the actual joint channel differs from (45c) by half-diamond error δ, the Helstrom recovery has sufficient error e_*+δ, capped at one; a fixed reading instead gives e_read+δ, also capped at one. That bound is constructive, not a new sharp optimum for all perturbed channels. A noisy readout generally need not restore the memory's original state for the next cycle.

**How far may the control record be compressed?** For a finite family of known unitary actions U_j on the full input space, suppose a classical record r is retained through weights w_{rj}=p_jP(r|j). Its channel is

    N_U(ρ)=Σ_{r,j}w_{rj} U_jρU_j†⊗|r⟩⟨r|.

Exact deterministic full-input recovery is possible iff

    w_{rj}w_{rk}>0  ⇒  U_j†U_k is scalar.        (45h)

For necessity, each composite Kraus operator of an exact identity channel is a scalar identity. Within a nonempty record fiber, let A be a nonzero Kraus operator of the conditional recovery. Then A U_j is scalar identity for every active j. Since U_j is invertible, the scalar is nonzero, A is proportional to U_j†, and every other active U_k must be proportional to U_j. Conversely, select one representative per fiber and apply its inverse; global phases vanish. This is the full-input-space instance of the correction condition, consistent with [Gregoratti and Werner, Proposition 2](https://arxiv.org/html/quant-ph/0209025).

The minimal exact classical alphabet therefore separates the distinct unitary actions modulo scalar phase, not every different history that implemented them. For I and Z with both probabilities positive it has two symbols. This is a single-use alphabet claim, not an entropy or thermodynamic lower bound. On a proper encoded subspace, or for a smaller family of output questions, fewer distinctions may suffice. For example a Z-basis answer needs no record of a Z phase flip. The full-unknown-qubit criterion cannot be transferred to that question.

**The future computation determines the correcting action.** Suppose a known unitary F occurs after the recorded U_j. A unitary correction V_j at the output realizes F on every input iff

    V_j F U_j=e^{iθ_j}F.

One explicit choice is

    V_j=F U_j†F†.                               (45i)

With that exact representative the full controlled operation is I_R⊗F: the record is returned even if it is coherent. Allowing arbitrary scalar phases in the first equality preserves the data channel, but can rotate relative phases of a coherent record; its return is a stronger statement than classical label return. It requires an admitted coherent controlled implementation. Access only to the individual channels Ad_{U_j} does not establish the relative phases of their controlled implementations.

For U_j=Z^s and F=H, the output correction is X^s, since HZH=X. Repeating Z^s gives the wrong branch action ZHZ when s=1. More generally, a Pauli-only output interface can do this exact unitary correction for both bit values iff FZF† is a Pauli up to scalar phase. The label can remain one bit while the executable action it selects changes. This is the established mechanism of [Pauli frame tracking](https://arxiv.org/abs/1401.5872); (45i) makes the required continuation relation explicit, rather than claiming a new gate calculus.

The partial-record optimum (45d) survives this known computation unchanged. Given a guessed value ŝ, apply FZ^ŝF†. The full branch then acts as FZ^{s⊕ŝ}. Conjugating the output by F† reduces both the attaining recovery and every competing recovery to (45d). Thus transporting the action need not increase the information required of its record, even when F and Z do not commute.

This construction does not by itself transport an unknown noise law. If the actual surrounding faults remain U_φ and U_φ†, inserting F between them gives U_φ† F U_φ even before our random controls. It equals F only under the appropriate commutation relation up to phase. An H generally fails this condition. A new intertwining law, an acquired phase or a different admissible implementation is needed. The old proof of an empty phase pair is not admission of every computation inserted into it. Implementing (45i) also has an actual control cost; it is not granted by writing down the conjugation.

**A sharp final question has its own record-release boundary.** For 0<p<1, discard the record and consider only the output of Ad_F [p id+(1−p)Ad_Z]. The requested final output is the binary projective measurement {Π,I−Π} of the ideal FρF†, with no demand to preserve a quantum output. Some physical binary measurement on the available output gives the exact requested probabilities for every input iff

    [Z,F†ΠF]=0.                                  (45i′)

Indeed, let M be its outcome effect and put M′=F†MF and A=F†ΠF. Exactness for every state is equivalent to

    pM′+(1−p)ZM′Z=A,     0≤M′≤I.

A projector is an extreme point of the interval of effects [0,I]. For a vector in its range, both effects in any strict convex decomposition must have expectation one; for a vector in its kernel, both have expectation zero. Positivity of each effect and its complement then removes cross terms and fixes both effects to A. Consequently M′=ZM′Z=A, proving necessity. If (45i′) holds, the original measurement M=Π attains the answer directly.

For F=H, the sharp output X-basis question survives without the record because its transported question is Z-basis. The output Z-basis question does not, because its transported question is X-basis. Thus the same data and same computation permit release for one requested answer and forbid it for another. This is exact equality of outcome distributions, not prediction of each individual random outcome. An unsharp effect is a different question: it need not be extreme, and rescaled readings such as those in IiS43 can exist without (45i′). Nor does this measurement criterion certify return of the whole logical state or replenishment of the record. For an explicit unsharp counterexample, take p=3/4, F=I and A=(I+X/2)/2. The physical reading M=(I+X)/2 obeys pM+(1−p)ZMZ=A although [Z,A]≠0. The loss of sharpness is therefore a real change in the release question, not just a label.

**Universal data return forces decoupling, but not replenishment.** Let Λ:L→L⊗R be any CPTP implementation with a fixed initial controller and suppose tr_R Λ=id_L on the entire quantum input space. Its normalized Choi state has the pure maximally entangled marginal |Φ⟩⟨Φ|. A joint state with a pure marginal must factor. Channel–Choi correspondence therefore gives

    Λ(ρ)=ρ⊗σ_R   for one fixed σ_R.              (45j)

The same conclusion preserves every reference. Thus absence of payload information in the final record is a consequence of exact universal return, not an extra postulate. Equality σ_R=τ_initial does not follow: a device may transmit the data perfectly while replacing its memory. In (45a) that equality is proved by the full controlled identity, and the resource really is reusable.

Preserving only two orthogonal basis states does not imply (45j). A CNOT from the data into an initially zero record preserves both basis states and copies their label, but dephases superpositions on discarding the record. Nor does an unchanged record marginal prove decoupling: after a first controlled Z on |+⟩, the record remains τ_p while it is correlated with |+⟩ or |−⟩. The correlation disappears only after the matching controlled inverse. Approximate data return does not establish exact record independence or exact resource reset.

**Scope.** The construction provides a finite repeated continuation, a necessary retained distinction, its exact loss penalty, and a rule for transporting the recorded action through admitted computation. It does not construct a general autonomous flow, infer stable storage from a label, or produce a controller from no physical resources. Environment-assisted recovery, Pauli tracking and quantum processes with memory are established subjects. The analytical results here connect those mechanisms to the particular IiS43–44 continuation and its actual available inputs; priority and hardware implementation are not asserted.

## Detail: §16u. A history may be compressed only relative to its continuation

### IiS46

**IiS46 (The retained decision must compose with the actual joint law).** IiS45 characterizes a retained record for one net action. The supplied continuation observes that many histories may have that same action. Here this gives an optimal sequential construction, a sharp obstruction to composing local error figures, and a criterion for safe compression. A small Pauli interface then selects different sufficient records for different final questions by one set of derived rules.

All spaces and histories below are finite. A history h has actual probability p_h and retained quantum record state σ_h, independent of the unknown logical input. The available channel is a classical mixture over histories with those records. Coherent interference between histories, input-dependent branch probabilities and inaccessible additional records are different contracts. The error d_⋄ is the half-diamond distance of IiS45; guarantees for binary questions use a separately defined measure.

**The net action, not every event, determines the recovery question.** For a sequence of recorded Z^{s_j} actions with no intervening noncommuting gates, write b(h)=s_1⊕…⊕s_m. Put

    A_b=Σ_{h:b(h)=b}p_h σ_h,
    D=A_0−A_1,       tr(A_0+A_1)=1.

The actual available channel and its exact recovery error are

    N(ρ)=ρ⊗A_0+ZρZ⊗A_1,
    e_end=(1−||D||_1)/2.                         (46a)

This is (45d) with subnormalized record operators; it includes zero-weight parity classes and arbitrary correlations among histories and their final records. An optimal binary reading of D followed by the guessed inverse attains the optimum. Different histories inside one parity class do not require different corrections at this boundary. Their other consequences have not thereby been equated.

**Independent record pairs admit an optimal sequential construction.** Assume now independence of the complete pairs (S_j,M_j), with P(S_j=0)=p_j and conditional record states σ_{j,0},σ_{j,1}. The full record is their tensor product, with no later unaccounted interaction. Let

    D_j=p_jσ_{j,0}−(1−p_j)σ_{j,1},
    e_j=(1−||D_j||_1)/2.

Expansion by parity gives D=⊗_jD_j. Singular values of a tensor product are all products of the singular values of its factors, so

    e_end=[1−∏_j(1−2e_j)]/2.                    (46b)

More than a scalar composition law follows. Read each record with its own Helstrom test and XOR the guesses into one working bit. The sign of a nonzero eigenvalue of ⊗_jD_j is the parity of the negative signs of its factors. Therefore this sequential reading is an optimal reading of D; joint quantum measurement cannot improve it in this independent model. Zero eigenspaces may be assigned arbitrarily. A constant optimal decision may require no stored bit.

The construction uses at most one reliable accumulator in addition to the incoming record and its admitted reading. It does not make erasure of spent records or reset of the accumulator free. Nor does it preserve every later question about the histories. For equal 0<e_j=e≤1/2, e_end tends to 1/2 as m grows. Compact working memory is compatible with a deteriorating continuation guarantee. When two controls share a nondegenerate random bit, their net parity is zero; independence and (46b) do not apply to that pair. A shared deterministic bit is independent and also gives zero in (46b).

**Complete local channels do not determine the error of their join.** Let S_1,S_2 be independent uniform control bits. Retain R_j=S_j⊕N_j, where the noise vector (N_1,N_2) is independent of the controls, has Bernoulli marginals e_j≤1/2, and can have arbitrary internal correlation. Each complete local record channel is the same binary symmetric channel with error e_j. The entire unconditioned record R_1R_2 is also uniform for every such coupling.

For a fixed joint noise law, let t=P(N_1=N_2=1) and f=e_1+e_2−2t. Given the records, net control parity differs from reported parity with probability f. IiS45 gives exact error min(f,1−f). The feasible interval 0≤t≤min(e_1,e_2) implies

    e_end ranges over
    [|e_1−e_2|, min(e_1+e_2,1/2)].              (46c)

Every value is attained. Indeed f ranges over [a,b] with a=|e_1−e_2|, b=e_1+e_2; a≤1/2 and 1−b≥a, so the continuous map f↦min(f,1−f) has exactly the displayed image.

For e_1=e_2=1/4, the same local channels permit:

| Noise coupling | Joint probabilities | Exact final error |
|---|---|---|
| Same noise bit | P(00)=3/4, P(11)=1/4 | 0 |
| Independent noise bits | Product of Bernoulli(1/4) marginals | 3/8 |
| Mutually exclusive errors | P(00)=1/2, P(10)=P(01)=1/4 | 1/2 |

Choosing the optimal parity reversal in min(f,1−f) requires the joint law. If only these local BSC laws are established, the exact minimax guarantee over all their allowed couplings is instead

    inf_R sup_couplings d_⋄(R N,id)
       =min(e_1+e_2,1/2).                       (46d)

For e_1+e_2≤1/2, XOR the records: its error f never exceeds their sum. For a larger sum, a fair random parity correction gives complete dephasing and error 1/2. These upper bounds are tight: choose f=e_1+e_2 in the first case and f=1/2 in the second. Both couplings are feasible, and (46a) bounds every CPTP recovery for that witness, not just the XOR rule.

For arbitrary joint records in distinct accessible registers, simultaneous local optimal readings retain their marginal errors. XOR and the union bound give the sufficient guarantee min(1/2,Σ_j e_j), without independence. The lower endpoint in (46c) is specific to its stated BSC/noise model, not universal.

**Even lossless local compression need not preserve a continuation.** Take independent uniform S_1,S_2 and an independent noise bit K with P(K=1)=e, 0<e≤1/2. Retain

    M_1=(S_1,K),       M_2=S_2⊕K.               (46e)

Local optimal errors for the two controls are 0 and e. Nevertheless, S_1⊕K⊕M_2 recovers net parity exactly. If K in the second record is replaced by an independent copy K′, both complete local record channels are unchanged, and so is the unconditioned joint record distribution. The optimal parity error becomes e.

Now consider compression M_1↦S_1 in the original coupled system. Every local question about S_1 is preserved: from S_1, adjoining a fresh independent Bernoulli(e) bit reproduces the full local channel M_1|S_1. Yet this compression changes the joint parity error from zero to e. Regenerating the same local distribution does not regenerate its association with M_2. Thus equivalence for every local source question is still insufficient for replacing that record inside this joint continuation. This does not forbid compression; it identifies which contextual relation must survive.

**Exactly which memory processing preserves the current optimum?** Let Λ be one common CPTP channel acting on the available memory in (46a), and write D=D_+−D_- for its positive and negative parts. Then ||Λ(D)||_1≤||D||_1, so processing cannot improve the best recovery error. It preserves that optimum iff

    supp Λ(D_+) ⟂ supp Λ(D_-).                  (46f)

Equivalently, there is an output effect 0≤Q≤I whose pullback X=Λ*(Q) acts as identity on supp D_+ and zero on supp D_-. To prove it, observe

    tr D_+−tr(DX)
      =tr[D_+(I−X)]+tr(D_-X)≥0.

Equality holds exactly under those support conditions. An optimal output effect attains equality iff output discrimination retains the input optimum. Existence of such an output effect is equivalent to orthogonality of the two positive output operators in (46f). The action on ker D is irrelevant to this decision; positivity of X and I−X removes cross terms with the fixed eigenspaces.

In particular, the binary Helstrom reading with P_+ the projector onto supp D_+ maps a record operator T to

    H(T)=tr(P_+T)|0⟩⟨0|+tr[(I−P_+)T]|1⟩⟨1|.

It sends D to tr D_+|0⟩⟨0|−tr D_-|1⟩⟨1|, preserving its trace norm. At most one classical bit therefore retains the full current binary recovery optimum, even if the original memory is quantum and high dimensional. This is an acquired decision, not necessarily the true control bit. Its construction requires access to the appropriate reading; existence is not free calibration. It does not reconstruct the original record states. Any added signal dependent on the actual history changes the available input and is not common postprocessing of the old record.

The preparation weights matter. For a purely classical example, take conditional record distributions

    P(r|0)=(1/2, 2/5, 1/10),
    P(r|1)=(1/10,1/5, 7/10).

At p=1/2 the optimal binary reading groups the first two symbols; its error, before and after compression, is 1/5. If the actual preparation probability changes to p′=1/4, the uncompressed record still permits error 1/5, but the compressed record permits only 1/4. The optimal sums of minima are respectively 3/40+1/10+1/40=1/5 and 9/40+1/40=1/4. Thus even a newly chosen decoder cannot reuse the old compression with the old strength. This is a changed ensemble, not a changed opinion about unchanged physical probabilities.

**A finite set of continuation rules can select the needed record.** Allow known single-qubit gates H and S=diag(1,i), and recorded phase flips Z^s. Write the current actual unitary as P_ab F up to scalar phase, where F is the ideal computation and P_ab=X^aZ^b. Starting at (a,b)=(0,0), the output frame updates as

    H:       (a,b)↦(b,a),
    S:       (a,b)↦(a,a⊕b),
    Z^s:     (a,b)↦(a,b⊕s).                     (46g)

HZH=X, HXH=Z, SZS†=Z and SXS†=Y prove these updates; induction on the admitted sequence proves the final action P_ab F. Thus two accumulated parity expressions suffice for every history in this interface, irrespective of its length. Two working bits suffice to update their values when actual control values are available. Symbolically naming two parities of unread controls does not acquire those values or compress their physical records; their expressions may still grow. Scalar phases are ignored for this incoherent history mixture; coherent control of histories can require their phases as additional content. These are standard Pauli-frame mechanisms, consistent with [Chamberland, Iyer and Poulin](https://arxiv.org/abs/1704.06662), not a new gate set.

Group the actual records by final frame: A_ab=Σ_{h:frame(h)=(a,b)}p_hσ_h. Full quantum return relative to F requires a four-way decision, with exact optimum 1−P_guess({A_ab}) by (45d′). No recovery of every history is required. A given family may occupy fewer than four frames.

For just the binary Pauli-projective question Q, define its sign bit χ_Q(a,b): it is b for Q=X, a for Q=Z, and a⊕b for Q=Y. Set A_c^Q=Σ_{χ_Q(a,b)=c}A_ab. The exact best worst-case error in the requested outcome probability is

    inf_{binary POVM M on data+memory} sup_ρ
      |P_M(+|actual ρ)−tr[Π_Q FρF†]|
      =[1−||A_0^Q−A_1^Q||_1]/2=:e_Q,
    Π_Q=(I+Q)/2.                                (46h)

For necessity, choose logical inputs whose ideal outputs are the two Q eigenstates ρ_+,ρ_-. Their actual outputs are ρ_+⊗A_0^Q+ρ_-⊗A_1^Q and the swapped expression. Their trace distance is ||A_0^Q−A_1^Q||_1. Their equal-prior discrimination error therefore lower-bounds the worst probability error by e_Q. For attainment, read the sign bit with its optimal memory test, measure Q on the data and relabel the result by that guess. For ideal outcome probability q the actual probability is e_Q+(1−2e_Q)q, whose worst discrepancy is exactly e_Q.

Exactness with memory holds iff A_0^Q and A_1^Q have orthogonal supports. If memory is unavailable before reading or correcting, exactness holds iff one sign class has zero total weight. All active frames may commute or all may anticommute; the latter uses a fixed outcome relabeling. Reading the relevant memory first and then releasing it is a different valid route. This one-copy physical-POVM criterion does not rule out statistical estimation with many copies and estimators that are not themselves outcome probabilities.

The same rules distinguish multiple exits of one example. Let Z^{s_1} occur, then H, then Z^{s_2}, with independent uniform controls. The final frame is (a,b)=(s_1,s_2). If only their parity k=s_1⊕s_2 is retained, the resulting guarantees are

| Required final output | Record needed by the rule | Optimum with only k |
|---|---|---|
| Full unknown logical state after H | Frame (a,b) | Half-diamond error 1/2 |
| X-projective answer after H | b | Probability error 1/2 |
| Z-projective answer after H | a | Probability error 1/2 |
| Y-projective answer after H | a⊕b=k | Exact probabilities |

For full return, each known k leaves two equally likely orthogonal Pauli actions, giving error 1/2. Each of a,b is individually independent of k, whereas the Y sign is k itself. A one-bit parity that sufficed for an uninterrupted Z chain therefore does not automatically suffice after an inserted H, yet remains exact for one declared final question. Keeping the two frame bits permits exact full return in this example.

**Scope and constructive content.** Equations (46g–h) are a bounded procedure: transport the two parity expressions through admitted contacts, select the frame or the sign demanded by the final output, group the actual available record by that decision, and retain a reading achieving its claimed bound. This is a mathematical constructor and worked execution of its rules, not an implemented hardware scheduler or proof that the joint record law is available from local calibrations. In particular (46c–e) prohibit that shortcut. The history quotient, acquired reading, execution cost and later applicability must be related to the same continuation. No priority claim or new physical dynamics follows from these finite models.

## Cross-page mentions

Labels mentioned here: <doc:interference_is_substitution__models_calibration#IiS12>, <doc:interference_is_substitution__models_calibration#IiS13>, <doc:interference_is_substitution__support_memory#IiS42>, <doc:interference_is_substitution__support_memory#IiS43>.
