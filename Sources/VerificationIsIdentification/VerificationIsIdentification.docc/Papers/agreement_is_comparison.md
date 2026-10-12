# Agreement Is Comparison (Record)

Two independently maintained records can drift between comparisons. This paper specifies one edit model for that interval. A common source or a preserved relation can change its premises and remove a need for independent maintenance. Seam Is Game supplies the revision scope of a judgment. Here the edit law and the evidence required for a later answer are treated separately.

The paper gives an edit model and two scope criteria. The model prices accumulation: the mean drift rises monotonically to N/(1+c), where N is the shared reach and c is the probability that a touch closes the divergence it lands on; the stationary law is Binomial(N, 1/(1+c)); stationary agreement has probability (c/(1+c))^N. The observation criterion asks whether every joint history compatible with the local record gives the same answer. When it does, structural inference can settle that answer without reading the other state. The generation criterion separates relations established between actual outputs by construction from an unestablished relation to what those outputs purport to record. V=I §5.21's instruction classification does not prohibit these inferences.

## §0. Derivation

AC1–AC4 use the declared model D. The later scope criteria use question factorization and actual source bindings. From V=I: §5.20 (revelation, not creation), §5.21 (the admission rule for comparison events), §5.24 (two encodings of one task run as two non-communicating executions), §5.18 and §5.19 (a cached comparison transfers across games; a repeated run performs zero new comparisons). From Difference Is Distance: S7 (the distance between two perspectives is the symmetric difference of their caches), S9 (translation between encodings is a priced game). From Distance Is Cost: G2 (W is a metric; one traversal computes it), G4b (the sign of a divergence halts at the first divergent address; the magnitude costs a full traversal), the frontier. From Merge Is Commutation: Definitions 1–3 (law support, edit inputs and writes, and sufficient independence conditions), MiC1 through MiC4. From Record Is System: SW3. From Dynamics Is Substitution: the elementary move. From Halt Is Ignition: HF2 (an infinite deterministic finite-state run eventually repeats). From Permanence Is Resistance: M12, M21, M24, M27. From Interference Is Intelligence: the distinction between a retained record, an excluded possibility and a settled question. From Seam Is Game: SG1 through SG3, consequence (c). Two imports are declared where used, at the standing M24 gives its own physical premise: the edit model D of §1, together with the standard theory of finite reversible chains (detailed balance; Kac's return-time formula), and the chain of Ehrenfest (1907), which D reduces to at c = 1. The definitions below are those, assembled by the author.

## §1. Definitions

**Definition 1 (pair, drift, agreement fact).** A pair is two records of one fact: (a, b), two Σ structures, each maintained by its own edit process. The drift of the pair is d = W(a, b) (DiC G2). Agreement is d = 0. An agreement fact is an equality classification whose object is the pair.

**Definition 2 (edit model D; declared).** The shared reach of the pair has N ≥ 2 addresses, and the interval begins at agreement, d₀ = 0. A touch is one elementary move applied to one side. Conditional on the past, its address is uniform over the shared reach. This is the transition premise used in AC1, stronger than exchangeability of an unconditional marginal. The two touch processes are independent; this clause excludes a common writer (§5). A touch at an agreeing address opens it. A touch at a divergent address closes it with probability c, 0 ≤ c ≤ 1; c is a property of the edit process. The touching side is not supplied a separate reading of whether its touch closed a divergence. That interface restriction does not prevent an outcome being inferable from the law and available history in a special case (AC5). Each side has its own counter: n_a and n_b touches since the pair's last comparison; the age of the pair is t = n_a + n_b. A clock is any observable that is independent of both processes' address choices given (n_a, n_b). No clause of D hands one side the other side's counter, and a statement that converts a clock into a touch count uses the sides' touch rates: declared parameters of the edit process, standing as c.

**Definition 3 (footprint).** The footprint of side a is its history taken up to relabeling of addresses: the orbit of H_a under address permutations. At c = 1 the part of the footprint that determines the law of d collapses to one number: m_a, the count of addresses side a has touched an odd number of times.

**Definition 4 (drift entropy).** S(d) = log₂ C(N, d); S(0) = 0; S is maximal at d = N/2. Used in §6.

## §2. The interval's dynamics

**AC1 (mean, ceiling, stationary law).** Under D, over the age t: (i) E[d_{t+1}] = E[d_t](1 − (1+c)/N) + 1, so E[d_t] = (N/(1+c))(1 − (1 − (1+c)/N)^t), monotone increasing to the fixed point d* = N/(1+c). The ceiling N/2 is the best case, c = 1; every process with c < 1 saturates higher. (ii) For 0 < c ≤ 1 the drift is a birth-death chain with up-probability (N−d)/N and down-probability cd/N per touch; detailed balance gives the stationary law Binomial(N, 1/(1+c)); stationary agreement has probability (c/(1+c))^N, and the expected return time to d = 0 is ((1+c)/c)^N touches. (iii) At c = 0 nothing closes: E[d_t] = N(1 − (1 − 1/N)^t), d increases to N, and no return exists.

*Proof.* (i) One touch raises d by 1 with probability (N−d)/N, lowers it by 1 with probability cd/N, and leaves it unchanged with probability (1−c)d/N; take expectations; the recursion is linear with ratio 1 − (1+c)/N and fixed point N/(1+c). (ii) Detailed balance, π(d)(N−d)/N = π(d+1)·c(d+1)/N, gives π(d) ∝ C(N, d)c^(−d), normalized Binomial(N, 1/(1+c)); the return time is 1/π(0) (Kac). At c < 1 the chain has self-loops, is aperiodic, and its distribution converges; at c = 1 see AC2. (iii) Substitute c = 0: d counts the distinct addresses touched. ∎

For a one-address reach, the same mean recurrence has ratio −c. At c > 0 it oscillates around 1/(1+c), so the monotone-mean statement requires the declared N ≥ 2 boundary. An interval starting with d₀ ≠ 0 instead has mean d* + (E[d₀] − d*)·(1 − (1+c)/N)^t.

**AC2 (parity at c = 1).** At c = 1 every touch changes d by exactly 1, so d ≡ t (mod 2): the parity of drift equals the parity of age, agreement is reachable only at even ages, and P(d = 0) = 0 at every odd age. The chain is the Ehrenfest urn: period 2, Binomial(N, 1/2) as invariant measure, convergence on the even subsequence and in time average. At c < 1 the parity claim is void: a touch may leave d unchanged.

## §3. Observation closed

**AC3 (the footprint is the statistic; the count is not).** Under D, the conditional law of d given side a's full history H_a and n_b depends on (H_a, n_b) only through (footprint of a, n_b). At c = 1 it depends only on (m_a, n_b). The count n_a is not sufficient.

*Proof.* Sufficiency: an address permutation maps any history to a history in the same orbit, preserves both processes' laws (exchangeability of the address measure; independence of the sides), and preserves d (W is invariant under relabeling of addresses), so conditional laws agree across one orbit. At c = 1, write x_a for side a's parity vector and X_b for side b's: d = Σ over odd addresses of (1 − X_b) plus Σ over even addresses of X_b, and X_b given n_b is exchangeable, so the law depends on x_a through m_a alone. Insufficiency, by exhibit at c = 1: N = 3, n_a = 2, n_b = 1. The history "address 0 twice" has m_a = 0, and the law of d is {1: 1.0}. The history "address 0, address 1" has m_a = 2, and the law is {1: 2/3, 3: 1/3}. One count, two laws. ∎

**AC4 (about the other side, the archive is the clock).** Fix n_b. For every event E of side b's touch process, P(E | H_a, n_b) = P(E | n_b): no function of side a's history carries anything about side b's touches beyond what n_b carries. Mixing over any clock prior preserves the equality, and the prior over n_b given a clock is supplied by D's declared rates, not by an observation of side b. Side a therefore holds its own displacement in its footprint, and its entire uncertainty about d is its uncertainty about the other side: a one-parameter family of laws indexed by n_b.

*Proof.* The two touch processes are independent, so an event of side b's process is independent of every function of side a's process conditionally on n_b. A clock is independent of both processes' address choices by Definition 2, so mixing over its prior preserves the identity. ∎

**AC5 (local evidence is sufficient exactly on constant answer fibers).** For an available local record h, let K_h be the nonempty family of joint histories compatible with h and the declared law. A deterministic answer to q is correct in every compatible history exactly when q is constant on K_h. A particular address j can be certified as divergent exactly when j belongs to the frontier in every member of K_h.

*Proof.* A decoder receiving the same h must give the same answer in each compatible history. If their q-answers differ, it cannot be correct in all of them. If they agree, that common answer suffices. For an address certificate, apply the same argument to its membership in the frontier. Equivalently, the available guaranteed addresses are the intersection of those frontiers. This is VC15's sufficiency criterion, not a requirement to store the other whole state. ∎

**The previous universal prohibition fails inside D.** Set c=0, which Definition 2 explicitly admits. A touch at an agreeing address opens a divergence, and a touch at a divergent address cannot close it. Hence every address touched at least once remains divergent. After any local touch at j, the local record of that address and the law c=0 certify j as a current divergence, regardless of the other side's intervening touches. No copy of the other current state is needed. Initial agreement and the transition rule are model premises. They are not inferred from this local record alone.

For c>0, a possible later closing touch can destroy that certificate. Whether it does so for a given record depends on K_h. A clock and a rate model can restrict K_h or support a probability estimate. An exact answer needs agreement over the admitted histories, rather than a favorable mean or an unspecified numerical simulation.

V=I §5.21 can reserve an explicit equality-classification event for the COMPARE instruction in its chosen pipeline. That syntactic rule does not prove that an equality or inequality cannot follow from other established relations. A static proof and a new comparison event are different objects.

## §4. The Scope of Construction

**AC6 (construction establishes its output relations under an actual source binding).** Let a=f(s) and b=g(s) be generated from the same actual source s. Their relation is determined by these constructions. For example, f=g forces a=b for every s without a fresh comparison of the outputs. More generally, a proof of f(s)=g(s) on the admitted source family supplies that equality whenever the two actual applications have the required source. `SingletonVerdict` and `IndependentReadingOrders` already provide static instances of these two forms of reasoning.

This does not automatically relate s, a or b to an independently changing fact they purport to record. That claim requires its own binding or the constant-fiber condition of AC5. An actual complete copy of that other state is sufficient in some interfaces, but is not necessary when a smaller relation settles the question.

The edit law AC1 applies to a remaining (source,fact) pair only if it is an actual pair satisfying D, including independent touches, their address law, initial agreement and the closing probability. Naming one form as the source establishes none of those conditions. Conversely, generating several views from one source removes their independent-edit premise when the construction and common source are maintained. This can eliminate that drift problem instead of moving its asserted ceiling to another unnamed pair. ∎

## §5. Sectors and the seam

The following sectors use the declared edit interfaces and recorded writers. Their finite support sets can be compared, while their interpretation still needs the factorization and application premises of MiC Definitions 1–3.

- S-I (independent interfaces). The edits preserve each other's read inputs, have disjoint writes and satisfy the separate law-support conditions (MiC Definition 3). Their final positions commute and the applicable verdict groups carry (MiC2, MiC3). Any region preserved by both edits keeps its old comparison. This paper makes no drift claim from independence alone.
- S-II (common writer). One process writes both sides: excluded by D's independence clause, treated by AC6. The pair is one record with two projections, and the pair subject to this paper connects the source and the fact it records. One degenerate case forms no pair at all: a record that constitutes its fact rather than records it (the ledger that is the balance) has nothing beside it to diverge, and Definition 1 does not apply: designating such a record closes the question instead of relocating it. Which case holds is written: a second record of the fact exists, or none does.
- S-III (independent, overlapping). D holds; AC1 through AC6 apply.

Relation to Seam Is Game: SG1 classifies the finite survivor count, SG2 supplies the revision scope, and SG3 requires a binding from declaration to implementation. This paper adds a declared edit law between judgments. A waiver can permit known disagreement at listed addresses under a changed acceptance contract. It neither proves semantic agreement nor changes D's dynamics by being recorded.

The addressed comparison can stop on a witnessed divergence, while computing the complete tree distance uses G4b's traversal. MiC4 bounds a sufficient rechecking set after an edit. Transported certificates can reduce it further. M21 retains a historical correction under its update premise, and reuse also requires its present applicability. The stronger convergence and maintenance claims require their own dynamics and cost assumptions (M12, M27). In HF2's finite closed deterministic model, a continuing infinite trajectory eventually repeats. Recurrence alone does not establish a specific cost of correction or show that every retained record is lost.

## §6. Two entropies, one source

Posterior uncertainty about a fixed question and shell entropy S(d) = log₂ C(N,d) are different quantities. Expected posterior entropy cannot increase under a supplied observation law. A particular observed branch can have higher entropy. AC1 describes the mean of d, not the mean of the nonlinear quantity S(d).

A counterexample to monotone E[S(d_t)] uses N = 2 and c = 1, starting at agreement. Initially d = 0 and S = 0. After one touch d = 1 with certainty and S = log₂ 2 = 1. After the second touch, d is either 0 or 2, and both shells have size one, hence S = 0. Thus E[S(d_t)] begins 0, 1, 0 while E[d_t] begins 0, 1, 1. No numerical tolerance or simulation is involved.

The mean drift law therefore supplies neither monotone shell entropy nor a physical arrow of time. Record accumulation, posterior conditioning and the chosen entropy each need their own relation.

## §6a. What an average can answer

**AC7 (Mean-only transfer preserves exactly affine response expectations on the full mixture family).** Let I be a real interval and q:I→ℝ a response. Consider every finitely supported probability law P on I. Its mean determines E_P[q(X)] for this entire family exactly when q is affine on I. These are explicit scalar and mixture premises for auditing a statistical representation, not consequences of The Cut.

*Proof.* A point law at m has mean m and response expectation q(m). Thus any proposed decoder from the mean must return q(m). Applying it to a two-point law gives q(λa+(1−λ)b)=λq(a)+(1−λ)q(b) for every a,b∈I and λ∈[0,1]. This is affine interpolation throughout the interval. Conversely, for q(x)=ux+v, finite summation gives E[q(X)]=uE[X]+v. No regularity assumption is needed because every mixture weight was included. A restricted law family can permit additional responses. ∎

There is an exact finite refusal. The equally weighted alternatives 0 and 2 and the constant value 1 both have mean 1. The response q(x) recording whether x differs from 1 is certain in the first preparation and impossible in the second. Replacing either preparation by its mean therefore loses a whole yes/no distinction. For two retained entries, the sources (0,2) and (1,1) likewise share a sum and count but disagree on whether their entries coincide. `AddZero<Lit2>` and `AddSuccessor<AddZero<Lit1>>` derive the same numerator from those actual operands. The existing agreed and zero/successor boundary constructors distinguish their contacts. The checks certify this finite refusal, not the real-interval theorem through sample enumeration.

**Finite statistics determine exactly their response span on the full mixture family.** Let g₀=1,g₁,…,gₖ and h be real functions on an arbitrary carrier X. Over all finitely supported probability laws on X, the readings E[g₁],…,E[gₖ] determine E[h] exactly when h belongs to the real linear span of g₀,…,gₖ. The decoder need not have been assumed linear.

*Proof.* Write g(x)=(g₀(x),…,gₖ(x)). Any finite relation Σᵢ cᵢg(xᵢ)=0 has Σᵢ cᵢ=0. If Σᵢ cᵢh(xᵢ) were nonzero, split the coefficients into positive and negative parts. Their equal positive total normalizes them into two probability laws with identical retained statistics and different h-expectations, contradicting determination. Consequently L(Σᵢ cᵢg(xᵢ))=Σᵢ cᵢh(xᵢ) is well-defined on the span of the g(x). Extend this linear functional to ℝᵏ⁺¹. Its coefficients express h as a combination of the gⱼ. Conversely that combination immediately decodes E[h]. ∎

This specializes AC7 when the retained function is x. It does not forbid finite statistics from determining a restricted family, such as a separately established parametric family. Its consequence is precise: on the unrestricted mixture family, adding a statistic adds its linear response direction, rather than certifying every remaining question. Closure under the relevant physical transitions is a further requirement of VC15.

**Constant low moments need not fix the remaining distribution.** Let U be a nonnegative reading and compare the equally weighted six-entry populations

    A = (0,0,0,2,2,2),    B = (0,0,1,1,1,3).

Both have sum 6 and sum of squares 12. Hence both have E[U]=1, E[U²]=2 and K=E[U²]/E[U]²=2. Their third moments are 4 and 5, and the probabilities of U>2 are 0 and 1/6. Every mixture (1−λ)A+λB keeps the first two moments and K unchanged while changing that tail probability to λ/6. Allowing λ to vary therefore supplies a family with constant low moments and a changing distribution. Each law also lifts to planar velocities by assigning each value u equally to (±√u,0) and (0,±√u). The lifted laws have zero mean velocity and identical covariance. No time evolution law or physical reachability of that family was inferred.

For a planar speed reading U=vₓ²+vᵧ², this is the radial statistic K used by [Vega Reyes et al.](https://arxiv.org/pdf/2602.20716). Their identification of stationary K with a complete reduction of the remaining distribution needs an additional closure premise. The counterexample tests that inference alone, not their measured trajectories or separately supplied kinetic model. AI's preparation test retains the distinction between these kinds of evidence.

`EqualFirstTwoMoments` in `Checks/Interactions.swift` checks the two sums using actual finite addition and product constructors. Each square is bound to two copies of its original entry, and each accumulation retains that entry in the source. Both six-entry populations are constructed, with a positive distinction at their third entries. A negative control rejects identifying their full sources from the two matching moments. The exact third-moment and tail comparisons above follow directly from the displayed populations. The general response-span argument is the mathematical proof above, not an enumeration by the compiler.

**Complete local statistics can still omit the joining.** Let E⊆X×Y be a finite nonempty set of admitted joint alternatives, with X and Y restricted to incident vertices. Retain both complete marginal laws of a probability law on E. A joint response h:E→ℝ has its expectation determined by those marginals for every law on E exactly when

    h(x,y) = u(x) + v(y)    on E

for some functions u and v. Equivalently, the alternating sum of h around every cycle of the bipartite incidence graph is zero. Thus finer separate measurements cannot recover an arbitrary interaction response after its joining has been omitted.

*Proof.* The marginal entries are expectations of the row and column indicators. AC7's response-span criterion therefore gives exactly u(x)+v(y). Such a response has zero alternating cycle sum because each vertex contribution cancels. Conversely, choose one root in each component and assign its potential zero. Propagate potentials along a spanning tree by the equation u(x)+v(y)=h(x,y). Each remaining edge closes a cycle. The zero alternating sum makes its equation agree with the already assigned potentials. ∎

There is also an exact boundary for recovering the entire joint law: the marginals determine it for every law on E if and only if this incidence graph is a forest. On a forest, subtract two candidate laws with the same marginals. At a leaf the incident edge difference must be zero. Remove it and repeat until no edges remain. On a cycle of length 2r, assign probability 1/r to its alternate edges and zero elsewhere. The two alternating assignments have identical vertex marginals and different joint laws. A cycle with nonzero alternating h-sum distinguishes their expected responses. These are consequences of the declared finite support and weights, not a derivation of physical probabilities.

For the full two-by-two support, the pairs (a,c),(b,d) and (a,d),(b,c), each taken with equal weight, have the same separate lists. The interaction contrast is

    h(a,c) + h(b,d) − h(a,d) − h(b,c).

With two distinct labels on both sides, agreement is certain in the diagonal preparation and impossible in the opposite preparation. `BinaryContactAlternatives` and `BinaryContactLocalLists` already construct these two joining tables and their equal local lists up to the explicit exchange of alternative addresses. Their existing positive separators and refusals in `Checks/Interactions.swift` certify that finite structural distinction. The weights and general cycle argument are established here. M32 supplies the stronger three-part case in which even every pair marginal agrees before one common reversible contact exposes a different answer.

Locally acquired records can still preserve which two readings belong to one occurrence. Such paired records can determine the joint law. The obstruction concerns retaining only the separate distributions after that correspondence has been erased. It need not require a new component or a more precise measurement of either individual reading.

On a restricted support, checking only rectangles is insufficient: a six-edge cycle can have no four-edge cycle. For a particular pair of observed marginals, forced zero weights can also remove a cycle and restore uniqueness. The criterion above quantifies over all laws on E. Absence of an observed event in a finite sample does not establish a forbidden edge. Establishing the support and the available distinguishing contact remains an acquisition obligation. This incidence graph joins local alternatives, whereas Space §3a's tree joins configurations by inverse operations. Their shared cancellation pattern does not identify those physical roles or make every cycle a memory effect.

IiS19 supplies the quantum boundary of a zero-only reading: states with the same support give the same zero/nonzero outcome weights after every common finite instrument protocol, while their probabilities can differ. The weighted response family above therefore cannot be replaced by an unweighted admission graph. A zero weight belongs to the stated probability model, and acquiring that exact relation is different from not observing an outcome. An additional source-related input changes the contact to be compared.

**Approximation can carry an exact scope.** For a finite admitted source family, retained reading S and real answer q, let A_s={q(x):S(x)=s}. A single answer v_s has worst-case error at most ε exactly when A_s⊆[v_s−ε,v_s+ε]. The least possible worst-case error on a nonempty fiber is (max A_s−min A_s)/2, attained at the midpoint of its extremes. This is AC5's constant-answer criterion with a stated tolerance. It supplies no probability that the actual source occupies a particular part of that interval. Reuse through further actions requires their answers to meet the bound too, as VC15 requires. A small initial error alone does not establish that continuation claim.

**Repeated readings help through their joint law.** For bounded readings X_i∈[0,1] under one supplied probability law, expansion gives

    Var((X₁+…+Xₙ)/n) = (Σᵢ Var(Xᵢ) + 2Σᵢ<ⱼ Cov(Xᵢ,Xⱼ))/n².

Independent readings have no cross terms and each variance is at most 1/4, so the mean's variance is at most 1/(4n). Repeating one fair bit n times instead gives variance 1/4 for every n, despite identical one-place distributions. A balanced alternating sequence can have an exactly balanced average over every even block while its next reading is predictable from its previous one. Average stability and unpredictability are different response questions.

Full independence is stronger than one useful sufficient condition. Let (F_i) be an increasing information filtration, X_i∈[0,1] be F_i-measurable, and require E[X_i|F_{i−1}]=p_i for the forecast p_i available before that round. Put D_i=X_i−p_i. For i<j, E[D_iD_j]=E[D_i E[D_j|F_{j−1}]]=0. The conditional mean minimizes conditional squared error, so E[D_i²|F_{i−1}]≤E[(X_i−1/2)²|F_{i−1}]≤1/4. Hence E[(ΣD_i/n)²]≤1/(4n). For ε>0, on the event |ΣD_i/n|≥ε its squared value is at least ε², giving a probability bound 1/(4nε²). This finite inequality is exact under the conditional-forecast premise. It concerns accumulated forecast error, and concerns deviation from one fixed mean only when those forecasts are fixed accordingly.

**Stopping can change exact unbiasedness.** In the [counting model of Zhan et al., Appendix III.13](https://arxiv.org/html/2406.06810v2), a detected pass consumes two accounting units and a fail one. At zero overlap, their probabilities are 1/3 and 2/3. Stopping at accounting threshold N=2 gives terminal histories P, FP and FF with probabilities 3/9, 2/9 and 4/9. For k fails, the estimator 1−2k/N gives 1, 0 and −1. Its exact mean is −1/9, although the target is zero. FP overshoots the threshold. This is a consequence of the stated stopping model, not a reanalysis of raw detections. The authors' Appendix specifies asymptotic unbiasedness. Omitting that limit would strengthen the conclusion incorrectly.

The law, the information available before each round, and the realized records must remain distinct. Equal marginal frequencies do not establish the conditional premise. PP22 supplies finite internal preparations with independent readings and a capacity limit, so no source outside the whole is required. IiS24 shows why a contact's support does not determine its weights. VI therefore supports exact consequences of statistical premises and exact refusals of an insufficient statistic, while identifying the physical weights and their stability remains a separate acquisition task.

## §6b. What local reweighting cannot remove

G14b's disjoint applications commute even when the input fields are correlated. VC77 transports an acquired answer across a specified source change. Neither construction requires a product probability law. IiS24's selection problem asks a different question: which preparation weights survive a filter? Keeping these relations separate permits an exact invariant of a specified filtering class.

Let p and q be positive probability weights on one finite support E⊆X×Y, without isolated vertices. The allowed reweighting is q(x,y)=r(x)s(y)p(x,y) with positive factors. Normalization can enter either factor. These factors use the declared outcomes, without an omitted source dependence.

**Cycle ratios classify this reweighting.** For a cycle x₁,y₁,x₂,y₂,…,xₖ,yₖ,x₁, define

    C_p = ∏ᵢ p(xᵢ,yᵢ) / p(xᵢ₊₁,yᵢ),    xₖ₊₁=x₁.

Then q is an allowed reweighting of p exactly when C_q=C_p on every cycle. Necessity follows by cancelling each vertex factor. Conversely §6a applied to h=log(q/p) gives h=u+v, hence r=exp(u), s=exp(v). These are the diagonal-equivalence invariants of [Saunders and Schneider, Theorem 3.1](https://people.math.wisc.edu/hans/paper_archive/scanned_papers/hs058.pdf). A spanning forest's fundamental cycles suffice. A forest leaves no such weight invariant, although its support can still forbid combinations. Whole closure supplies neither these weights nor this filtering law.

**The marginals and these cycle ratios together determine the full law.** Suppose p and q have the same support, all cycle ratios and both marginals. The preceding factorization gives q=rsp. In one connected component choose M=maxₓ r(x). Equality of column sums makes 1/s(y) a positive weighted average of adjacent r-values, so s(y)≥1/M. At a row with r(x)=M, equality of row sums makes the average of its adjacent s-values equal 1/M. Every such s-value must therefore equal 1/M. Their column equations then force every adjacent r-value to equal M. Connectivity propagates these equalities through the component. Thus r(x)s(y)=1 on every edge and q=p. Repeat in each component. ∎

This is the uniqueness of a prescribed-marginal diagonal fit, also stated in [Kurras, Lemma 2.1](https://proceedings.mlr.press/v38/kurras15.pdf). The argument establishes completeness for actual positive laws. Arbitrarily proposed marginals, support and ratios need not be jointly realizable. It supplies no sampling accuracy or runtime reconstruction claim.

For two binary outcomes the single ratio is p₀₀p₁₁/(p₀₁p₁₀). The laws proportional to (1,1,1,1) and (2,1,1,2), in address order 00,01,10,11, have the same two uniform marginals and full support. Their ratios are 1 and 4. Hence no positive outcome-local row and column filters turn one into the other. On a full rectangular support all cycle ratios equal 1 exactly when the law factorizes into its marginals. Such filtering therefore cannot create or erase statistical independence while retaining that entire support. This claim concerns this filtering relation, not every operation on the two participants.

**A physically local filter need not be local to the retained outcome description.** Prepare independent fair bits a,b,s inside the whole. Give the first participant (a,c,s), where c=a⊕b, and the second b. Before filtering, the visible pair (a,b) has the first law above. The first participant accepts if c=0 or s=0, then reports a. The second always reports b. Each equal pair has two accepted preparations, and each unequal pair has one. Thus six of the eight prepared records survive, with the second law above. Every visible outcome remains possible. The first acceptance probability is 3/4 at each visible a, and both final marginals remain uniform.

The cycle ratio has changed even though the acceptance action uses only the first participant's packet. Its retained a omits the prepared relation c to b. The complete packet already determines b=a⊕c, so independence of the visible outcomes did not establish independence of the participants' complete preparations. Averaging that hidden relation does not produce a filter depending on a alone. No communication or exterior selector is required for this counterconstruction. It separates locality of an actual operation from locality of its proposed reduced description.

Consequently a changed cycle ratio can exclude the conjunction of a common source law, matched outcome addresses and the stated positive outcome-local filtering. It does not on its own exclude physical locality. Unchanged ratios permit reweighting under the theorem, while unchanged ratios together with unchanged marginals identify this full observed law. Neither conclusion identifies unrecorded source distinctions. Zero weights require their actual support, and a finite unobserved event does not establish a zero. These obligations connect the statistic to LQ13's contact profiles and VC15's continuation criterion. The proofs are the arguments above, without a new probability runtime or a marker declaring an unspecified physical filter valid.

## §6c. A long record is not automatically many trials

Matter M39 excludes a reversal-symmetric full law when an established record contrast has nonzero expectation and carries the relevant reversal. This is a statement about laws. Its finite-data use requires an admitted preparation class and a statistical error guarantee, even when the record is complete and its transformation exact.

**Reversal symmetry alone places a strict bound on evidence from one whole record.** Let R be an involution of the complete observed record, and let the null class contain every R-invariant probability law. A record may be an arbitrarily long history. Let a(x)∈[0,1] be a test's probability of rejecting after observing x, including any justified test randomization. Uniform level α means E_Q a≤α for every law Q in this null class.

For any alternative law P, the symmetrized preparation Q=(P+R_*P)/2 belongs to the null class. Consequently

    E_P a ≤ E_P a + E_(R_*P) a = 2E_Q a ≤ 2α.

Thus even the test's probability of detecting an alternative cannot exceed 2α under this unrestricted null. In particular, a deterministic test with any rejecting record cannot have uniform level below 1/2: the equally weighted pair x,Rx already defeats it. At an R-fixed record, unit weight defeats any deterministic rejection. If the decision itself is reversal-invariant, a(Rx)=a(x), the bound strengthens to E_P a≤α. An orientation-neutral test then has no power above its allowed false-positive rate. These bounds apply to a test with the entire record available, so further lossless encoding of that same input cannot evade them.

This does not make statistical observation of irreversibility impossible. It identifies an insufficient null class. The symmetric preparation can select one complete directional history or its reversal once, retaining that choice across all recorded positions. A long movie does not exclude this shared preparation by having many frames. No outside randomizer is asserted: Q is a candidate law on internal preparations admitted by the stated statistical premise. If the experimental contract excludes Q, it already contains an additional restriction that the proof must retain. Mixing, controlled repeated preparations, conditional bounds or a specified dynamical family can supply more structure. Stationarity, independence and quantitative mixing are different restrictions, and none follows from whole closure or from balanced transition counts.

**The useful resource is a justified family of separately applicable changes.** For m recorded blocks, suppose the joint null law is invariant under reversing any chosen subset of blocks. This is stronger than invariance under reversing all blocks together. Independent reversal-symmetric block preparations suffice, but the required relation is the joint invariance itself. Internal dependence compatible with it is allowed. Cutting a movie into m pieces does not establish it.

Under this contract the subset reversals form a group G. For a fixed statistic T, the tail fraction

    p(x) = |{g∈G : T(gx)≥T(x)}| / |G|

is a valid, possibly conservative p-value. On each orbit, group invariance assigns equal probability to the distinct transformed records, and counting upper ranks gives P(p≤α)≤α. This is standard group-invariance testing, as treated by [Hemerik and Goeman, §2](https://arxiv.org/pdf/1411.7565). Distinct transformations can give the same record or statistic, creating ties rather than extra evidence. With a free orbit of m binary block reversals the finest nonzero rank is 2⁻ᵐ. At five aligned nonzero signs, a prespecified one-sided sum can reach 1/32. For the corresponding absolute-sum test both opposite alignments tie, so six are needed to reach 1/32. These counts concern the exact stated sign-reversal design, not a universal sample requirement for physics.

The statistic must denote one procedure on the complete input at every transformed argument. If learning, feature selection or choosing a direction is part of that procedure, transform or repeat that step too, or establish its invariance before freezing it. Permuting only the outputs of an adaptively selected feature can test a different contract. Nor do transformed copies become independent new observations. More justified local changes can enlarge the comparison orbit. More repetitions of an unjustified transformation cannot.

## §6d. Which internal fragments can be reversed separately

LQ13 and G14b separate a local replacement's admission from commutation of disjoint operations. For the statistical use in §6c, a further condition concerns weights. If S is a bijection of the admitted finite records, retaining their outside fields, its probability law is invariant exactly when every record and its S-image have equal weights. Equivalently, the conditional weights within each retained outside context must be invariant. Equal unconditional marginals of the fragments do not establish this condition. Complete statistical independence is sufficient in some designs, but is stronger than the required conditional symmetry.

**Returning to a common label does not reset a joint preparation.** Let a loop have either recorded orientation +=ABCA or −=ACBA. Join two loops at their common A. Apply §6b's joint law proportional to (2,1,1,2) to (++,+−,−+,−−). Every joined word is admitted and each individual loop has uniform orientation. Reversing the whole word exchanges ++ with −− and fixes each mixed word, so the full law is reversal-invariant. Reversing only the first loop changes a weight 2/6 into 1/6. The common label and all separate orientation frequencies have been preserved, but this local reversal is not a symmetry of the joint law. Putting zero weight on both mixed words would additionally destroy its admission. The example locates a missing relation between successive fragments. It does not identify its carrier as controller or medium, and it does not declare A a complete state of that carrier.

**An explicit local weight law supplies a positive case.** On a finite state graph, specify a time-homogeneous transition matrix p and the full path law

    W(x₀,…,x_N) = μ(x₀) ∏_(t=0)^(N−1) p(x_t,x_(t+1)).

This factorization is the Markov premise for the declared state interface. It is additional structure, not a consequence of naming a present state. Assume there are positive π(x) with π(x)p(x,y)=π(y)p(y,x). In this model reversal reverses the order of these state labels, without an additional odd-coordinate transformation. On every positive closed subpath x_i,…,x_j with x_i=x_j,

    ∏_(t=i)^(j−1) p(x_t,x_(t+1)) / p(x_(t+1),x_t)
        = ∏_(t=i)^(j−1) π(x_(t+1))/π(x_t) = 1.

Thus reversing that subpath preserves its endpoint contacts, the outside factors and its weight. LiR7 already proves the converse potential criterion for reciprocal edge ratios on their connected support: unit closed products permit these node factors. In the Markov setting this is Kolmogorov's reversibility criterion, reviewed and proved by [Pistone and Rogantin, §2.5](https://www.ism.ac.jp/editsec/aism/pdf/10463_2012_Article_368.pdf). The state graph, path factorization and interpretation of reversal must be established before assigning this criterion physical meaning.

The initial μ need not equal π. Reversal of an internal closed block leaves x₀ and its preparation factor unchanged, so the result can apply before stationarity. It tests this conditional mechanism relation, rather than every asymmetry of the prepared full history. Fix disjoint block interiors in advance and reverse a block when its endpoints agree, otherwise act as the identity. Each transformation is an involution, preserves its own guard and commutes with the others. They therefore supply §6c's group-invariance test without estimating the unknown entries of p or π. Fixed blocks with unequal endpoints contribute no change. A rule selecting successive return excursions can also be used when the selection is unchanged by their reversals, for example complete excursions between consecutive visits to one fixed anchor. Other adaptive selections need that invariance checked.

**Compatible memory need not be removed.** Multiply W by a nonnegative factor C of the full record and renormalize, assuming a positive normalizing sum. If C is invariant under each retained block reversal, the new law has the same symmetries. C may couple lengths or unoriented shapes of different excursions, so this family can include processes that are not Markov at the retained state interface. What the test requires is preservation of the relevant conditional weights. The orientation-dependent coupling in the two-loop example violates exactly that relation. Calling all memory a violation would discard valid sources, while ignoring all memory would admit that counterexample.

The boundary part has a static consumer. `JoinedFourEntryWords` in `Checks/Interactions.swift` joins the actual last field of one word to the actual first field of the next, retaining both input words. `ClosedBlockReversalPreservesContinuation` reverses a closed first word through `ReverseFourEntries`, obtains an admitted joined word, preserves the continuation and restores the entire joined result on a second reversal. The construction is generic in all its payloads. An expected refusal reverses an open first word and rejects its now mismatched contact with the unchanged continuation. These checks establish the word-boundary relations. Weight invariance, the Markov sufficient case and the more general invariant coupling follow from the arguments above, not from an unspecified protocol called a physical law.

## §6e. A symmetry of spelling is not a new comparison case

The transformations in §§6c–6d act on records for a statistical comparison. Three different obligations must remain visible: preserving a referent under a change of description, relating possible records under a specified null law, and implementing an intervention on the source. A computation on a stored record can be physically performed inside the whole while leaving the earlier source event unaltered. Its existence does not establish the other two relations.

**A pure change of description cannot improve the rank of an invariant question.** If a scalar relational statistic T satisfies T(hx)=T(x) for every member h of a proposed test group H, then every comparison in §6c's tail count is tied. Its p-value is 1, regardless of |H|. A large group of spellings has supplied no contrasting answer. VI1 already explains why this does not erase relational distinctions: transforming both a form and its reference preserves their comparison, while changing one relative to the retained other can change it.

For example, reorder a collection of paired condition labels and outcomes together, retaining every pairing. A statistic comparing those conditions is unchanged. Reassign outcomes among the fixed condition positions and the joining changes. That second family can support a statistical test when the null law permits these reassignments with the required weights. Neither freedom to rename the condition labels nor equality of the two separate outcome lists establishes that premise. The contrast is in a retained internal relation, without an exterior reference.

**Changing coordinates must transport the entire test.** For an invertible record encoding h, define G′=hGh⁻¹ and T′=Th⁻¹. At y=hx, every transformed statistic satisfies T′((hgh⁻¹)y)=T(gx). The group correspondence therefore preserves the complete tail count and p-value exactly. The source law and its null class are transported by h as well. Keeping an old reversal or comparator after changing the representation is a different construction, as M39's lossless delay-pair example demonstrates. An encoding need not be invertible if it retains all the comparisons this particular test uses, but that sufficiency must be established.

The same distinction applies to a reversal comparison before choosing a statistic. If Q=h_*P and R′=hRh⁻¹, then R′_*Q=h_*R_*P and TV(Q,R′_*Q)=TV(P,R_*P). Bijection transports the event sets over which the supremum is taken. Thus an invertible change of coordinates cannot create or remove that law-level asymmetry when its comparison relation is retained. Using an untransported R can ask a different question.

**A valid statistical transformation need not be an available intervention.** The local loop reversals of §6d describe alternative paths with equal weights under that hypothesis. Computing their scores does not physically reverse the source, rewrite its past or produce independent repetitions. Conversely, implementing a change somewhere in the whole does not make its induced data distribution invariant. That assertion still requires the specified source-law relation.

IiS14 supplies a precise related distinction: software can transpose a matrix's entries, while the corresponding proposed operation on an unknown quantum subsystem fails the untouched-reference positivity test. The computed inscription exists. The claimed local physical operation lacks the required joint admissibility. No separate nonphysical world is needed to make this distinction. Matter §1 already places descriptions, their computation and their referents inside the same whole while retaining their different roles. A new recording act can leave its own trace without becoming another observation of the original event.

## §7. Statement

1. Between comparisons, under the declared model, the mean drift of a pair rises monotonically to N/(1+c); the stationary law is Binomial(N, 1/(1+c)); stationary agreement has probability (c/(1+c))^N; at c = 0 there is no return (AC1).
2. At c = 1 drift and age share parity: agreement is reachable only at even ages (AC2).
3. What one side's history yields about drift factors through its own footprint and the clock; the count of its touches is not a sufficient statistic, the footprint is (AC3).
4. About the other side's contribution, one side's entire archive carries exactly what the clock carries (AC4).
5. A local record certifies an answer exactly when all compatible joint histories agree on it. At c=0, a locally touched address is a guaranteed divergence without a copy of the other state (AC5).
6. A common-source construction can establish relations among its outputs. A relation to an independently changing recorded fact needs its own binding. D does not automatically apply to that pair (AC6).
7. Expected posterior entropy under observation and the pair's shell entropy have different laws. Monotone mean drift does not imply monotone shell entropy (§6).
8. Across all finite mixtures on a real interval, the mean preserves exactly affine response expectations. Error envelopes and sampling bounds require their own source and conditional-law premises (AC7).

The edit model determines a conditional drift law. The question and available evidence determine whether a new comparison is needed. Common-source construction changes the first problem by removing an independence premise, and can settle the second by a structural proof.

## Scope

AC1–AC4 concern D, with N≥2, initial agreement and the stipulated address and closing laws. Section 6 separates mean drift from shell entropy. AC5 gives the exact evidence criterion and refutes the old universal ban on one-sided certificates. AC6 concerns actual construction and states when D ceases to apply. Physical use requires the corresponding implementation and edit premises. No instruction naming convention establishes their necessity in every system. AC7 audits a separate statistical family, without assuming D or deriving the weights and conditional forecasts from the given whole.

## §8. Dependency

| Source | Used |
|---|---|
| V=I | §5.18, §5.19, §5.20, §5.21, §5.24 |
| Difference Is Distance | S7, S9 |
| Distance Is Cost | G2, G4b, the frontier |
| Merge Is Commutation | Definitions 1, 3; MiC1-MiC4 |
| Record Is System | SW3 |
| Dynamics Is Substitution | the elementary move |
| Halt Is Ignition | HF2 |
| Permanence Is Resistance | M12, M21, M24, M27 |
| Interference Is Intelligence | records, elimination and question resolution |
| Seam Is Game | SG1-SG3; consequence (c) |
| Verdict | VC15; actual-source verdict and composition constructors |
| Declared here | the edit model D; finite reversible chains (detailed balance, Kac); the Ehrenfest chain (1907) at c = 1 |
