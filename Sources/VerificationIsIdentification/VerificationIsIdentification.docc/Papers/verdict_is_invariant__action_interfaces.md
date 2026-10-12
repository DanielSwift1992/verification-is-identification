# Verdict Is Invariant (Correspondence) — Action interfaces

This part contains the original derivations for action interfaces.

Family and original section headings: <doc:verdict_is_invariant>.

Section setting: <doc:verdict_is_invariant#6zzd-Available-interventions-constrain-the-hidden-carrier>.

Required setting: VC100f uses the four-phase catalogue and its full setting. <doc:verdict_is_invariant__four_phase_catalogue#VC100a>, <doc:verdict_is_invariant__four_phase_catalogue#VC100b>, <doc:verdict_is_invariant__four_phase_catalogue#VC100c>, <doc:verdict_is_invariant__four_phase_catalogue#VC100d>, <doc:verdict_is_invariant__four_phase_catalogue#VC100e>, <doc:verdict_is_invariant#6zzj-Twelve-actual-words-supply-the-complete-four-phase-ambiguity>.

### VC100f

**VC100f (a common relation can be transported while the law changes).** The fixed-law condition in these query results has a relational extension. At the t-th contact, suppose the actual law is related to a reference law by

    τ_t = β_t ∘ τ₀ ∘ α_t,

where the input and output permutations α_t,β_t, their inverses and this relation are available through the supplied construction. A current point reply τ_t(i)=z is then exactly the reference reply

    τ₀(α_t(i)) = β_t⁻¹(z).

The physical input and output names need not remain fixed. Count distinct normalized inputs α_t(i), rather than raw input names i alone. To carry over the exact acquisition bounds, the transports and their inverses must be usable without further unknown-law contacts, and their available contents must be determined by the supplied context and the already counted query history. They may adapt to that history but may not introduce an additional distinction between laws agreeing on it.

*Proof.* Apply β_t⁻¹ to the defining relation at i. Conversely, to ask reference input a, ask current input α_t⁻¹(a) and decode the reply by β_t⁻¹. Each direction uses one point contact and the supplied transports. Thus, under the stated information and access conditions, the corresponding inquiry trees simulate each other with the same number of such contacts. Their coordinate changes supply no additional unknown-law evidence. ∎

For a final current payload x_t, the reference payload is x₀(a)=x_t(α_t⁻¹(a)); the reference output is then relabelled by β_t. The conditional acquisition bound of VC100d applies to this pulled-back payload on the normalized unread inputs. VC100e applies if successive questions refine in these reference coordinates. Refinement of raw labels alone does not establish that relation when their input coordinates move. For arbitrary successive questions, bundle their pulled-back values and use VC100e's joint-question benchmark instead.

The construction which supplies the transports is substantive. An arbitrary replacement law does not become known on the basis that some α_t,β_t could relate it to τ₀. The earlier mixed-history counterexample omits that transport from its accessible evidence and remains a counterexample.

Nor is an informative coordinate map free acquisition. For a direct counterexample choose α=τ₀⁻¹ and β=id, so the current law is id. If the complete α table is supplied, it already identifies τ₀ before any further point query. The normalization equation is still true, but VC100d's lower bound based only on the old point transcript no longer applies. If α is instead only another unknown oracle, using its inverse to prepare a coordinate can itself require a counted contact. More generally, exact VC100d counts require that the accessible normalized evidence leaves all parity-compatible completions of the recorded point images. A transport that further restricts them changes that acquisition problem.

`KnownPhaseLawTransport<A,B,C,D>` supplies a concrete generic instance using the existing phase word's actual W change

    (A,B,C,D) → (D,B,A,C).

Its independently specified current question reads input 2, whose answer is A. Its observation contains only the old point-0 fact and the input transport obtained by applying the same W action to four coordinate labels. That map sends current input 2 to old input 0. The decoder reads the old fact under precisely this address relation; the factor derives agreement with the actual current source for arbitrary A,B,C,D. The old recorded question remains point 0. The new reading supplies its current applicability. The displayed path records that one original reply, performs W beside its retained fact, and carries the supplied transport beside the resulting source. It performs no second measurement of the law. The direct current point-2 reading specifies the target question; the decoder obtains its answer from the retained point-0 fact and its transport. Here the coordinate map is the same fixed W action on four supplied labels for every A,B,C,D; it carries no extra information about the unknown table.

This example also shows why counting raw addresses fails. Reading input 0 before W and input 2 after W reads the same reference input twice. Initial even laws (0,1,2,3) and (0,2,3,1) give identical complete records for those two questions, while their current laws after W differ. Reading input 1 after W instead supplies reference input 1 and completes the two-image calibration. Even repeating raw input 0 after W supplies a different reference input, namely 3. The coordinate relation determines whether the contact adds an independent image of the unknown law.

### VC100g

**VC100g (two actions determine an intrinsic four-point frame).** There is also a way to acquire the correspondence required for combining questions. Let K have four distinct points. Supply two directed bijections W,Z on K, where W has one three-cycle and one fixed point, and Z exchanges two disjoint pairs. These are the action shapes of the existing phase generators. Define the roles

    b = the unique fixed point of W,
    a = Z(b),    c = W(a),    d = W(c).

They are four distinct points, and their complete actions are forced:

    W: a→c→d→a, b→b;
    Z: a↔b, c↔d.

Indeed Z has no fixed point, so a differs from b and belongs to W's three-cycle. W therefore supplies its other two members c,d. Since Z exchanges a,b, its remaining exchange must pair c,d. No input point was chosen as a distinguished origin in this definition. Under any renaming of K, the same expressions produce the renamed roles.

For two such systems with corresponding W and Z actions, matching these four roles gives an isomorphism of both actions, and it is the only one. Any intertwining bijection must preserve W's unique fixed point and then its images under Z,W,W. W alone leaves three possible cyclic alignments of its other points. The second action removes exactly that ambiguity. Which actions correspond remains part of the compared signature; knowing that two systems generate an abstractly isomorphic group does not identify their individual contacts or physical occurrences.

The entire frame has exact worst-case acquisition cost **three point queries**, each asking W(i) or Z(i), when the four point identities and the stated action class are available. Start at any accessible point i.

* Read j=W(i). If j=i, then b=i. Read a=Z(i), then c=W(a); the remaining point is d.
* If j≠i, read k=W(j). The directed three-cycle is i→j→k→i; its remaining point is b. Read a=Z(b), then obtain c,d from that already known cycle.

Both branches use two W replies and one Z reply. The starting point affects their order, not the final frame. There are eight possible W three-cycles and three possible Z pairings, hence 24 distinct frames on four named ports. Each single W point reply leaves exactly two possible W actions; reading Z does not distinguish them. Conversely, any W history still permits all three Z pairings until Z is read. Thus every successful transcript requires at least two W queries and one Z query. The algorithm attains both lower bounds on every branch. This counts the stated point queries, with their preparations and macro execution supplied by that instrument; the action-type premises come from the supplied construction or an independently justified calibration.

This is a mathematical frame construction from the established W,Z actions. The earlier resident two-probe pipeline does not implement this new adaptive three-query procedure; its query count and algorithm are established here by the displayed argument.

### VC100h

**VC100h (a unique frame need not give compatible joint actions).** The frame part of VC100g needs less than its full action premise. If W has one three-cycle and the unique fixed point b, any second bijection Q satisfying Q(b)≠b defines four distinct roles

    a=Q(b),    c=W(a),    d=W(c),    b=Fix(W).

Every bijection intertwining two such pairs must match these roles. Consequently there is at most one candidate correspondence. This does not yet show that it intertwines Q on the other three points. VC100g's two-exchange premise forced those remaining rows; the weaker premise does not.

The distinction survives even when both individual action shapes are fixed. On the same four roles take the directed cycles

    W=(a c d),    Q₁=(b a c),    Q₂=(b a d).

Each action has order three and one fixed point. Both pairs (W,Q₁) and (W,Q₂) produce the very same intrinsic roles above: W fixes b, both Q actions take b to a, and W then takes a to c to d. Yet their joint actions are incompatible. Writing W∘Q for performing Q and then W gives

    W∘Q₁=(a d)(b c),    W∘Q₂=(b c d).

The first has order two, the second order three. If a common bijection intertwined both corresponding actions, it would intertwine every composite word and preserve its order. These two periods contradict that requirement. No relabelling of the four points repairs it.

There is also a direct distinguishing preparation. Start at b, selected as W's unique fixed point. One joint step reaches c in both systems. After the second joint step, the first system is back at b and the second is at d. Thus identical individual periods, the same acquired frame and even the same first joint answer do not determine continued joint behavior. A joint contact supplies the missing relation.

The remaining acquisition problem has an exact positive answer. Suppose only this frame and the two individual three-cycle shapes have been acquired, with no further Q replies. Given Q(b)=a, the third member of Q's cycle is either c or d; these give exactly Q₁ and Q₂ above. One Q query at the intrinsically identified point a returns c or d and completes the joint action. No zero-query completion works because both laws retain the entire available frame. Equivalently, the unresolved relation is whether Q(a)=W(a) or Q(a)=W²(a). It survives all point renamings and belongs to the relative placement of the actions, not either action's individual period. This is a conditional one-query count after the frame is available.

The complete acquisition problem in this action class also has an exact answer: **three point queries for the frame, four for the full joint action**, in the worst case. The class consists of all pairs of directed three-cycles W,Q on four known points with different fixed points; this is exactly Q(b)≠b. VC100g's algorithm still acquires the frame with two W replies and Q(b). Querying Q(a) then identifies the remaining action. There are 24 possible frames (each with two Q completions), while a two-query tree has at most 4² leaves, so no two-query strategy always identifies the frame.

For the full-action lower bound, the two contacts play symmetric roles in this class. Suppose the first query is W(i), and consider its possible reply i. W then has two possible orientations on the other three points. Independently, Q has six possible three-cycles whose fixed point differs from i. If the next query asks W, at least six Q actions remain for the last query, which has at most four replies. If it asks Q, some possible reply leaves at least two Q actions; both W orientations also remain. The last query to either action cannot determine the other. Thus some transcript needs at least four queries. A first Q query has the symmetric argument. The four-query construction attains this bound. These counts use point access to the two supplied actions; their adaptive acquisition proof is mathematical, not a new resident query interpreter.

The two three-cycles trace triangles sharing one edge. For (W,Q₁) that edge is a→c in both actions. For (W,Q₂) it is d→a in W and a→d in Q₂. The unresolved binary relation is therefore agreement or opposition of their directions on the shared edge. Interchanging the names of the two contacts or reversing both directions preserves this distinction; reversing only one contact exchanges the two cases. The displayed obstruction therefore preserves the directed contacts as stipulated. Allowing an independent replacement of a contact by its inverse changes that comparison contract, and cannot be treated as renaming the points.

Nevertheless these same systems admit an explicit contact-to-word translation. In performed order their actual words satisfy

    Q₁ = W Q₂,    Q₂ = W W Q₁,
    Z = W Q₁ = W W Q₂.

Both pairs therefore generate exactly the same twelve phase actions as the original W,Z family. What fails is correspondence of each single contact to the equally named single contact. If the interface permits translation to words, keep W and substitute the displayed word for Q. Composition then preserves every translated phase action at its word boundaries.

With only the two forward contacts of each target interface counted as primitives, translating Q₁ needs exactly two contacts, and translating Q₂ in the reverse direction needs exactly three. For the first bound, neither target primitive equals Q₁, and W Q₂ attains two. In the reverse direction neither primitive equals Q₂. Among two-letter words, W W fixes b, Q₁ Q₁ takes b to c, and W Q₁ and Q₁ W are involutions, whereas Q₂ has order three. Thus none is Q₂; W W Q₁ attains three. If inverse contacts are supplied as additional primitives, that cost question changes. These counts concern the two declared contact interfaces, not the earlier star-contact implementation of each macro.

The translation does not identify the intervening execution histories or erase its additional contacts. A question about which single contact occurred keeps that distinction. The positive bridge and the earlier refusal thus answer different, explicitly related interface questions.

`PhaseAlignmentObstruction<A,B,C,D>` realizes the example using the existing actual words Q₁=WWZ and Q₂=WZ. It composes their cubes and the joint words WWZW and WZW through their exact intermediate sources. The individual cubes, the first joint square and the second joint cube return arbitrary supplied values to their initial arrangement. The marked-point consumer derives the common intrinsic preparation, the common first joint answer and the unequal second answers. Requiring those final answers to be equal is rejected. These are relations of the actual words, without an added assumption equating their results. The generic consumer `PhaseContactWordTranslation` also composes the four displayed translations through the current sources and derives their endpoint equalities for arbitrary A,B,C,D.

This sharpens the positive identification claim. Relations can force the only possible correspondence; additional relations still decide whether that correspondence is an admissible one. In this example the remaining obligation is precisely a joint action, not another origin, unit or independently assigned coordinate label.

The negative result does not require a complete four-point universe. Its local certificate is a preparation b and a corresponding word P with P²(b)=b in the first displayed action, whereas P′²(b′)=d′≠b′ in the second. A proposed map h preserving the preparation and those action steps would require

    b′ = h(b) = h(P²(b)) = P′²(h(b)) = d′.

Thus even a non-injective intertwining map with h(b)=b′ is impossible. Adding unobserved states outside the displayed action does not repair this equation while those relations are retained. If b is only a projected reading, preservation of the projected action steps must be established as part of this contract; an observed return alone does not assert a complete hidden-state return. Both systems can exist as different subsystems. The excluded claim is their proposed identification under the stated preparation and corresponding contacts. This is M71's local incompatibility applied to acquired joint actions.

### VC100i

**VC100i (VC89 applied to a library of programs).** Identifying the unknown action is not always necessary to act correctly. Apply VC89's existing adequate-choice criterion to a finite nonempty context family C and a finite program library P. Let L_c⊆P contain the programs whose actual application in c satisfies an independently specified target on every admitted working input. For available evidence E:C→M, a selector d satisfying d(E(c))∈L_c exists exactly when

    for every m∈E(C),  ⋂ { L_c : E(c)=m } ≠ ∅.

VC89 supplies the proof. The requirement can concern the phase result, histories, contact counts or records; changing it changes L_c. Membership must follow from actual application paths. The criterion itself does not acquire the sets L_c or their proof.

If each context permits exactly one program, this reduces to the usual factorization of that program through E. With several permitted programs, requiring some previously preferred choice to factor can be too strong: a different common program may work throughout the same fiber. With no readout, E is constant, so one program must belong to every L_c. A longer word can supply such an intersection even when the shorter library does not. The library, target question and cost therefore belong to the acquisition problem; the unknown source alone does not determine it.

### VC100j

**VC100j (acting without identifying the remaining orientation).** Keep the acquired intrinsic frame of VC100h and W=(a c d), with one unknown but fixed Q∈{Q₁,Q₂}, Q₁=(b a c), Q₂=(b a d). Available primitives are forward W and Q. Words here are written in performed order. Then

    U = Q Q W Q W           acts as Q₁ for either fixed Q;
    V = Q Q W W Q W W       acts as Q₂ for either fixed Q.

These are full phase-action equalities on arbitrary inputs, not agreement only on the preparation b. They require no intermediate readout, branch selection or identification of Q. They do require three actual Q calls using the same law. “No readout” does not mean no interaction, no change to the working phase or no information elsewhere in the whole source.

For existence, use the already established performed-order identities Q₁=W²Z, Q₂=WZ, W³=Q₁³=Q₂³=Z²=I. For Q=Q₁, (Q₁W)²=I, so U=Q₁. For Q=Q₂, Q₂²W=Z and ZQ₂W=ZWZW=W²Z=Q₁. Interchanging W and W² and interchanging Q₁ and Q₂ gives V. This proof uses the actual joint relations; the separate periods alone would not establish these words.

The lengths five and seven are minimal among fixed forward words with no intermediate readouts. To see this without enumerating words, consider the three partitions ab|cd, ac|bd, ad|bc. W cycles these partitions; Z fixes each. A word with n occurrences of W and m occurrences of Q acts on these partitions as W^(n+2m) under Q₁ and W^(n+m) under Q₂. For a common Q₁ result, m≡0 and n≡2 modulo three. A word with m=0 fixes b and cannot be Q₁. Thus m≥3, n≥2: at least five calls, attained by U.

For a common Q₂ result the congruences are m≡0, n≡1 modulo three. Again m=0 is impossible. Below length seven the only remaining possibility has three Q calls and one W. Its word is Q^k W Q^(3−k), 0≤k≤3, whose fixed point is Q^(3−k)(b). For k=0 or 3 that point is b; for k=2 it is a. For k=1 it is c under Q₁ but d under Q₂. None is the common target Q₂, which fixes c. Hence at least seven calls are needed, attained by V.

This resolves two different acquisition questions:

| Required guarantee after the frame is known | Additional readout | Forward action calls |
| --- | --- | --- |
| Identify which Q is present | One point query Q(a) | Query interaction accounted separately |
| Implement Q₁ by a word chosen after that identification | Uses the acquired answer | One if Q₁, two if Q₂ |
| Implement Q₂ by a word chosen after that identification | Uses the acquired answer | Three if Q₁, one if Q₂ |
| Implement Q₁ by the same word for either fixed Q | None | Exactly five |
| Implement Q₂ by the same word for either fixed Q | None | Exactly seven |

The point-query rows retain VC100h's query/preparation contract. They are not claims that obtaining or retaining the query answer costs no contacts. Nor are these words an identification of the two interfaces: their primitive actions and intermediate histories remain different.

`UnobservedPhaseBridge<A,B,C,D>` composes all four paths through their actual intermediate arrangements. Its generic `Null` witnesses derive the two common endpoint actions without asking the caller to supply their equality. The minimality proof above is mathematical; the Swift construction proves the attaining words, not a search over all words. The costs count W,Q calls in the stated interface. Expanding the supplied Q clauses into the existing W,Z representation certifies their phase effects; it is not the cost convention used in the five/seven bounds.

### VC100k

**VC100k (changing context, and acquisition of an applicable correction).** The same acquired frame need not make VC100j applicable over time. Replace only the third Q in U by Q₂, with its first two occurrences Q₁. The performed word Q₁ Q₁ W Q₂ W acts as W, not Q₁. Starting from b it returns b, whereas the stable-law U reaches a.

This change can be entirely internal to one fixed reversible system. Take a three-state clock t∈{0,1,2}; W acts on phase and leaves t alone. One total Q contact acts on phase by Q₁ at t=0,1 and by Q₂ at t=2, then advances t cyclically. This is a bijection on the twelve point-and-clock states: the final clock determines the preceding clock and hence which inverse phase permutation to apply. Starting at t=0, U uses Q₁,Q₁,Q₂ and ends at t=0 with phase action W. Thus the clock returns and the same instantaneous intrinsic phase frame remains available, while the desired phase bridge fails. No external source of change has been introduced.

The distinction is more general than this clock. Suppose each Q occurrence may independently use either Q₁ or Q₂, with the same W and intrinsic frame. No fixed forward word without intermediate observations realizes one fixed full phase action if it contains Q. Choose its last Q, fix all earlier choices, and compare two executions differing only there. Their common prefix is bijective. Some working input therefore reaches a point where Q₁ and Q₂ disagree. The remaining suffix consists only of powers of W and cannot erase that difference. A word containing no Q fixes b, so cannot realize either target Q₁ or Q₂.

Any specified finite switching schedule in this argument can itself be implemented by a sufficiently long finite internal clock; the negative result does not require outside interventions. Its scope is all such schedules and a fixed word required to work on every phase input. It is not a prohibition on feedback, a controller exploiting a particular known clock law, or success on a special preparation. For instance Q(b)=a in both clauses, so that one prepared answer alone conceals their difference.

For the displayed three-state clock there is a positive repair. Acquire only the current bit e(t) indicating t=2. Select Q if e=0, and WQ if e=1. The latter is Q₁ by VC100h. Added W does not tick the clock. The resulting whole contact N therefore satisfies, with E the phase projection,

    N(x,t) = (Q₁(x), t+1 mod 3),       E∘N = Q₁∘E.

This gives an autonomous phase action even though E∘Q does not factor through E for the uncorrected contact. The evidence has not made the raw laws identical: it selects an applicable program that makes the requested phase action common. In the two-word library {Q,WQ}, the permitted sets are {Q} at clocks 0 and 1 and {WQ} at clock 2. Thus e is necessary and sufficient for this selector, by VC100i. This is not a lower bound for every controller allowed to exploit the known clock dynamics. It also depends on asking for the full phase action: on the preparation b, raw Q alone reaches a at all three clocks. The positive consumer `PreparedPhaseWithoutClockReadout` derives that weaker answer directly.

There is a stronger impossibility when the target retains N's actual clock advance. Even with this clock law known, no fixed forward word of any length realizes N at every phase and unknown initial clock without current-clock evidence. Use VC100j's three pair partitions. W acts as one cyclic step on them; the Q clauses act as u₀=2, u₁=2, u₂=1 such steps. If a word has n W calls and m Q calls, its clock advances by m modulo three, regardless of where the W calls occur. To realize N, m=3k+1. On the pair partitions the phase action at initial clock t is therefore

    W^(n+5k+u_t).

The first 3k Q calls contribute k complete clock rounds, each with exponent 2+2+1=5; the remaining Q contributes u_t. W is clock-neutral, and all partition actions commute as powers of the same three-cycle. The displayed exponents differ between initial clocks 0/1 and 2, whereas N has the same phase action Q₁ everywhere. This is impossible. Allowing inverse contacts cannot remove this particular obstruction: on the finite carrier each inverse is a positive power of its contact, so any such word could be expanded into a forward word. The earlier five/seven cost bounds still use forward calls as their unit.

Thus a longer fixed word cannot replace the acquired distinction while also preserving this context transition. Among controllers that acquire one finite message about the initial clock, then execute its selected fixed word on arbitrary working inputs, at least two used message symbols are necessary; the displayed bit and the two words attain that minimum. This lower bound is stronger than the two-word-library observation, but it retains the clock-advance requirement. It does not exclude a common phase action with a different clock endpoint, a payload-dependent choice or a controller given additional current-context evidence. Two symbols measure a required distinction, not a physical acquisition cost.

If the initial clock is already known to be zero and its transition relation is retained, the third-clause correction in the earlier U path can instead be scheduled from that knowledge. `PhaseCyclingBridge.Corrected` does exactly this. No new clock measurement is needed in that prepared case. The lower bound concerns a current clock still ranging over all three possibilities under the executor's available evidence.

The acquired bit is sufficient for this action, but not an autonomous clock state: e(0)=e(1), while e(1)≠e(2) after one contact. To repeat the policy one must read the current bit again or possess enough retained clock information and a valid transition relation. Retaining an old true record alone does not supply the next selector input.

`PhaseCyclingContacts` supplies the three actual reversible clauses and their inverse applications. `PhaseCyclingBridge` derives the failed U endpoint, the returning clock and the repaired endpoint for arbitrary phase values. `PhaseClockCorrectionBit` reads the actual clock slot. `AcquiredPhaseClockPolicy` records that reading beside its source and uses `SelectedLocalApplication` to select the actual Q or WQ application from its current root. Its decoder input contains only the recorded bit and a fixed program marker. Each of the three concrete source clauses derives the same phase result, the actual next clock and the retained record. The decoder is not handed an additional private orientation or an independently chosen primitive. The concrete clock law, the reading construction and the finite selection grammar are the stated premises; arbitrary user-written reading conformances are not certified by this example. Checks reject the wrong branch and reuse of the old zero-bit record at the source whose current bit is one.

Together these results locate the obligation more precisely than “first identify the law”. Establish which programs are valid throughout the current evidence fiber, and whether the actual intervening contacts preserve the relations used in that validity proof. Sometimes one common word removes the need for identification. Sometimes internal change destroys that word's applicability. A small acquired context can restore the requested action without reconstructing the entire source.

### VC100l

**VC100l (acquire through a disturbing contact, then restore applicability).** The direct clock-slot reading in VC100k is a declared instrument; its availability does not follow from W,Q. The same selection can instead be fed by a retained phase-probe reply. Declare one additional internal probe prepared at a, with the working values parked beside it. Q acts on the active phase register and the same shared clock; structural refocusing exposes the working register after the experiment. The probe preparation, phase readout and this refocusing are the explicit access contract.

Apply Q to the probe once and read only whether its resulting phase is d. The reply is zero at initial clocks 0/1 and one at initial clock 2. The contact has already advanced the clock, so this fact is not yet its current correction bit. Apply two further Q contacts to the reached probe, without another readout. The actual paths are

| Initial clock | Probe after first Q | After second Q | After third Q | Returned clock | Retained bit |
| --- | --- | --- | --- | --- | --- |
| 0 | c | b | a | 0 | 0 |
| 1 | c | c | b | 1 | 0 |
| 2 | d | d | d | 2 | 1 |

Now the same original fact is the required bit at the restored clock. Refocus the parked working values together with this actual clock and fact. The existing selector applies Q for reply zero and WQ for reply one. The working phase becomes Q₁(x) and the clock advances from its original t to t+1. The final probe phases a,b,d and the original recorded reply remain in the whole output. In particular the experiment returns the clock, not the full source. Initial clocks 0 and 1 remain unidentified by the supplied reply; the unexamined probe residue distinguishes them.

This path uses three probe Q calls, one retained phase-bit readout, then one working Q call and at most one working W call. This is an attaining construction under the stated preparation and refocusing contract. A minimum contact count over controllers with such auxiliary probes is not proved. VC100k's word impossibility concerns W,Q acting on its one phase register; it must not be transferred to the expanded auxiliary-register interface.

`PhaseProbeClockReturn` records after the first actual contact and retains that fact through the next two. `PhaseProbeClockExperiment` derives the three clock returns, replies and unequal probe residues. The generic `ProbeAcquiredPhaseClockPolicy<A,B,C,D>` parks arbitrary working data, performs this experiment, refocuses the actual returned clock and original fact, and uses the same `PhaseClockPolicyRoot` decoder. That root now accepts the acquired fact independently of its acquisition path: no replacement “current” fact or copied certificate is manufactured. Its decoder still receives only the fact's answer and the fixed program. The resulting phase-and-clock targets and retained facts/probes are derived from the whole composed path.

The refusal at the premature seam is informative. Starting from clock 1, the first reply is the truthful zero bit, but the clock is now 2. The zero-bit selector legally chooses its direct Q branch and this actual branch performs Q₂, not the required Q₁. Its claimed phase target is rejected. Thus a valid local lookup is not itself proof of the lookup's applicability. The two further contacts restore the specific relation that makes this very same retained fact sufficient, while preserving the changed probe rather than pretending it returned.

The expanded interface also permits a completely unobserved construction. Write Q_w for Q on the working register and Q_p for Q on the auxiliary register, both advancing the same clock, and define the performed block

    F = Q_w Q_p Q_p.

The block returns the clock to its initial t. On the working register it acts as Q_t; its last two contacts alter only the auxiliary phase and the clock. Thus every F in a composed path presents the same Q_t to the working register, although the auxiliary residue changes. W_w also keeps the clock fixed. VC100j therefore applies to the effective interface F,W_w:

    F F W_w Q_w W_w

has working action Q₁ and advances the clock by one through its last Q_w. The first two F blocks return the clock; the third working Q therefore still uses the same Q_t. There is no further Q whose law would require another restoration. Its expanded length is nine primitive contacts. No register is read and no branch is selected. The auxiliary initial phase may be arbitrary: its role is to permit the two clock-advancing contacts away from the working register. Its final phase is retained, not required to return.

Consequently zero readouts are attainable in this enlarged interface; one readout trades for the shorter four/five-contact path above. Nine is an upper bound, not a proved minimum contact count. This nine-contact result follows mathematically by composition of the clock return with VC100j. VC100m below additionally supplies its full static two-register trace and closes the continuation question. The single-register obstruction and this positive auxiliary-register construction differ in exactly the declared ability to advance the shared clock without acting on the working phase.

### VC100m

**VC100m (a common carrier for a repeatable interface).** Keep exactly VC100l's fixed clock law and access to the two phase registers. The admitted complete states are

    C = X⁴ × {0,1,2} × Y⁴,       s=(x,t,y),       E(s)=x.

Here X and Y are any nonempty payload sets. Every working and auxiliary arrangement is admitted, including repetitions of values. There is no blank reserve, prepared auxiliary mark, accumulated record, or extra phase-dependent access condition. Refocusing preserves both registers and the same shared clock. The contact law and this access contract are fixed premises; arbitrary changes to them are not changes of state within C. As in VC100l, nine counts Q/W calls. The admitted structural refocusing steps are explicit in the trace and are not assigned a free physical cost.

Write q for Q₁ acting on either register's four slots, w for W, and ε(t)=1 at t=2 and zero otherwise. The actual nine-contact program M from VC100l and working W have the full actions

    M(x,t,y) = (q(x), t+1 mod 3, q^ε(t)(y)),
    W_work(x,t,y) = (w(x), t, y).

The auxiliary formula follows from the actual F blocks, not from treating their unobserved outputs as disposable. If y=(E,F,G,H), the two auxiliary contacts within one F produce respectively

    t=0: (G,H,E,F),     t=1: (H,G,F,E),     t=2: (G,E,F,H).

Each F returns the clock. The first two auxiliary permutations square to identity; the third is q² and its square is q. M contains two such F blocks, followed by no further auxiliary contact. Its working action is q by VC100j and its final working Q advances the clock once. This proves the displayed full formula.

In particular both M and W_work map all of C back into C, and

    E∘M = q∘E,       E∘W_work = w∘E.

These two obligations have different roles. The equations establish the promised phase action; closure establishes that the complete actual output is an admitted input for the next call. A statement about one register's allowed values alone would not supply that closure.

For every finite word in M,W_work, repeated composition therefore gives the corresponding word in q,w under E. Proof: the empty word preserves C and E; either appended generator preserves C and its commuting equation extends the preceding one. No enumeration of longer words and no fresh preparation is needed. Since w,q generate the twelve phase actions of VC100h (the performed word wq is Z), all twelve are realizable through this reusable interface without reading the current clock. This concerns phase actions at call boundaries, not identity of full action histories.

The full formula makes that distinction particularly explicit:

For a finite interface word u containing m calls to M, let u_phase be the same performed word with M replaced by q and W_work by w. Its complete action is

    u(x,t,y) = (u_phase(x), (t+m) mod 3, q^floor((t+m)/3)(y)).

Each M advances the clock and applies one auxiliary q precisely when that advance wraps from two to zero; W_work changes neither. Induction on the word therefore proves the formula. In particular,

    M³(x,t,y) = (x,t,q(y)),       M⁹(x,t,y) = (x,t,y).

Every three successive calls visit each clock once, so their auxiliary exponents sum to one, while q³ is identity on working data. Repeating that triple three times proves the second equation. For auxiliary data with a nontrivial q orbit, three calls return the working phase and clock but not the auxiliary register. On a payload domain with such a tuple, the full action has order nine: clock return requires a multiple of three calls and auxiliary return requires three such triples. One call to M contains nine primitive Q/W contacts; the full nine-call return thus uses 81 contacts. Full return here means return of the displayed carrier C, not a carrier enlarged by an independently retained contact journal.

`UnobservedClockInterface.swift` constructs the three actual F paths and three nine-contact M paths from `PhaseCyclingContacts`, with generic working and auxiliary payloads. `WholeSources` and `WholeOutputs` derive all input/output arrangements. Structural refocusing carries every field. `ReusablePhaseInterface.swift` supplies generic `CommutingTransition` constructors for M and W_work, and applies the existing `JoinedTransition` at the actual full intermediate sources. It admits MM, MW and WM at all three clocks and derives M³'s complete output. W_work closes under further W_work directly by its generic unchanged-context formula. The common carrier and the finite-word induction above extend these constructions; M⁹ is a consequence of the full M³ formula, not a separately enumerated 81-contact Swift fixture.

The operation-address adapter `PhasePathReading` alone proves no intended meaning. The concrete squares tie its actual path endpoints to the independently defined phase actions. Neither their constructors nor the generic join request the final phase equality from the caller. The verified fragment consists of these constructors and their joins, not every possible conformance to `PredicateReading` or `CommutingTransition`.

Finally, absence of readouts during execution does not assert permanent unobservability of the residue. Two initial states with the same working phase have identical boundary working histories under the same interface word; this follows from its commuting equations. A policy using only those histories also makes the same next choices. Auxiliary readings, clock readings, intermediate observations or timing questions are richer interfaces and need their own comparison. For example a known auxiliary mark at a is unchanged by M at initial clocks 0/1 but moves to c at initial clock 2. An admitted subsequent auxiliary reading could distinguish that case. The established claim is an interface requiring no clock identification, with equivalence relative to its declared observations.

## Cross-page mentions

Labels mentioned here: <doc:permanence_is_resistance__forced_answers#M71>, <doc:verdict_is_invariant__four_phase_catalogue#VC100d>, <doc:verdict_is_invariant__four_phase_catalogue#VC100e>, <doc:verdict_is_invariant__relative_questions#VC89>.

Mentions of this page’s labels: <doc:learning_is_liquid__reconstructed_sides> (VC100f), <doc:permanence_is_resistance__contact_rigidity> (VC100h), <doc:verdict_is_invariant__return_costs> (VC100k), <doc:verdict_is_invariant__return_costs> (VC100m).
