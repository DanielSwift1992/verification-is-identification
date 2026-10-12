# Learning Is Liquid (Phase) — Coordination blocks

This part contains the original derivations for coordination blocks.

Family and original section headings: <doc:learning_is_liquid>.

Section setting: <doc:learning_is_liquid#6c-Coordination-through-internal-changes>.

## Detail: §6c. Coordination through internal changes

### LQ14

**LQ14 (admission gives a necessary coordination scale, including all internal detours).** Fix a finite set I of addressed parts and admitted forms R⊆∏ᵢ Aᵢ. The parts and their addresses must belong to the proposed construction. For x,y∈R, let Δ(x,y)={i:xᵢ≠yᵢ}. Among all finite paths from x to y through R, define

    κ_R(x,y) = min_path max_step |Δ(x_previous,x_next)|,
    κ_R(x,x) = 0.

For distinct endpoints the direct path gives a candidate changing at most |I| addresses in one step. Every candidate width is a positive integer, so a minimum exists. A step here is a relation between forms, with composition giving a path. Its width counts changed addresses without specifying a physical instant. This definition uses every compatible intermediate form. It does not assume that every such step is actually available. Consequently κ_R is a lower bound on the largest step width in any actual path that remains in R with these addresses. An actual operation family can require a larger change or admit no such path at all.

**The coordination scales form a hierarchy.** Symmetry of Δ allows each path to reverse, so κ_R is symmetric. It vanishes exactly on identical endpoints. Concatenating minimizing paths proves

    κ_R(x,z) ≤ max(κ_R(x,y), κ_R(y,z)).

Thus κ_R is an integer-valued ultrametric. For each k, κ_R(x,y)≤k is exactly reachability through admitted pairs differing at at most k addresses. These equivalence classes merge as k increases. They describe the largest compatibility envelope for that change width. By LQ12, properties preserved by every pair in this envelope are exactly functions of these classes. This uses the radius-graph construction already present in Navigation N1–N2. Here the vertices are admitted forms of a contact structure, and the radius limits address changes per step rather than a library search distance.

There are two complementary certificates. An admitted path of width at most k proves κ_R(x,y)≤k. A partition of R placing x and y on opposite sides, with every crossing pair differing at more than k addresses, proves κ_R(x,y)>k. Conversely, if no width-k path exists, the forms reachable from x supply such a partition. This is a partition of admitted forms, distinct from the earlier cut between their addressed parts. The lower certificate applies to every actual operation family respecting R and the width bound. The upper certificate additionally needs actual constructions for its steps before it certifies a realized process.

The earlier examples now have exact scales. In the full cube and the vacancy relation, every distinct pair has κ=1 because the one-coordinate paths already constructed connect them. In even parity, every distinct pair has κ=2: one change is forbidden, and pair flips connect every two admitted forms. For the repetition relation {0ⁿ,1ⁿ}, κ(0ⁿ,1ⁿ)=n, since no other admitted form exists. Coupling all n coordinates can therefore require changing either one, two or n addresses per step in these different relations. The number of parts coupled does not determine the required coordination scale.

**When the elementary refusal determines the binary law.** Let R⊆{0,1}ⁿ, n≥2. Suppose its projection onto one chosen n−1 roles is the full cube, and no two admitted forms differ at exactly one role. Then R is exactly one parity class. The parity law is a conclusion from these two admission requirements.

*Proof.* Write a form as (x,t), with t at the omitted role. Full projection gives at least one t for every x. The elementary refusal gives at most one, so t=f(x). If x and y differ at one role, f(x) and f(y) must differ too, or their full forms would violate the refusal. On a binary carrier this forces the output to exchange its two values at every such change. Starting at 0ⁿ⁻¹ and changing the nonzero coordinates of x gives f(x)=f(0ⁿ⁻¹)⊕parity(x). Thus R is exactly the class with total parity f(0ⁿ⁻¹). QED

One exhibited admitted form fixes which class it is. No independent parity equation, probability, metric or temporal law was assumed. All other proper projections are full as a consequence. The established refusal also rules out any process between distinct admitted forms consisting only of changes to one role while retaining these roles and this complete R. Pair flips connect the class, giving κ=2, though their physical availability still requires actual operations.

Full projection can be weakened when the question concerns a smaller supplied domain D⊆{0,1}ⁿ⁻¹. Require at least one completion for every x∈D and the same elementary refusal. The unique completion f again changes at every one-role edge inside D. Hence f(x)⊕parity(x) is constant on each connected component of that domain graph. Conversely, one freely chosen binary value per component defines every relation satisfying these requirements. One exhibited completed form in each component determines all its other completions. The full-cube theorem is the connected special case.

For a particular target input, even knowledge of all D is unnecessary. A finite chain of inputs from an exhibited completed form to the target suffices, provided each input is known to admit a completion and consecutive inputs differ at one role. The refusal forces the answer along that chain. A richer domain retaining these admissions, refusals and role identities cannot change this answer. An oppositely completed target would contradict the finite chain. Thus a positive route can transmit a necessary answer without an exhaustive catalogue of possibilities. Claiming that no such route exists still requires the appropriate coverage. The chain orders the argument and supplies no physical sequence of those forms.

Each premise has content. Without full projection, a singleton relation obeys the refusal but omits most of a parity class. Without the refusal, the full cube has the projection. Binary alternatives are essential: on three-valued roles, c=a+b and c=a−b modulo three both have full (a,b) projection, no admitted one-role change and the given form 000, but differ at the same addressed input (0,1). This is an exact conditional identification of a relation, not a derivation of binary carriers or complete projection from happening. To apply it to a given phenomenon, those carrier, coverage and refusal facts must be established for the same roles. A few observed unchanged cases do not establish the universal refusal.

**An irreducible direct replacement need not require an irreducible process.** One proposed atom would be a pair x,y with no admitted intermediate assembled coordinatewise from their endpoint entries. That criterion fails in the presence of detours. Consider the single internal relation

    R = {(a,b,c) ∈ {0,1}³ : c=1 or a=b}.

With c fixed at zero it admits only 000 and 110. Every proper partial replacement between them violates a=b. But the whole relation admits

    000 → 001 → 101 → 111 → 110.

Each step changes one coordinate. The c=1 forms permit independent a and b, and the final change restores c=0 only after their agreement is restored. Every displayed edge has its reverse within R. The fixed-zero fragment needs width two, while the same endpoint pair has width one in the full internal relation. The distinction between these conclusions is the retained or changing context, not an external exception to the law. The same relation is satisfied throughout the detour.

This example changes which constraint the addressed fragment must satisfy through a resident coordinate. LQ12's earlier example instead changed its permitted moves while keeping the same parity admission condition. Both are possible descriptions of a regime change, and neither should be silently substituted for the other. A physical phase interpretation would have to establish which kind of change its actual construction permits.

**Two meanings of greater freedom move differently.** On fixed addresses, if R⊆R′, every old path is still available in the enlarged compatibility envelope. Hence κ_R′(x,y)≤κ_R(x,y) for old endpoints. Yet LQ13's R₀⊂R₁⊂R₂ example shows that a uniform local law can become invalid and then valid again. Opening more forms can ease a particular rearrangement while making a universal law harder to satisfy. These are two precise properties of a changing logical medium, not one scalar liquidity.

**The whole need not have finitely many parts.** For arbitrary I, use finite paths whose individual changes have finite support. Two admitted endpoints can be joined in this envelope exactly when they differ at finitely many addresses. Necessity follows because the union of finitely many finite supports is finite. Sufficiency is the direct finite-support change between those endpoints. Within each such class the same integer minimum and strong triangle argument apply. Endpoints differing at infinitely many addresses have no finite path of this kind. A proposed limiting process would require its own convergence and continuation relation. This result does not impose finite support on reality. It states exactly what that construction premise implies, without assuming a finite whole.

The quantity κ depends on the addressed decomposition. A permutation of addresses and independent bijections on their carriers preserve difference supports, so they preserve κ. An arbitrary encoding that mixes coordinates need not do so. It is not a physical energy, a duration or an entropy. Its direct use is sharper: to refute a claimed bounded-width rearrangement, prove that no path of that width fits the actual contact relation, including all its internal context changes. To establish actual attainability, bind a minimizing path to the medium's available constructions.

## Detail: §6d. Which independent blocks are forced?

### LQ15

**LQ15 (finite recombination determines a unique finest independent partition on fixed addresses).** Let I be a finite set of addresses and let R be a nonempty admitted family in ∏ᵢ Aᵢ. These are a set presentation of one fragment and its addressed distinctions, not an assumption that the whole has finitely many parts or that every logical environment is a product. For S⊆I, define the proposed splice

    c_S(x,y)ᵢ = xᵢ if i∈S, and yᵢ otherwise.

Call S a free cut when c_S(x,y)∈R for every x,y∈R. The test includes every admitted pair of descriptions. It does not assert that two such forms coexist or that their splice is an available physical operation.

**Free cuts determine each other by exact identities.** The empty and full cuts are free. Complementation exchanges the inputs: c_(I\S)(x,y)=c_S(y,x). If S and T are free, so is their intersection, because

    c_(S∩T)(x,y) = c_S(c_T(x,y),y).

Union follows by complementation. Thus the family C_R of free cuts is a Boolean subalgebra of the address subsets. This is an algebra of independently recombinable address masks. It does not assign Boolean truth values to every question in the medium.

For each address i, intersect all free cuts containing i. Since I is finite, this gives a smallest free block B_i. If j∈B_i, no free cut contains i without j. No free cut can contain j without i either, since its complement would separate them the other way. Thus i and j have the same membership in every free cut, and B_i=B_j. The distinct B_i are disjoint and cover I. Every free cut is a union of these blocks. Repeatedly splicing the finitely many blocks proves

    R = ∏_{B in P_R} π_B(R),

where P_R is the partition into the distinct B_i. Indeed, choose an admitted form realizing each proposed block value and splice the blocks into one admitted form. Conversely, every admitted form has those block values by projection. If R factors over any other partition P, each of its blocks is a free cut and hence a union of B_i. Therefore P_R is the unique finest product partition on these addresses. Any finer proposed separation inside one B_i fails the universal splice condition. An admitted pair x,y whose mixed form is forbidden is a positive obstruction to that proposed separation. An actual universal constructor proving splice closure can establish a free cut without enumerating the family.

The result excludes a choice between incompatible finest independent partitions once the addressed relation is fixed. It does not derive the addresses themselves. It also does not say that a coupled relation has no parts: the vacancy relation has meaningful addressed positions while its free-cut partition has only one block. An internal contact can be exactly what prevents independent recombination.

**The infinite extension fails without an additional premise.** On countably many binary addresses, let R consist of the sequences with finitely many ones. Every splice of two admitted sequences is admitted, for every S: its ones are contained in the finite union of the two source supports. Every finite partition gives a product factorization, because combining finitely many finite supports leaves finite support. Yet the product of the single-coordinate projections is the entire binary sequence space and contains the excluded all-one sequence.

There is no finest product partition in this example. Any partition into infinitely many nonempty blocks fails: choose one address per block, producing infinitely many ones while every block value occurs in an admitted finite-support sequence. Every partition into finitely many blocks can be refined by splitting an infinite block. Thus closure under all two-source splices does not imply unrestricted assembly of infinitely many separately possible choices. Neither absence of an outside nor successful finite assemblies supplies the missing premise.

**Finite-character admission supplies an infinite extension.** Suppose I may be infinite, but a proposed tuple belongs to R whenever each of its finite address restrictions occurs in an admitted form. This is an explicit completeness property of admission. Under it, C_R is closed under arbitrary intersections. For S=⋂_α S_α and any finite set F of addresses, finitely many S_α suffice to exclude every i∈F\S while retaining F∩S. Their finite-intersection splice belongs to R and agrees with c_S(x,y) on F. Finite-character admission therefore admits c_S(x,y).

The blocks B_i now exist as arbitrary intersections of free cuts. Their product again equals R: any finite restriction of a proposed assembly meets only finitely many blocks, which can be spliced from admitted representatives. The completeness premise admits the whole assembly. This proves the same unique finest partition without imposing a finite whole. In the finite-support counterexample every finite restriction of the all-one sequence is admitted, so this premise positively fails. The proof identifies the missing condition rather than inferring the impossibility of an infinite assembly from a finite check that did not perform it.

In this set presentation, finite-character admission is equivalently the condition that every excluded tuple has a finite forbidden restriction. It therefore states exactly when finite address evidence is complete for refuting a proposed assembly. The all-one sequence in the finite-support example has no such finite refutation. Completeness of finite refutations neither bounds their required size nor gives a terminating procedure for accepting every admitted infinite tuple. To establish a particular free cut, supply its universal splice construction; to refute one, supply an actual forbidden splice. The unique mathematical partition alone is not an acquisition procedure.

This completeness condition is sufficient for the finest-partition theorem, not necessary for every relation to have some finest partition. For example, add only the all-one sequence to the finite-support family. Any nonempty proper cut would have to admit both its indicator and its complement by splicing the all-one and all-zero sources. At least one of those indicators has infinite proper support and is excluded. Thus the only free cuts are empty and full, and the single whole block is the finest partition. The relation still excludes an alternating sequence while admitting all its finite restrictions. Having a forced inseparable block and having complete finite refutations are different properties.

An address permutation and independent changes of each carrier's notation transport P_R. An arbitrary encoding that mixes addresses can change what counts as a splice. For example, even parity on three bits is one inseparable block on its three original addresses, yet the bijection (a,b,a⊕b)↦(a,b) presents its four admitted forms as a product of two binary roles. Its inverse restores the constrained third coordinate. The encoding preserves the admitted forms but does not transport the original address roles as two independent coordinates. LQ12–LQ14 already require transport of the actual rearrangement relation for the same reason. The decomposition is forced by a relational presentation, not by its number of forms alone.

**A partition of jointly admitted roles requires a different law.** A free-cut block concerns independent recombination of values. To ask which roles belong together, fix instead a finite nonempty role set I and a downward-closed family K⊆𝒫(I) containing every singleton. A member of K is an admitted joint set for a specified relation. Downward closure means that selecting fewer roles from such a set preserves this admission. Neither a subject nor a partition is supplied. This premise concerns one finite presentation and does not bound the whole.

There is a partition P of I such that

    S∈K  iff  S⊆B for some B∈P

exactly when K satisfies the following overlap law:

    S,T∈K and S∩T≠∅  imply  S∪T∈K.

To prove necessity, intersecting admitted sets belong to the same partition block, which also admits their union. For sufficiency, every member of K lies in a maximal member because I is finite. Two maximal members cannot overlap: the law would admit their union, forcing both to equal it. The maximal members cover I because all singletons are admitted. They are consequently a partition, and downward closure supplies exactly all their subsets. Every partition with the displayed property has precisely these maximal members, so it is unique. This is a criterion for representation by disjoint regions, independent of the free-cut criterion above. Calling a relation connected does not supply its overlap law.

**One retained role can have a unique region even when there is no global partition.** Fix a∈I and form U(a)=⋃{S∈K:a∈S}. A unique maximal admitted set containing a exists exactly when U(a)∈K. If the maximal set is unique, every set containing a extends to it and their union equals it. In the reverse direction an admitted U(a) contains every such set and is their unique maximum. Downward closure also gives

    U(a)={a}∪{b∈I:{a,b}∈K}.

Thus pair contacts determine the candidate U(a), but the admission of that entire candidate is a further question. The family with maximal members {a,b} and {b,c} has unique regions through a and c and two maximal regions through b. It is closed under selecting fewer roles but fails the overlap law. The role retained in this question belongs to the same presentation. Its selection and its interpretation as a given occurrence have not been supplied by the theorem.

There is an exact positive obstruction to uniqueness through a: two admitted sets S,T containing a whose union is refused. A unique maximal region would have to contain both and hence admit their union by downward closure, a contradiction. Conversely, if uniqueness fails, choose two distinct maximal sets containing a. Their union is refused by maximality. Equivalently, failure of admission for U(a) has such an obstruction: build its finite union from admitted sets containing a, and take the first step whose union is refused. All earlier unions were admitted. Thus the finite criterion supplies both a sufficient complete region and a pair witnessing that no unique one exists. It does not require choosing one of the competing maximal regions.

**All pair contacts can survive while the proposed common region fails.** Let I={a,b,c} and K contain every proper subset of I. Every pair is admitted, but the triple is refused. The full family 𝒫(I) has exactly the same singleton and pair answers and does admit the triple. Therefore those answers cannot determine this joint-admission question on the two-source family. VI's factorization criterion gives the obstruction directly. For any n≥3, all proper subsets of an n-role set likewise agree between 𝒫(I) and 𝒫(I)\{I}, while the full-set answer differs. In the latter family I\{a} and I\{b} overlap for a≠b and their union is forbidden, explicitly violating the overlap law. No fixed bound on the size of inspected subsets settles every such question.

**Joint assembly has an exact symmetric composition.** On any such K, define μ(S,T)=S∪T exactly when S∪T∈K. It is idempotent and commutative. Both μ(μ(S,T),U) and μ(S,μ(T,U)) are defined exactly when S∪T∪U∈K, by downward closure, and then give that same union. Thus rebracketing preserves availability as well as the result, even when K has a refused triple with every pair admitted. Associativity and commutativity do not force a partition of jointly admitted roles. This operation is different from LQ16's retention of one specified input role: with S={a}, T={b}, Z={a} and {a,b} admitted, μ(μ(S,T),Z)={a,b}, while μ(S,Z)={a}. The first absorption law fails at an admitted contact.

**Contact-profile intersection has a precise completeness premise.** For S∈K, let N_K(S)={U∈K:S∪U∈K}. Whenever S∪T∈K, downward closure gives N_K(S∪T)⊆N_K(S)∩N_K(T). In the proper-subset family on {a,b,c}, the singleton {c} belongs to N_K({a}) and N_K({b}) but not to N_K({a,b}). The combined form has an additional refusal which the separate contacts omit.

For finite I the inclusion is equality at every admitted S∪T exactly when K is determined by its pair admissions: every set whose pairs are admitted is itself admitted. To prove sufficiency, if S∪T, S∪U and T∪U are admitted, every pair in S∪T∪U is admitted, so the whole union is admitted. This gives the reverse inclusion of profiles. For necessity, suppose pair admission is incomplete and choose an inclusion-minimal refused set F all of whose pairs are admitted. Every proper subset of F is admitted and |F|≥3. Partition F into three nonempty sets S,T,U. Their pair unions are proper subsets and hence admitted, while the triple union F is refused. Thus U belongs to both separate profiles but not the profile of S∪T, a contradiction. The proof names exactly the additional relation hidden by an unsupported intersection rule.

Conjunction of predicates on one fixed complete domain still has intersection as its truth set. The failed equality here concerns the compatibility profile of a constructed joint form. Treating that profile as the conjunction of the two separate profiles omits the possible extra constraint among all three participating sets. The medium supplies the construction relation needed to justify that identification.

A partition requires still more. The family with maximal sets {a,b} and {b,c} is determined by its pair admissions and obeys this profile-intersection equality, yet overlapping admitted sets can have a refused union. A classification that represents joint admission solely by equality of one region label must obey the stronger overlap law. Admission of {a,b} and {b,c} would force all three labels to agree and incorrectly admit their joint set. GluedEqualities already supplies the underlying equality composition in bare Swift. Richer constraints can retain the refusal, but change the representation from one partition to a more general joint relation. This is not an obstruction to VI's Pair constructor, as VC23a explains for parity.

Finiteness is material if the claim concerns complete admitted regions. On an infinite I, the family of all finite subsets satisfies downward closure and the overlap law and contains all singletons, but has no maximal member. It cannot be all subsets of partition blocks: admission of every pair would force a single block I, which is not admitted. A declared closure under the relevant infinite unions would be an additional premise. This parallels the earlier finite-character boundary without asserting that every episode or every support is finite.

**Forgetting the occurrence changes the boundary question.** Suppose an indexed description supplies role sets B_w for internal occurrences w. Here B_w records the complete membership assigned to that occurrence. Its completeness is part of this description, not derived from a label. Forgetting w leaves the admission family

    K={S⊆I : S⊆B_w for some w}.

This projection is downward closed. For a role a that occurs in it, its possible companions are

    U(a)=⋃{B_w : a∈B_w}.

The projected K has a greatest a-region exactly when some B_w contains U(a). Since that B_w contains a, it must then equal U(a). This asks whether one occurrence includes every companion supplied across those occurrences. It does not ask whether each individual B_w has a complete membership. Take distinct roles a,b,c and two occurrences g,h, with B_g={a,b} and B_h={a,c}. Both indexed sets are complete, yet K has no greatest a-region: it admits {a,b} and {a,c} and refuses {b,c}. Even a shared role a does not identify g with h.

The distinction applies on any nonempty I. Every downward-closed K containing the singletons has a presentation of the displayed form: take one index w_S for each nonempty S∈K and set B_{w_S}=S. If a nonempty T is contained in one of these sets, downward closure gives T∈K. Conversely w_T supplies it. The empty set is present on both sides because I is nonempty. Thus a K failing the overlap law can still be the projection of individually specified complete sets. Duplicating an index with the same membership changes none of K either. K alone therefore does not determine the identity or multiplicity of its indexed occurrences. These are counterdescriptions to reconstruction from this projection. They do not establish which arrangements can be experienced.

If each role is instead required to belong to exactly one indexed occurrence, the nonempty B_w are disjoint and their projection satisfies the partition law. Unique occurrence membership is the extra requirement doing that work. An overlap refusal cannot be used to refute the unity of the original given G after G's occurrence correspondence has been erased. Conversely, naming all roles incident to g as a set does not establish that our record covers that set, or that mere membership captures the experienced joint relation. Those remain source obligations. VC84's sufficient input interfaces answer a further question and need not be these regions.

**Partial evidence can settle a boundary question without supplying K.** Now allow I to be any nonempty set, and retain a∈I. A greatest region through a means an admitted B containing every admitted set through a. For finite I this is equivalent to a unique maximal region. On an infinite carrier those two questions must be distinguished.

Let P₊ contain certified admitted sets and P₋ contain certified refused sets for the same joint relation and the same addressed roles. Define

    L = {S⊆I: |S|≤1 or S⊆P for some P∈P₊},
    U = {S⊆I: no N∈P₋ satisfies N⊆S}.

Assume L⊆U, so the supplied answers are consistent with downward closure and admitted singletons. The compatible descriptions are exactly the downward-closed K with L⊆K⊆U. An unobserved set has not thereby been refused. These K are alternative descriptions of the relation being investigated, not additional realities outside the whole.

Put A=⋃{S∈L:a∈S} and C={z∈I:{a,z}∈U}. A contains the mandatory companions, and C the possible companions, with A⊆C. The exact family of boundaries that can be the greatest a-region in a compatible description is

    ℬ = {B∈U: A⊆B}.

Necessity follows because a greatest region must contain every certified set through a and must itself be admissible. Conversely, for any displayed B, construct K_B=L∪𝒫(B). It is downward closed, remains inside U, and contains all supplied positive answers. Every one of its members containing a lies inside B, since those from L lie inside A. Hence B is its greatest a-region. This proves the exact family without completing every unknown admission answer.

It follows that no compatible description has such a region exactly when A∉U, equivalently when some certified refused N is contained in A. Otherwise K_A supplies a compatible description with greatest region A. The construction establishes what the data permit. It does not certify K_A as the actual relation.

There is also an exact criterion for when every compatible description has a greatest a-region:

    C∈L  or  |C|≤2.

If C∈L, it is admitted in every K and contains every possible companion, so it is always the greatest region. If |C|≤2, the only possible sets through a are {a} and possibly one pair, and a greatest member always exists. For necessity, first consider K=L. It has a greatest a-region only if A∈L. If C=A, this gives C∈L. Otherwise choose b∈C\A. When A contains x≠a, the compatible description L∪𝒫({a,b}) has both A and {a,b}, but no admitted set containing their union: such a set belongs neither to L nor to 𝒫({a,b}). When A={a} and |C|≥3, choose distinct b,c∈C\{a} and use L∪𝒫({a,b})∪𝒫({a,c}). It likewise has no greatest a-region. These constructions apply to infinite I as well.

Thus the partial data force absence exactly when A∉U, force existence exactly under the displayed condition, and otherwise admit explicit descriptions giving opposite answers. To force the same particular boundary in every description requires C∈L, and that boundary is C. Indeed any such boundary must equal A in L and contain each possible companion b in L∪𝒫({a,b}), so A=C∈L. Knowing that a boundary exists can therefore require less than identifying it. With I={a,b} and only singleton answers supplied, a greatest a-region always exists but can be {a} or {a,b}. This is VC15's distinction between an invariant answer and selection applied to the boundary question.

**A finite refusal can survive every enlargement of the described carrier.** The absence criterion has a direct certificate: retain one refused set N and, for each n∈N, an admitted contact {a,n}. Any greatest a-region would contain every n, hence N, contradicting downward closure. If N is finite, this certificate uses finitely many actual answers. It remains a refutation in every larger, possibly infinite, carrier preserving those contacts, that refusal and the same relation. New internal roles cannot repair the contradiction. No complete enumeration of K, maximal regions or hidden roles is required.

For example, {a,b} and {a,c} can be admitted while {b,c} is refused. A purported greatest region through a must then include a,b,c and would admit the refused pair. More generally, one higher-order refusal can be covered by many separately admitted contacts through a. The certificate need not include two already certified large sets whose union is explicitly refused. This is an application of downward closure, not a claim that every infinite failure has a finite certificate: all finite subsets of an infinite carrier admit every finite test and still have no greatest region.

**Positive closure needs a different obligation.** Suppose a description on I does have a greatest a-region B. Add a previously unrepresented internal role z and define K′=K∪𝒫({a,z}). Every old admission and refusal on I is unchanged, but B is no longer greatest. If B contains b≠a, B and {a,z} have no admitted common extension. If B={a}, the new greatest region is {a,z}. Thus even complete knowledge of the old relation does not establish its coverage of all relevant internal roles. A positive certificate for B consists of its admission together with the universal boundary relation {a,z}∈K ⇒ z∈B. A structural derivation of that relation can suffice without enumerating z. Closure of the physical whole supplies no missing coverage claim for a particular description of it.

Finally, the infinite maximality distinction has an explicit counterexample. On I={a,b}∪{c₀,c₁,…}, take K=𝒫({a,b}) together with every finite subset of {a,c₀,c₁,…}. Its only maximal member is {a,b}, since every member of the other family can gain another cᵢ. Yet {a,c₀} is admitted and has no extension into that maximal member. There is no greatest a-region. The finite refusal above excludes a region containing all compatible companions, while uniqueness of an unextendable member alone can survive. Using the latter as a complete boundary would leave an entire admitted direction unaccounted for.

These certificates concern actual answers to one stated joint-admission question. A failed measurement, an absent declaration or a change of context is not automatically a refused set for that relation. Its roles may be situated inside the whole while their correspondence to an experienced episode remains to be established. The improvement is an exact account of which partial data already settle the structural question and which coverage premise a positive boundary still needs.

## Cross-page mentions

Labels mentioned here: <doc:learning_is_liquid__medium_contacts#LQ12>, <doc:learning_is_liquid__medium_contacts#LQ13>, <doc:learning_is_liquid__reconstructed_sides#LQ16>, <doc:verdict_is_invariant__finite_records#VC15>, <doc:verdict_is_invariant__recovery_memory#VC23a>, <doc:verdict_is_invariant__relative_questions#VC84>.

Mentions of this page’s labels: <doc:interference_is_substitution__models_calibration> (LQ15), <doc:learning_is_liquid> (LQ14), <doc:learning_is_liquid> (LQ15), <doc:learning_is_liquid__atoms_continuations> (LQ15), <doc:learning_is_liquid__medium_contacts> (LQ15), <doc:learning_is_liquid__reconstructed_sides> (LQ15), <doc:permanence_is_resistance__cost> (LQ15), <doc:permanence_is_resistance__recovery_remainder> (LQ14), <doc:permanence_is_resistance__recovery_remainder> (LQ15), <doc:verdict_is_invariant__finite_records> (LQ14), <doc:verdict_is_invariant__finite_records> (LQ15), <doc:verdict_is_invariant__recovery_memory> (LQ15).
