# Verdict Is Invariant (Correspondence) — Bounded calibration

This part contains the original derivations for bounded calibration.

Family and original section headings: <doc:verdict_is_invariant>.

Section setting: <doc:verdict_is_invariant#6zzd-Available-interventions-constrain-the-hidden-carrier>.

## Detail: §6zzq. What a finite passing experiment cannot establish

### VC107

**VC107 (no unrestricted finite positive calibration test).** Suppose the unknown source is accessed through its five-stage reading E, the four involutive contacts A_i, and an autonomous selected U. The interface may also report which contact U actually selected. No capacity bound or complete contact definition is supplied. For every finite operation budget N there are two finite realizations agreeing on every such experiment of length at most N from their corresponding prepared sources, although only one is completely calibrated. Every A_i and U can be an involution in both.

*Construction.* The reference is the five bare stages, A_i=t_i and U=t₀. For the alternative put D=3(N+1), M=2D+1 and K=V×Z_M. Read E(v,p)=v, prepare (v,0) for each stage v, and use

    A₀(v,p)=(t₀(v),p),       A₁(v,p)=(t₁(v),p),
    A₂(v,p)=(t₂(v),−p),      A₃(v,p)=(t₃(v),1−p),

with phase arithmetic modulo M. Each is a total involution with the required exact stage action. Set U=A₁ at phase D and U=A₀ everywhere else. Both choices preserve phase, so U is also a total involution. This is one fixed internal selection rule, not a later change of law or an external clock.

After at most N operations from phase zero, the phase has an integer representative z with |z|≤N. Inductively each operation keeps z, negates it, or replaces it by 1−z. Since D>N and M−D>N, no such phase is D. Every encountered U therefore selects A₀, exactly as in the reference. The stage action of every specified A_i is also the same. Thus all acquired stage readings and selected addresses agree. Adaptation based on those acquired values chooses the same next contact in both realizations. Restoring one of the supplied preparations (v,0) does not create a difference within this budget either.

Yet R=(A₁A₃)³ returns every stage and sends phase zero to one. The performed product A₂A₃ increments phase by one. Let H=(A₂A₃)^D. Its stage action is identity because D is divisible by three. From (★,0), H reaches (★,D), where U reads leaf one. From R(★,0), the same H reaches (★,D+1), where U reads leaf zero. One of the six short return words thus changes a continuation profile. The alternative, with only 5M states, is not completely calibrated. ∎

In particular, an observation-only procedure cannot finitely accept the reference as completely calibrated and remain sound over this unrestricted class. Take N to be its stopping budget on the reference. The constructed alternative yields the same acquired transcript and therefore the same acceptance, while violating the asserted property. This obstruction uses finite carriers throughout; no inaccessible infinite universe is needed.

The access restriction is substantive. An instrument reading another internal relation, a certified bound on the relevant carrier, or a faithfully supplied definition of the complete contacts changes the evidence. A static proof from such a definition is not a finite experiment using only E and the reported addresses. Conversely, naming an uninspected definition does not add that stronger reading. VC107 identifies a missing relation in the proposed positive certificate, while VC104 still supplies a finite negative witness when its observed residence occurs.

### VC107a

**VC107a (the exact first distinguishing experiment in this family).** In VC107's alternative let D≥3 be divisible by three and M=2D+1. With its five supplied preparations (v,0), stage readings and selected-address reports attached to performed U steps, the minimum distinguishing operation count is exactly 2D.

*Proof.* The two phase reflections form the path

    0, 1, −1, 2, −2, …, D, −D       modulo 2D+1.

These are all M different phases. Negation joins k with −k and fixes zero; the other reflection joins −k with k+1 and fixes −D. Thus phase D lies at distance 2D−1 from the prepared phase zero. The remaining operations preserve phase. Until U is performed at phase D, all U choices and all stage effects agree with the reference. No experiment of at most 2D−1 operations can include such a U, even with adaptive choices or repeated supplied preparations.

For sufficiency perform S=(A₃A₂)^(D−1)A₃ from prepared leaf two. It has length 2D−1 and reaches phase D. Since D is divisible by three, its stage action is (t₃t₂)²t₃=t₂. It therefore reaches center. The following U reads leaf zero in the reference and leaf one in the alternative. This distinguishes them at operation 2D, using stage readings alone. ∎

The phase path uses the same two alternating matchings as the finite `AlternatingPhaseLine` witness. The internal switching condition, not an outside clock, places the difference at this distance. For D=3·2^k the binary parameter D has k+2 bits while the experiment requires 6·2^k contacts. The proof remains one parametric argument; it does not execute those contacts or enumerate their carrier. This separates a supplied structural proof from observation through the stated instrument. It is not a measured complexity claim about the compiler. Access to the actual defining relations is the additional evidence that makes that proof applicable.

## Detail: §6zzr. A supplied bound makes positive calibration finite

### VC108

**VC108 (complete finite test on a bounded continuation scope).** Retain VC101's onto five-stage reading and total stage lifts A₀,…,A₃, without yet assuming that their source actions are involutions. Let an autonomous U select one actual A_i at each source. Prepare q₀ over center. Let Q be the quotient of its contact orbit by equality of all future E answers under {A_i,U}. Suppose an independently established bound |Q|≤n is supplied, with n≥5. Then complete endpoint calibration on Q is equivalent to the following finite family of equalities:

    E(s(h(q₀))) = E(s(R(h(q₀))))

for every contact word h of length at most n−4, every continuation s in {A_i,U} of length at most n−5, and each R in this ten-word family: the four squares A_iA_i and VC101's six return words. If the A_i are already known to induce involutions on Q, the four square tests can be omitted. Each modified trial uses at most 2n−1 primitive operations from q₀. This is a sufficient test horizon, not a claim of minimum trial length or minimum number of queries. The claim concerns this reachable continuation scope; it does not certify unrelated orbits or equality of hidden sources.

*Proof.* Equality of all future readings is a congruence for each admitted operation. The A_i therefore descend as total maps to Q. A U step is one of their edges, so adding U does not enlarge the contact orbit. The first contact layer from q₀ contains its four leaf neighbors, all with different E answers from one another and from q₀. Thus five profiles are reached at depth one. Each further nonempty breadth layer contains at least one new profile; an empty layer closes the orbit. Every profile is consequently reached by a contact word of length at most |Q|−4≤n−4.

Partition Q first by E, obtaining five nonempty classes. At each refinement compare both the current class and successor classes under every admitted operation. After k refinements, equality means agreement on all E readings after words of length at most k. If a step adds no class, the partition is already a congruence and no later refinement can split it. Each strict step adds at least one class. Because distinct members of Q have a distinguishing continuation by definition, at most |Q|−5≤n−5 strict steps make the partition discrete. Any two different profiles therefore separate within that horizon.

Assume the displayed tests pass. For any q∈Q choose a permitted h reaching it. Agreement for every tested s forces R(q)=q by bounded separation. Thus all ten words act identically on every profile. The four squares make the induced A_i involutions; VC101's remaining six give complete endpoint calibration. Conversely that calibration makes every displayed equality hold. The longest return word has eight contacts, so the modified trial length is at most (n−4)+8+(n−5)=2n−1. ∎

The unmodified comparison uses at most 2n−9 operations. These bounds count target operations, not the cost of reading, recording, selecting experiments or returning the target for another trial. Enumerating all words within the two bounds is finite but can require exponentially many trials. An already acquired presentation of preparations and separating continuations may replace that enumeration; its coverage then becomes the supplied relation.

**Returning without erasing the experiment.** Repeated preparation need not mean an unexplained reset. Suppose the experiment can acquire the actual chosen address of every U step, and the same A_i involutions remain applicable throughout. Commanded A_i addresses are already specified. After reading a trial's answer, apply its recorded contacts in reverse order. VC106 gives a return of the actual target to its preparation, while the record and controller retain what happened. Applying U backwards is unnecessary, and applying U again would in general choose another contact.

This construction uses a finite prepared recording and control arrangement; it does not infer such an instrument from a list of observations. The return argument also uses the involution relation it was given. It cannot silently be used to test that same relation from scratch. Testing all ten equations of VC101b would require an independently justified return or preparation arrangement. Replacing the contact catalogue between a step and its proposed inverse fails exactly as the internal exchange in VC106.

For these repeated E questions, an actual whole-source return is stronger than necessary. If the induced A_i on Q are known involutions, reversing the acquired address word restores the same profile. The instruments must preserve that profile or provide their own justified restoration; a passing prefix alone does not establish this. Questions about the complete returned history can still differ.

For example, enlarge any model of the original involutions to K×I*, where I* is the set of finite words of contact indices, and set

    A_i′(x,h)=(A_i(x),h appended i),
    U′(x,h)=(U(x),h appended a(x)),       U(x)=A_(a(x))(x).

Read only the original E(x). Projection to K intertwines every admitted target continuation, and every old distinguishing word still distinguishes. The new continuation quotient is therefore exactly the old Q. The enlarged contacts are injective and retain their sources, but no nonempty word returns the full history. Replaying reversed addresses restores x while appending the return occurrences too. This is a retaining realization on a supplied history carrier, not an inference of freely available physical storage. Adding a contact that uses this history may split the quotient; the stated bound concerns the original target questions and operation vocabulary.

**The bound need not count the hidden carrier.** VC12 already supplies a structural way to establish the required bound. Suppose a reading F of the actual source has at most n images, E=e∘F, and every admitted operation T has a supplied image operation T̄ satisfying F∘T=T̄∘F on the entire reachable scope. Induction shows that equal F images have every future E answer equal. Hence F refines Q and |Q|≤|F(K)|≤n, even for an infinite K. F need not itself be the coarsest such reading. These are the existing commuting relations, not a new label declaring a representation complete.

Checking all ten returning words as identities on F is sufficient for their identity on Q; the four squares can again be omitted if the induced involutions are already known. A failed identity on F, however, need not fail on Q: F may retain additional distinctions. For example, use the first two-phase assignment of VC101a and take U=A₀ always. The phase makes one cubic return nonidentity on the ten-element stage/phase image. Yet E alone is already closed under every A_i and this fixed U. There are just five continuation profiles and calibration on those profiles holds. An E separator is required before turning that richer-image failure into a failure of the stated future question.

The bounded experiments above test Q directly. Their evidence differs from that of a faithful definition with generic commuting proofs: the latter can provide the bound structurally, while finite E samples alone do not establish those universal equations. VC107 excludes obtaining the missing bound by extending a passing prefix. Together the results distinguish finite falsification, finite testing under a justified bound, and static proof from a supplied presentation.

There is a tempting circular shortcut. Complete calibration makes this contact orbit an S₅ orbit, so a calibrated Q has at most 120 members. It does not follow that an unknown candidate may be tested with n=120. That bound excludes some of the very alternatives under investigation and must hold for the actual candidate independently of the conclusion. VC107's uncalibrated alternatives can pass an arbitrarily long finite prefix. The six short algebraic equations form a finite presentation of the law; they are not six finite observations certifying their own universal scope. A short returning word can have an arbitrarily delayed observable effect.

`FourLeafProfileScope.swift` supplies the last route for the existing twenty-profile model. `LocalStagePhaseImage` is built from the actual stage and phase projections. `FourLeafPrimitiveProfiles` derives equality of all four subsequent images across arbitrary contexts K,L and arbitrary symbolic phase labels. `FourLeafControlProfiles` derives the same equality for the four admitted one-hot selection clauses, including their selected addresses. Both clauses carry the same resident program. With one-hot stage and phase preparations, the image has at most 5×4 members; the earlier source coverage and distinguishing readings give all twenty. The arbitrary retained context is not counted as twenty states or assumed finite.

The context need not remain fixed. `LocalContextExchange` exchanges two fields behind the retained program and derives the same image. Its use can be interleaved with the admitted contacts. In contrast, the separate reserve contact in `Checks/FourLeafProfileScope.swift` exchanges the active phase with a reserved one. It is itself an involution, retains both fields and the program, and has a reading constructed from their actual addresses. Two sources with the same old image then reach different active phases. Their next U applications use the actual exchanged roots and expose different stages. The proposed equality is refused. This is a change of the admitted contact scope, not a failure of the original generic proof or evidence that the unchanged context was absent from the whole.

## Detail: §6zzs. The residence argument depends on the observed action, not the star

### VC109

**VC109 (a finite observed action forces an aliased pair of paths).** Let E:K→V be an onto reading with finite V. Each admitted contact A_i is a total map with a specified total observed action t_i:V→V satisfying E∘A_i=t_i∘E. Let U be one fixed total map that selects an actual A_i at each source. Fix v∈V. Let M_v consist of the distinct maps generated by the t_i that individually fix v, including the empty word, and put d=|M_v|.

If a U trajectory has d+1 consecutive readings v followed by a different reading, two contact words of length at most d have the same complete observed map but different continuation effects from the same preparation. Thus the complete observed contact action does not determine the action needed for all future E questions. Neither source reversibility nor a finite source carrier is needed for this conclusion.

*Proof.* Name the equal-reading sources q₀,…,q_d and the exit q_(d+1). Let w_j be the actual contact prefix taking q₀ to q_j, with w₀ empty, and let p_j be its complete observed map. Every contact in these prefixes fixes v because both its actual endpoint readings are v. The d+1 maps p₀,…,p_d lie in M_v. Hence p_i=p_j for some i<j.

Their full source effects need not be compared through inaccessible state equality. Put k=d+1−j. Then U^k(q_j)=q_(d+1), whose reading differs from v, whereas U^k(q_i)=q_(i+k) still reads v, since i+k<d+1. The same admitted continuation separates w_i(q₀) and w_j(q₀). This is a witnessed failure of factorization through the complete observed contact map. ∎

Both distinguishing continuations occur as segments of the original trajectory. No additional return to a past source is required to infer this existence statement. Identifying the particular aliased contact words also requires their actual selected addresses; the sequence of stage answers alone need not supply them. The common, autonomous U relation ties the two continuations. A changing controller omitted from the declared source does not supply that relation.

**Visible inverses turn the pair into one returning word.** If all t_i are permutations, M_v is the group H_v generated by those contacts fixing v. Write w_j as w_i followed by its actual intervening word B. Cancelling p_i=p_j in the observed permutation group shows that B acts identically on all V. From q_i it reaches q_j, and U^k distinguishes its effect. Here |B|≤d, preparation length i≤d−1 and separator length k≤d. This step still does not require A_i to be invertible: only the observed maps were cancelled. Involutive source contacts additionally forbid certain shorter returns, as used in VC104a's six-contact lower bound.

For m=|V| there are m^(m−1) total maps fixing v, so d is at most that number. For permutations d≤(m−1)!. The particular admitted maps can give a smaller bound. In the four-leaf star, the three individually fixing contacts generate the full permutation group of the other four stages. Thus d=24 and this argument recovers VC104a before its sharper short-word analysis. The number twenty-four comes from this declared action, not a universal physical scale.

If complete calibration does hold on the relevant source or continuation quotient, it gives another description of the same limit. With permutation images it defines an action of their generated group G: a positive word for each inverse exists because every observed permutation has finite order. Calibration with the empty word then supplies inverse actions on the scope where it is asserted. A contact orbit has at most |G| members, and the profiles over v in that orbit have at most |G_v| members. An uninterrupted residence uses only H_v≤G_v, explaining why its more specific bound may be smaller. Unreachable copies and distinctions outside the admitted future questions do not enlarge this orbit.

The two-path conclusion is more general than a return criterion. With noninvertible observed maps, equal prefixes cannot in general be cancelled. For example, contacts whose observed maps are the two constants on {0,1} have no nonempty word with observed identity. An explicit retaining source is K={0,1}×({0,1}×{0,1})*, where the second field h is a finite internal history. Set E(v,h)=v and

    A_b(v,h) = (b, h appended with (v,b)),       b∈{0,1}.

Every A_b is injective: its appended pair retains v and its preceding history is still present. Select U=A₀ when |h|<2 and U=A₁ otherwise. From (0,empty) the readings are 0,0,0,1. The prefixes A₀ and A₀A₀ have the same complete observed map, the constant zero. Their next U readings are respectively zero and one. Every nonempty contact word has a constant observed map, so no such word is observed identity. The different paths remain consequential without a returning observed word or any loss from the complete source. The contacts have inverses on their images; they are not asserted to be onto this entire history carrier. Its internal record length controls the choice, without an outside clock.

Finally, U has not been assumed to possess a fixed map on V. It selects an actual contact using the source. If E∘U=u∘E for a fixed u were also supplied, two equal readings followed later by exit would already be impossible: u(v)=v would keep every subsequent reading v. The residence therefore probes distinctions available to the internal chooser and omitted by E. VC109 asks the stronger question of when even the full observed *contact action* is insufficient for those future choices.

## Cross-page mentions

Labels mentioned here: <doc:verdict_is_invariant__calibration_residence#VC101>, <doc:verdict_is_invariant__calibration_residence#VC101a>, <doc:verdict_is_invariant__calibration_residence#VC101b>, <doc:verdict_is_invariant__calibration_residence#VC104>, <doc:verdict_is_invariant__calibration_residence#VC104a>, <doc:verdict_is_invariant__calibration_residence#VC106>, <doc:verdict_is_invariant__finite_records#VC12>.

Mentions of this page’s labels: <doc:learning_is_liquid__reconstructed_sides> (VC107), <doc:permanence_is_resistance__contact_rigidity> (VC107), <doc:permanence_is_resistance__forced_answers> (VC107), <doc:permanence_is_resistance__forced_answers> (VC108), <doc:permanence_is_resistance__frame_acquisition> (VC107).
