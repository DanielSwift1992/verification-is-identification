# Interference Is Substitution (Wave) — Acquired programs

This part contains the original derivations for acquired programs.

Family and original section headings: <doc:interference_is_substitution>.

Section setting: <doc:interference_is_substitution#16l-Acquiring-the-relation-that-the-next-control-needs>.

## Detail: §16l. Acquiring the relation that the next control needs

### IiS37

**IiS37 (Retained comparisons reduce configuration acquisitions).** Keep IiS34's fixed linear device, repeatable training preparations, admitted two-mode G contacts and mode-resolved power access. A probe setting below means one identity configuration, or one temporary two-mode rotation followed by restoration. It can read all output powers. It is not one photon or an assertion of exact finite-sample statistics. Committed rotations and preparation launches are separate resources.

Let a fixed positive training mixture have full support on an r-dimensional subspace N of Cᵈ, and let m=d−r outputs be read. The r(d−r)-rotation controller can be acquired using at most

    1+r(r−1)+2r(d−r)

mixed probe settings, before independent final admission.

*Construction.* The initial identity setting reads all d diagonal powers. Acquire both quadratures of each pair among the r unread outputs, costing r(r−1) further settings. At a read stage, only the r complex comparisons between the current read output and those unread outputs remain to be acquired. The current read output has not been touched by previous stages; its diagonal is still the initial acquired diagonal. These 2r settings complete the local (r+1)-mode matrix. Choose a kernel row and implement it with r G contacts, as in IiS34. Transport the acquired local matrix through that known word and retain its unread r×r block. This is the actual block required at the next stage. No already acquired unread pair has to be measured again. Counting the initial block and all read stages gives the formula. Positive full support makes a zero mixed reading zero on every trained direction. ∎

This construction uses the actual common source and actual known transition between readings. Identical names on unrelated blocks would not implement the transport. A unitarily transported matrix error has the same operator norm, and compression to the unread block cannot increase it; new acquisition errors still enter when new rows are added. Exact reuse is not a claim that uncertainty disappears on later stages.

In C⁴ with r=2 this gives eleven mixed settings instead of fourteen, while keeping the four committed rotations. If the mixture is implemented by two separate pure launches at each setting, the corresponding upper counts are twenty-two and twenty-eight launches. These counts do not include preparation, actuator restoration, power integration or final admission.

**Uniform training reduces the four-mode count further, to nine.** Now retain the stronger current contract C=P/2, where P is the rank-two orthogonal projector onto the actual transformed training plane. Acquire the first triple (0,2,3) in seven settings, with the identity also reading mode 1. Implement the two G contacts making the whole training plane dark at mode 0. The known first triple transports exactly through those contacts; mode 1 is untouched.

On the remaining modes (1,2,3), the actual projector has the form

    P_R=I₃−ww†,       ‖w‖=1.

The transported unread block therefore supplies

    B=I₂−(P_R)_{ {2,3},{2,3} }=b b†,
    b=(w₂,w₃),       q=‖b‖²,
    |w₁|²=1−q.

If q=0, mode 1 is already dark. If q=1, w=(0,b) is known up to an irrelevant common phase. Otherwise choose j∈{2,3} maximizing Bⱼⱼ, so Bⱼⱼ≥q/2>0. Fix the common phase by taking bⱼ=√Bⱼⱼ and reconstruct b=B eⱼ/√Bⱼⱼ. Two balanced settings on (1,j), with phases 0 and π/2, acquire the one complex entry (P_R)₁ⱼ. They determine

    w₁=−(P_R)₁ⱼ/√Bⱼⱼ.

The normalized row w† is then implemented by the two final G contacts on (1,2),(1,3). Mode 0 is untouched. Thus all of N is dark on the read pair, and the complete readout is the target Π. The count is at most seven plus two mixed settings and four committed rotations for every initial U, including the branches where fewer settings or identity contacts suffice. No hidden source matrix is an input to the controller.

Nine is a constructive upper bound for this entire procedure, not a proved global minimum of all possible acquisition strategies. The shortcut from eleven to nine uses a uniform mixture and unitarity: a general rank-two mixed matrix on three modes is not necessarily proportional to I−ww†. The broader eleven-setting construction does not need this special spectrum.

**The uniform method can tolerate moving individual profiles.** The fixed full upstream unitary can be weakened for the nine-setting construction. Suppose the actual unitary U_t may change between trials, but U_t N=L for one common r-dimensional output subspace L. At each trial the conditional input training state is Π_N/r, independently of the currently selected U_t. Then

    U_t(Π_N/r)U_t†=Π_L/r

for every t. Thus the acquired mixed covariance is the same even though the image of every individual pure training vector may move. The controller acquires and nulls L. Once W maps L to the unread outputs, unitarity gives

    U_t† W† D W U_t=Π_{N⊥}

for every such t, including later use. No fixed internal frame on N or N⊥ is required. The general r-dimensional retained-block construction also applies to this common uniform covariance.

This conditional preparation relation matters. Cycling through pure inputs while the device changes in a way correlated with that cycle does not automatically produce Π_L/r. Nor can one replace a common L by an arbitrary varying plane. Both changes can destroy the shared covariance used by the acquisitions.

The twelve-pure-setting method in IiS38 has a different requirement: its successive pair readings must describe a repeatable coherent profile. To see the difference, allow one pure input to sweep through two orthogonal outputs spanning L. Its acquired two-mode covariance can have positive determinant, so no one two-mode rotation nulls it, by IiS36's local control floor. Yet the common mixed plane still has a null row in each appropriate (r+1)-mode block, and the mixed method remains applicable. Fewer pure launches therefore does not dominate the mixed method over these distinct source-stability contracts. Keeping the needed subspace can be enough when keeping each preparation's output is impossible or unnecessary.

**Adaptation saves real answers even against arbitrary fixed linear readings.** The nine-setting procedure identifies the whole unknown rank-two projector P in C⁴: its known final word W determines P=W†(I−D)W. It acquires at most eleven new real expectation values: three diagonal powers after the known trace relation, six first-triple quadratures and two final adaptive quadratures.

By comparison, fourteen scalar linear readings are necessary and sufficient to identify every such P if all the readings are fixed before any answers are obtained, even when arbitrary positive measurement effects are allowed. These are scalar expectation counts, not numbers of detector configurations or individual particles. The adaptive procedure's nine settings and eleven scalar values are different resource counts.

For necessity, the real space of trace-zero Hermitian four-by-four matrices has dimension fifteen. At most thirteen fixed scalar readings leave a kernel of dimension at least two in this space. On the unit circle of any two-dimensional kernel plane the odd continuous function X↦tr(X³) must vanish somewhere. For that nonzero X, tr X=tr(X³)=0 makes its characteristic polynomial even, by Newton's identities. Its real eigenvalues therefore come in pairs a,−a,b,−b. Scale so |a|,|b|≤1. In each corresponding two-space the two rank-one projections

    P_a=(1/2)[[1+a,√(1−a²)],[√(1−a²),1−a]],
    Q_a=(1/2)[[1−a,√(1−a²)],[√(1−a²),1+a]]

differ by diag(a,−a). Direct sums for a,b and conjugation by the eigenbasis of X give distinct rank-two P,Q with P−Q=X. All the fixed readings agree on them. A predetermined list of thirteen or fewer linear answers cannot identify every plane.

For sufficiency, choose fourteen orthonormal trace-zero Hermitian directions spanning the orthogonal complement of

    Z=diag(3,−1,−1,−1)

inside the trace-zero space. Read those directions along with the already known trace. They leave only the ambiguity P−Q=tZ. But every difference of equal-rank projections has

    tr((P−Q)³)=tr P−tr Q−3tr(PQ)+3tr(PQ)=0,

whereas tr((tZ)³)=24t³. Thus t=0. Each chosen direction B can be implemented as a positive effect I/4+sB with sufficiently small known s>0; the fixed trace removes its constant contribution. This proves the exact fourteen-scalar bound in the stated broad fixed-linear interface.

The construction also supplies a stable inverse, as follows. Let E be the Frobenius-orthogonal projection onto these fourteen directions. For X=P−Q, the paired eigenvalues give |X₀₀|≤‖X‖_F/√2. Since ⟨Z,X⟩=4X₀₀ and ‖Z‖_F²=12,

    ‖E(X)‖_F²≥‖X‖_F²/3.

Accordingly two projectors whose fourteen-coordinate records differ by at most η in Euclidean norm differ by at most √3η in Frobenius norm. Physical conversion to the chosen positive effects also includes their known scaling s. An exact answer-count saving therefore does not by itself prove a saving in photon count or precision; the two procedures have different conditioning and different physical configurations.

There is no contradiction with the adaptive eleven-answer construction. The later linear functionals depend on earlier acquired answers, so there is no single fixed measurement kernel on the whole family to which the preceding impossibility applies. Neither eleven adaptive scalar answers nor nine mixed settings have been proved minimal. The general distinction between model dimension and globally sufficient fixed measurements is established in [Heinosaari, Mazzarella and Wolf](https://arxiv.org/abs/1109.5478); the explicit paired-spectrum argument above supplies the stated four-mode comparison, without claiming priority for constrained tomography.

**Identifying the promised family and excluding other positive states have different costs.** The fourteen fixed readings above identify P/2 among normalized rank-two projectors. They need not identify it among all density matrices. For example, with P=diag(1,1,0,0), every

    σ=P/2−tZ=diag(1/2−3t,1/2+t,t,t),  0<t<1/6,

is a different full-rank state with the same fourteen readings.

For the stronger fixed-linear task—every P/2 must be distinguished from every other positive trace-one matrix—the exact minimum is fifteen scalar expectations. Any smaller fixed list has a nonzero trace-zero Hermitian kernel element X. Change its sign if necessary so that X has at most two negative eigenvalues. Choose a rank-two P commuting with X whose range contains every negative eigenspace. Then P/2+tX is a different density matrix for all sufficiently small t>0, yet gives the same readings. Fifteen independent trace-zero directions attain the bound by determining the whole Hermitian matrix with its known trace.

This distinction is established in the literature on complete and strictly complete tomography, including [Baldwin, Deutsch and Kalev, Section II](https://arxiv.org/pdf/1605.02109). Here the target family is specifically the equal-eigenvalue rank-two states, and the fixed bound is uniform over every member, without an excluded set of exceptional targets.

**Twelve adaptive scalar expectations suffice for the stronger task.** Modify the first step of the nine-setting procedure. After the initial diagonal reading, omit a coordinate j with smallest P_jj, inferred as twice its normalized power. Its value is at most 1/2. Let A be the other three coordinates, and acquire their six real cross quadratures. These initial readings contain nine independent real expectations and determine the full compression C_A of C=P/2.

The restriction T:range P→C^A has

    T†T=I−(P e_j)(P e_j)†  on range P,
    λ_min(T†T)=1−P_jj≥1/2.

In particular C_A has rank two. Apply the same completion procedure as above to obtain the known candidate P, using at most two further quadratures. The change of omitted coordinate does not require a physical permutation: A contains at least one of the two designated read outputs; null that output first, then send the remaining null row to the other designated read output with two contacts on the remaining three modes. The known anchor block can include that second output before it is nulled. Thus the four-contact interface and the acquisition count are unchanged.

Finally acquire one additional scalar expectation of K=I−P, by reading the completed controller. On a target C=P/2 this value is zero. If any positive trace-one σ gives the same whole adaptive record, this last equality forces σ=PσP: positivity turns a zero expectation of I−P into absence of support outside P. The initial record also fixes σ_A=C_A. Since T is injective, its left inverse then gives σ=P/2. No rank, flat spectrum or upper eigenvalue bound has been imposed on this competing σ. The original program may use the promised family to propose P; the extra acquired relation certifies the proposal against the larger positive class. If no candidate matches the acquired relations, the construction does not declare that the actual source has the promised form.

The total is at most twelve adaptive real expectations, implemented by at most ten mixed probe configurations in the stated interface: one initial power configuration, six first-block quadratures, at most two completion quadratures, and one final sum of powers. This twelve is not the twelve pure training configurations of IiS38. It is an upper bound for this stronger identification task, not a proved adaptive minimum. No photon-count saving follows without an accuracy and sampling analysis.

**The extra relation has a uniform finite-error version.** Let P now be any known rank-two candidate, and choose its omitted j so P_jj≤1/2. For an arbitrary positive trace-one actual state σ, suppose acquired bounds establish

    tr((I−P)σ)≤η,
    ‖σ_A−(P/2)_A‖≤κ.

Then the trace distance obeys

    (1/2)‖σ−P/2‖_1 ≤ min(1,3√η+2κ).            (37a)

More generally, if the acquired coordinate choice has γ²=1−P_jj>0, the right-hand expression before clipping is (1+γ^(−2))√η+κ/γ². Thus a noisy initial choice can use the actual candidate's γ, rather than asserting an exact pivot bound that the acquired record did not supply.

For a proof, write δσ=σ−PσP. Decompose σ into pure states. For a pure component with outside weight a, the trace norm of its difference from the unnormalized projection is √(4a−3a²)≤2√a. Convexity of trace norm and concavity of the square root give ‖δσ‖_1≤2√η. Let J restrict to A and let L:C^A→range P be the left inverse of T. Then LJP=P and ‖L‖≤1/γ. With Δ_A=σ_A−(P/2)_A,

    σ−P/2 = δσ−LJ δσ J†L† + L Δ_A L†.

The first two terms have total trace norm at most (1+γ^(−2))2√η. The last has rank at most two and operator norm at most κ/γ², hence trace norm at most 2κ/γ². Divide by two; γ²≥1/2 proves (37a).

The same argument applies to any known trace-one candidate ρ₀ supported on a rank-r projector P. For a coordinate restriction J injective on range P with smallest singular value γ>0, an acquired outside weight η and compression error ‖JσJ†−Jρ₀J†‖≤κ imply

    (1/2)‖σ−ρ₀‖_1
      ≤min(1,(1+γ^(−2))√η+rκ/(2γ²)).

The rank used in the last trace-norm estimate is that of the known candidate support, not a promised rank of the actual σ. Thus the mechanism is an acquired support relation plus an injective reading on that support; the four-mode counts are one application.

The quantities η and κ are acquired bounds, not exact zeros declared by a fitting routine. For an estimated first block C̃_A, one may take κ=‖C̃_A−(P/2)_A‖+e₀, using its established operator error e₀. If the realized final effect differs from I−P in operator norm by at most e_K, an upper event-probability reading q_U gives η≤min(1,q_U+e_K). Statistical failure budgets for these bounds also remain part of the certificate. The same actual state must underlie the compared readings, or an established transfer must provide them for that state; arbitrary drift is not removed by positivity.

**A particular question can need less than the full-state bound.** Let F be the desired Hermitian observable and H a proposed reading of the compressed record JσJ†. Put

    D=F−J†HJ,       P D P=0.

The equality is the content that makes the proposed reading correct on the candidate support. With a=tr((I−P)σ), positivity gives

    |tr(Fσ)−tr(H JσJ†)|
      ≤2‖P D (I−P)‖√(a(1−a))
          +‖(I−P)D(I−P)‖ a.                    (37b)

Indeed the off-diagonal block of a positive state has trace norm at most √(a(1−a)); factor the positive block matrix and apply the Hilbert–Schmidt Cauchy–Schwarz inequality. Pair it with the off-diagonal block of D, and bound the remaining positive block by its trace a. This proves (37b). For only an upper bound a≤η, the always valid simpler right-hand side is 2‖P D(I−P)‖√η+‖(I−P)D(I−P)‖η. An acquired record error adds its own term, for example ‖H‖_1κ for compression operator error at most κ.

If D also has no block between P and its complement, only the linear leakage penalty remains. When that block is present, a square-root penalty can be necessary: in two dimensions, take P=|0⟩⟨0|, D=|0⟩⟨1|+|1⟩⟨0| and the pure state with amplitudes √(1−a),√a. Its missing comparison is exactly 2√(a(1−a)). For D=I−P the missing answer is instead exactly a. Thus the error required by the downstream question is not determined solely by how much total power was omitted. The remaining cross relation determines whether the question incurs an amplitude or a population penalty.

A nonzero error bound does not certify exact rank: the full-rank states σ_z=(1−z)P/2+zI/4, 0<z<1, have η=z/2 and κ=z/4 and approach P/2 arbitrarily closely. Formula (37a) certifies a distance relevant to subsequent readings, not absence of every additional occupied direction.

Full state identification is an optional stronger question. A controller can already be applicable from its acquired support leakage and phase-family floor. The present completion does not make tomography a new prerequisite for IiS38 or IiS40.

**Free output-coordinate phases do not reduce the retained minimum.** IiS34 excluded extra free controls from its lower-bound contract. For diagonal phase screens in the same output control bank, that restriction can be removed. For D=diag(e^{iθ₀},…,e^{iθ_{d−1}}),

    D Gᵢⱼ(c,s,φ) D†=Gᵢⱼ(c,s,φ+θᵢ−θⱼ).

An arbitrary word with k G contacts and arbitrarily many such screens can therefore be rewritten D_total V, where V contains only k G contacts. The final coordinate read projector commutes with D_total, so the complete input power effect is unchanged by discarding that screen. The set of attainable readout effects with k contacts is exactly the former set. The lower bound r(d−r) and its attaining construction survive these free phase controls. This does not cover controls inserted before the unknown device, additional mixing operations or questions about coherent output phases relative to an external continuation.

**The remaining phase has an exact action-dependent query price.** After the first exact nulling stage, suppose the acquired block has 0<q<1. Write b=√q u, with u a known unit vector in modes 2,3. All remaining compatible null directions are

    w_φ=√(1−q)e^{iφ}e₁+√q u,       φ∈R/(2πZ).

For a normalized final read row v† in these three modes, the remaining total null leakage is

    L(v,φ)=v†P_R(φ)v=1−|w_φ†v|².

It is twice the power of the uniform training mixture in that single output. It is already the contribution to IiS34's δ, not an extra normalization of δ.

With no phase acquisition,

    min_{‖v‖=1} max_φ L(v,φ)=min(q,1−q).

For a proof, discard any component of v outside span{e₁,u}: it can only reduce every overlap. A relative phase can always make the cross term nonpositive, so the largest guaranteed squared overlap is max(q,1−q). It is attained by v=e₁ or v=u. The apparatus can therefore meet any tolerance at least this large without learning the remaining phase.

If a strictly smaller uniform tolerance is required, two restored single-pair probe settings are necessary and sufficient in the worst case. Every such setting depends on φ through at most one real sinusoidal contrast. The two output powers of its mixed pair have a fixed sum, while all other powers are unchanged. A zero contrast leaves two antipodal phase alternatives. Their null vectors have overlap magnitude |1−2q|. No common normalized row has guaranteed squared overlap larger than

    (1+|1−2q|)/2=max(q,1−q).

Indeed the average of the two rank-one projectors has that largest eigenvalue, bounding the smaller of the two overlaps; the bound is attained. Thus one setting cannot improve the zero-query worst-case tolerance. Two quadratures of a nonzero anchor identify φ and attain zero leakage. Adaptivity does not avoid this one-query transcript. This proves a zero-or-two worst-case query price for the specified tolerance task and specified single-pair interface, not for simultaneous multi-pair measurement architectures.

An individual first answer can nevertheless justify stopping. If it leaves two null vectors w₊,w₋, their exact best common leakage is (1−|w₊†w₋|)/2. A normalized, phase-aligned sum of the vectors attains the bound; if their overlap vanishes, take their equally weighted sum. Whether the second query is needed is consequently a question about this acquired branch.

**A phase interval can specify the best action without specifying the phase.** Suppose the remaining phase is known only to lie in an arc |φ−φ₀|≤a, with 0≤a≤π. Its exact minimax leakage is

    R(q,a)=(1−√(1−4q(1−q)sin²a))/2,    0≤a≤π/2;
    R(q,a)=min(q,1−q),                  π/2≤a≤π.

For a≤π/2, absorb φ₀ into the first coordinate and choose v from the top eigenvector of

    [[1−q, √(q(1−q)) cos a],
     [√(q(1−q)) cos a, q]].

Its components can be chosen nonnegative. The two endpoint phases minimize its overlap, and the top eigenvalue gives 1−R. No other phase of v improves the smallest cosine over the arc. For a≥π/2 that smallest cosine is nonpositive for every phase choice, and a single known component attains the optimal max(q,1−q) overlap. This also proves optimality among complex rows and rows with a third orthogonal component.

**Weak phase information need not make the action unstable.** Keep the preceding block exact, and suppose the acquired complex anchor h=w₁ conjugate(bⱼ), with j chosen as above, has error at most e in modulus. Its true modulus is

    H=√((1−q)|bⱼ|²).

For e<H, the measurement disk confines φ to an arc of half-width at most arcsin(e/H). The minimax row just constructed gives

    L≤2q(1−q)e²/H²≤4e².

The first inequality follows from (1−√(1−x))/2≤x/2 for 0≤x≤1. For e≥H, choose the phase-independent row instead. Then

    L≤min(q,1−q)≤2q(1−q)≤4H²≤4e².

There is also a sharp uniform bound, rather than only that quadratic envelope:

    F(e)=(1−√(1−8e²))/2,    0≤e≤1/(2√2);
    F(e)=1/2,              e≥1/(2√2).

For e<H the arc formula gives L≤F(e), using |bⱼ|²≥q/2. For e≥H, put t=min(q,1−q). Then t(1−t)=q(1−q)≤2e², implying t≤F(e) on the first range; on the second range a known-component row always gives L≤1/2. For attainment on the first range choose q≤1/2 with q(1−q)=2e² and |b₂|²=|b₃|²=q/2. Now H=e and the record h=0 leaves every phase possible, forcing leakage q=F(e). At and above e=1/(2√2), use q=1/2. Thus this is the exact worst-case minimax guarantee over the known-block families and admissible complex-error records. The coefficient four in the simpler bound is attained at that transition. This concerns one complex acquired-error disk; different error geometry gives a different sharp formula. The phase angle itself can be arbitrarily unstable as H→0. Its weight in the required action supplies the missing control. Errors in the earlier block are not included in this last bound.

**Nine settings also admit an end-to-end finite-error bound.** The following conservative controller avoids dividing by a nearly vanishing phase reference. Let every newly read scalar power have absolute error at most ν. Suppose the first acquired local matrix has operator error at most e₀; direct reconstruction gives the available choice e₀=(1+4√2)ν. Use an exact minimum-Rayleigh row and exact pair-local unitary synthesis at the first stage. Then the actual first read leakage t=P₀₀ satisfies

    t≤t₀=min(1,4e₀).

On the remaining three modes a rank-two projection P has the compression form

    P_R=I₃−Q−t uu†,
    Q=ww†,     ‖w‖=‖u‖=1,     w†u=0.

For 0<t<1, the projection block equations give eigenvalues 1,1−t,0 for P_R: its coupling to the first coordinate is an eigenvector of eigenvalue 1−t. The endpoint cases follow directly; when t=1 any orthonormal pair in the complementary two-space can be used for w,u. Thus this decomposition exists without selecting a stable eigenvector from noisy data.

Transport the first local estimate through the known committed word and retain its two-mode block C̃_B. Put B̃=I₂−2C̃_B. Relative to the true Q_B its operator error is bounded by

    E_B=2e₀+t₀.

Choose j∈{2,3} maximizing the real diagonal of B̃. Mode 1's diagonal still has its original scalar error ν, while the transported diagonal at j has error at most e₀. The two new balanced readings therefore estimate the complex entry Q₁ⱼ with error at most

    E_X=√2(3ν+e₀)+t₀/2.

The last term bounds t|u₁ conjugate(uⱼ)|; it is at most t/2 by normalization. Form h̃ whose anchor coordinates are the j-th column of B̃ and whose first coordinate is the negative of twice the newly acquired C₁ⱼ. Then

    ‖h̃−Q eⱼ‖≤h=√(E_B²+E_X²).

Write q̃=tr B̃ and p₋=B̃ⱼⱼ−E_B. Two explicit possible continuation rows have certified leakage bounds

    v=e₁:             b₀=min(1,max(0,q̃+2E_B));
    v=h̃/‖h̃‖:       b₁=min(1,h²/p₋), if p₋>0.

Use b₁=1 when p₋≤0; if h̃=0 it cannot give a certified bound below one, so take e₁. Choose the row with the smaller bound and synthesize it with at most two G contacts.

For the first bound, P_R≤I−Q gives leakage at e₁ at most q=tr Q_B≤q̃+2E_B. For the second, Q eⱼ has squared norm Qⱼⱼ≥p₋. Its distance from the line spanned by h̃ is at most h, yielding 1−|w†v|²≤h²/p₋; again P_R≤I−Q converts this to a power bound. This also explains why a small reference is a reason to choose another action, not to claim an accurate phase by unstable division.

The final total leakage obeys

    δ≤t₀+min(b₀,b₁)
      ≤t₀+min(1,2E_B+√(4E_B²+2h²)).

For the uniform bound, split at q̃=√(4E_B²+2h²). Below it use b₀. Above it, maximal anchor selection gives p₋≥q̃/2−E_B>0 and the b₁ bound is at most the same number. Zero-error limiting cases are read directly from the exact construction. This proves a finite guarantee for the shortened acquisition itself, not only for a perfectly known first block.

This conservative bound may be worse than the fourteen-setting bound at the same per-reading error. Fewer settings has not been equated with uniformly better precision. Solver error, imperfect row realization, drift and cross-talk require their own admitted bounds; the preceding version assumes exact solver and pair-local unitary contacts. Independent final admission measures the device actually reached and can be substantially tighter.

## Detail: §16m. Learn in one program and execute an equivalent shorter one

### IiS38

**IiS38 (Question-preserving normalization separates learning from retained control cost).** Let D be a fixed rank-m coordinate read projector in Cᵈ, with r=d−m. Suppose a known, physically admitted unitary word V acts after an otherwise unknown source. There is a word W of at most r(d−r) allowed G contacts such that

    W† D W=V† D V.

The original word can be kept when already shorter. Consequently one can choose a replacing word with no larger contact count and at most r(d−r) contacts. This is an exact equality of complete final power readings, not equality of the two unitary maps.

*Construction.* The known word defines the known projector

    P_V=V†(I−D)V.

Apply IiS34's r(d−r)-contact subspace construction algebraically to range P_V: at each stage compute the relevant local projector block from the known word, choose its kernel row, and synthesize that row with r G contacts. No query to the unknown source is needed. The resulting W sends range P_V to ker D, so W†(I−D)W=P_V and the displayed equality follows. The worst-case retained bound is attained by IiS34's dimension obstruction. Phase screens within the same output bank can be removed as in IiS37. ∎

For every actual field y, including one supplied by an unknown lossy or time-dependent upstream process,

    ‖D W y‖²=‖D V y‖².

Thus normalization does not require identifying the upstream unitary U, and the equality itself does not require that the upstream process be unitary at all. It compares both programs on the same field. A certificate acquired on an earlier source does not automatically apply to a later changed source: W on the later field equals V on that later field, not necessarily V on the earlier field.

**This removes the apparent acquisition penalty in the four-mode controller comparison.** The five-rotation pure-training procedure can itself reuse its known powers. For the first training vector, one identity setting reads all current powers. Each nulling contact then needs only its two new quadratures: the unaffected powers remain known, and the surviving power of the nulled pair is its former sum. Three contacts therefore need seven pure settings. After these contacts, one new identity reading for the second training vector and two quadratures for each of its two contacts need five more. Total: at most twelve pure probe settings, rather than the unshared upper bound of fifteen.

Let V be the resulting known five-contact word, whether the actual training result is perfect or imperfect. Normalize its power effect to a four-contact W. Reset only the controlled bank and install W; do not reset or infer the unknown source. The same final readout is obtained with no new source acquisition. In particular, any previously established tolerance for V's reading transfers through this equality, as long as the admitted controls, source relation and reset remain valid.

The full resource statement is therefore:

    at most twelve pure training settings;
    five committed contacts accumulated during learning;
    at most four contacts in the retained working program;
    independent final admission, when required by the physical contract.

Twelve is an upper bound, not an acquisition minimum. The learning contacts have not disappeared: temporary probes, reprogramming and restoration are real work. Nor does this show that a fixed five-element mesh can always be replaced in place by an arbitrarily ordered four-element mesh. The theorem uses the same permitted pair-word interface as IiS34; the required word must be physically implementable in the actual bank.

For r orthonormal pure training inputs in Cᵈ, progressive individual routing uses

    L=(d−1)+(d−2)+…+(d−r)=rd−r(r+1)/2

training contacts. Retaining powers gives r initial pure readings plus 2L quadrature settings, or r(2d−r) pure settings. Normalizing the learned word still leaves at most r(d−r) working contacts, without further unknown-source measurements. The source family need not be reconstructed beyond what is carried by that known learned word.

**Twelve pure settings need not assume perfectly observed zeros.** For the four-mode schedule, suppose each acquired normalized scalar power has absolute error at most ν, and the two-mode controls and minimum-Rayleigh solver are exact. At each contact reconstruct the two-by-two pure coherency block from its stored diagonal estimates and the two newly measured quadratures. Choose its minimum-Rayleigh row, implement that row and transport the entire estimated block through the known contact. Store the surviving diagonal from that transport; do not replace it by the old pair sum on the assumption that the other actual output vanished.

Each fresh leaf diagonal has error at most ν. If the surviving anchor diagonal has error at most a, each new real quadrature has error at most (3ν+a)/2. The two-by-two matrix error is therefore at most

    e(a)=a+(3ν+a)/√2,       a≥ν.

The actual pure two-mode block has minimum eigenvalue zero. The acquired minimum-Rayleigh row consequently leaves power at most 2e(a), by comparing its estimated value with a true null row. Transport gives the surviving diagonal error at most e(a). Starting from a=ν, the three successive available error bounds are

    e₁=(1+2√2)ν,
    e₂=(3+4√2)ν,
    e₃=(7+7√2)ν.

The first training vector incurs at most 2(e₁+e₂+e₃) total power outside its assigned unread mode. Subsequent contacts avoid that mode, so they cannot increase this total, although they can redistribute the residual. The second training vector uses a new identity reading and incurs at most 2(e₁+e₂) power in the final read modes. For the orthonormal training pair their sum is the total null leakage. Hence the learned word satisfies

    δ_V≤min(2,(30+38√2)ν).

This is a conservative sufficient bound, not an optimal error constant. It requires the same actual source at the compared settings and exact admitted contacts; contact implementation errors are treated separately below. It does show that the twelve-setting scheme survives finite acquired error without an unstable division by a weak phase reference. Independent final admission can supply a tighter bound for the actual device.

**Approximate implementation has a scoped transfer bound.** Suppose V and W are the commanded unitary words above, while the physically implemented unitary words Ṽ,W̃ satisfy ‖Ṽ−V‖≤e_V and ‖W̃−W‖≤e_W. Then

    ‖W̃† D W̃−Ṽ† D Ṽ‖≤e_V+e_W=:e.

For unitaries A,B, put R=AB†. The difference of their conjugated projectors has norm ‖DR−RD‖. In the decomposition range D⊕ker D this commutator has only its two off-diagonal blocks, whose norms are each at most ‖R−I‖=‖A−B‖. Apply this inequality to both implementations and use the commanded equality. A sum of per-contact operator errors is an available word-error bound by telescoping products of unitaries; a common physically established error bound can be tighter. Passive nonunitary implementation errors require a different effect bound.

With the same unitary upstream source as in IiS34, let the earlier total null leakage be δ_V. For the same trained N,

    δ_W≤(√δ_V+√r e)².

Indeed leakage is the squared Frobenius norm of the read projector applied to an orthonormal basis of the transformed N. The two projectors differ in operator norm by at most e; the triangle inequality gives the bound. In particular, an exact old null becomes at most r e² leakage, rather than requiring a first-order power penalty. A final acquired certificate can supersede this conservative transfer bound.

This result separates a useful learning path from a useful working path. It does not preserve the intermediate history, the power of each read mode separately, or the coherent frame passed into an arbitrary next analyzer. IiS35 provides a counterexample to that last extension. What is preserved is the stated sum-of-powers question on every input to the bank.

Equivalently, W=R V for a known block unitary R commuting with D. The normalization has changed only the internal output frames within the read and unread groups. If a later analyzer originally reads an effect E, replacing it by R E R† restores the old composite reading. The availability and actuation cost of that analyzer change must be supplied; an arbitrary continuation does not adjust itself for free.

**A common unknown coordinate phase need not be learned.** Suppose the actual controls are ΔGΔ† for one unknown diagonal unitary Δ, common to all probes, committed contacts and the two alternative programs. The power detectors commute with Δ. Acquisitions then describe Δ†CΔ, and the actual programs are ΔVΔ† and ΔWΔ†. Their effects remain equal because the commanded effects are equal. All exact acquisition and normalization results therefore hold in this unknown common frame. Knowing every absolute control phase is a stronger requirement than this question needs. Independent edge offsets or changing frames between contacts need not admit such one Δ and are not covered by this argument.

**The number of distinguishable output groups gives a general retained-control bound.** Let the final requested observable be diagonal, with distinct values λ₁,…,λ_s of multiplicities d₁,…,d_s, summing to d. Its conjugates can all be synthesized with at most

    C(d₁,…,d_s)=Σ_{i<j} dᵢ dⱼ
                 =(d²−Σᵢdᵢ²)/2

G contacts, and this is the minimum worst-case count. Align the first eigenspace at cost d₁(d−d₁), keep it fixed, and align the next in the remaining complement; continue. The costs sum to the displayed number. For the lower bound, off-diagonal blocks of an infinitesimal unitary change between distinct eigenspaces give 2Σ_{i<j}dᵢdⱼ independent real directions of the observable orbit: the commutator multiplies each such block by a nonzero eigenvalue difference. Fewer two-parameter contacts cannot cover that open orbit chart, by the same smooth-image argument as IiS34.

Every known unitary word before this observable can therefore be normalized at this cost without identifying its unknown input. Merging two outcome groups of dimensions a and b reduces the worst-case contact count by exactly ab. That is a change of the question, with its sufficiency to be justified for the downstream task, not an unexplained improvement in implementing the old observable.

In four modes the groupings (1,1,1,1), (1,1,2) and (2,2) give respectively six, five and four contacts in the worst case. The exact Q readout with two distinct nonzero weights belongs to the middle spectral class; the sufficient Π readout belongs to the last. These are family bounds. The specific Π additionally has the direct four-contact obstruction below. Classical unitary synthesis and its Givens decompositions are established subjects, including [Clements et al.](https://arxiv.org/abs/1603.08788). The result here spells out which output distinctions this normalization preserves and how its equality transports an acquired reading; it is not a claim to have invented optical unitary synthesis or unitary orbit geometry.

**A different elementary coupler changes the count.** If an elementary contact is instead a fixed balanced splitter B(φ)=G(1/√2,1/√2,φ), with arbitrary available relative phases and free diagonal screens, the minimum worst-case count for that same observable orbit is 2C(d₁,…,d_s). Each balanced contact has only one continuous parameter after the screens have been moved to the final boundary, so fewer than 2C cannot cover the orbit of real dimension 2C. Conversely every general G can be made from two balanced contacts up to an irrelevant diagonal: choose 0≤t≤π with c=sin(t/2), s=cos(t/2), and put

    φ₁=φ−π/2,       φ₂=φ₁+t.

Direct multiplication gives

    B(φ₂) B(φ₁)
      =diag(e^{i(t/2−π/2)},e^{−i(t/2−π/2)}) G(c,s,φ).

Moving these diagonal factors to the output proves the upper bound. Thus four general controllable mixing contacts and eight fixed balanced contacts are different resource statements; eight here is a family worst-case bound, not a proved minimum for the single Π witness. The familiar Mach–Zehnder construction has precisely this distinction between fixed splitters and a tunable compound element. Actual fabrication errors can also restrict the reachable ratios, as analyzed by [Hamerly et al.](https://www.nature.com/articles/s41467-022-34308-3). Contact count alone is not chip area, insertion loss or elapsed experimental time.

**The specified witness itself requires four contacts.** IiS34's dimension argument established a worst-case lower bound among all rank-two projections in C⁴. The particular target Π=I−Π_N also has a direct obstruction to three contacts when synthesized directly in the declared input coordinates, equivalently when the uncounted upstream map is identity. An already mixing upstream device can supply part or all of this action; this is not a four-contact lower bound for every possible initial U.

For any rank-two projection Q obtained by conjugating a coordinate rank-two projection with a word of at most three G contacts,

    Im(Qᵢⱼ Qⱼₖ Qₖᵢ)=0

for every triple of distinct coordinates. To prove this, form the graph of the mode pairs used by the word. If it is connected on four vertices, its at most three occurrences must be the three distinct edges of a tree. One diagonal change of coordinates removes all three G phases. The resulting word and projection are real, and each displayed cyclic product is unchanged by that diagonal change. If the graph is disconnected, every component has at most three vertices. The projection is block diagonal. Any contributing triple must be inside a three-mode block; a projection of rank one or codimension one there has a real cyclic product (respectively + or − a product of three nonnegative squared moduli). Rank zero and full rank give zero. Other triples cross blocks and also give zero. This covers repeated contacts as well as shorter words.

For the actual N=range V₀, with

    V₀=[[1,0],[0,1],[1,1]/√2,[1,i]/√2],

direct inversion gives

    (V₀†V₀)⁻¹=(1/7)[[4,−1−i],[−1+i,4]].

Therefore, writing P=Π_N,

    P₀₁=−(1+i)/7,
    P₁₂=(3+i)/(7√2),
    P₂₀=(3+i)/(7√2),
    P₀₁ P₁₂ P₂₀=−(1+7i)/343.

Its imaginary part is −1/49; for Π=I−P it is +1/49. The four-contact upper construction is thus minimal for this specified readout even when its complete matrix is known. The argument permits free diagonal screens in the same bank, by their elimination above. It does not demand a physical loop in the wiring: with longer words, repeated contacts on a tree can carry phases that one common coordinate change does not remove.

The obstruction has a nonzero tolerance. If a three-contact projection Q were within operator distance e of Π, entrywise errors would be at most e. Expanding the difference of the three factors gives

    1/49 ≤ e(5+2√10)/49
            +e²(√2+2√5)/7+e³.

At e=1/15 the right side is strictly smaller than 1/49. For an exact rational check, use √10<19/6, √2<10/7, √5<9/4, obtaining the upper bound

    34/2205+83/22050+1/3375 < 1/49.

The right side increases with e≥0. Consequently every three-contact Q has ‖Q−Π‖>1/15. Equal-rank projectors obey ‖Q−Π‖²≤tr(Π_N Q), by their principal-angle decomposition. Thus its total intended-null leakage satisfies

    δ>1/225.

This is a certified lower bound, not the sharp distance to the three-contact family. It already exceeds IiS34's aggregate-certificate threshold δcrit: μ<1/57 and 1/57<896/50625=4(1/225)(1−1/225), so δcrit=(1−√(1−μ))/2<1/225. For μ<1/57, use √2>24/17 and 194/17>(385/114)² in the exact formula μ=1/2−√(10+√2)/7.

Hence three contacts cannot even enter that proven uniform leakage-admission region. This does not prove that every possible three-contact device fails every alternative, more specifically acquired phase-family decision criterion. That stronger task would have to compare the actual family responses, not just this sufficient aggregate certificate.

**Passive loss does not lower this exact synthesis count.** Replace each G by an arbitrary passive two-mode contraction, without changing the mode carrier or the rank-two final read projector. If the resulting word M has exact effect M† D M=Π, then M is norm preserving on S=range Π and sends S completely into the read outputs. For every input in S, norm cannot decrease at any intermediate stage: subsequent contractions could not restore that decrease.

At each stage, the current projections of S into that contact's two modes therefore form a subspace on which the contact is an isometry. Extend that isometry to a two-mode unitary. Making these replacements successively preserves the complete action on S. The resulting unitary word with the same number of two-mode contacts has the same rank-two read projector Π. Every two-mode unitary is a G contact times a diagonal phase screen; those screens do not reduce the minimum. Thus a three-contact passive implementation of this exact unit-gain projection would yield an impossible three-G implementation.

This proof needs full transmission on S, not losslessness on all modes. It does not apply to a target γΠ with γ<1, to gain elements, additional prepared inputs or a different final question. The quantitative 1/225 leakage bound above was proved for the unitary/projection class; this exact unitarization argument does not transfer that numerical bound to every approximately matching passive effect.

**Configuration count is not observation count.** IiS37–38 count distinct controlled probe settings. An exact expectation is not obtained from one photon or from an unspecified finite integration. Here is one explicit final-admission contract for the implemented projection-class device, using established elementary counting statistics rather than treating an observed zero as an exact null.

Freeze a candidate K in the admitted rank-m projection class before the final batch. Prepare the uniform mixture σ_N=Π_N/r, and record a binary read event on each of n fresh normalized input trials. Let the fixed event probability be q=tr(Kσ_N)=δ/r, with independent trials. Accept only if the whole batch has zero read events. Under the bad-device hypothesis δ≥δ_* >0, the probability of acceptance is at most

    (1−δ_*/r)^n.

For false-acceptance budget 0<α<1, the exact smallest batch size for this zero-event acceptance rule is therefore

    n≥ceil(log α / log(1−δ_*/r)),       0<δ_*<r.

Equality at δ=δ_* proves the necessity for this specified rule. This is not a lower bound for every possible testing procedure. Equivalently the zero-event branch has one-sided upper confidence limit q_U=1−α^(1/n). The probability statement concerns false certificates under repeated trials; it is not a posterior probability assigned to a fixed unknown q. Such exact binomial limits are standard; see [NIST](https://www.itl.nist.gov/div898/software/dataplot/refman2/auxillar/exacbici.htm). For application to IiS34, choosing δ_* strictly below δcrit is a convenient conservative way to retain an explicit positive classification gap.

A randomized preparation is not necessary. Prepare each of the r orthonormal training vectors equally often, with n divisible by r. For their fixed probabilities p_j, whose average is δ/r, independent trials give probability

    [∏_{j=1}^r(1−p_j)]^(n/r)≤(1−δ/r)^n

by the arithmetic-geometric mean inequality. Thus a balanced deterministic schedule gives the same bound. Unequal uncontrolled coverage of the training directions does not give this conclusion.

Full independence can also be replaced by the actual weaker obligation used in the argument: on every all-zero prefix under the bad-device hypothesis, the next conditional read probability must have the asserted lower bound. Multiplying the conditional probabilities then proves the same result. Merely giving every trial the same marginal probability is insufficient. If one Bernoulli variable is drawn once and copied on every trial, each marginal is q but the all-zero probability remains 1−q for every batch length.

**Imperfect preparation and detection need a detection relation.** Suppose the actual uniform training preparation differs from σ_N by at most ε in trace distance, and the detected event probability is at least η times the ideal read probability, for an acquired 0<η≤1. The effect bound 0≤K≤I gives a preparation-induced probability error at most ε. A bad device then has detected-event probability at least

    p_* = η(δ_*/r−ε)_+.

When 0<p_*<1, replace δ_*/r in the batch formula by p_*. When p_*=0, no finite zero-event batch supplies this certificate: the premises still allow a bad device whose admitted event is never detected. A relation such as detector effect F≥ηD is one way to justify the detection factor. It must be acquired or supplied by the physical contract, not inferred from the absence of clicks.

These statements use normalized emitted/prepared trials with a defined event, not a denominator that silently discards losses. Zero leakage alone does not establish that an arbitrary passive device transmits the complementary signal space. IiS36's bright capacity or another suitable admission remains necessary when the projection class itself has not been established. The statistical batch does not manufacture that structural assumption.

**Repeated tuning cannot restart the same confidence budget for free.** Even a fixed bad candidate with 0<q<1 eventually produces an all-zero batch almost surely if independent batches of a fixed length are tried indefinitely and the first zero batch is accepted: each batch has success probability (1−q)^n>0. This procedure's eventual false acceptance is one, not α.

A simple valid replacement allocates α_j in advance with Σ_j α_j≤α, for example α_j=α/[j(j+1)]. A candidate may depend on all preceding work, but is frozen during batch j; use fresh data with the required conditional law and choose its batch length from α_j before observing that batch. The conditional bound and union bound then control the probability of any bad accepted candidate by α. Reusing training data as if it were independent admission data does not satisfy this construction. More efficient procedures that remain valid throughout monitoring are studied by [Howard et al.](https://arxiv.org/abs/1810.08240); this paragraph uses only the displayed elementary allocation.

Neither a finite batch nor a continuing confidence bound licenses unrestricted future source drift. The admitted relation between the tested device and its later use remains part of the result.

## Detail: §16n. Four contacts are necessary for the question itself

### IiS39

**IiS39 (Three-contact scalar indistinguishability).** In the direct four-mode input coordinates, let a retained word contain at most three admitted G contacts and arbitrary diagonal phase screens in the same bank. Read only the total normalized power in a fixed rank-two output group. For every such word there exist a normalized pure input in N and a normalized equal-modulus phase input giving exactly the same scalar reading. No decoder of that reading can separate the two whole input families, even with exact acquisition.

The four-contact Π construction separates them by 0 versus at least μ. Consequently four is the minimum retained contact count for this actual discrimination question, beyond reproducing a chosen matrix or entering a particular sufficient leakage certificate.

The upstream map is identity for this direct-synthesis lower bound. An uncounted upstream unitary could already implement the required mixing. Further measurement configurations, mode-resolved vector answers, ancillary inputs, feedback during the queried action and nonunitary contacts are different interfaces.

*First step: the short readout has a real coordinate form.* Its effect Q is diagonally equivalent to a real symmetric matrix: Q=Δ A Δ† for a diagonal unitary Δ and real symmetric A. If the contact graph connects all four modes, three contacts are precisely three distinct tree edges. One choice of node phases makes all three G matrices real. If the graph is disconnected, Q splits into blocks of size at most three. Inside a three-mode block a projection has rank zero, one, two or three; rank one and rank two are vv† or I−vv† and become real after phases are removed from v. Smaller blocks have the same property. The blocks can be gauged separately. Free phase screens can first be moved to the irrelevant final screen, as proved in IiS37. Thus every allowed three-contact Q has the stated real form, including repeated-contact and degenerate cases.

*Second step: every real four-mode correlation has a phase mixture.* Here is a finite constructive version of the established real correlation rank argument. Factor a real positive unit-diagonal matrix R as Gram(v_i), with spanning v_i in R^p. If p≥3, the space of real symmetric p×p matrices has dimension p(p+1)/2>4. Choose nonzero H with v_iᵀH v_i=0 for all four i. It has both signs, because a semidefinite H would annihilate the spanning vectors. The two boundary matrices I+t₊H and I−t₋H are positive and singular for suitable positive t₊,t₋. Their Gram matrices still have unit diagonal, have lower rank and mix back to R with weights t₋/(t₊+t₋) and t₊/(t₊+t₋). Repeat until each term has rank at most two. A real unit Gram of rank at most two is

    R_ij=cos(θ_i−θ_j)=Re(z_i conjugate(z_j)),   |z_i|=1.

It is therefore the equal mixture of zz† and its entrywise conjugate. The recursion supplies a finite phase mixture for R. This is the real counterpart of IiS32's complex argument for at most three modes. The general extreme-rank condition is classical; see [Li and Tam](https://people.wm.edu/~cklixx/corr.pdf).

*Third step: exhibit overlap of the two answer sets.* Let V₀ be the four-by-two matrix with rows (1,0), (0,1), (1,1)/√2 and (1,i)/√2, and put

    ρ_* = V₀V₀†/4.

This is a trace-one positive matrix supported on N, with every diagonal entry 1/4. It is not the uniform mixture Π_N/2; uniform training is not needed for this impossibility argument. The matrix

    R=4 Re(Δ†ρ_*Δ)

is real positive with unit diagonal. Positivity follows by testing real vectors against the original positive Hermitian matrix. By the second step, σ=Δ R Δ†/4 is a mixture of normalized equal-modulus phase inputs. Since A is real symmetric, its trace against the imaginary skew-symmetric part vanishes. Hence

    tr(Q σ)=tr(Q ρ_*).

The common value lies between the minimum and maximum of Q on normalized pure inputs in N. Every intervening value is attained there, by the Rayleigh quotient on that subspace. It also lies between the minimum and maximum on the phase torus; the torus is connected and the reading continuous, so every intervening value is attained by one pure phase input. Thus the equality is realized by a pure input from each family, not only by two ensembles. ∎

The argument actually proves the overlap for any diagonally real Hermitian scalar effect on these four inputs. The contact graph is one way to force that restriction on the admitted reading. It does not make an imaginary cyclic product sufficient for discrimination; the already constructed Π supplies the positive direction.

This obstruction concerns the information carried by the final scalar. Repeating that same exact expectation does not remove its ambiguity. Under an independently established repeated binary measurement model, the two pure inputs also give the same complete distribution of those repeated binary outcomes. A new contact or additional acquired observable can change the answer space.

**Why this real-form argument has a finite domain.** The rank reduction also works for any real correlation matrix with at most five positions, since 3·4/2>5. It fails as a universal statement at six positions. For example the real Gram of e₁,e₂,e₃ and (e₁+e₂)/√2,(e₁+e₃)/√2,(e₂+e₃)/√2 is positive with unit diagonal and has zero value of the three corresponding squared linear residuals. A scalar phase record cannot make those residuals zero: it would require three unit vectors in the real plane to be pairwise orthogonal. Positive mixtures cannot repair a nonnegative residual that vanishes only when each supported record vanishes.

There is also a uniform nonzero bound. For the three original unit phases put c_ij=Re(conjugate(z_i) z_j). Their real Gram has rank at most two and trace three, so tr(G²)≥9/2 and Σ_{i<j}c_ij²≥3/4. Minimizing each of the three additional phases separately, the total residual is at least

    Σ_{i<j}(√(1+c_ij)−1)²
      ≥ (3/4)(√2−1)² > 0.

This bound is not asserted sharp. The example prevents extending the four-mode real-form indistinguishability to arbitrary numbers of channels. Complex contact orientation matters to the specified four-mode witness; it is not a universal requirement of every phase-mixture exclusion problem.

## Cross-page mentions

Labels mentioned here: <doc:interference_is_substitution__comparison_fluctuations#IiS32>, <doc:interference_is_substitution__support_calibration#IiS34>, <doc:interference_is_substitution__support_calibration#IiS35>, <doc:interference_is_substitution__support_calibration#IiS36>, <doc:interference_is_substitution__support_memory#IiS40>.

Mentions of this page’s labels: <doc:interference_is_substitution__support_memory> (IiS37), <doc:interference_is_substitution__support_memory> (IiS38), <doc:interference_is_substitution__support_memory> (IiS39).
