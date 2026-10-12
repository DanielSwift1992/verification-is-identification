# Permanence Is Resistance (Matter) — Records entropy

This part contains the original derivations for records entropy.

Family and original section headings: <doc:permanence_is_resistance>.

Section setting: <doc:permanence_is_resistance#4a-The-closed-whole-records-and-entropy>.

## Detail: §4a. The closed whole, records and entropy

Take Ω to be the entire system. There is no external observer, memory, sink or controller. A partition into A and B names internal parts. Every physical implementation must include its controls and storage within Ω. The following claims separate conditions that were previously compressed into the word permanence.

The Cut's record commitment concerns the full history. Its continued growth does not imply that every new event changes an answer already settled in a fixed scope. VI's finite saturation is compatible with that commitment: an interface can finish acquiring its required distinctions without enumerating every later event. Conversely, our finite reversible cycles describe prepared acquisition windows, not an implementation of unbounded historical storage.

The chain from one whole to usable knowledge therefore needs internal reading, a separating interaction, a retained record and a compatible subsequent question. `PreparedFirstAnswerIsCertified` checks the symbolic reading of a prepared transition's output. `AcquireAnswer` and `AnswerInTrace` express recording and retained access as relations (VC40–VC42). VC38 supplies its dynamic compression criterion: states may share an interface only when every permitted continuation preserves the relevant common answers. A discarded interface distinction still belongs to the whole.

### M29

**M29 (Closure and preservation).** For a deterministic complete-state model with carrier K, closure says `T: K → K`. Preservation of all input distinctions says `T(x) = T(y) ⇒ x = y`. Closure alone does not entail preservation: the two-state constant map is closed and merges its inputs. A recovery map satisfying `R(T(x)) = x` proves preservation by applying R to an assumed output equality. Thus the no-loss conception requires this stronger relation, or an equivalent no-merger condition.

The closure tested here is closure of the declared state carrier under its transition. If the whole instead denotes all actual events and their relations, including their historical positions, a current-state projection need not be that whole. A merger of projected states then leaves open whether the histories differ. M29 does not refute retention in that larger object; M50 states the additional bridge to a later reading.

The existing `Permanent` protocol already contains a recovery witness: its post-record `Right` has `Right.Left == Left`, the previous record. `RetainedWhole<Before, Event>` constructs that relation for arbitrary inputs. This is an explicit structural model of retention, not a derivation of physical reversibility from the word closed. An append constructor is invertible on its image, without being a permutation of a fixed finite carrier.

### M30

**M30 (Internal reset and internal recording).** Consider two classical bits within Ω. On the support `(x, 0)`, SWAP gives `(0, x)`: A resets while the whole retains x. CNOT gives `(x, x)`: B records A. Both operations extend to permutations of all four states. With uniform x the joint Shannon entropy is one bit before and after. After copying, each marginal has one bit and their mutual information is one bit. A record creates a correlation, not a second independent bit. Preparing a blank register is a resource condition, and these logical tables assert no physical energy cost.

### M31

**M31 (Retention can be relational).** Let x and r be independent uniform bits inside Ω. The permutation `(x, r) → (r, x XOR r)` retains x in the joint output. Neither output alone has any mutual information with x. Joint XOR recovers it. Information need not move into an individually readable component when it disappears from another component. Preservation establishes recoverability under a specified decoder, not that any internal process actually runs that decoder or can implement it with available resources.

The admitted input family matters. IiS12 separates this classical message from a common isometric encoding that makes one complete quantum marginal independent of every coherent input. In that stronger contract the complementary part must recover the input. A phase family can still be hidden from both individual outputs while retained jointly, as the existing IiS16 construction shows. Its local readings cease to be constant when the omitted population preparations are admitted. Memory therefore requires a specified source question, partition and preparation family before one can decide which retained relations are sufficient.

### M32

**M32 (Which entropy).** For a classical distribution transported by a permutation, joint Shannon entropy is unchanged: its probabilities are reordered. In a quantum model with unitary whole-system evolution, the eigenvalues of the joint density operator are unchanged, so its von Neumann entropy is unchanged. Marginal entropies can change as correlations change. For the classical partitions above, `H(A,B) = H(A) + H(B) − I(A:B)`. The choice of distribution, observables and internal partition must be explicit. Tree size and number of historical events are not these entropies. A point distribution has zero Shannon entropy even when its one supported state has internal structure. The distribution describes possible configurations mathematically, without adding an observer or reservoir outside Ω.

A coarse observation can fail to recover a preserved distinction. This alone establishes neither a thermodynamic arrow nor monotonic entropy growth. Calling all entropy dilution or information destruction would erase the distinction between these mathematical quantities. A physical account of an arrow also needs dynamics, initial conditions and a specified macroscopic description.

**A relation can change its order without changing these entropies.** Prepare three internal classical bits uniformly on the four states satisfying a XOR b XOR c=0. Every individual bit is uniform, and every pair has the uniform four-outcome distribution. Nevertheless the joint has four possible states rather than eight. The reversible operation

```
T(a,b,c) = (a, b XOR c, c)
```

is its own inverse on all eight states. On the prepared support it gives (a,a,c), with a and c independent and uniform. The first two addressed bits now agree in every admitted state. Every individual entropy remains 1 bit and whole entropy remains 2 bits. The total correlation, defined here as H(A)+H(B)+H(C)−H(A,B,C), remains 1 bit. Initially that restriction is invisible to every pair marginal. Afterwards the first pair carries it as agreement. There is no need to locate the old constraint in one extra particle or to call its conversion a decrease of whole entropy.

The odd-parity preparation supplies the attack on an incomplete interface. It has exactly the same three pair marginals as the even preparation. Under the same T it gives (a,1 XOR a,c), so the first two bits disagree instead. All old pair marginals together therefore fail to determine this later agreement question. This is an instance of VC15's continuation requirement: the omitted three-way distinction becomes necessary under an admitted operation. Pairwise statistical independence is compatible with a joint constraint. Representing that constraint by nested `Pair` constructors does not make it a product of pairwise statistical constraints.

`ExchangeParityWeights` computes T's permutation of eight addressed weights. Its generic return equation recovers every weight. `ThreeBitMarginalOperands` regroups actual source entries for the three marginal sums. The existing `AddZero` / `AddSuccessor` and `AddNaturalMatrices` constructions give identical old marginals for the even and odd unit-weight preparations, then diagonal and off-diagonal first-pair tables after T. Each arithmetic input is bound to the actual regrouped weights. Positive zero/successor distinctions separate both the original joints and their later tables. Refusals reject identifying the whole from its pair marginals or predicting the same later table. Dividing the weights by four supplies the stated probabilities in this argument. The Swift relations establish the finite entries and recovery, without a probability runtime or a claim to realize the physical bits.

AC7 now characterizes this omission for a finite bipartite support: complete marginals determine every joint law exactly when the support graph is a forest. A particular response expectation needs less: its alternating sum must vanish on every cycle. These statements concern one declared family of joint alternatives. A single measurement basis need not supply such a complete family for further physical questions.

For example, in the two-qubit model, Ψ₊=(HV+VH)/√2 and Ψ₋=(HV−VH)/√2 have identical reduced density matrices I/2 and identical joint H/V probabilities. Yet the common observable X⊗X has answers +1 and −1, because it exchanges HV with VH. Thus even that entire joint H/V table cannot support both answers through one fixed response rule. The retained source must distinguish their relative coherence. This is a direct consequence of the stated quantum model, not a failure of the finite marginal criterion or a derivation of the quantum carrier from closure.

[Mattle et al.](https://courses.grainger.illinois.edu/phys513/sp2019/reading/week9/Dense_coding_Zeilinger1996.pdf) supply an experimental contact: changing one photon's polarization phase changed the two-photon coincidence pattern at a common analyzer. Their device distinguished three message classes, leaving two of the four Bell states unresolved. At matched paths, the reported identification reliabilities for Ψ₊ and Ψ₋ were 95% and 93%, conditional on detecting both photons. These measured joint responses support the relevance of the preparation relation. Exact equality of all local statistics above belongs to the ideal Bell-state calculation, not an assertion of exact experimental preparation or detection.

**An unchanged local environment can still change its relations.** Suppose a finite classical joint SC evolves by a permutation and the marginal distribution of C returns exactly. Subtracting H(S,C)=H(S)+H(C)−I(S:C) before and after gives ΔH(S)=ΔI(S:C). If the input is a product, local entropy can only increase, by the amount of newly created mutual information. With earlier correlations it can instead decrease as those correlations are consumed. The bit transformation (s,c)↦(s XOR c,c) exhibits both directions: (0,c) becomes (c,c), and (c,c) becomes (0,c), for uniform c. The environment value itself is unchanged in every case, but its relation to S changes.

This identity is also the accounting behind [Wilming's reversible catalysis result](https://arxiv.org/abs/2012.05573). The paper's catalyst returns in its marginal state while correlations are permitted. Local return therefore does not certify return of the joint preparation. Reusing one fair internal bit to fill several prepared zero slots gives repeated copies of that same bit, each fair, with only one bit of joint entropy. A contract promising one fair output is weaker than a contract promising independent outputs across uses. The independence question needs its own joint relation. All registers and preparations in these examples are internal. No heat or work scale follows from the entropy identity.

Interference Is Substitution IiS12 supplies an explicit quantum instance. For two internally calibrated arms, an environment overlap g multiplies the cross-arm coherence. A balanced input gives local eigenvalues (1±|g|)/2, while its return probability to the prepared probe is (1+Re g)/2. Relative phase can therefore reverse the comparison answer while preserving purity and zero local von Neumann entropy. Orthogonal environment records instead yield one bit of local entropy within a pure joint state. Entropy and agreement with the selected reference are different questions about the same construction. IiS11–IiS13 identify the additional probe relations that constrain this freedom, with exact and bounded-error premises.

IiS14 gives a further boundary: transposition preserves the spectrum and entropy of every isolated density operator, but its action on one factor of a Bell pair produces a negative measurement weight. Entropy preservation therefore does not establish admissibility of a local rule on joint states. The required joint context is internal to the whole, with its own retained relations.

IiS19 also identifies a reversible reduced description. A finite-dimensional space of questions closed under an admitted unitary step carries an orthogonal update of its exact expectation coordinates. Those coordinates need not determine the whole density operator, but their distinctions cannot merge under that step. This supplies a criterion for lossless reuse relative to future questions even on an infinite state set. It concerns statistical descriptions and does not by itself make those statistics available from a single system or assign them a new entropy.

IiS15 supplies a positive construction with retained factors. The two vectors (1,0) and (2,3) generate the matrix with rows (5,6) and (6,9), whose entries and source relations are computed statically. After division by 14 this is a mixed local state, realized mathematically by a pure joint vector with two orthogonal internal record states. Its positive local entropy reflects the omitted joint relations. The description record in Swift preserves both factor vectors, without claiming to instantiate that quantum preparation.

IiS16 also ties the operator normalization, prepared record, joint action and two readings to one type-level source. All four input matrix entries are recovered from the joint output, while the local reading retains only the diagonal. The controlled-NOT realization supplies a reversible operation on a fixed internal system with a prepared memory part. The entropy distinction follows from the explicit preparation and reduction, without making literal unbounded history retention a consequence of this finite model.

The experimental comparison in IiS12 adds a representation boundary. A pseudopure encoding commutes with every unitary update of its fixed carrier and gives calibrated expectation values. It does not preserve tensor products of separately encoded states: global and separate preparation can have equal marginals and different joint responses. Thus transport of the selected dynamics does not by itself transport independence, purity or the entropy of the represented object. The preparation relation is part of the correspondence. Conversely, IiS12's full quantum contract fixes all unitaries, independent products and the factor reading. Those relations force identity or complete replacement on the source carrier, without assuming linearity of the representation. One preserved contrast selects identity. For a qubit, IiS12 obtains the same conclusion from H, T, CNOT, products and both marginal readings, with no assumed continuity. Omitting T admits a nonlinear fifth-power Pauli representation that preserves all the other relations. The stated quantum carrier and available joint comparisons carry these conclusions.

System IQ1–IQ3 separates another pair of orders. Exact evidence can shrink the set of possible sources while increasing posterior Shannon entropy on one rare branch. Conditional entropy decreases on average over the readings, not necessarily on each realized branch. A twelve-state reversible recording model exhibits this with source, memory and readiness all internal. The same analysis separates an answer's entropy from the cost and extra distinctions of the available questions. These are statistical and operational claims, not a thermodynamic arrow derived from the size of a candidate set.

### M33

**M33 (Complete history and instantaneous state).** An append-only history Ω_history records prior occurrences by construction. A complete instantaneous state Γ_t preserves their distinguishability only if the evolution and encoding do so. Writing a new event named reset does not prove that its record distinguishes the reset inputs. These are separate claims even when both descriptions concern the same whole.

On a fixed finite carrier an injective endomap is a permutation and every trajectory is periodic. A strictly increasing, literally retained record cannot be embedded into that same finite state space indefinitely. A finite record at each time with unbounded possible size is a different model and agrees with M23's finite-at-each-moment wording. Reversibility permits recurrence, while an indefinitely growing independent record requires capacity beyond a fixed finite bound.

Verdict Is Invariant VC32–VC34 makes this boundary constructive. An internal controller can acquire a correct answer during a prepared finite experiment, while a finite reversible whole retains every original distinction. The whole subsequently returns to its prepared configuration. A forward-invariant set of a finite permutation has no incoming transitions from its complement, so newly acquired readiness cannot become permanent under those assumptions. Recovery of prior distinctions and perpetual readability of a newly acquired answer therefore require different claims. Injectivity alone does not imply the literal append-only record required by I3.

### M34

**M34 (Discovery inside the whole).** In a fixed deterministic model with preserved global distinctions, discovery can be an internal change of correlation: an agent's record becomes sufficient for a question about another part. The learned object is specified by the question and the whole's structure, while access to it changes. This gives an operational reading of discovery without requiring information to arrive from outside Ω. It does not establish that every question has a unique answer or an accessible finite certificate. Physical content requires a model linking the structural distinctions to observables, dynamics, probabilities and resource units.

**What preparation makes a new constraint attainable?** Let K be a nonempty finite complete-state domain, P its nonempty prepared support, and R the states satisfying the desired output relation. If every permutation of K is admitted, there is one operation T with T(P)⊆R exactly when |P|≤|R|. Necessity follows because T is injective on P. For sufficiency choose an injection P→R, then biject the unused input states with the unused output states. The two maps form a permutation of K. This is one operation for every possible prepared input, rather than a different unobserved choice for each input.

The relation can therefore become certain on a prepared support without reducing the number of complete alternatives. It cannot become certain on all K when R is a proper subset. The parity preparation in M32 and its agreement target both contain four of eight states, and the displayed T supplies the required permutation. Whole closure places the preparation and all available controls inside the system. It does not select that preparation or grant every permutation as an available interaction.

For a fixed probability law p and nonempty R with |R|=m, the largest achievable probability of R over all permutations is the sum of the m largest input probabilities. The preimage of R always has m states, giving the bound. Mapping the m largest-weight states onto R attains it. Certainty is thus equivalent to support(p) having at most m members. Entropy at most log₂m is necessary but insufficient: on four states, (1−3ε,ε,ε,ε) has arbitrarily small entropy as ε tends to zero, yet for every 0<ε<1/4 it has full support and cannot be placed with certainty into a two-state target. A scalar entropy does not specify the exact attainable constraint.

The admitted operation family is a second independent restriction. On K=ℤ/4ℤ allow only rotations x↦x+k. Let P={0,2} and R={0,1}. Their cardinalities coincide and every individual state can reach R, but no one rotation maps P into R: the images remain an opposite pair. For uniform P the best success probability is 1/2. Relative separation of the two possible inputs obstructs uniform preparation even though the action is transitive on individual states. The missing structure belongs to how an operation acts on alternatives together. It is not repaired by counting their individual reachable states. An internal feedback policy can change the question, but then its acquired distinction and retained controller state must enter the whole, as VC31–VC33 require.

**An exact factor of a surjective change cannot have a nontrivial idempotent update.** Let U:X→X be surjective and E:X→Y one fixed reading onto its declared image Y. Suppose one deterministic F:Y→Y describes the next answer at every source:

    E∘U = F∘E    on all X.

Then F is surjective. Given y∈Y, choose x with E(x)=y and a predecessor z with U(z)=x. The equation gives y=F(E(z)). Consequently, if F²=F, choose w with F(w)=y and obtain F(y)=F²(w)=F(w)=y. Thus F=id. The source set, image and fibers may all be infinite. Injectivity of U, probability and a time metric were not used. Surjectivity and the same complete factor equation are additional facts, not consequences of the absence of an exterior.

More generally, a uniform eventual law F^(m+p)=F^m, with m≥0 and p>0, forces F^p=id. Surjectivity of F^m allows its cancellation from that equality. A global finite settling bound, where p=1, therefore permits no change at all. When Y is finite, surjectivity alone makes F a permutation. These conclusions concern a deterministic factor on the entire carried domain, rather than a coarse relation or a prepared episode.

**Pointwise settling and uniform settling differ.** Take X=ℤ, U(n)=n+1, Y={…,−2,−1,0}, E(n)=min(n,0) and F(y)=min(y+1,0). U is bijective, E is onto, and E(U(n))=F(E(n)) at every n. Each y reaches zero after finitely many steps and remains there. F is surjective and noninjective, with unbounded settling times across Y. For every m, the input y=−m−1 has F^m(y)=−1 and F^(m+1)(y)=0, so no common finite settling bound applies. This explicit counterconstruction prevents strengthening the preceding result into a ban on all eventual stabilization in an infinite reversible description.

Nor does a deterministic factor of an invertible map always retain its input. On X={0,1}^ℤ shift every coordinate one position, and let E retain the coordinates indexed by n≥0. The resulting F on Y={0,1}^ℕ deletes the first symbol. It is onto and two-to-one. The omitted symbol remains at a negative address in the same whole. This is the standard two-sided extension of the one-sided full shift. [Hochman, Proposition 5.10 and §5.4, Problem 3](https://math.huji.ac.il/~mhochman/courses/TD2022/notes-v3.pdf) treats natural extensions in the compact topological setting. The displayed example needs no probability or topology to verify its maps. In particular, invertibility of U does not give a deterministic factor for U⁻¹ through the same E.

**Preparation has a precise role in an idempotent episode.** Suppose the factor equation is required only on P⊆X. Its exact image equation is

    F(E(P)) = E(U(P)).

If E(U(P))=E(P) and F maps E(P) to itself, the same argument makes any idempotent F the identity on E(P). Therefore a proper idempotent update on that image requires E(U(P)) to be a proper subset of E(P). When F²=F on Y, every configuration whose E-value is outside Fix(F) has all its U-predecessors outside P. Otherwise the factor equation would place that value in F(Y)=Fix(F). Preparation thus excludes specific predecessors of the unsettled answers. This is a restriction on the carried source domain, with no missing distinction sent outside the whole.

Forward invariance of P alone does not restore the prohibition. On the same integer shift, take P={n≥−1}, let B(n)=0 for n<0 and B(n)=1 for n≥0, and put F(0)=F(1)=1. Then U(P)⊊P and B∘U=F∘B throughout P, so one step establishes a permanently retained value on this prepared domain. The equation fails globally: n=−2 and n=−1 have the same current B-answer and different next answers. For a finite forward-invariant P and injective U, by contrast, U(P)=P and the prohibition applies. This is the precise finite-domain limit already used by M33.

The resident law construction in M70 provides the finite static counterpart. The predecessor law on {Never, Lit1} is idempotent, as `LocalResetIsIdempotentOnDeclaredCarrier` now computes. The prepared zero and the recorded image of one have the same current local value zero. Their next whole steps give zero and one respectively. `LocalResetCoarseInputsAgree` and `LocalResetCoarseFutureRefusal` establish these equal inputs and positively different futures. The existing refusal of repeated local reset rejects using the prepared law on the restored phase. The phase and retained source are internal parts of the complete representation.

**Static saturation is a different operation from this global factor.** Intersecting a candidate family with the same established fact twice can be idempotent. Its input is a description together with that fact and their correspondence to the source. This does not assert that the resulting refinement is the exact image of one globally surjective physical step through one unchanged reading. Acquiring a previously unavailable fact can supply another input, change the prepared domain or require a richer reading of the current configuration. VI can express the resulting consequences statically while keeping those source relations explicit. No runtime mechanism follows from this distinction, and the factor obstruction does not prohibit learning inside one whole.

**A new permanent entrance requires arbitrarily deep unsettled predecessors.** Let F:Y→Y be surjective and let R⊆Y satisfy F(R)⊆R. Put A_n=F⁻ⁿ(R). These sets increase with n. If any source enters R from outside it, then R⊊F⁻¹(R). Preimages under a surjection preserve strict inclusion, so A_n⊊A_(n+1) for every n. Equivalently, there are sources whose first entrance takes exactly n+1 steps for every n≥0. The strict difference A_(n+1)\A_n supplies them. This needs neither topology nor a deterministic reading of readiness from its previous value. It concerns the actual state transition and the target region. A uniform entrance bound is already excluded by one proper entrance and global surjectivity.

**Finite certifiability adds a second boundary.** Fix the available source readings. A finite certificate specifies answers at finitely many of their addresses, and its cylinder is all admitted sources with those same answers. Call R finitely certifiable when every y∈R belongs to a cylinder entirely contained in R. The unions of cylinders form the topology of these readings, so this condition says exactly that R is open. It is relative to those readings and to the retained source assumptions. It does not supply an algorithm that finds a certificate or a grammar that validates it.

Suppose this source presentation has the finite-cover property: every cover by such open sets has a finite subcover. Also require that preimages under F of open sets are open. This continuity condition means that a finite certificate about the next source can, at each source where it applies, be supported by finitely many current reading answers. If F is surjective, R is open and forward invariant, and every source reaches R after finitely many steps, then R=Y.

Indeed the increasing open sets A_n cover Y. A finite subcover reduces to A_N=Y for their largest N. Hence F^N(Y)⊆R. Surjectivity gives F^N(Y)=Y, so R=Y. Only the finite-subcover property for this particular countable cover was needed. Compactness is a familiar sufficient condition, stronger than that minimum. No premise E∘F=H∘E for a deterministic readiness update is needed here. Removing forward invariance changes the statement: on a two-state exchange each orbit visits either singleton, although neither singleton records permanent readiness.

VC23 supplies one finite-cover presentation without requiring finitely many sources. Use countably many finite-valued reading addresses and admit exactly the assignments satisfying a stated family of finite-address requirements. Its finite-branching argument gives compactness in the cylinder topology. Equivalently, a full assignment whose every finite restriction extends to an admitted source must itself be admitted. No extra global admission restriction may be discarded. [Hochman, §3.2](https://math.huji.ac.il/~mhochman/courses/TD2022/notes-v3.pdf) describes these cylinder sets for symbolic systems. They are a topology of the chosen presentation, without a metric or topology being assigned to physical reality by this argument.

**One preserved existence fact changes the conclusion.** Let δ_k be the binary pattern on integer addresses with one at k and zeros elsewhere. Take Y={δ_k:k∈ℤ}, with the explicit premise that exactly one marker exists. Let F move the marker from k to k−1, and let R={δ_k:k≤0}. The zero boundary names an internal reading reference in this model. F is bijective, R is proper and forward invariant, and every source reaches R. Reading the one at any k≤0 certifies membership in R. Each δ_k is identified by the single answer at k, using the retained uniqueness premise. Thus R is open and F is continuous.

The finite-cover property fails: the cylinders asserting a one at k cover Y, and no finite subfamily covers it. The all-zero pattern agrees with some member of Y on every finite window but violates the existence premise. Admitting it to complete the pattern space changes the given source family. This is an example about preserving a specified existence fact, not a reduction of encountered qualia or joint contrast to a marker.

Adjoin the all-zero pattern o explicitly and call the enlarged family Ȳ. It is compact: the requirement of at most one marker is the family of finite two-address refusals of simultaneous ones. Extend F by F(o)=o. The same open R now fails universal reachability because o never enters it. If instead readiness is enlarged to R∪{o}, every source reaches readiness, but that readiness is not open. Every finite all-zero window is compatible with a marker farther to the right, outside readiness. Hence o has no finite positive readiness certificate through these coordinate readings. A uniformly sound reader restricted to finitely many such answers cannot certify o: after any finite adaptive transcript of zeros an unqueried positive coordinate still supplies a counter-source. Other access or a retained global premise changes this question.

Projecting Ȳ to its nonnegative coordinates gives the compact one-sided family with at most one marker. Its shift is surjective, and each source eventually becomes the all-zero pattern and remains there. Thus even compactness and continuity do not prohibit pointwise finite stabilization of the whole projected state. Its absorbing zero singleton again lacks a finite certificate. This realizes the earlier unbounded-settling example through binary readings rather than a numerical distance to readiness.

The distinction is therefore between occurrence, permanent target membership, finite evidence for that membership and uniform completion across a source family. A positive global premise can validly remove a limiting counterdescription. VC23 already proves why unbounded existence cannot in general be replaced by only finite-carrier local constraints, even with hidden variables. The source contract must retain that premise or a corresponding witness. Membership of everything in one reality supplies neither the finite-cover property nor a license to insert a description contradicting what was given.

### M35

**M35 (The residual required by compression).** Let K be finite, E the visible compressed representation and R an internal residual. Exact recovery of the whole requires `(E,R)` to be injective. For each image e, distinct members of its fiber `E⁻¹(e)` must have different residuals. Therefore a fixed residual alphabet needs at least `max_e |E⁻¹(e)|` values. This bound is attainable by assigning different residual labels inside each fiber. An encoder that uses fewer labels merges some whole states. No external storage is invoked: E and R are parts of the same complete representation.

For random input X and deterministic E(X), R(X) with exact recovery, `H(R|E) = H(X|E)`. Indeed `H(E,R) = H(X)` by injectivity on the input support, and subtracting `H(E)` gives the equality. The residual can require joint reading with E. This statement quantifies where local compression leaves distinctions, without calling those distinctions thermodynamic entropy or requiring an active decoder.

The three binary beam coordinates give eight whole states. The visible two-coordinate image has four fibers of size two, so one residual bit is necessary and sufficient for exact recovery. `BeamWithResidual<B>` retains that coordinate and the Swift checks recover all three original coordinates for arbitrary B. Each of the four fibers must assign its two states different residual labels. Each fiber has two such assignments, independently, giving 2⁴ = 16 recovering binary residual maps. Variable-length coding and physical resource costs require their own representation and cost models.

M70 applies this obligation to an entire class of local laws and their repeated use. A freely supplied internal record permits every local finite deterministic table over any prepared finite horizon. Fixing the carrier and requiring continued autonomous use changes the result: the reset horizon has an exact capacity bound even while the joint entropy remains unchanged.

### M36

**M36 (Stationarity prevents strict retaining growth almost surely).** Let U preserve a probability measure μ on the entire Ω. For a measurable real V with V(Ux)≥V(x) μ-almost surely, V(Ux)=V(x) almost surely. Neither invertibility, finite Ω nor integrability of V is needed. Physical closure and entropy preservation do not imply the premise U_*μ=μ.

*Proof.* For every rational r, monotonicity nests {V(Ux)≤r} inside {V(x)≤r}, up to a null set. Measure preservation gives equal probabilities, so their difference has probability zero. Every strict increase crosses a rational r. The countable union of these differences therefore has measure zero. Taking the countable union of its preimages under U gives a single full-measure set where V is constant at every forward step. QED

For a fixed countable fact vocabulary with measurable membership tests, apply this argument to each fact's cache-membership indicator. If facts are never dropped, none are added almost surely under μ. This also covers infinite caches without relying on their cardinality as a scalar progress measure. Fact identities and decoding must remain fixed. Exceptional zero-measure states are not excluded by an almost-sure assertion.

*Quantitative boundary.* For any prepared distribution μ, put μ′=U_*μ and TV(μ,μ′)=sup_A|μ(A)−μ′(A)|. For fixed 0≤V≤1,

    |E_μ[V(Ux)−V(x)]| ≤ TV(μ,μ′).

Indeed E[V]=∫_0^1 P(V>r)dr, and each probability difference is bounded by TV. If V does not decrease on the prepared support, then for ε>0, P_μ(V(Ux)−V(x)≥ε)≤TV(μ,μ′)/ε. Without monotonicity, gains and losses can cancel. Normalizing V matters: this is not a universal bound on learned bits, training loss, physical entropy production or heat.

### M37

**M37 (Prepared growth inside one reversible whole).** Let Ω contain a retained L-bit source x and an internal cursor k∈{0,…,L}. The transition U(x,k)=(x,k+1 mod(L+1)) is a permutation. The accessible record C(x,k) is the prefix x_0,…,x_(k−1), with position identities retained by its order. Its accessibility is part of the declared reading model. Decreasing k modulo L+1 is the complete inverse.

Prepare uniform x and k=0. The first L steps reveal one additional source bit each: I(x;C)=0,1,…,L. Whole Shannon entropy remains L bits, but the whole distribution changes because its cursor support moves. At wrap the accessible prefix becomes empty while x survives. Under the stationary uniform distribution over all Ω, growing phases and the reset balance, and mean record length remains L/2. Thus stationarity permits temporary increases when the same process also permits losses.

For uniform x and k uniform on 0,…,L−1, one step increases V=k/L by 1/L on every prepared state. TV(μ,U_*μ)=1/L, attaining M36's bound. Accessible source information increases by one bit and whole entropy is unchanged. The resulting ensemble includes the reset phase, so the same argument cannot be repeated to claim indefinite retention. At L=4 the formula gives TV=1/4.

*Infinite capacity changes the construction.* Take Ω=A^ℕ×ℤ, an immutable infinite source tape and an internal integer cursor. U(x,k)=(x,k+1) is bijective. C(x,k) consists of (i,x_i) for 0≤i<max(k,0), so each record is finite, no fact is lost, and from k=0 each step adds one position. A product tape law with cursor δ_0 evolves to the same tape law with cursor δ_t. No U-invariant probability measure exists on Ω: its integer-cursor marginal would have equal mass at every integer, which cannot sum to one. Product tape measure times counting measure is invariant but has infinite mass. The probability-stationarity premise of M36 therefore fails.

Everything in this construction is inside Ω. It assumes an infinite tape and unbounded cursor, without deriving a finite physical implementation. The cache represents expanding access to an existing internal source. It does not certify an unknown physical law from no evidence.

`ExposeNext` and `RewindExposure` move a resident Pair field into a cache and recover the original fields in pure types. They do not encode a probability measure or establish that an arbitrary Pair is a nonempty tape. The underlying stationary monotonicity result is standard mathematics: [Solomyak, Proposition 1.11](https://u.math.biu.ac.il/~solomyb/TEACH/20/ET/Lec1.pdf). Its role here is to make the retention and preparation premises explicit.

**Verification boundary.** The generic whole-record and two-swap constructions derive recovery of the previous record and original components. Swift nominal wrapper names are not identified with their structural contents. These coordinate relations do not prove physical unitarity or the entropy arguments, whose measures and dynamics are stated above.

## Detail: §4b. Time, cell volume and the entropy of a reading

Fix a finite complete-state carrier K, a permutation U and a reading E whose nonempty cells are M_a, with sizes w_a. The clock, program and any physical controls of an implementation belong to the whole. A distribution describes possible complete states mathematically. It supplies no outside scheduler. Keep E fixed in the following claims. Use base-two logarithms and dimensionless bits, without identifying the finite cells with a thermodynamic phase space.

### M38

**M38 (The coarse entropy ledger).** For a probability distribution μ on K, put p_a=μ(M_a) and define its cell-uniform reconstruction by Πμ(x)=p_a/w_a for x∈M_a. Then

    H(Πμ) = H(p) + Σ_a p_a log₂ w_a,
    D(μ || Πμ) = H(Πμ) − H(μ) ≥ 0.

*Proof.* Each cell contributes −p_a log₂(p_a/w_a) to H(Πμ). Also, −Σ_x μ(x)log₂Πμ(x) has exactly that same value, because Πμ is constant on the cell and μ has cell mass p_a. Subtract H(μ) to obtain the relative entropy identity. Zero-mass cells contribute zero. QED

For μ_t=(U^t)_*μ_0, M32 gives constant H(μ_t). Thus

    H(Πμ_t) − H(Πμ_s)
      = D(μ_t || Πμ_t) − D(μ_s || Πμ_s).

The divergence measures the nonuniformity within cells that this reconstruction discards. It need not consist only of correlations between named subsystems. This identity gives no sign to either change. If Πμ_0=μ_0, then H(Πμ_t)≥H(Πμ_0) for every integer t, including inverse evolution. That is a bound relative to a specially prepared reference distribution, not monotonicity between arbitrary later times or a selection of one arrow.

For an individual state x, log₂w_(E(x)) is the finite cell-volume quantity. Its ensemble mean differs from H(Πμ) by H(p), the uncertainty over cell labels. A change of the mean volume term can therefore have a different sign from a change of coarse entropy. For a one-point distribution, H(μ)=0 but H(Πμ)=log₂w_(E(x)). A definite state need not have a small macrocell. M38 keeps these quantities separate from thermodynamic entropy, heat and the number of historical events.

These distinctions are established in statistical mechanics. In particular, [Goldstein, Lebowitz, Tumulka and Zanghi, §§1 and 8](https://arxiv.org/pdf/1903.11870) separate Gibbs and Boltzmann entropy and explain why a lower bound from an initial time is weaker than monotonicity. H(Πμ) is the finite one-partition form of [observational entropy](https://arxiv.org/pdf/1905.03841), Theorem 3 and equation 22. The finite proof above states the premises used by VI. No priority for these entropy notions is claimed.

### M39

**M39 (Forward and inverse macrocell counts).** Let N_ab=|M_a ∩ U⁻¹(M_b)|. For uniform preparation within the starting cell,

    P_U(b | a) = N_ab / w_a,
    P_(U⁻¹)(a | b) = N_ab / w_b.

When N_ab>0, their ratio is w_b/w_a, so its base-two logarithm is the change log₂w_b−log₂w_a of cell-volume entropy.

*Proof.* U maps the N_ab forward starts bijectively onto exactly the starts of inverse transitions from M_b to M_a. Divide the same count by the two preparation volumes. QED

Summing counts shows that π_a=w_a/|K| is stationary for this one-step macro transition matrix. The ratio compares two conditional preparations. The uniform inverse preparation is generally different from the actual forward-evolved distribution. Also U⁻¹ need not equal U or the physically available time-reversed experiment without a separate reversal structure. No expectation that every step increases entropy follows. Replacing U by U^n gives the corresponding n-step count directly. It does not assert that successive coarse readings form a Markov process.

**Which contacts admit an exact finite reversible realization?** Fix a finite nonempty addressed set A and a relation T⊆A×A. The following conditions are equivalent:

1. There are a finite carrier K, an onto reading E:K→A and a permutation U of K whose exact projected contact relation is T={(E(k),E(Uk)):k∈K}.
2. Every vertex has an outgoing contact, and positive integer weights n_ab on exactly the edges of T satisfy ∑_b n_ab=∑_b n_ba at every vertex.
3. Every vertex has an outgoing contact, and a balanced weighting positive on exactly T exists with real weights.
4. Every vertex has an outgoing contact, and every edge belongs to a directed cycle, including a one-edge loop.

For 1⇒2, count the microstates taking each projected edge. Their total leaving a is |E⁻¹(a)|, and bijectivity makes the entering total equal to it. The weights are positive exactly on T. Condition 2 implies 3. For 3⇒4, take an edge a→b. If b had no path back to a, the set of vertices reachable from b would have no outgoing edge and would receive positive weight from a. Summing balance over that set gives a contradiction. Thus the edge has a return path. For 4⇒1, choose a cycle through each edge and form the disjoint collection of their addressed positions. Let U advance each position around its cycle and E read its vertex in A. Every edge of T occurs, no new edge occurs, and every vertex is represented. This is a finite construction from the supplied contact relation. It does not declare that relation physically realized.

The same reading E at both ends is essential. If two different readings are allowed, any T with both projections equal to A has the representation K=T, U=id, E₀(a,b)=a and E₁(a,b)=b. This supplies the contact between two addressed questions without a change of the underlying pair. It does not satisfy the original common-reading contract. The distinction is internal to the represented whole and requires no exterior observer.

Normalize a weighting by N=∑_ab n_ab and w_a=∑_b n_ab. Then π_a=w_a/N and P_ab=n_ab/w_a give a strictly positive stationary distribution on A with P_ab>0 exactly on T. Conversely, such a distribution and kernel give balanced weights n_ab=π_aP_ab. Thus the same criterion characterizes which supports admit this full stationary weighting. It neither selects particular probabilities nor establishes a memoryless process for successive projected readings. No entropy formula enters the criterion.

More directly, balance asks for a joint probability on the contacts whose two marginals agree. It needs no premise about a sequence being Markov. Equal entropies of those marginals are weaker. Assign weight 1/3 to each of a→a, a→b and b→b. The input marginal is (2/3,1/3), the output marginal is (1/3,2/3), and their Shannon entropies agree by exchanging entries. All listed contacts have positive weight, but the marginals differ and the crossing has no return. Their inequality survives every common relabeling of A, so the comparison needs no absolute names. Entropy equality therefore does not establish the balance condition. M37 gives the related distinction between unchanged whole entropy and a changing prepared distribution.

**An invariant admission set can still fail this test.** On three distinct roles, take a→b, b→a, b→c and c→c. Every role has both an incoming and an outgoing edge, and T[A]=A. Yet b→c has no return path. No enlargement to any finite hidden carrier can realize exactly these contacts through a permutation. A stationary weighting cannot give positive weight to b→c: the set {c} receives weight and sends none out. Omitting that edge, giving it zero weight, restricting to a prepared part of the carrier, or admitting a return contact changes the stated contract. M70's finite prepared horizons therefore do not contradict this obstruction on the complete carrier.

**The smallest finite realization counts a balanced use of contacts.** Its size is at least |T|, since every edge must be represented. Equality is possible exactly when T's unweighted incoming and outgoing degrees agree at every vertex, with each vertex incident to an edge. Necessity follows because every edge then has weight one. For sufficiency take K=T and, at each vertex, pair its incoming edges bijectively with its outgoing edges. This makes a permutation of the edge positions with exactly the required projection.

For a→b, a→c, b→a and c→b, every edge has a return, but the degrees at a and b are unbalanced. Four hidden positions cannot suffice. The cycles a→b→a and a→c→b→a give five positions, so five is the exact minimum. Their shared projected edge b→a has two distinct represented occurrences. Counting permitted edge names alone would miss that requirement.

Finiteness is a substantive premise. On K=ℤ, let U(n)=n+1 and let E(n)=a for n<0 and b otherwise. This bijection has exactly a→a, a→b and b→b as its projected contacts. The crossing has no return, so it has no finite realization of the required kind. The infinite construction has no invariant probability measure, as M37's integer-cursor argument shows. More generally, even an infinite hidden carrier cannot supply equal projected probability marginals with positive weight on every edge of this finite contact graph. Those weights would again violate balance. Nor does an arbitrary outer bound on the whole follow from a finite set of reading labels. Exact contact support, finite reversible realization, invariant probability and entropy are separate questions about specified internal relations.

**With an unbounded carrier, the exact support criterion is weaker.** For finite nonempty A, an onto common reading of a permutation on some carrier realizes exactly T if and only if every vertex has at least one incoming and one outgoing edge. Necessity follows by reading a microstate, its successor and its predecessor. For sufficiency, each edge e can be extended to a walk w_e:ℤ→A containing e at positions 0,1. To construct it, follow incoming edges backwards until a vertex repeats, and outgoing edges forwards until a vertex repeats. The finite carrier A supplies periodic tails in both directions. All contacts in the walk belong to T.

Take K=T×ℤ, U(e,n)=(e,n+1) and E(e,n)=w_e(n). U is a bijection. Every projected contact is in T and every e occurs at its designated position, so the support is exact and E is onto. This countable construction covers the whole relation, without choosing one observed path as the entire domain. If a contact lacks a return, the finite criterion proves that every such realization must be infinite, while this construction shows that countably many positions suffice. The integer position is a coordinate of this proposed representation, not a clock inferred for reality. Arbitrary hidden capacity consequently removes the finite return obstruction but does not supply the missing full stationary weighting.

**Even the entire entropy profile can miss continuation.** Fix a finite alphabet D of size d≥2, a fixed-point-free permutation f of D, and a positive integer n. On the same complete carrier K=Dⁿ define two transitions, with one common reading E(x₁,…,xₙ)=x₁:

    U(x₁,…,xₙ) = (x₂,…,xₙ,x₁),
    V(x₁,…,xₙ) = (x₂,…,xₙ,f(x₁)).

Both are permutations: the inverse rotation recovers x₁ from the last field, applying f⁻¹ for V. Prepare the uniform distribution on all dⁿ states. It is stationary under either transition. The first n readings expose the initial word exactly. Consequently every word of length k≤n has probability d⁻ᵏ in both sources. At every length k≥n there are exactly dⁿ distinct words, each of probability d⁻ⁿ: their length-n prefixes already separate the initial states, and subsequent symbols are determined. Thus, for both sources and every positive k,

    H(E₀,…,E_(k−1)) = min(k,n) log₂d.

Nevertheless, after the same initial word, the next reading is x₁ for U and f(x₁) for V. They differ for every word. Their admitted words of length n+1 are disjoint. Equality of all shorter word distributions, all block entropies, all resulting conditional entropies and the entropy rate does not determine this continuation.

The failure survives a stronger record than consecutive-block entropies. For any finite set J of nonnegative reading positions, both sources have

    H((E_j)_(j∈J)) = |{j mod n : j∈J}| log₂d.

Write j=qn+r with 0≤r<n. U reads x_(r+1), while V reads f^q(x_(r+1)). Each represented residue contributes one independent uniform letter; every reading at that residue is a bijective recoding of it. This proves equality of the entropy of every finite selection of reading positions. The omitted content is the actual correspondence between those letters. Equal uncertainty does not identify which addressed alternatives are joined.

For n=2 and the exchange f(0)=1, f(1)=0, each source has four states. U has the fixed states 00,11 and the cycle 01↔10. V has the cycle 00→01→11→10→00. Their single readings are balanced and all four one-step observed pairs have probability 1/4. Their triples are:

| Initial two readings | Third under U | Third under V |
|---|---|---|
| 00 | 0 | 1 |
| 01 | 0 | 1 |
| 10 | 1 | 0 |
| 11 | 1 | 0 |

Here H₁=1 and H_k=2 for k≥2. The word 001 has probability zero under U and 1/4 under V. After two readings either source's next symbol is determined, yet the determining relations disagree. Neither one-symbol process is Markov: conditioning on only its last symbol gives two possible next answers, while the preceding symbol settles the answer within the specified source. Repeated use of the common one-step probability matrix would invent words that the actual source refuses.

The comparison uses one fixed reading alphabet across the repetitions. A common relabeling preserves the contrast between E_n=E₀ and E_n≠E₀. Separate relabelings at each position can conceal it, but their relative correspondence is then part of the relation removed from the description, as in VI1. No absolute names or exterior observer are needed. Reading positions enumerate applications in these proposed models; they do not supply a clock for the whole of reality.

For every prescribed finite observation length n this construction provides the opposing continuations, with a finite carrier that grows with n. There is no universal finite observation cutoff in this unrestricted class, even with the whole entropy profile supplied. This does not show that all exact finite-word probabilities would leave finite-word questions unanswered, or that additional source restrictions cannot provide a bound. Nor does the construction certify both sources as physically realizable. Its target is the inference from the stated statistics to an exact continuation. Under Verdict §6c, the same retained input cannot determine the next answer across these two sources. Binding it to an established source relation resolves this ambiguity; a longer observation may distinguish the sources but is not a prediction made before it.

The n=2 contact uses no new transition protocol. `TwistedPairShift` composes the existing paired application, field exchange and sequential reading; `DoubleTwistedPairShift` retains the intermediate source. Its two letters can be `Paired<A,B>` and `Paired<B,A>` with A≠B. `Checks/Discovery.swift` derives the common second reading, the third-reading expressions and the four-step return for arbitrary structured letter fields. It refuses 001 in the plain source and 000 in the twisted source. These are static constructor consequences. The general entropy and arbitrary-n proofs above are not presented as compiler-certified by these finite witnesses.

An inverse step does not yet select the reversal used by a directional comparison. Space §5k gives both a nonuniqueness witness and reconstruction from a discriminating internal reading. A reversal defined on all observed profiles can also fail to lift to the represented source. The following constructions therefore state their source reversal separately from the dynamics and from reversal of the recorded word.

**A stationary record can acquire an apparent direction from its reading.** Take a ring with four addressed positions carrying A, an unmarked interior position, B and C, where A,B,C are distinct landmarks. The whole state is (i,d), with i modulo four and d∈{+1,−1}. Define U(i,d)=(i+d,d) and Θ(i,d)=(i,−d). Both the direction and the position are internal coordinates of this finite model. U is a permutation, Θ²=id, and ΘUΘ=U⁻¹. The uniform law on its eight states is invariant under both maps. Reading the actual position symbol ignores d. Every finite raw word therefore has the same probability as its reversal, by the source correspondence k↦ΘUⁿ⁻¹k for words of length n.

Now let E report the last landmark passed in that state's directed periodic history. At a landmark it reports that landmark. At the interior position it reports A for d=+1 and B for d=−1. The two cyclic recorded words are AABC and CBBA. Each starting position in each direction has weight 1/8. The recorded process is stationary, yet AAB has probability 1/8 and its reversed word BAA has probability zero. The complete process has the stated reversal symmetry. Its ordinary reversed label word is not the corresponding observation of that reversed process.

The missing relation can be exhibited without probabilities. At position A and at the interior position with d=+1, E gives A. After Θ, the first gives A and the second B. Therefore no single map θ on the three recorded labels can satisfy EΘ=θE on all eight states. Even choosing a different reversal convention for the labels cannot repair this particular interface.

**There is an exact minimum repair.** For any source K, involution Θ and reading E, such a θ on E(K) exists exactly when E(k)=E(k′) implies EΘ(k)=EΘ(k′). This is VC15's factorization criterion for the one specified operation. Define θ(E(k))=EΘ(k). The condition makes it well-defined, and Θ²=id then gives θ²=id. Conversely any such θ supplies the condition.

The refined reading E±(k)=(E(k),EΘ(k)) always carries Θ by swapping its two fields. It is the least refinement of E that does so: if E=dF and FΘ=θ_F F, then E±=(dF,dθ_F F) factors through F. In the ring example its five values are (A,A),(A,B),(B,A),(B,B),(C,C). The interior is identified by its two directional bounding landmarks, exchanged under reversal. This is the minimum for the reversal question, not for every continuation. The two directions at position A still share (A,A) but have different next readings under U. Future closure remains VC15's further obligation. Availability of the second coordinate also requires an acquisition or adequate retained evidence.

One retained earlier reading already suffices in this model. The pairs (previous,current) along AABC are CA,AA,AB,BC, and along CBBA are AC,CB,BB,BA. All eight differ, so the pair identifies the complete represented state and hence EΘ. An appropriate memory decoder can therefore supply the repair without another source contact. This conclusion uses the established traversal law and one-step sampling relation. It does not infer those relations from the words alone.

`LandmarkReversal` in `Checks/Interactions.swift` constructs the records from actual tagged symbols. `VisitLandmark` takes the marked input's payload, while `PassInterior` retains the preceding landmark. `FourLandmarkSteps` binds each step to its predecessor and retains the input word. The forward traversal of A–interior–B–C gives AABC, while the traversal of the actually reversed word gives CBBA. A positive equal-reading witness and a zero/successor distinction expose the failed Θ factorization. An expected refusal rejects identifying CBBA with the ordinary reversal CBAA. `InteriorReversalExchangesBoundaryPair` checks the repaired interior coordinate through the existing field exchange. These types certify the specified clauses and their composition. The stationary weights, general minimality and reversal of the eight-state model follow from the arguments above.

The physical importance of this distinction is already recognized. [Hartich and Godec, §IV](https://arxiv.org/pdf/2011.04628) analyze a related failure of coarse graining to commute with time reversal in their diffusion model, calling it kinetic hysteresis. Their thermodynamic interpretation requires the appropriate microscopic reversal before the trajectory reduction. This is a theoretical contact, not a new measured violation supplied by VI. The finite ring above assumes no temperature, heat or entropy-production law, and does not specify a cost-free physical recorder. It demonstrates why a direction score on a reduced record needs an actual reversal relation before it can support a claim about physical dissipation.

**A valid reversal reading makes the obstruction survive hidden extensions.** Let ν be a law on complete paths, R a specified path reversal and F the retained record. Suppose R preserves ν and FR=rF for the proposed record reversal r. Then the record law P=F_*ν satisfies r_*P=P: pushing forward the two equal full laws and using the commuting relation gives the equality. Equivalently, each record event and its reversed event have equal probabilities. No Markov premise, finite hidden-state bound or complete observation of the source is required.

Consequently an established inequality between those two probabilities excludes every hidden extension preserving these premises. Additional internal memory cannot rescue a reversal-symmetric full law by itself. It must change the law, the interpretation of reversal or the recording relation. This is M71's obstruction-preservation pattern applied to probability-law answers. It does not exclude an invertible dynamics with an asymmetric preparation, since invertibility alone never supplied R_*ν=ν.

There is a controlled-error form. Use total variation TV as the supremum of event-probability differences, and suppose ν{FR≠rF}≤δ is a justified bound on failure of the complete recording relation. Then

    TV(P,r_*P) ≤ TV(ν,R_*ν) + δ.

Indeed compare F_*ν with (FR)_*ν, which cannot differ more than the two source laws, and compare (FR)_*ν with (rF)_*ν using their coupling on the same source. The latter difference is at most δ. Thus observed asymmetry larger than the allowed recording defect forces asymmetry of the full law. Statistical uncertainty in estimating that observed difference remains a separate obligation. No heat scale or thermodynamic entropy formula enters this bound.

**The complete commuting relation is sufficient, but a particular statistical question can require less.** On a finite source K with involution R, fix a reading F and proposed record involution r. Every R-invariant source law gives an r-invariant record law exactly when, for every k, the two-entry multiset {F(k),F(Rk)} is r-invariant. Necessity follows by preparing equal weights on the R-orbit of k, or unit weight at a fixed point. Sufficiency follows by mixing these orbit laws. Equivalently, each pair either satisfies F(Rk)=rF(k), or both its images are separately fixed by r. The second case can fail FR=rF while preserving every tested symmetry of the record law.

For example, let R exchange a with b and c with d. Let F preserve all four labels and let r exchange a with b while fixing c and d separately. The complete operations disagree on c,d, yet every R-invariant law is r-invariant. The proposed record reversal asks no directional question of those two labels. This does not make r the actual reversal of that lossless representation. It separates a guarantee about a law from a faithful image of an operation.

For just one bounded source response f, an even smaller exact condition suffices. Its expectation is zero under every R-invariant law exactly when f(Rk)=−f(k) at every k. The same one-orbit preparation proves necessity, and pairwise cancellation proves sufficiency. If f=wF for a chosen record contrast w, only this pullback needs the property. Other fields of F can be irrelevant to that question. With |f|≤1 and ε=(1/2)E_ν|f+fR|,

    |E_ν f| ≤ TV(ν,R_*ν) + ε.

Split f into (f−fR)/2 and (f+fR)/2. The first expectation is half the difference of the two source-law expectations of f, bounded by TV. The second is bounded by ε. An established response-specific defect can therefore be smaller than the failure probability of the complete recording relation. It still needs its source justification. Nonzero values on individual histories do not establish nonzero expectation. Agreement §6c shows why a symmetry of whole-history laws alone supplies very little finite-sample confidence, even with exact observation.

**Even a lossless temporal representation needs its own reversal.** For a word x₀,…,x_n define the overlapping-pair record

    D(x) = ((x₀,x₁), (x₁,x₂), …, (x_(n−1),x_n)).

Every raw entry is recoverable. The admissible records satisfy equality of each pair's second field with the next pair's first field. Let R reverse the raw word, r reverse the order of recorded pairs, and S exchange the two fields of every pair. Reading the reversed input gives DR=SrD, rather than DR=rD. This follows at each position by reading the same two source addresses in their reversed order. S and r commute and are involutions, so Sr is the correct reversal on the record image.

Give the eight three-bit raw words equal weights. This full law is invariant under R. The raw word 001 has record (00,01) with probability 1/8. Its ordinary record reversal (01,00) has probability zero: the shared middle field would have to equal both 1 and 0. The correct reversal is (10,00), which reads the equally weighted raw word 100. Thus lossless encoding alone does not preserve a comparison with an independently chosen reversal. No hidden information, thermodynamic model or external randomness mechanism is needed for this finite counterexample to that inference. The weights describe the declared preparation over the eight internal records.

`DelayPairReading` in `Checks/Interactions.swift` constructs both windows from the same triple. `DelayPairRecovery` requires their actual overlap and reconstructs the input. `DelayPairIsLossless` and `DelayPairReversal` check recovery and the exchanged-field reversal for arbitrary structured entries. An expected refusal rejects recovery of the ordinary reversed (00,01) record because its overlap disagrees. These are constructor relations, not a separately asserted property of a representation.

**Pointwise learning preserves only the reversal it actually receives.** A fixed g applied identically to each raw frame commutes with reversing frame order, independently of g's linearity or injectivity. If frames themselves transform by an involution θ, a corresponding latent transformation η instead requires gθ=ηg. Any preprocessing H must also carry the source reversal into this frame reversal. Composition then proves the complete relation. Calling the last stage frame-by-frame does not discharge H's obligation.

A relevant contact is [Li et al., §§III–IV and IX](https://arxiv.org/html/2305.19983v2): a feedforward autoencoder encodes phase-field frames, and a compression estimator compares the latent trajectory with its ordinary reverse. The phase fields are extracted from intensity histories. Their cited [Tan et al. method, Methods](https://bpb-us-e1.wpmucdn.com/sites.mit.edu/dist/9/2055/files/2020/08/s41567-020-0841-9.pdf) uses the two delayed intensities I(t),I(t+τ), after background subtraction, to compute phase. For the ideal delay pair the transported reversal exchanges these intensities and reverses the interval order. For a nonzero pair with φ=atan2(b,a), exchange gives π/2−φ modulo 2π, not φ. To use the transported reversal, a later spatial encoder must carry that transformation, or the reversed input must be reprocessed through the full established reading. The authors' implemented preprocessing and raw records have not been reanalyzed here. This identifies a concrete missing comparison to audit, without deciding their empirical result from the simplified pair example.

**Attribution to a selected source requires a conditional recording relation.** Fix a context of observation and finite alphabets X of source histories and Y of records. Let P be the source-history law in that context, and K_x the established conditional record law at source history x. Then Q=KP, where Q(y)=Σ_x P(x)K_x(y). These are two related internal readings, not two separate worlds. K concerns complete histories and can include detector noise and memory. It is not a premise that successive frames are independent or Markov.

For source and record reversals R,r, a sufficient calibration condition is K_(Rx)=r_*K_x. Define its defect δ_K(x)=TV(K_(Rx),r_*K_x). Then

    TV(Q,r_*Q) ≤ TV(P,R_*P) + E_P δ_K.

To prove it, compare KP with K(R_*P), then with r_*(KP). A common conditional reading contracts total variation, so the first difference is at most TV(P,R_*P). The second compares the mixtures Σ_x P(x)K_(Rx) and Σ_x P(x)r_*K_x, and is at most their averaged conditional difference. Thus asymmetry exceeding a justified recording defect requires asymmetry of this source law. The premise does not require microscopic reversal symmetry of the apparatus's entire state or its energy use.

A tested response can again require less than the full conditional law. For |w|≤1 on records, put m(x)=E_(K_x)w. Zero expected response under every R-invariant preparation is equivalent to m(Rx)=−m(x), by the earlier one-orbit argument. Only this calibrated conditional mean is required for that question. A bound on E_P|m+mR|/2 gives the corresponding response-specific error term. Its calibration must cover the source cases and context to which the bound is applied.

If the actual conditional reading L differs from a calibrated K by β=Σ_x P(x)TV(L_x,K_x), its observed law Q_obs satisfies

    TV(Q_obs,r_*Q_obs) ≤ TV(P,R_*P) + E_P δ_K + 2β.

Indeed TV(LP,KP)≤β, and applying r preserves that distance, giving two additional error terms. A small calibration error averaged under a different preparation does not by itself bound β here. The required source correspondence belongs to the claim.

The conditional reading must also survive the preparation changes for which it is promised. Averaging an omitted variable whose conditional relation to x changes can change K_x, even when the displayed x agrees. M64's scoped calibration transfer and the preparation-dependent contact in AI §7 concern this obligation. No independent external noise source is being inserted. Finally, P is the source's actual law with this apparatus coupled. A calibrated reading can separate distortion of the record from asymmetry of that law, but does not establish how the source would behave without the coupling. That further question needs a relation between the two observation contexts or a distinguishing intervention.

**Completeness for reversal need not recover the whole source law.** Keep finite X,Y and involutions R,r, and now require the exact calibrated relation KR_*=r_*K. Let A be the space of signed source contrasts v with R_*v=−v. Then

    KP = r_*KP implies P = R_*P, for every probability law P,
    exactly when ker K ∩ A = {0}.

Indeed d=P−R_*P belongs to A and KP−r_*KP=Kd. Injectivity on A therefore gives the implication. Conversely, suppose a nonzero v in A is erased by K. Its entries sum to zero. Choose a strictly positive R-invariant law u, such as the uniform law on X, and a sufficiently small nonzero ε so that P=u+εv is nonnegative. It remains normalized, differs from its reversal by 2εv, and has KP=Ku. This record law is symmetric. Thus any erased directed contrast supplies an explicit preparation that defeats completeness. The statement concerns all laws on the declared finite source family. A restricted preparation family can require less.

When A is nonzero, define c as the minimum of ‖Kv‖₁ over v in A with ‖v‖₁=1. Compactness in this finite space gives c>0 exactly under the same injectivity condition. Stochastic reading contracts the norm, so

    c TV(P,R_*P) ≤ TV(KP,r_*KP) ≤ TV(P,R_*P).

If A={0}, every source law is already symmetric and the question is vacuous. No minimum over an empty set is required. With the actual reader L and the calibrated average error β above, the lower bound becomes c TV(P,R_*P)−2β ≤ TV(LP,r_*LP). An estimated record asymmetry still needs its sampling justification. Agreement in a finite sample is not the exact equality of laws used by this theorem.

An explicit reading separates this criterion from complete reconstruction. Label both interfaces by (A,B,C,D), with reversal exchanging A/B and C/D. In that fixed output order, the four conditional laws, multiplied by four, are

    K_A = (2,0,1,1),    K_B = (0,2,1,1),
    K_C = (1,1,2,0),    K_D = (1,1,0,2).

Each displayed column has total four. The actual conditional laws divide it by four. One construction uses four equally weighted internal seed slots. Two report the source itself, while the other two report the two members of its opposite pair. This conditional seed preparation is supplied, not deduced from four type names or from closure. Reversing the source pair and exchanging the final two seed slots reproduces reversal of every output. Thus K has the calibrated covariance. On a directed contrast v=(a,−a,b,−b), it gives Kv=v/2, so c=1/2. Every asymmetry of the source law remains distinguishable at the record-law level.

Nevertheless, preparations (1/2,1/2,0,0) and (0,0,1/2,1/2) both produce the uniform record law. Even exact knowledge of that law cannot recover which preparation was used. Their difference is symmetric, and K removes it. A single recorded A can arise from source A, C or D, so completeness for the law does not identify an individual source occurrence. This is loss at the selected reading, with no claim that a distinction disappears from the whole. `TwoPairRecording` constructs the four reply catalogues from source fields in bare Swift. Rearrangements of the eight source-seed slots verify the equal mixture records, while source exchange and seed exchange verify the reversal correspondence. A separate positive boundary distinguishes the preparations, and a refusal rejects identifying them from the common record law. The general probability and norm argument is given above, not asserted by an empty type marker. This finite construction sharpens VC15's question-specific completeness. It does not derive a physical state space or a universal stochastic law.

The deterministic boundary is stricter. For an equivariant reading E, with K_x the point mass at E(x), completeness for reversal under every source law permits collisions only between R-fixed source points. To see this, each output fibre at an r-fixed answer is R-invariant. If it contains x≠Rx, the nonzero contrast δ_x−δ_(Rx) is erased. A fibre at a nonfixed answer is disjoint from its reversed fibre. If it contains distinct x,z, the nonzero contrast δ_x−δ_(Rx)−δ_z+δ_(Rz) is erased. These exhaust the possible bad fibres. Conversely, if every nonfixed source point has its own fibre and only fixed points can merge, an erased odd contrast has every coefficient zero. Thus a deterministic reader must recover each nonfixed source case for this all-laws question. The four-source stochastic example exceeds that compression limit at the level of laws by using the stipulated seed relation. It does not establish equally complete reading on individual occurrences.

**A concrete biological contact needs both this reading relation and a valid sampling claim.** [Battle et al., Fig. 3](https://www.colorado.edu/conference/bss/media/317) measured mean deflection angle and curvature of primary cilia. They reported circulation in their joint record, reduced after myosin inhibition. Their untreated contour statistic gave P=0.018, while the treated residual gave P=0.16. The latter is not proof of exact equilibrium. The two-bead example in their Fig. 2 is a simulation. For a fixed frame-by-frame shape reading, reversal changes the order of frames, preserving each frame's geometry. This supplies the relevant recording relation under that calibration contract, without assuming that angle and curvature describe every internal state. It does not certify the implementation of tracking, temporal filtering or statistical estimation.

**Balance of counted transitions cannot by itself certify stationarity.** For any finite recorded word x₀,…,x_T, let N_ab count its actual adjacent a→b transitions. At every label a,

    Σ_b (N_ab−N_ba) = 1[x₀=a] − 1[x_T=a].

Each interior occurrence contributes one arrival and one departure, which cancel. Only the two endpoints remain. A word returning to its initial label therefore has zero count divergence, irrespective of how its occupancies changed along the way. For example, the prepared deterministic word A,A,B,B,A has balanced total flows while its occupied label changes between its fixed reading positions. Repeating this cycle from a fixed initial phase still does not give a stationary law. Randomizing the phase uniformly would change the preparation and supply one. Dividing endpoint imbalance by an increasingly long recording duration makes it small without establishing that randomization.

The transition-count definition in Battle et al.'s main text must be distinguished from a time-local stationarity test. When those counts exhaust each recorded path, their discrete divergence has the endpoint property above. A small accumulated divergence alone consequently cannot verify stationarity. This audits that inference, not their full experimental conclusion. Their supplementary handling of crossings, filtering and stationarity has not been checked here, and the raw records have not been reanalyzed. A complete assessment must retain those further tests. The distinction is between an identity enforced by recording a path and a property of the law producing paths.

### M40

**M40 (Repeated forgetting changes the evolution).** Exact transport with a reading at time t gives Π(U^t)_*μ_0. The recursively reconstructed sequence σ_(t+1)=ΠU_*σ_t, starting with σ_0=Πμ_0, instead satisfies

    H(σ_(t+1)) ≥ H(U_*σ_t) = H(σ_t).

The inequality follows from M38, the equality from permutation transport. This is an entropy law of the reconstructed sequence. Equality with the exactly transported coarse distribution at every time requires a further closure argument or a justified approximation. It cannot be inferred by applying the reconstruction inequality repeatedly to a different sequence.

An eight-state example includes x∈{0,1,2,3} and an internal phase c∈{0,1}. U exchanges x=0 and x=1, fixes x=2,3 and flips c. Its inverse is itself. E reports c and whether x=0 (small) or x∈{1,2,3} (large). The two cell sizes at each phase are one and three. Prepare c=0 and uniform x in the large cell. All initial controls and the phase are inside the model.

| Internal phase | Whole H | Exact coarse H | Mean log₂ cell size | Recursively reconstructed H |
| --- | --- | --- | --- | --- |
| 0 | 1.584963 | 1.584963 | 1.584963 | 1.584963 |
| 1 | 1.584963 | 1.974938 | 1.056642 | 1.974938 |
| 0 | 1.584963 | 1.584963 | 1.584963 | 1.996953 |

The exact whole returns after two steps. At that point its probability of the small cell is zero. Recursive reconstruction predicts 2/9. On the first step coarse entropy increases while the mean volume term decreases. On the second, exact coarse entropy decreases while reconstructed entropy increases. The internal clock changes throughout, but its phases neither count cycles forever nor fix a thermodynamic arrow. These are logical state tables with declared readings, without a free physical measurement or energy model.

The missing closure is explicit: x=1 and x=2 in the same large cell have different next readings. E therefore cannot determine its own update. This is Verdict VC18's execution-closure distinction applied to a probability description. After the first step, replacing the actual cell distribution by a uniform one removes information relevant to the next step. If a physical mixing process is meant to realize this replacement, its mechanism, preparation and residual belong inside the whole and must be included in the dynamics.

There is a sufficient refinement: report c and the three classes {0}, {1}, {2,3}. The six resulting classes determine their own next reading. Current and next values of the old reading distinguish exactly these classes, in the sense of VC21, and the refined coarse entropy is constantly log₂3 for this preparation. Constructing an instrument for the refined reading has its own implementation obligations.

More generally, for the finite K of M38, if E∘U=V∘E exactly on all K, VC20 makes V a permutation of the image. U sends each M_a injectively into M_(V(a)). Hence w_a≤w_(V(a)). Following a finite cycle of V forces equality at every step. U therefore maps each source cell onto its successor cell. Cell-volume entropy is constant on trajectories, and ΠU_*=U_*Π. The latter identity also makes H(Πμ_t) constant for every prior. An exactly autonomous deterministic finite description does not acquire an entropy arrow from identifying such cells alone. This conclusion is scoped to the declared fixed reading, finite complete carrier and bijective dynamics.

*Literal history retention.* To remove recurrence of the complete record, replace the eight-state whole by the space of all valid nonempty finite histories h=(w_0,...,w_t), where w_(i+1)=U(w_i). Append U(w_t) on every step. Dropping the last entry recovers the preceding history. The map is injective, but singleton histories have no predecessor in this space. This is an unbounded-capacity whole, not another finite permutation.

At each length there are exactly eight valid histories, in bijection with their last states. Reading length, phase and small/large therefore gives complete cells of sizes one and three even in the full history space. Starting with the same three equiprobable one-entry histories, whole Shannon entropy remains log₂3. The coarse entropy still alternates between the two values in the table. The formulas apply at every length. All earlier entries remain present and the historical order strictly grows, yet this reading's entropy decreases on alternate steps. Thus the record commitment can supply a nonrecurring historical order without supplying monotone entropy. This construction asserts unbounded storage explicitly and supplies no finite physical implementation of it.

The example does not refute a statistical second law under physical premises. It rejects a derivation from closure, a coarse partition and reversibility alone. A physical arrow needs a physically justified macroscopic description, dynamics and boundary conditions. [Lebowitz's account of time's arrow](https://www.cpt.univ-mrs.fr/~verga/pdfs/Lebowitz-1993xw.pdf) emphasizes the role of preparation and history. Extending the description to the whole relocates these conditions internally rather than deriving them.

The entropy inequalities follow from the specified measures, partitions and dynamics. The pure-type recovery witnesses express coordinate preservation. A type representation of M38–M40 would also need those distributional relations.

### M41

**M41 (Resolution change has its own entropy order).** Keep the finite K and the probability distribution μ fixed. Let F refine E, so E=d∘F on K, and let Π_E and Π_F reconstruct uniform distributions within their respective cells as in M38. Then

    Π_E Π_F μ = Π_E μ,
    H(Π_E μ) − H(Π_F μ) = D(Π_F μ || Π_E μ) ≥ 0,
    H(F_*μ) ≥ H(E_*μ).

*Proof.* Each F-cell is contained in one E-cell. Uniformization in an F-cell preserves that cell's mass and therefore the total mass in every E-cell. This gives the first identity. Apply M38 to the distribution Π_F μ and the E-partition to obtain the second. Finally E is a function of F, so `H(F_*μ)=H(E_*μ)+H(F|E)` with a nonnegative conditional entropy. QED

Refining the reading can therefore lower the entropy of its cell-uniform reconstruction while increasing uncertainty over its more detailed output labels. Neither is a change of μ under physical time evolution. An instrument that physically acquires the finer reading has its own interaction and memory requirements inside the whole. These inequalities do not supply it.

Verdict VC38 now constructs the least autonomous refinement for a fixed finite model, with a certificate for every added future distinction. On M40's eight-state clock it recovers the six-cell refinement. Its increasing number of classes is an order of representation refinement. It does not prove increasing entropy of the whole or a thermodynamic arrow. In particular, M38's bound from a prepared initial distribution applies with its reading fixed. Replacing that reading during an inference invokes M41 instead of another step of the same fixed-reading evolution.

This is the finite resolution order of the observational entropy used in M38. The distributional identity follows from the stated refinement and conditional measures. It is not supplied by naming a Swift protocol.

### M42

**M42 (A determined future answer need not reduce whole entropy).** In a declared finite probability model, let T be the specified complete-state transition, E_0 and E_1 its initial and final readings, and V an image transition satisfying E_1∘T = V∘E_0. Let q=d∘E_1. For X distributed on the complete carrier, the future answer Y=q(T(X)) satisfies

    Y = d(V(E_0(X))),
    H(Y | E_0(X)) = 0,
    H(Y) ≤ H(E_0(X)).

*Proof.* Substitute the commuting equation into q∘T. Each initial image then specifies one Y, so its conditional entropy is zero. Since Y is a function of E_0(X), the joint entropy of that pair equals H(E_0(X)). The chain rule gives H(E_0(X))=H(Y)+H(E_0(X)|Y), proving the inequality. QED

If an internal record R supplies E_0(X) through a fixed decoder, the same substitution gives H(Y|R)=0. This is a relation of sufficiency under the stated joint distribution. Acquiring such a record physically is another interaction within the whole. Choosing to condition a calculation on E_0 does not itself provide that record to an internal participant.

For a complete triple of independent fair bits (a,b,c), execute swap_bc and then swap_ab. The future alpha answer is c. Its uncertainty given only a is one bit, and given (a,b,c) is zero. The complete transition permutes the eight states, so whole entropy remains three bits. The two conditional entropies compare different available readings. They do not describe a decrease of whole entropy as time passes. This is a finite symbolic example, with its joint distribution explicitly supplied.

Verdict VC45 gives the structural factorization used here, and VC44 supplies closure under every permitted finite two-swap continuation. The Shannon statements additionally use the finite probability model above. Neither the number of Swift type names nor the nesting depth of a path supplies a probability measure or an entropy. A double-swap expression can grow while its complete coordinate image returns. Interpreting that expression as a retained physical history would require its own record relation.

The orders now have separate objects: Permanent relates retained records, CommutingTransition relates source and image changes, M41 compares readings at a fixed distribution, and M42 concerns the answer conditioned on an available image. A type-level derivation does not assert that the modeled source transition occurred. Its physical implementation, including compilation or a participant's reasoning, is another process inside the whole. These distinctions preserve the whole-system premise without using it to select a thermodynamic arrow.

For a partial proposed action T:D→K, the random variable q(T(X)) is defined on that domain. Applying M42 therefore requires preparation supported on D, or a separately specified outcome model for attempts outside D. VC46–VC47 give the domain condition needed when using a compressed image. Silently assigning a default answer to an unavailable action changes the random variable and can change its entropy.

## Detail: §4c. The same internal acquisition, its entropy and its order

Use the binary carrier X={0,1}³ and the six-class reading E from Verdict VC49. The participant has already acquired E(x). Its source-bound memory contains that class fact, while the source x remains another part of the whole. A constant instrument address names the beta channel of VC55. It contains no answer. A quiet phase and a blank new slot specify preparation.

For a ready source, let w_x denote the prepared whole and keep it fixed: its old class already determines x. For a blocked source, let w_x⁰ be the prepared whole and w_x¹ its output after recording beta, with the source and old memory retained. Define Ω to contain the four ready wholes and the two wholes for each of the four blocked sources. It has twelve states. Define one fixed U by U(w_x)=w_x and U(w_x⁰)=w_x¹, U(w_x¹)=w_x⁰. The phase, memory and fixed channel belong to each whole. No externally chosen action sequence enters U. This is a finite logical model with a specified coupling, not a claimed microscopic model of a physical instrument.

### M43

**M43 (internal knowledge can increase at unchanged whole entropy).** Prepare x uniformly on its eight values, choosing w_x for ready sources and w_x⁰ for blocked sources. After one application of U, the participant's accessible memory determines x. Whole Shannon entropy remains three bits. The participant's source uncertainty falls from one half bit to zero. Applying U once more restores the initial distribution and the previous accessible uncertainty.

*Proof.* The four fixed points and four disjoint pairs make U a permutation, in fact an involution. The prepared distribution gives eight distinct whole states probability 1/8. U preserves those probabilities, so its whole entropy is three bits at both steps. Initially the four ready memory labels each have probability 1/8 and the two blocked labels each have probability 1/4. Thus H(M₀)=4·(1/8)·3+2·(1/4)·2=5/2 bits. M₀ is a deterministic reading of x, hence H(X|M₀)=H(X)−H(M₀)=1/2 bit. After acquisition, ready labels still identify their singleton sources and the added beta distinguishes each blocked pair. The eight accessible labels are distinct, each of probability 1/8. Consequently H(M₁)=3 and H(X|M₁)=0. Finally U² is identity. The second step restores M₀ while the source is retained throughout. QED

The average increase in source information is one half bit. With the declared one-answer beta instrument, a fresh read is needed on four of the eight equiprobable sources and omitted on the others. These are different quantities: an average read count and an information difference. Neither supplies joules, duration, memory bytes or a thermodynamic entropy. Constant question tags, phase and preparation are part of the state model even when they add no independent uncertainty to this preparation.

The inverse does not erase beta from the whole. It removes beta from the participant's current record while retaining it in the source. If the participant has no additional accessible archive, the new question becomes unresolved again. If an accessible archive is retained, the participant has a different reading of a larger state and the calculation must include it. Preservation of a distinction and continued access to it are separate relations.

The recovery premise here is explicit. VC55 constructs a prepared predecessor from output coordinates, and the twelve-state U is a permutation by its disjoint branches. M29's two-state constant map remains a countermodel to deriving preservation from closure alone. Nothing in this example upgrades the condition “there is no outside” into a proof that every proposed complete-state transition has a recovery relation.

### M44

**M44 (a retained history orders occurrences without fixing an entropy arrow).** The twelve-state model's current phase cannot be a strictly increasing clock along all steps. A whole that additionally retains every occurrence can instead be represented by finite valid histories h_t=(w₀,…,w_t), extended by appending U(w_t). Proper-prefix inclusion gives a strict order of these history records. Under the preparation in M43, whole-history Shannon entropy is still three bits at every fixed length. The participant's current-memory uncertainty can still alternate between one half bit and zero if its accessible reading remains the last memory only.

*Proof.* On a blocked orbit, U²w=w. A state function τ strictly increasing at each step would require τ(w)<τ(Uw)<τ(w), which is impossible. A ready fixed point also excludes strict increase there. In the history model, removing the final entry recovers the preceding record, and appending an entry strictly increases finite sequence length. Thus proper-prefix inclusion orders occurrences even when their last configurations repeat. At each fixed t the eight histories are in one-to-one correspondence with their original x, retained already in w₀. They therefore each have probability 1/8 and entropy three bits. Reading only the last memory gives precisely the alternating readings in M43. QED

The history model changes the carrier: it admits unbounded possible record length. If the whole is required to retain literally all historical distinctions, the twelve instantaneous states are not that complete historical whole. They are a reduced description of its current configuration. This makes the additional commitment explicit instead of silently asking a finite cycle to preserve a count of every occurrence.

`AppendObservation` expresses source-bound prefix retention in the finite constructor grammar. It does not by itself prepare a new physical slot. The output of one `PreparedTraceExtension` has a filled slot and a signal phase, while the next extension requires a new blank slot and a quiet phase around its enlarged prefix. These whole endpoints do not match. Rewinding restores a prepared slot but also retracts the latest accessible record. Continued retention therefore needs an internal preparation and capacity relation beyond repeating the first constructor.

The existing `RetainedWhole` constructor also keeps the acquisition output in a history after the current instrument has rewound. The same `AnswerInReadyWhole` decoder can read the archived output at that historical address. This requires access to the archive as its input. It does not grant that access to a participant whose declared reading reaches only its current register. Thus the static relations distinguish a retracted current fact, a retained historical record and permission to read that record.

The prefix order supplies neither calibrated durations nor a thermodynamic arrow. Conversely, decreasing the participant's uncertainty does not supply a permanently advancing clock. The instrument law, preparation and retained-history commitment are relations inside the proposed whole. A further physical identification would have to connect them to observables, dynamics and units rather than obtaining those identifications from the word entropy.

## Detail: §4d. Restore the instrument, retain the distinction

### M45

**M45 (resident relocation separates workspace reset from loss of access).** Extend M43's prepared binary model with an old archive, an occupied workspace slot and two blank reserve slots, all initially fixed across the eight sources. On ready classes, reuse the old class fact. On blocked classes, perform VC59's preparation, VC55's beta acquisition and VC59's parking, selected by VC58. At the end, a blocked workspace has its old class and a prepared blank slot. The new beta fact remains in the accessible archive. Whole Shannon entropy is three bits at every stage. Uncertainty about the source from the participant's entire accessible memory is one half bit before acquisition and zero after acquisition and parking.

*Proof.* Each selected branch preserves the source and has the recovery relation given in VC55 or VC59. Different sources cannot merge because the source is retained. Ready branches leave the whole unchanged. Thus the eight initially equiprobable whole states have eight distinct images at each stage, giving three bits of whole entropy. Preparation relocates only the same fixed prior content and adds a branch-dependent layout already determined by the old class. The accessible partition remains the four singleton ready classes and the two blocked pairs, so its entropy is 2½ bits and conditional source entropy is ½ bit. Acquisition distinguishes each blocked pair by beta. Parking retains this distinction in the archive and preserves the old class, so the complete triple remains decodable and conditional source entropy remains zero. ∎

| Accessible reading | Initial | After preparation | After acquisition | After parking |
|---|---:|---:|---:|---:|
| Workspace only: H(X\|work) | ½ | ½ | 0 | ½ |
| Workspace and archive: H(X\|work,archive) | ½ | ½ | 0 | 0 |
| Complete whole: H(whole) | 3 | 3 | 3 | 3 |

All entries use the stated distribution and logarithms to base two. The two post-parking uncertainties concern different readings of the same whole. They are not contradictory entropy laws. No distinction has to arrive from outside: the source, channel, displaced content, fresh slots and final archive all belong to the represented whole.

In this particular retaining layout, a blocked run uses two reserve heads. A ready run uses none, giving one reserve head used on average under the uniform preparation. This number is neither the ½ bit gained about X nor an energy cost. The first parked value was fixed and added no distinction about X. Its retention demonstrates the general rule's ability to preserve arbitrary prior content, not optimal storage for that special constant input. A previously prepared blank workspace would need only the parking head. Already available evidence can answer further determined questions without another acquisition or reserve head.

The stage maps specify a finite prepared experiment. They do not assert a globally absorbing acquired state, an infinite supply of slots or a clock derived from a shrinking reserve. VC34 supplies the separate finite reversible completion argument and its limit on permanent new readiness. M44 supplies the different carrier needed to retain every historical occurrence. Continued access to a new answer requires a distinguishing accessible component even when the instrument itself returns to its prepared state.

## Detail: §4e. A retained distinction can have two different futures

The Cut's whole has no outside source. A resident program, its active position, the exchanged fields, the observing participant and memory all belong to that whole. This tells us where a needed relation must occur. To determine what an exchange does, name the fields and the actual predecessor-successor relation. To obtain a shared answer, also name the common-answer contract. VC68–VC71 complete that chain for two resident blocks.

### M46

**M46 (a realized internal relation forces an interface-specific result).** Under VC68's exchange relations, the displaced coordinate remains inside the source and contributes to later common answers exactly as represented by VC69's table Φ. For a fixed initial working image and operation word, every realization satisfying those relations gives the same table update and decoded common class. The minimum is fifteen working-image classes on the full binary carrier, or thirteen on the prepared reachable carrier.

*Proof.* The source-to-coordinate squares follow by projecting the internal exchanges. The coordinate-to-table squares follow from the addressed comparisons. Composition fixes the common-class result. VC69's separating continuations require every exact representation to preserve each distinction between its fifteen table values, while the all-B pair has one table under every continuation. Restriction to VC70's reachable carrier gives thirteen. QED

Where the exchanges and readings are realized, their result is forced by those relations. A formal declaration specifies the condition, and a source-bound acquisition supplies a record of its particular answer. The law needs no source outside the whole to resolve that answer. Establishing that a material arrangement realizes the stated coupling is part of identifying that arrangement. Closure alone does not select one exchange law from all possible internal laws.

Two sorts of omitted distinction have explicit witnesses. The first-beta difference between (0,0,0,0) and (0,1,0,0) returns to the common interface after E. The distinction between (0,0,1,1) and (1,1,0,0) never returns through this interface, although a component reading within the same whole separates it. Preservation does not require every retained distinction to be used by every chosen interaction family. The exact object keeps what that family can make consequential. This is a local boundary inside reality.

### M47

**M47 (whole uncertainty separates into future-relevant and interface-invisible residue).** Prepare the sixteen working configurations uniformly, with every other initial field fixed or a deterministic function of that configuration. Then H(X)=4 bits, H(Φ)=31/8 bits and H(X|Φ)=1/8 bit. For the current common class C, H(C)=3/2 bits and

```
H(X | C) = H(Φ | C) + H(X | Φ)
   5/2   =    19/8   +     1/8.
```

*Proof.* Φ has fourteen singleton fibers of probability 1/16 and one double fiber of probability 1/8. Its entropy is 14·4/16+3/8=31/8 bits. Only the double fiber leaves binary uncertainty, weighted by 1/8. C has probabilities 1/4, 1/4 and 1/2 for J₀, J₁ and B, so H(C)=3/2. Since C is a deterministic reading of Φ and Φ of X, the decomposition follows by separating the two nested fibers. QED

The 19/8 bits concern distinctions exposed by some permitted continuation. The remaining 1/8 bit concerns the orientation that this entire common-answer interface omits. Both belong to the complete source. Conditional Shannon uncertainty is an average under the stated preparation, not a fractional storage slot or a thermodynamic price.

Each fixed E/S word permutes X and induces a permutation of Φ's values. Therefore H(X), H(Φ) and H(X|Φ) are individually preserved for any initial distribution transported by that fixed word. The uniform preparation also makes the current-class distribution stationary. These exchange laws supply no entropy arrow. A variable resident program or feedback controller requires its joint distribution and update law to be included before making a whole-entropy claim.

VC72 exposes the remaining orientation through a new internal cross-block connection while keeping the common question. If only Φ is accessible, the all-B class then requires one component read, and every old singleton class requires none. Under this preparation, the mean is 1/8 read and the gained information is 1/8 bit. Their equal numbers follow from this particular binary residual and instrument. If the original four-coordinate trace remains accessible, no new read is needed. The distinction was retained inside the source or trace before that connection made it relevant.

The resident tape orders operations internally. A working configuration can recur, and the table can recur even sooner. An occurrence record still names its predecessor and actual step. At each fixed length of a deterministic retained-history construction, the sixteen equally probable initial cases give sixteen distinct histories, hence four bits of history entropy. Length can grow while that entropy remains fixed. M44's distinction between ordered history and current recurrence applies directly, without external clock values.

## Detail: §4f. Learning a routing law redistributes uncertainty inside the whole

VC74–VC76 give a finite case with one retained routing source, two calibrated internal instruments and two initially blank records. The probe vectors are p=(0,0,1,1) and q=(0,1,0,1), observed at all four output addresses. Their records identify a fixed coordinate-routing law. VC75 reuses those records with a separately read data input. The family and preparation determine which uncertainty is being measured.

### M48

**M48 (probe records reduce conditional law uncertainty while the whole retains its distinctions).** Give the twenty-four four-address permutations equal probability. Keep the remaining initial preparation fixed. Write L for the routing and R₁,R₂ for its first and second probe records. Entropies use base-two logarithms. Then

```
H(L)          = log₂ 24
H(L | R₁)     = 2
H(L | R₁,R₂)  = 0
H(R₁)         = log₂ 6
H(R₂ | R₁)    = 2.
```

At each fixed phase of VC76's constructed experiment, the whole has entropy log₂ 24. This probability assignment describes uncertainty over the admitted internal preparations. It is not an additional physical source outside the whole.

*Proof.* The first probe has two zero and two one entries. A permutation can place the ones at any two output addresses, giving six images. Each image has 2!·2!=4 compatible permutations. Under the uniform preparation those four remain equiprobable, so conditional law entropy is two bits. Within each first-image fiber, q assigns distinct second bits to the two addresses in each first-bit group. Its four possible images separate the four remaining permutations, giving zero residual law uncertainty. Each whole phase retains L and adds only fixed preparation fields or deterministic functions of L. Thus its mapping from the twenty-four initial cases is injective with the same probability weights, which preserves whole entropy. QED

If instead all 4⁴ fixed coordinate-selection maps are equally probable, the corresponding law entropies are 8, 4 and 0 bits. Each first output bit leaves two source-address choices independently at each of four outputs. The second bits resolve those choices. This is a different preparation, not a correction to the permutation calculation. Neither assignment is forced by closure alone.

The first model records eight binary output coordinates in total but acquires only log₂ 24 bits about the law. Representation size, acquired information and number of probe calls therefore differ even in this small case. The residual two bits after the first probe specify exactly which distinctions the second probe must expose. Their later use is explicit: the reconstructed signatures select the new input values. Knowledge of the law does not supply those new values.

The experiment's internal phase order has four stages and only two acquisitions. Exchanging instrument addresses advances the declared path without changing the records or conditional law entropy. Reversing the constructed path restores the blank instruments and removes their accessible evidence while L remains inside the source. Retaining the acquired law while restoring working instruments requires an internal archive or equivalent remaining correlation. The paired realization does not assume an unlimited archive.

The resulting direction of learning is a growth of correlation across this chosen internal boundary under the prepared forward relation. Whole distinctions persist throughout. A changing internal schedule can mimic a fixed law's records (VC74), so interpreting that correlation as knowledge of a stable law also requires the actual routing relation. The entropy calculation neither supplies that relation nor converts memory growth into an independent universal time arrow.

### M49

**M49 (uncertainty about the current law can increase while its old record survives).** In VC77's whole ((I,H),J), fix H and choose I and J independently and fairly from identity and K. Retain an acquired record R that identifies I. Before the routing-reserve exchange, the current law is I and H(I|R)=0. After the exchange, the current law is J and H(J|R)=1 bit. The old record is unchanged, and whole entropy remains two bits.

*Proof.* There are four equally probable ordered pairs (I,J). Within either value of R, the two reserve laws remain equally probable. The exchange sends (I,J) to (J,I) while retaining R beside the whole, giving an injective update of these four cases. Applying the exchange twice restores the original arrangement. Thus the decrease in knowledge of the current law is a change in which internal variable the current-law question reads. It is not deletion of R or an increase in whole uncertainty. QED

For the empty continuation and arbitrary repeated reserve exchanges, the ordered pair (I,J) determines the current law: even paths read I and odd paths read J. Each coordinate is necessary on this independent preparation, since the empty path exposes I and one exchange exposes J. The four-value pair therefore supplies the future-law object that the two-value current-law record omits. The same distinction between a current answer and its continuation-sufficient object appears here at the level of learned laws. Nothing external to the whole enters the replacement.

## Cross-page mentions

Labels mentioned here: <doc:interference_is_substitution__models_calibration#IiS11>, <doc:interference_is_substitution__models_calibration#IiS12>, <doc:interference_is_substitution__models_calibration#IiS13>, <doc:interference_is_substitution__positive_channels#IiS14>, <doc:interference_is_substitution__positive_channels#IiS15>, <doc:interference_is_substitution__positive_channels#IiS16>, <doc:interference_is_substitution__positive_channels#IiS19>, <doc:permanence_is_resistance#M23>, <doc:permanence_is_resistance__retention#M50>, <doc:permanence_is_resistance__retention#M64>, <doc:permanence_is_resistance__recovery_remainder#M70>, <doc:permanence_is_resistance__forced_answers#M71>, <doc:verdict_is_invariant__finite_records#VC15>, <doc:verdict_is_invariant__finite_records#VC18>, <doc:verdict_is_invariant__recovery_memory#VC20>, <doc:verdict_is_invariant__recovery_memory#VC21>, <doc:verdict_is_invariant__recovery_memory#VC23>, <doc:verdict_is_invariant__discovery_acquisition#VC31>, <doc:verdict_is_invariant__discovery_acquisition#VC32>, <doc:verdict_is_invariant__discovery_acquisition#VC33>, <doc:verdict_is_invariant__discovery_acquisition#VC34>, <doc:verdict_is_invariant__discovery_acquisition#VC38>, <doc:verdict_is_invariant__discovery_acquisition#VC40>, <doc:verdict_is_invariant__discovery_acquisition#VC42>, <doc:verdict_is_invariant__reusable_images#VC44>, <doc:verdict_is_invariant__reusable_images#VC45>, <doc:verdict_is_invariant__reusable_images#VC46>, <doc:verdict_is_invariant__reusable_images#VC47>, <doc:verdict_is_invariant__reusable_images#VC49>, <doc:verdict_is_invariant__reusable_images#VC55>, <doc:verdict_is_invariant__reusable_images#VC58>, <doc:verdict_is_invariant__reusable_images#VC59>, <doc:verdict_is_invariant__routing_laws#VC68>, <doc:verdict_is_invariant__routing_laws#VC69>, <doc:verdict_is_invariant__routing_laws#VC70>, <doc:verdict_is_invariant__routing_laws#VC71>, <doc:verdict_is_invariant__routing_laws#VC72>, <doc:verdict_is_invariant__routing_laws#VC74>, <doc:verdict_is_invariant__routing_laws#VC75>, <doc:verdict_is_invariant__routing_laws#VC76>, <doc:verdict_is_invariant__routing_laws#VC77>, <doc:verdict_is_invariant#VI1>.

Mentions of this page’s labels: <doc:interference_is_substitution> (M35), <doc:interference_is_substitution__global_obstructions> (M35), <doc:interference_is_substitution__models_calibration> (M31), <doc:interference_is_substitution__models_calibration> (M32), <doc:interference_is_substitution__models_calibration> (M39), <doc:interference_is_substitution__positive_channels> (M32), <doc:learning_is_liquid> (M35), <doc:learning_is_liquid> (M38), <doc:learning_is_liquid> (M41), <doc:learning_is_liquid__reconstructed_sides> (M35), <doc:permanence_is_resistance> (M29), <doc:permanence_is_resistance> (M30), <doc:permanence_is_resistance> (M33), <doc:permanence_is_resistance> (M36), <doc:permanence_is_resistance> (M37), <doc:permanence_is_resistance__forced_answers> (M29), <doc:permanence_is_resistance__forced_answers> (M31), <doc:permanence_is_resistance__forced_answers> (M32), <doc:permanence_is_resistance__forced_answers> (M35), <doc:permanence_is_resistance__forced_answers> (M36), <doc:permanence_is_resistance__physical_models> (M32), <doc:permanence_is_resistance__recovery_remainder> (M29), <doc:permanence_is_resistance__recovery_remainder> (M35), <doc:permanence_is_resistance__recovery_remainder> (M36), <doc:permanence_is_resistance__recovery_remainder> (M48), <doc:permanence_is_resistance__retention> (M31), <doc:permanence_is_resistance__retention> (M32), <doc:permanence_is_resistance__retention> (M33), <doc:permanence_is_resistance__uniform_routing> (M30), <doc:verdict_is_invariant__calibration_residence> (M35), <doc:verdict_is_invariant__discovery_acquisition> (M38), <doc:verdict_is_invariant__discovery_acquisition> (M40), <doc:verdict_is_invariant__discovery_acquisition> (M41), <doc:verdict_is_invariant__finite_policies> (M34), <doc:verdict_is_invariant__finite_policies> (M39), <doc:verdict_is_invariant__finite_records> (M29), <doc:verdict_is_invariant__finite_records> (M35), <doc:verdict_is_invariant__local_lifts> (M39), <doc:verdict_is_invariant__local_lifts> (M40), <doc:verdict_is_invariant__recovery_memory> (M29), <doc:verdict_is_invariant__recovery_memory> (M32), <doc:verdict_is_invariant__recovery_memory> (M33), <doc:verdict_is_invariant__recovery_memory> (M34), <doc:verdict_is_invariant__recovery_memory> (M35), <doc:verdict_is_invariant__reusable_images> (M43), <doc:verdict_is_invariant__reusable_images> (M44).
