# Permanence Is Resistance (Matter) — Balance clock

This part contains the original derivations for balance clock.

Family and original section headings: <doc:permanence_is_resistance>.

Section setting: <doc:permanence_is_resistance#4g-Which-future-must-carry-a-real-distinction>.

### M64au

**M64au (two cycle readings restore exact record admission, not its physical provenance).** Keep M64at's Petersen graph, its common raw edge record z, and the five retained matching parities. Now allow z to be *any* binary edge record; do not assume in advance that its error count is at most one. The five bits always determine a proposed pair (q̂,ê), where ê is either no edge or one edge, by M64at's majority-and-minority rule. This is a proposed interpretation until its applicability to z has been established.

Let O(z) be the XOR of the five outer-cycle edges and I(z) the XOR of the five inner-cycle edges. For an edge e let χ_O(e),χ_I(e) indicate membership in those cycles, with both zero for no edge. Then

    z is within one edge error of some comparison record δθ
      iff O(z) = χ_O(ê) and I(z) = χ_I(ê).

If the condition holds, its comparison record and error location are unique, and the joint source parity is q̂. Uniqueness here concerns the realizations admitted by this one-error family. It does not identify an unrestricted actual source from its allegedly corrupted record.

Here is a constructive proof of sufficiency. Put z′=z XOR ê, interpreting ê as its one-edge indicator. The five retained matching parities of z′ all equal q̂. The sixth equals their XOR, hence also q̂. The two new conditions say O(z′)=I(z′)=0. Choose an arbitrary bit at a_0 and use the outer edge records successively to assign a_1,...,a_4. The last edge is consistent because O(z′)=0. Set b_i=a_i XOR z′(s_i) from the spokes. This constructs θ and matches every outer edge and spoke without using any inner edge equation as a premise.

Only inner residuals may remain. Define

    r_i = z′(k_i) XOR b_i XOR b_(i+2).

Subtracting δθ does not change cycle parities. The spoke matching has zero residual; each other matching has residual r_(i+1) XOR r_(i+2). All six corrected matching parities were equal, and every matching parity of δθ equals the joint vertex parity. Therefore all these pair residuals are zero. Successive r_i are equal, so all five equal one bit r. The inner cycle condition now gives 0=I(z′ XOR δθ)=5r=r. No residual remains. The spoke matching also shows that the constructed θ has joint parity q̂. This proves existence by constructing all vertex relations; it does not add existence of θ to the caller's premises.

Conversely, suppose z=δθ XOR e with at most one error. M64at recovers exactly (q_T,e), and every cycle has zero parity on δθ. The two displayed equalities follow. Uniqueness of e and q_T follows from the same decoder; δθ then equals z XOR e. On this connected graph θ is determined by that full corrected raw record up to one global bit. This last recovery uses the raw record, not only the seven compressed bits.

Two is minimal in the declared interface of *additional binary linear parity readings of the same raw record*. Let U be one on every outer edge and zero elsewhere; let V similarly mark every inner edge. Every matching meets each cycle in either zero or two edges. Thus adding U, V or U XOR V leaves all five old summaries unchanged. In particular 0,U,V,U XOR V all have old message zero. Their new cycle messages are respectively (0,0),(1,0),(0,1),(1,1). Only the first is admitted: the old message forces the proposed pair (0,no error), while each other record violates at least one cycle condition necessary for a comparison record.

Any single binary linear reading has a nonzero kernel element on the two-dimensional span of U,V. It therefore gives the same new bit on zero and at least one of the three nonadmitted records. Choosing that one reading adaptively from the five old bits does not help on their common zero transcript. The two displayed readings attain the bound. An arbitrary nonlinear oracle that directly answers record membership would be a different interface and could return one bit; no absolute two-bit lower bound for a Boolean question is claimed. The six-matching sum supplies no repair because it was already determined by the old five bits.

There is also a lower bound without prescribing the first five readings. For the total question which returns either "not admitted" or the pair (q_T,e), **seven binary linear parity readings are optimal, even with adaptive choice of readings**. To prove necessity, follow any successful strategy on the all-zero raw record. Its answer must be (0,no error). Every raw record with the same transcript must have that same answer, so it must belong to C_0={δθ : XOR_v θ_v=0}. There are exactly 2^8 such edge records: the parity-zero vertex assignments number 2^9, and each edge record on the connected graph has exactly the two assignments related by a global flip. Both assignments have even parity because there are ten vertices.

After k binary linear queries on the fifteen raw bits, the transcript's solution set contains at least 2^(15-k) records. This remains true for an adaptive strategy: the chosen queries are fixed on this reached branch, and any record satisfying their equations follows that same branch. To fit inside C_0 therefore requires 2^(15-k)≤2^8, or k≥7. The five matching and two cycle readings attain seven. This is a lower bound for the joint admitted-answer-and-location task. It is not asserted for the Boolean admission question alone, for unrestricted nonlinear messages, or for the number of physical edge acquisitions. All fifteen edge records are already accessible in the declared interface. There are only 33 possible final answers: 32 admitted pairs and one refusal. An unrestricted encoder that has already solved the question can label those answers with six bits. The seven-bit lower bound is therefore a restriction of acquiring the answer through linear parity readings, not a count of the answer's abstract possible values.

The seven-bit reading factors two questions that the old five-bit reading did not factor jointly: membership in the admitted raw-record family, and, when admitted, its uniquely determined (q_T,e). It still discards most of the source. Both new facts must concern the same addressed raw record as the matching summaries. If that record is retained, acquiring the new question does not require repeating the physical measurements. If only the five old bits survive, no further internal calculation on them recovers the lost admission test; the four records above are a direct witness to that impossibility.

Record admission is not acquisition of the physical error bound. For example, the zero raw record can arise from the all-zero source with no errors, or from a source with exactly one vertex bit changed and with all three incident edge records flipped. In the second realization the joint source parity is one, but the raw record, all matching summaries and both cycle checks are exactly as in the first. Even complete access to that same raw record cannot distinguish these two explanations when such coherent errors are allowed. The test proves existence of a one-error explanation; it does not prove that the actual history belongs to it. Inferring the actual q_T still requires an established relation restricting that history, or a further contact which separates these possibilities. This is a concrete application of the sufficient-reading criterion, not a new trust flag or an unexplained physical exception. Nor does failure of the test make a record impossible in reality. A contact law with actual path dependence can produce a nonzero cycle without any bad measurement. What fails is its representation as these fixed vertex comparisons with at most one erroneous edge. Flatness of that representation has a proved admission test here; it has not been derived as a universal law from closure of the whole.

`PetersenCycleReadings` reads both cycles from the same fifteen fields as `PetersenContactRows`. In matching-index order with M_5=M∞, the outer edges are 24,03,14,02,13 and the inner edges are 34,04,01,12,23. The existing `JointEvidence` construction requires a common actual source. `FiveBitParity` links four successive parity applications to those actual row fields; its concrete uses contain only the finite parity clauses in `WitnessTransfer`. An arbitrary conformance with the same operation name does not establish XOR semantics. The four hidden-cycle cases yield the four distinct acquired bit pairs, and M64at's original triangle yields (1,0) from its actual raw source. `RecordReading` retains that source with the acquired fact. Refusals reject the triangle's alleged zero cycle result and joining cycle facts from different raw records, even when the substituted individual answer is equal. These static checks verify the addressed construction and the displayed cases; the universal admission criterion and its lower bound have the constructive proofs above, without executable enumeration.

### M64av

**M64av (a joint balance can be sufficient without an autonomous model of the process).** An independently developed control mechanism supplies a useful test of VI's scope. The ideal antithetic controller has two controller species: reference production increments Z1, sensing increments Z2, and a common reaction decrements both by one. The sensing intensity is proportional to the regulated output; actuation connects Z1 back to that output. The published stochastic tracking theorem requires ergodicity and moment bounds; the cancellation alone is not its stability proof. See [Briat, Gupta and Khammash, reactions (1), equations (2–4), Theorem 1](https://arxiv.org/pdf/1410.6064).

For VI, first separate the finite event relation from assumptions about time, rates and limiting distributions. Consider any finite admitted history of count pairs (z1,z2). Reference and sensing events have changes (1,0) and (0,1). A common removal has change (−1,−1) and requires both reactants. Other events in the admitted fragment leave these counts unchanged. Let A,B,C count the respective three events. Directly summing their changes gives

    z1′ = z1 + A − C,       z2′ = z2 + B − C,
    D′ − D = A − B,         D = z1 − z2.

Equivalently, z1′+z2+B = z2′+z1+A. This natural-count equality does not require a signed-number implementation. It follows by induction on the actual event sequence: reference adds one to the first difference, sensing subtracts one, and common removal changes neither. No event probability, fixed common-removal rate, independence, clock or convergence is used. The same proof admits any jointly equal count changes. The specified reaction incidences perform the work. Describing two separate losses with the same parameter name does not make them one such event.

This gives an exact finite bound on accumulated imbalance. If |D′−D|≤K and A>0, then |B/A−1|≤K/A. Along a sequence of histories with A→∞, the event-count ratio B/A tends to one exactly when (D′−D)/A tends to zero. These statements use the actual reference events as the denominator, without introducing external time. They concern numbers of events; a regulated concentration or output rate needs its additional sensing relation. Persistent event imbalance must appear in D or in a violation of the admitted event/capacity conditions. It cannot be removed by an unknown number of the common cancellations.

The statistic D does **not** determine all enabled microscopic actions. States (0,0) and (1,1) have the same D=0, but common removal is unavailable in the first and available in the second. Actuation depending on z1 can also distinguish them. This alone does not prove that D's own evolution is nonautonomous: common removal leaves D unchanged.

For a separate test of autonomy, include the regulated output Y in the complete state and use the stipulated Markov reaction intensities μ and θY. On any bounded test function f of D, the projected generator is

    L(f∘D)(z1,z2,Y) = μ[f(D+1)−f(D)] + θY[f(D−1)−f(D)].

Common removal and actuation contribute zero directly. If the admitted state family contains two states with the same D and different Y, their instantaneous rates to D−1 differ. No Markov generator on D alone can represent this projected law for every such initial state. The exact event balance still holds for both. This is a statement about the declared family, not a refusal of every possible restricted preparation.

Conversely, with constant reference and sensing intensities μ and ν, the same reaction incidences admit an autonomous continuous-time random walk for D: the displayed generator has ν in place of θY and depends only on D. Hidden common removals may still have rate ηz1z2 and different availability. Thus loss of the full action description, nonautonomy of the chosen reading, and exactness of its event balance are three separate properties. Neither autonomy nor its failure is required to use the finite balance. Its long-run consequence needs the further conditions below.

For the time-based interpretation, suppose the counting model has reference intensity μ>0 and sensing intensity θY(t), with θ>0, and its counts are nonexplosive and both the counts and integrated intensities are integrable on the interval considered. Write M_A(t)=A(t)−μt and M_B(t)=B(t)−θ∫₀ᵗY(s)ds for their compensated counts. The same finite-count identity yields, path by path,

    (1/t)∫₀ᵗY(s)ds = μ/θ − (D(t)−D(0))/(θt)
                            + (M_A(t)−M_B(t))/(θt).

Under the stipulated intensities and integrability, the compensated counts have zero mean. Consequently

    (1/t)∫₀ᵗ E[Y(s)]ds = μ/θ − (E[D(t)]−E[D(0)])/(θt).

Hence convergence of this averaged mean output to μ/θ is equivalent to sublinear growth of the mean difference on the right. Full stationarity is not needed for this particular implication. Neither pointwise convergence of E[Y(t)] nor almost-sure convergence of the single-path time average follows from this averaged-mean identity alone. On a single path, sublinear growth of D and of the compensated-count difference is sufficient. The mean identity does not remove this latter random term from a realized history. Nor does a bounded difference by itself bound the two separate populations: they can grow together. Under the unit-Poisson time-change assumptions, M64ax gives a sharper path criterion: relative to its diverging internal clock, sublinear growth of the difference alone is necessary and sufficient for the weighted output limit. That inference uses the counting law in addition to the finite event balance. The ratio μ/θ is the remaining reference-to-sensing relation, not an absolute constant supplied by closure of the whole. Changing that ratio changes the target. For a common variable multiplier μ(t)=ρa(t), θ(t)=a(t)>0, the deterministic balance instead controls the weighted reading ∫a(t)y(t)dt/∫a(t)dt, with boundary correction −(D(t)−D(0))/∫a(t)dt. It does not automatically control the unweighted time average. The identity follows directly by integrating dot D=a(t)(ρ−y(t)); convergence needs a diverging denominator and a sublinear boundary term relative to it. Thus even removal of a common unknown timing scale preserves a specified relational question, rather than every meaning assigned to the word "average".

The finite identity also states exactly what breaks under extra losses. If L1 and L2 count additional separate decrements, then

    D′−D = A−B−L1+L2.

Even equal per-capita loss rates δ do not give equal actual losses. In a deterministic description with such loss terms, dot D=μ−θy−δD, so a stationary value satisfies y*=μ/θ−δD*/θ. For a concrete admitted counterexample, take

    dot z1 = 3/4 − 2z1z2 − z1,
    dot z2 = y − 2z1z2 − z2,
    dot y  = z1 − y.

The positive constant state (z1,z2,y)=(1/2,1/4,1/2) satisfies all three equations, while the ideal target is 3/4. This is an exact counterexample to deriving that ideal stationary target after adding equal independent loss-rate coefficients. No claim about convergence to this state or about measured biological parameters is needed for the counterexample.

The physical application has an experimentally important boundary. Aoki et al. implemented paired sequestration using sigma/anti-sigma proteins in E. coli. Their comparison circuit omitted the anti-sigma feedback module. Under induced protease perturbation, the closed-loop fluorescence was maintained in an investigated region while the open-loop output decreased. The article also reports an exit from that adaptation region and models dilution and saturation. This is evidence about a concrete implementation and range, not exact regulation under every perturbation. See [Aoki et al., Fig. 2 and discussion of non-ideal conditions](https://doi.org/10.1038/s41586-019-1321-1). No experimental data have been independently reanalysed here. The ideal cancellation, the stochastic theorem and these experimental findings retain distinct claims and premises.

`JointReactionBalance` supplies a finite proof grammar. A start witness has equal current and ledger pairs. A reference or sensing constructor increments the actual current field and its corresponding ledger field. A removal constructor consumes two actual successor fields, changes both current counts and retains the ledger. Induction proves that current and ledger differences agree for every finite construction from these rules and finite Never/Succ counts. The caller supplies neither final difference equality nor a desired final count. An open `JointEventBalance` conformance by itself does not establish that interpretation. Generic type checks compose a birth/removal path, retain the actual removal record, and distinguish a returned working pair from its birth ledger. Refusals reject an empty reactant pair and identifying one-sided loss with the common removal. No runtime arithmetic is used.

This imports a constraint from an independently studied mechanism into VI: a useful exact guarantee need not be a complete autonomous quotient of the dynamics. The common event establishes a balance that can support regulation without a stored model of the unknown network. The local count description does not claim that matter disappears from the whole; inactive products, reservoirs and the surrounding process are outside this particular reading. The construction also supplies no inference from regulation or local accessibility to subjective experience.

### M64aw

**M64aw (retaining a selected answer need not retain the contact that can apply it).** An external experiment separates selection from the prepared input of an action. Lahue, Au and Modrich reconstituted E. coli mismatch repair. Changing which strand carried the single GATC methylation changed the strand corrected; the site lay 1024 base pairs from the mismatch. Pre-incision allowed correction without MutH when ligase was absent. Adding ligase inhibited this route. MutH restored repair for GATC-bearing substrates, but not for the tested substrate lacking GATC, including when both substrates shared a reaction. Other repair requirements remained. These interventions support distinct initiation and downstream roles; they do not make every marked strand historically correct, or every individual repair infallible. See [Lahue et al., Figs. 3–5](https://cmgm-new.stanford.edu/biochem/biochem201/Papers/modrich.pdf).

Here is a finite relational model of that distinction, not a molecular simulation. Express both stored contents in one comparison convention, so matching contents have the form (a,a). Write a current surface as

    s = ((a,b),(m,(o,h))),

where m is an attached selection relation, o is the actual access state, and h is a retained remainder. Let C mean closed and N2 access to the second content. For a selection m=1 preserving the first content, the following are partial operations with the displayed exact domains:

    I2: ((a,b),(1,(C,h)))  -> ((a,b),(1,(N2,h))),
    T2: ((a,b),(m,(N2,h))) -> ((a,a),(m,(N2,(b,h)))),
    L2: ((a,b),(m,(N2,h))) -> ((a,b),(m,(C,h))).

I2 prepares access; T2 transfers the selected content and retains the displaced b; L2 closes access. T2 uses a prepared N2 and its actual contents, without requesting the earlier m=1 relation again. The symmetric I1/T1/L1 branch preserves b. The domain restrictions are the declared local model, motivated by the intervention above. They are not derived from the spelling of an enzyme name or from global closure.

**What is constructively forced.** The word I2,T2,L2 maps the closed source to ((a,a),(1,(C,(b,h)))). Direct substitution proves agreement, preservation of a, closure and retention of b for all a,b,h. None of these final equalities is supplied as an extra premise. On T2's image, the inverse reads a from the first current field, b from the head of the remainder, and h from its tail. It recovers the entire presented input. The local projection (a,b) -> (a,a) is many-to-one when at least two b are admitted; the displayed complete transfer is injective. This is an explicit recoverable realization, not a claim that the experiment has measured that environmental record or that every physical correction has a supplied inverse.

Now perform I2,L2 before T2. The contents, selection and h return unchanged, but o=C, so the required T2 input is absent. Thus even exact preservation of the selected answer does not preserve the opportunity to apply it. In the interface containing only T2, L2 and identity, a closed state cannot change: the first nonidentity step of any proposed word is undefined. For a≠b, agreement is therefore unreachable in that interface despite the retained value of a. With the attached m=1 and I2 available, the word I2,L2,I2,T2,L2 instead has exactly the same full endpoint as I2,T2,L2. This supplies both the obstruction and its repair by an actual contact, rather than by an assertion that access once existed. It gives no scheduling or reaction-rate guarantee.

Three questions require separate answers. Selection determines which current content the declared correction preserves. Prepared access determines whether the next action is admitted. Historical fidelity asks whether that selected content equals the earlier intended one. On a≠b, both branches produce agreement, but their current outputs are (a,a) and (b,b). If the admitted histories allow either strand to have acquired the discrepancy, the mismatch itself cannot identify the historical target. An attached marker selects a branch; identifying that branch with historical fidelity additionally uses its acquisition and copying relations. When a=b, both branches already give the same content answer and selection can be omitted for that particular question.

This applies M71e's distinction between an answer and admitted future contacts to a separately investigated mechanism. Closure here changes an actual relation in the medium; it cannot be reduced to a status change in an observer's record. Information about the earlier opening may remain perfectly legible while the opening no longer exists. Neither an external clock nor loss of that historical information is needed for this order sensitivity. Conversely, knowing the allowed order does not establish that a competing process will permit its completion.

`DirectedRepair.swift` gives the displayed field constructions, using the existing `SequentialReading` rather than a new correctness protocol. `FirstDirectedRepair` derives the target and agreement; the symmetric branch separates agreement from content identification. `RestoreSecondFromRemainder<S>` accepts only the actual result and projects its fields, with no hidden earlier-b parameter. `ReopenedFirstRepair` composes actual re-opening. The checks include arbitrary residual h, a prepared contact with no upstream selection marker, and retaining an opening's source and fact through `RecordReading`. Refusals exclude use after closure, the opposite opening, and identifying the two agreement outcomes. They verify this stated finite fragment, not arbitrary `PredicateReading` conformances or the complete chemistry.

**No privileged surviving side is required when another relation suffices.** The need for M64aw's directed marker is relative to the two-copy task; it is not a universal need for a permanently trusted object. Here is the elementary repetition-code alternative, derived from actual contacts. Let values belong to any set with at least two elements. Prepare five internal positions as

    ((a,a,a),(b,c)),

with arbitrary reserve contents b,c. The available corruption family contains identity or one transposition of a replica with a reserve. Every such contact is a permutation of the full five-position carrier. Its displayed wiring, not the name "one error", establishes that at least two replicas still carry a. The reader receives only the three current replicas, omitting the reserves and the contact address.

Define D on triples with an equal pair to return the repeated value. The three clauses compare positions 1/2, 1/3 and 2/3. If two clauses apply, all three entries agree, so the outputs agree. Thus these clauses define one function of the current triple, independent of which clause was used. They cover every prepared one-transposition outcome, and each returns a. There is no trusted surviving position and no old-a input to the decoder. Permuting positions or bijectively renaming values preserves this conclusion. Equality has its stated content-comparison meaning; the construction does not prove an instrument for comparing arbitrary physical preparations.

Two replicas cannot give the same guarantee. For x≠y, the view (x,y) can result from preparation (x,x) by replacing its second entry with y, or from preparation (y,y) by replacing its first entry with x. Both replacements can be realized as swaps with an internal reserve. The same complete available input would have to return both x and y. Consequently three is the minimum number of homogeneous replicas for this one-affected-position, unmarked recovery question. It is not a universal three-bit basis for information or a consequence of closure without the preparation and contact relations.

Even three do not survive an unexamined extension of the contact family. Start from (a,a,a,b,b). Swap positions 1/4 and then 2/5, obtaining (b,b,a,a,a). From (b,b,b,a,a), swap positions 3/4, obtaining (b,b,a,b,a). The visible triples are both (b,b,a), while their original values are a and b. The complete states and their histories remain different; no information has been destroyed by these swaps. At most two allowed swaps therefore defeat recovery from that view. Naming the first two swaps one macro-operation does not restore the one-position guarantee. Contact support, not number of command names, matters.

Reading is still distinct from repair. Admit the additional, explicitly defined contact

    J_D: (v,r) -> ((D(v),D(v),D(v)),(v,r)).

It is controlled by the current view v alone, keeps the complete current input in its remainder, and is injective with inverse projection on its image. Following any prepared one-swap path by this contact restores the working replicas to (a,a,a). This is a recoverable symbolic realization with an admitted record extension, not a derivation of blank storage, cloning of arbitrary physical states or indefinite finite-carrier reuse. Without an available realization of J_D, the decoder alone gives knowledge of a, not the act of repairing the medium.

The rule's historical meaning comes from preparation and contact support. Symmetry alone does not prefer the repeated value: on triples with exactly two equal entries, choosing the singleton is also invariant under position permutations and equivariant under value renaming. Only the first rule recovers the homogeneous preparation after every permitted single swap. The criterion is grounded by those internal relations; it need not be a frozen object outside the process.

`RepairWithoutAnchor.swift` supplies four actual swap clauses, covering all three working positions and an alternative reserve, and proves their full involutions. The generic recovery paths pass only the current triple to the three equal-pair readers. These paths certify coverage; the executor's answer is the single glued D above, not a hidden choice based on a supplied fault address. `RestoreReplicasFromReading` uses that view to restore the replicas and retains the input as actual output fields. The two-history collision has equal available views and distinct original values. Static refusals reject extending the guarantee to that collision and treating unequal fields as an equal-pair reading. The general minimum and the interpretation of this finite grammar have the proofs above; this is an application of known repetition coding, not a new coding bound.

### M64ax

**M64ax (an internal clock can be omitted exactly for the answers its reweighting preserves).** M64av leaves a precise timing question. Changing the name of a time coordinate, changing the measure used to average a path, and changing the relative speed of actual contacts are different operations. For a C¹ coordinate change s=φ(t) with φ′(t)>0, and an integrable output on [0,T], the old average ∫y(t)dt/T becomes ∫y(φ⁻¹(s))(dt/ds)ds/T over [φ(0),φ(T)]. Using uniform ds instead is a different reading unless the relevant invariance has been established. This distinction needs no clock outside the whole: two internal ways of comparing progress may supply different measures.

**The complete finite clock-reweighting family.** Let Q be the generator of an irreducible continuous-time Markov model on n≥2 states. Write π for its positive stationary distribution, λ_i=−Q_ii>0, and P_ij=Q_ij/λ_i for j≠i, P_ii=0. P describes which state comes next conditional on a jump, not the transition probabilities over a fixed time interval. Multiply all outgoing rates at state i by a_i>0:

    Q^a_ij = a_i Q_ij,
    π^a_i = (π_i/a_i) / Σ_j(π_j/a_j).

The jump matrix remains P because the same a_i cancels in numerator and denominator. The second formula is stationary since (π^a Q^a)_j = (πQ)_j / Σ_i(π_i/a_i) = 0; irreducibility gives uniqueness. This uses the finite generator criterion, for which see [Lalley, §2 and §3.2, Corollaries 5 and 8](https://www.stat.uchicago.edu/~lalley/Courses/312/ContinuousTime.pdf). The stationary jump weights, proportional to π_iλ_i, also remain unchanged after reweighting. The entire jump-record law is unchanged when the same initial jump-state distribution is used. Initializing each timed model in its own stationary distribution is a different comparison and need not give the same initial state law.

Every strictly positive probability vector p is attainable as π^a: choose a_i=π_i/p_i. Thus the conditional jump law alone permits every positive stationary occupation law in this class. For a nonconstant real output q, its possible stationary means fill the open interval between its minimum and maximum; the extrema are approached by positive weights concentrating at extremal states. Every interior value is attained by a positive mixture. Consequently a stationary mean is invariant under all these state-dependent speeds exactly when q is constant. A common constant speed is a smaller change family and preserves every stationary mean.

This is not a contradiction in probability theory: holding times were part of Q and have been omitted from P. Nor is the finite Markov carrier asserted to be the complete physical whole. A physical speed change must be distinguished relative to some internal comparison process. Rescaling that comparison together with every contact may instead be a mere coordinate change. The derivation states the model and the retained reading, rather than deriving either from closure.

**A weaker, positive criterion for an unknown clock.** Suppose the allowed speed depends only on a specified class c(i), independently choosable as a_c>0. For each nonempty class define

    w_c = Σ_{i:c(i)=c} π_i,
    m_c = Σ_{i:c(i)=c} π_i q_i / w_c.

Then the new stationary mean is

    Σ_c (w_c/a_c)m_c / Σ_c(w_c/a_c).

It is the same m for every allowed class speed exactly when every m_c=m. Sufficiency is substitution. For necessity, w_c/a_c can range independently over all positive weights; concentrating them at one class forces its m_c to equal the purported common value. No recovery of the individual speeds is required. Requiring preservation of the whole distribution of q instead gives the stronger condition that the conditional q distributions be the same in every clock class, by applying this argument to each output indicator.

For example, a directed four-cycle with unit base rates has uniform π. Let its successive q values be 0,1,0,1 and its clock classes be A,A,B,B. Unknown class speeds give unnormalized occupation masses (u,u,v,v), with u=1/a_A and v=1/a_B. Each outcome receives mass u+v, so the mean is exactly 1/2 for every positive u,v. Change only the class-to-output alignment to A,B,A,B: the masses become (u,v,u,v), and the mean is v/(u+v). The two class sizes, output counts and conditional next-state laws did not determine that joint alignment.

Even robust preservation of a mean is not preservation of the noise law. On the same A,A,B,B clock partition, use q=(0,2,1,1). Both class means equal 1, so every speed gives mean 1. Its stationary variance is u/(u+v), which can vary throughout (0,1). These are exact finite model calculations, not measured biological parameters.

**The regulated relation in an internal event clock.** In M64av's counting model allow a positive predictable speed a(t), a nonnegative predictable output Y(t), and intensities ρa(t) and a(t)Y(t), with ρ>0. Assume nonexplosion and finite integrated intensities on every finite interval. For the expectation statements below, additionally require integrability sufficient for the compensated counts to be true zero-mean martingales on the stated finite interval. Put C(t)=∫₀ᵗa(s)ds, M_A=A−ρC, and M_B=B−∫₀ᵗa(s)Y(s)ds. The existing pathwise count balance gives, whenever C(t)>0,

    ∫₀ᵗa(s)Y(s)ds / C(t)
        = ρ − (D(t)−D(0))/C(t) + (M_A(t)−M_B(t))/C(t).

The counting/intensity distinction is the one specified in [Anderson and Kurtz, §2.2–2.4 and Definition 1.5](https://people.math.wisc.edu/~dfanderson/papers/SURVEY_AndKurtz.pdf). The path criterion becomes sharper under that model's unit-Poisson time-change representation. Write S(t)=∫₀ᵗa(s)Y(s)ds and A(t)=P_A(ρC(t)), B(t)=P_B(S(t)). On the probability-one event where both unit Poisson paths obey P(u)/u→1, and on paths with C(t)→∞,

    S(t)/C(t)→ρ  if and only if  (D(t)−D(0))/C(t)→0.

For sufficiency, A/C→ρ, so B/C=A/C−(D−D(0))/C→ρ>0. Therefore B→∞, which forces S→∞, and B/S→1. It follows that S/C=(B/C)/(B/S)→ρ. Conversely S/C→ρ>0 implies S→∞ and B/C→ρ; subtracting from A/C gives the vanishing difference residue. This uses the Poisson strong law, stated in Anderson and Kurtz, Theorem 1.2. The clocks may depend on previous events: the pathwise limit holds along every diverging argument, so no independence of S or C from their drivers is inserted. There is no separate small-noise premise. The result needs the counting-law representation; it does not follow from the finite balance alone. Nor does it imply convergence of the expectation of the normalized ratio without an additional bound such as uniform integrability. Ordinary t-averaging does not follow. The actual-event identity D′−D=A−B also still gives B/A→1 when A→∞ and (D′−D)/A→0, without obtaining a from a clock. C is an integrated intensity, not a claim that its exact value is directly observed as a count.

Expectation requires special care when C is random. The zero-mean compensation gives

    E[∫aY] = ρ E[C] − E[D(t)−D(0)].

It does not permit division inside the expectation by random C. A finite discrete illustration needs only two independent fair trials: stop after the first if it is 1; otherwise perform the second and stop. The terminal records 1, 01 and 00 have probabilities 1/2, 1/4 and 1/4. If N counts ones and T counts performed trials, E[N]=3/4 and E[T]=3/2, so E[N]/E[T]=1/2 and E[N−T/2]=0. Yet E[N/T]=5/8. The stopping rule uses an acquired internal result, not an outside intervention or a look-ahead at the second trial. This illustrates the invalid algebraic step; it is not an antithetic-controller realization or a new stopping theorem.

`ClockClassMass.swift` verifies the four-cycle's positive structural fragment. Two actual class fields expand into their repeated occurrences; regrouping those occurrences by outcome produces identical formal mass lists. This derives equality for every additive positive interpretation, without supplying final balance as a premise. The source and its acquired fact remain bound. A changed grouping and substitution of another current class source fail the addressed checks. These type relations do not prove the Markov equations, stationarity, real-number limits or probability normalization; those have the explicit mathematical arguments above. The contribution is an exact boundary on omitting a clock, not a new stochastic formalism or a universal preferred time for reality.

**Changing relative contact speeds can preserve an answer while changing the jump law.** The preceding row reweighting accelerates every outgoing contact at a state together. If only some are accelerated, the mixture of next contacts generally changes. M67's exchange of admitted serializations and LQ13's preservation of contact admission do not determine that mixture. The following finite criterion addresses the eventual answer rather than the whole path law.

Let X be a finite state set and B a nonempty proper absorbing boundary for this question. Every x outside B must have a directed path to B. The boundary means that reading stops there, not that the physical whole stops. At each x outside B, split the outgoing contacts into finitely many nonempty groups g. Their fixed nonnegative rate rows r_xg(y), with r_xg(x)=0, have positive row sums. Different groups may reach the same y. Each row is multiplied by an independently unknown constant a_xg>0. All these constants are fixed during this first model:

    Q^a_xy = Σ_g a_xg r_xg(y),  y≠x,
    Q^a_xx = −Σ_{y≠x} Q^a_xy.

Fix a real terminal question f:B→ℝ. There is one function h on X which equals the expected terminal answer from every starting state, for every positive choice of the multipliers, if and only if there is an h with h|_B=f satisfying the separate balances

    Σ_y r_xg(y)(h(y)−h(x)) = 0  for every x outside B and every g.   (†)

This is a criterion for one common answer function on all the stated starting states. It is not asserted as a necessary test for a single special preparation while other starting-state answers are allowed to change. It also does not identify the individual outcome from its probability. For f the indicator of a part of B, h is its hitting probability; retaining one general mean need not retain the full law.

*Proof of sufficiency and of the completion obligation.* For any fixed positive multipliers, every selected path to B has positive probability in the jump chain. Choose one such simple path per interior state. Finiteness gives a common length bound L and a positive minimum δ of these path probabilities. Conditional on not yet hitting B, hitting within the next L jumps has probability at least δ. Thus survival through kL jumps has probability at most (1−δ)^k. Absorption occurs almost surely. These bounds depend on the multipliers and need not be uniform over their whole family. Finite rates on the finite state set give nonexplosion; the finitely many holding times before absorption are finite almost surely.

Summing (†) with weights a_xg gives Q^a h=0 in the interior, or h(x)=Σ_y P^a_xy h(y) for its jump matrix. Repeated conditioning gives E_x[h(X_{N∧τ})]=h(x), where τ is the first boundary jump. Since h is bounded and τ is almost surely finite, taking N→∞ gives E_x[f(X_τ)]=h(x). The same argument for the difference of two solutions with zero boundary shows uniqueness. This is the elementary harmonic boundary argument; the hitting-probability formulation is set out in [Weber's Cambridge notes, §3.1–3.3, Theorem 3.4](https://www.statslab.cam.ac.uk/~rrw1/markov/M.pdf). Here reachability of the specified boundary is proved sufficient for uniqueness, rather than inferred from finiteness alone.

*Necessity.* A common expected-terminal-answer function satisfies the first-jump equation for every multiplier choice. Therefore Σ_g a_xg Σ_y r_xg(y)(h(y)−h(x))=0. Hold all multipliers fixed except one and subtract the equations at two distinct positive values. The coefficient for that group must vanish. Repeat for each group. QED

In particular, if every independently accelerated group is just one deterministic outgoing contact x→y, (†) requires h(y)=h(x) on every edge. Across this full speed family, nonconstant terminal answers cannot be preserved through a state that can reach different terminal values. A nontrivial robust probability needs a retained relation between competing contacts: grouping two opposed contributions into one shared speed is substantive, not a notation for two unrelated rates. The criterion does not acquire that relation from the graph.

**A positive family changes paths but preserves their final law.** Take states named 0,1,2,3,4, with boundary {0,4}. These names index the specified relation; no physical length is assigned. The short-contact group from each interior i has unit rates to i−1 and i+1. A second, long-contact group has the following nonzero rates:

    from 1: to 0 at rate 2, to 3 at rate 1;
    from 2: to 0 at rate 1, to 4 at rate 1;
    from 3: to 1 at rate 1, to 4 at rate 2.

The proposed numerator H(i)=i has zero balance in every short group. Its three long-group balances are respectively 2(0−1)+(3−1)=0, (0−2)+(4−2)=0, and (1−3)+2(4−3)=0. Thus h=H/4, with f(0)=0 and f(4)=1, is forced by the criterion for all six positive, independently chosen group multipliers. Relative multipliers change the next-state distribution and the routes, but the probability of ending at 4 remains i/4. For example from 2, long contacts terminate immediately, whereas short contacts visit another interior state. This is stronger than a change of holding times with one unchanged jump chain. It is a constructed model, not a measured physical law or a new claim of priority for harmonic functions. The known rate ratios are an explicit input to the model.

**History-dependent scheduling preserves the balance, not automatically termination.** At each jump, now allow the weights of the group mixtures to depend on the acquired past. If the conditional law within each selected group still uses its fixed normalized row, (†) gives

    E[h(X_{(n+1)∧τ}) | the acquired history through n] = h(X_{n∧τ}).

Induction retains the finite-N expectation. If boundary arrival is also almost sure, bounded convergence gives the same terminal answer. There is no need to read, predict or store h inside the mechanism to obtain this mathematical consequence of its actual branching laws. The next argument derives completion for the five-state example from its actual branch rows, even under these adaptive mixtures.

**A required amount of answer variation can itself force completion.** For a binary terminal question, suppose 0≤h≤1, the boundary values are 0 or 1, and every admitted conditional group law satisfies (†). Assume that at each unfinished jump, every group has conditional squared variation at least some fixed ε>0:

    Σ_y [r_xg(y)/Σ_z r_xg(z)] (h(y)−h(x))² ≥ ε.

This is a quantitative condition on alternatives, not a requirement that every individual realized jump changes h. It is sufficient, not necessary, for completion. It can be derived from a finite list of actual branch rows; it must not be inferred from the word “different.” Assume the specified next-jump laws continue to apply until the boundary, allowing arbitrary choices of group mixtures based on the acquired history.

Write Z_n=h(X_{n∧τ}), with the boundary held after it is reached. The zero conditional increment gives

    E[Z_N²]−Z_0² = E[Σ_{n=0}^{N−1}(Z_{n+1}−Z_n)²].

Indeed expand the square at each step. The cross term has expectation zero by conditioning on the prior history, and the remaining terms telescope. Since Z_N²≤Z_N and E[Z_N]=Z_0, the right side is at most Z_0(1−Z_0). The variation premise also makes it at least ε E[min(N,τ)]. Monotone convergence therefore gives

    E[τ] ≤ h(x)(1−h(x))/ε.

In particular τ is almost surely finite: completion has now been derived, not assumed. Bounded convergence then identifies the terminal probability as h(x), and the total expected squared variation equals h(x)(1−h(x)). This is the elementary square identity for a bounded martingale, applied here to the admitted contact rows; no independent noise source, physical clock or stored internal value of h is required. The probability law and its conditional row interpretation remain premises. The bound concerns the number of actual jumps, not duration or a guarantee for every single possible infinite path.

In the five-state example, the short groups have squared variation 1/16. The long groups at 1,2,3 have respectively 1/8,1/4,1/8. Thus ε=1/16 works for every adaptive mixture and E_i[τ]≤i(4−i). Equality holds for the pure short-group rule: its variation is exactly 1/16 at each unfinished step, so the same identity gives E_i[τ]=i(4−i). If both groups must receive strictly positive mixture weights, that pure rule is excluded, but the bound remains valid. No claim that every such positive mixture attains it is made. The exact row calculations and square expansion supply this proof without executing or enumerating walks.

The general fixed-rate proof must not be extended to arbitrary history-dependent mixtures on the basis that every current rate is positive. The finite path minimum δ used there can disappear along the changing history. The repair example gives an exact obstruction.

**Repair turns relative speed into a success question.** At M64aw's prepared opening O with initially distinct contents, count success when the admitted transfer has occurred; the existing closing contact can then be applied separately. Suppose transfer T occurs at rate α>0 and early sealing L at rate β>0, constant for this trial. Their exponential race reaches transfer first with probability

    ∫₀^∞ α exp(−(α+β)t)dt = α/(α+β).

A common factor on α and β changes the waiting time, not this answer. Changing α alone changes the answer while preserving the existence of both contacts and their endpoint maps. The early-seal endpoint still retains the target but lacks the transfer input. This is an added stochastic model of the existing finite interface, not an experimental fit to DNA repair and not an inference that a biological reaction has exactly two competing channels.

If every failed closure is actually reopened and no other failure or deadline is added, fixed α,β give p=α/(α+β) at each attempt and survival after n attempts (1−p)^n. Eventual success is almost sure; no finite attempt count guarantees it, and no finite count gives a uniform nonzero success bound over all p>0. M64aw already constructs reopening and the same repaired endpoint after a closure. It does not itself prove that repeated openings occur or select the race law.

More sharply, let p_n∈(0,1) denote the conditional success probability at attempt n given that the preceding attempts failed. Assume these attempts continue to occur after each failure. The chain rule gives survival through N as Π_{n=1}^N(1−p_n), without independence of trials. Eventual success has probability one exactly when this product tends to zero, equivalently when Σ_n p_n diverges. If the sum diverges, use log(1−p)≤−p. If it converges, eventually p≤1/2 and log(1−p)≥−2p; the finite initial factors and the remaining product are positive. This proves both directions under the stated p_n range.

For p_n=1/(n+1)², the survival product telescopes to (N+2)/(2(N+1)) and tends to 1/2. Every attempt has a positive success chance and the same available contacts, yet half the probability remains on endless failed attempts. These ratios can be realized by α_n=p_n, β_n=1−p_n, with total opening hazard 1 at every attempt and reopening hazard 1. The internal attempt count supplies the changed rate relation. Thus even unchanged total hazards and infinitely many actual opportunities do not preserve the fixed-rate success guarantee. This is an unbounded-history model, not a fixed finite homogeneous chain contradicting the theorem above.

The relation retained by a clock question is therefore more precise than “the order can be traversed differently.” Whole-row rescaling, changes between balanced contact groups, and changes between opposed single contacts preserve different answers. Actual continued access is another obligation. The bare Swift `DirectedRepair` constructions already address opening, early sealing and reopening from their real sources. `BalancedContactRows` now presents the six actual branch rows and computes each weighted balance through the existing finite `AddZero`/`AddSuccessor` and product constructors. `ContactRowMoment` ties every operand to the current row; its two result fields are compared only after that computation. Six positive declarations derive the balances without requesting their equality from the caller. One refusal changes the 2:1 rate relation to 1:1 and obtains unequal computed moments; another tries to reuse arithmetic from a different row and fails the operand binding even though 1×0 and 2×0 give the same zero and the remaining moments would balance. These checks do not supply the probability interpretation, the squared-variation bound or criterion (†); those conclusions have the proofs just given. The mathematical description reads the law of this constructed fragment. It does not make the whole a predictor of itself, or infer experience from its ability to use a prepared contact.

## Cross-page mentions

Labels mentioned here: <doc:learning_is_liquid__medium_contacts#LQ13>, <doc:permanence_is_resistance__reacquisition_residue#M64at>, <doc:permanence_is_resistance__recovery_remainder#M67>, <doc:permanence_is_resistance__forced_answers#M71e>.
