# Permanence Is Resistance (Matter) — Frame acquisition

This part contains the original derivations for frame acquisition.

Family and original section headings: <doc:permanence_is_resistance>.

Section setting: <doc:permanence_is_resistance#4g-Which-future-must-carry-a-real-distinction>.

### M64a

**M64a (two paired acquisitions can identify the relative action while both connections and the probe source remain unknown).** Let X be four distinct probe states and V four retained record labels. Two fixed unknown bijections f,g:X→V share the same probe on each occasion. A paired acquisition returns

    (u,v)=(f(x),g(x)).

Suppose the relative permutation D=g∘f⁻¹ on V is even. The individual connections need not be known or even. For example a common unknown bijective output instrument c gives f=c∘a, g=c∘b, and D remains even whenever a and b have the same parity. All these components remain internal. The pairing, bijectivity and admitted law family are supplied relations, not inferences from matching labels.

Two acquired pairs (u₀,v₀),(u₁,v₁) with u₀≠u₁ determine D exactly. They are two point constraints D(uᵢ)=vᵢ. Two input and two output labels remain. There are two bijective completions, differing by one transposition; exactly one is even. One pair is insufficient for this full relative-law question: every first image has three possible even completions. These completions are actually compatible with the unknown-component model: choose any f, set g=D∘f and choose x=f⁻¹(u). Thus the lower bound does not rely on candidates forbidden by the model.

A second distinct first image does not require identifying x or f. If an available probe operation J satisfies J(x)≠x on the admitted preparations and preserves the two connections, acquire the pairs before and after J. Injectivity gives f(J(x))≠f(x). One such intervening operation therefore guarantees the required two distinct constraints. A known fixed-point-free operation on X is sufficient; the weaker separation condition on the actual preparation is enough. Its availability and preservation of the acquisition relation must be established. Counting two pairs does not include preparing, recording or restoring an instrument.

The old two-image decoder has a direct algebraic reuse. There is a unique even permutation A sending fixed record labels 0,1 to u₀,u₁, and a unique even permutation B sending them to v₀,v₁. Then D=B∘A⁻¹. These are both the existing VC100 two-image completion question: D∘A is even and has B's two specified images, hence equals B by uniqueness. Neither individual connection has to be even. No unknown source x, f or g is an additional input to this decoder. Applying D to a newly acquired first-connection image predicts the second image under the same relative law. The instrument's absolute calibration and the channels' decomposition are not obtained and are not needed.

There are two different common changes. A shared bijective readdressing J of the input gives f′=f∘J and g′=g∘J, hence D′=D without a commutation requirement. A shared output change instead conjugates D, as in M64b. The two actions cannot be interchanged on the basis that both affect the connections together.

`JointReplyAcquisition.swift` supplies a static acquisition fragment. It records the first fields of two supplied forward point tables, applies the actual Z word to both input tables, and records their new first fields beside the old record. Its memory reads only these two facts and the fixed `FourLeafReplyTable`. A generic equality allows all four unmeasured table fields to vary without changing that memory, including the facts' operation addresses. The decoder projects the acquired pairs and uses the existing two-image decoder twice; it produces the presentation (A,B), not a newly asserted name for D.

For the forward tables W and Z it obtains (W,Z). After the same actual input shift it obtains (ZW,I). The actual words WWZ and (ZW)² have the same full payload action (B,C,A,D), although these decoded presentations differ. Wrong lookup seams and equating the presentations are rejected. This verifies the acquisition, two concrete decodings and their relative word identity.

`FourLeafInverseWords.swift` then provides an inverse interface at the same twelve occurrence addresses as the forward catalogue. Each leaf is an existing actual word. All twelve forward/inverse compositions return the whole source for arbitrary working fields and retained context. Address agreement and agreement of the carried library with its actual leaves are also derived; an address name alone does not establish inversion.

`JointReplyExecution.swift` records the acquired memory beside its source and attaches it to a prepared working world. `JointReplyPolicy` reads only that carried memory and its selector instruction. The first decoded address selects its inverse from the inverse root; the second selects its forward word at the actual reached working source. Hence the action is B∘A⁻¹. The original acquisition whole, its new record and arbitrary remaining context survive. The mathematical all-pairs construction uses the twelve inverse identities and composition; no new table of 144 pairs is needed.

The two source-bound complete paths for (W,Z) and (ZW,I) are checked from acquisition through selection and action on arbitrary working data. Both produce (B,C,A,D), keeping their different archives. A fresh marker at 0 is sent to 2, matching the two current channel fields at an unmeasured input position. Those fields are inspected by the check, not supplied to the decoder. Refusals reject a different selected address, reuse of the working source before the first action, and treating the forward root as the inverse root despite their equal address layouts.

These are finite static constructions, not a new runtime dispatcher or a compilation of every possible source instantiation. Bijectivity, evenness, availability of the paired contact and the calibrated action library belong to the stated family; arbitrary `Pair` or `PredicateReading` conformance alone does not establish them. The action library must refer to the same record-label frame as the question. An unknown change of that relation is not corrected by retaining the observations alone.

This is an acquisition result within a stated family, extending M60 rather than replacing its premises with unspecified reliability. If D may instead be any permutation, two pairs leave the two completions unresolved. If successive paired acquisitions do not belong to the same D, even a unique completion need not describe the current pair of connections. M64b supplies an example in which each individual acquisition is truthful.

### M64b

**M64b (a common change preserves a relative law exactly when it commutes with that law).** After acquiring D=g∘f⁻¹, let both output connections change by the same unknown bijection h:V→V:

    f′=h∘f,        g′=h∘g,        D′=h∘D∘h⁻¹.

Reusing D unchanged predicts every new second image from its corresponding first image exactly when D′=D, equivalently h∘D=D∘h. This follows by substitution and surjectivity of the first connection. Commonality of h alone does not give the last equality. It describes a physical change of both connections relative to a retained decoder. Relabeling the decoder, all records and both connections together is a different comparison.

The binary I/S family is special: its two maps commute, so every common I/S change preserves the relative action. For a three-cycle on four labels, only its three powers commute with it among all twenty-four frame permutations. A commuting map must fix the three-cycle's unique fixed label; its image of one moving label determines the other two, leaving three choices. For a product of two disjoint exchanges, the commuting maps may exchange the two pairs and independently exchange the two labels inside each pair: eight choices. The identity commutes with all twenty-four.

Consequently an unspecified common S₄ change leaves respectively one, eight or three possible current relative laws, according as D is identity, a three-cycle or a double exchange. This class information is known without further calibration. In particular identity, period and cycle pattern survive. The exact labeled law need not survive.

Under an available point-query instrument for D′, the exact worst-case numbers of new distinct point constraints are:

| Previously established cycle type | Possible current laws | Required queries |
| --- | --- | --- |
| identity | 1 | 0 |
| two disjoint exchanges | 3 | 1 |
| three-cycle | 8 | 2 |

For a double exchange, the partner of any queried label determines the other pair. For a three-cycle, a fixed queried label leaves the two orientations of the other three; a moved queried label leaves two choices of the cycle's third label. Thus one answer always leaves two laws. Two distinct inputs suffice by M64a. The counts concern a fixed current D′ throughout acquisition. M64a's two paired probes can supply the point constraints without knowing either connection separately when its separation operation is available. Arbitrarily repeating an uncontrolled preparation is not a guarantee of two distinct inputs.

There is an explicit obstruction to extrapolating the binary cancellation. Take W=(a c d), fixing b, and H=(a b). The relative law after the common change is P=(b c d), fixing a. In left-to-right word notation HWH has payload output (A,D,B,C), while W has (D,B,A,C). Both have period three. `PhaseFrameDrift.swift` constructs these actual paths with arbitrary retained context and proves the changed output. It also constructs the common change by W itself, which preserves W, and refuses identifying the H-conjugated action with the original one.

For mixed acquisition, before the H change obtain (b,b); afterwards obtain (c,d). The two truthful pairs have distinct first labels and determine W as their unique even completion. But the current law is P, and at new first label a it returns a, whereas that completion predicts c. Such records are possible with f=id, g=W before the change and f′=H, g′=H∘W after it, using probe states b and c. The static witness checks the corresponding actual marker positions: B at output b before, C at output d afterwards, both compatible with the old W table. It does not claim a new resident recording implementation for that mixed-law counterexample. M64a separately gives the positive acquisition and its subsequent source-bound application.

### M64c

**M64c (an old policy needs agreement of frames only modulo the action it must implement).** Let an acquired program represent D on four record labels. A common change h of the two observation connections makes the current target hDh⁻¹. Suppose a change k of the actual action library makes the same retained program realize kDk⁻¹. This covariance is a relation of the library's actual operations, not a consequence of retaining its names. No new observation is needed to use the old program correctly whenever

    kDk⁻¹ = hDh⁻¹  iff  rD=Dr,  where r=k⁻¹h.

Indeed conjugating the left equality by k⁻¹ gives D=rDr⁻¹. Thus the relevant unknown is the relative frame discrepancy r, and only its action modulo the centralizer of D matters. Requiring h=k is sufficient but can be unnecessarily strong for a single requested action. Identity tolerates every discrepancy; a three-cycle tolerates its three commuting rotations; a double exchange tolerates the eight transformations described in M64b.

For example k=hD gives r=D⁻¹ and works for this D even when h≠k. That same discrepancy need not work for a different action. Correctness for every D in a family L requires r to commute with every member of L, rather than only with the one most recently exercised.

For the whole A₄ interface the only such r in S₄ is identity. It already suffices to commute with W=(0 2 3), fixing 1, and Z=(0 1)(2 3). Commuting with W forces r to fix 1 and restricts it to the three powers of W. Commuting also with Z forces r(0)=r(Z(1))=Z(r(1))=0. Only the identity power of W fixes 0. Consequently correctness for the full interface forces h=k within this model, although correctness for one action does not. These are equalities of full actions, not a claim that two isolated point observations verify the whole interface.

This criterion separates repair of observation from repair of action. M64b is the special case k=id: preserving the old action fails when h does not commute with D. The positive case k=h preserves applicability without changing the old memory or individually identifying either frame. It does require the stated relation between current observations and the current implementation. Agreement in a finite history does not establish that relation for an unrestricted class of later implementations (VC107–108).

The static construction uses the existing acquired D=WWZ and H=(0 1). A reversible change of the common observation frame changes the actual two channel tables while retaining both old facts. The intended current action is H D H=ZW. An H transport around the same memory-selected program, or the different compatible frame k=H D, supplies the current action. `JointReplyFrame.swift` constructs the channel change, reads the old facts from the changed whole and supplies the working-frame transports. The complete consumer checks both policies from acquisition through the frame change and selection on arbitrary working data. Both yield (C,A,B,D), preserve the current acquisition whole and its old facts, and correctly send a fresh marker 1 to 2, as required by the unmeasured current channel fields. The decoder input remains exactly the old memory. These are the displayed coherent channel and transport families, not an inference that arbitrary unknown changes are coordinated.

### M64d

**M64d (exact acquisition of applicability from unresolved transformations).** Let G be a given finite group of permutations of a finite input set X, and H a subgroup. An unknown r∈G is accessible through exact point queries r(i), with i chosen by the querying process. The question is membership r∈H, not identification of r. For queried inputs Q, write

    G_Q={g∈G : g(i)=i for every i∈Q}.

The exact worst-case number of distinct point queries is

    b(G,H)=min{|Q| : G_Q ⊆ H}.

One fixed set of inputs attains it; adaptive choice cannot improve the worst case for this question and access model. This does not claim that finding an optimal Q or processing a transcript has no computational cost.

*Proof.* The replies from r leave exactly rG_Q: equality on Q is equivalent to r⁻¹s fixing Q. If G_Q⊆H, any such coset either misses H or is entirely inside H. Thus the question is constant on every available-evidence fiber. Conversely run any exact adaptive strategy on identity. If it stops at Q with G_Q not contained in H, some g∈G_Q\H gives the same complete transcript as identity and the opposite membership answer. Repeated queries do not alter Q. This proves the bound and also the nonadaptive attainment. ∎

For M64c take H=C_G(D), the admitted transformations commuting with the desired action D. On X of size n≥1 let f be D's number of fixed points, and let ε₂ indicate whether D has a two-cycle. For unrestricted r∈Sₙ,

    b(Sₙ,C_Sₙ(D)) = n − max{1, f, 2ε₂}.

Indeed the unresolved transformations are all permutations of U=X\Q. For |U|≥3 they commute with D exactly when D fixes U pointwise: D must preserve their unique nontrivial orbit U, and the center of S_U is trivial. For |U|=2 it suffices and is necessary that D fix both points or exchange them. For |U|≤1 there is no residual ambiguity. The largest permissible U therefore has the displayed size. This is a positive-certificate bound; some incompatible frames can be rejected earlier.

For known even r∈Aₙ the residual group is A_U. For |U|≤2 it is trivial; for |U|=3 its centralizer on U is the three-cycle group; for |U|≥4 its centralizer on U is trivial. The latter follows because commuting with every three-cycle not containing a point forces that point to be fixed. Consequently, with ε₃ indicating a three-cycle in D,

    b(Aₙ,C_Aₙ(D)) = n − max{min(n,2), f, 3ε₃}.

These formulas give the following exact worst-case counts on four labels:

| Desired action D | Unknown frame r∈S₄ | Known even frame r∈A₄ |
| --- | --- | --- |
| identity | 0 | 0 |
| two disjoint exchanges | 2 | 2 |
| three-cycle | 3 | 1 |

For a double exchange in S₄, query partners i and D(i). If their images are partners, the remaining two images complete the remaining pair in either order; both completions commute. One query cannot decide. Two arbitrary different inputs need not suffice: for D=(0 1)(2 3), identity and (1 3) agree on inputs 0,2 but differ in commutation. The relation between the probes matters, not only their number.

For a three-cycle W=(0 2 3) fixing 1 and even r, commutation is equivalent to r(1)=1. Fixing 1 leaves just the three even permutations of the other labels, which are the powers of W. Thus a single reply verifies applicability while leaving three distinct frames possible. Without the even-family premise, identity and the odd exchange (2 3) give that same reply, although the latter does not commute with W. If the frame is known odd, applicability to this three-cycle is already impossible without a point query.

The A₄ premise has a concrete origin in VI's coupled four-leaf family: VC99a classifies the residual phase actions when the complete final stage action is identity. It is not inferred from the return of one preparation or asserted for arbitrary reframings. Within this established family, `OneReplyApplicability.swift` reuses `FourLeafSecondProbe` as the sole probe at prepared phase 1. The resident word and U produce a stage record; the decoder receives only that fact and a fixed four-entry reading. It accepts exactly I,W,WW. All twelve original resident law addresses are retained, and the three accepted cases have exactly the same decoder input.

Separately, actual word compositions prove that I,W,WW commute with W on arbitrary working data, and exhibit a differing field for each of the other nine words on distinct markers. The acquired verdict is recorded beside the resulting experiment. Refusals reject identification of the hidden frame from the one reply and extension of the commutation conclusion to the odd fixed-point example. This counts one point acquisition, not one primitive contact: preparing the marker, executing the word, U and retaining the result remain operations in the displayed path.

Finally, the probe need not freeze the entire source representation. Readdressing inputs by D changes a table r to rD while preserving the membership question: (rD)D=D(rD) iff rD=Dr. A fixed-address probe before and after this specific change reads r(i) and r(D(i)). This supplies the right mathematical preparation relation for the double-exchange test, without assuming that r commutes with D in advance. Its acquisition path must still implement this right composition and exclude other untracked changes. `PartnerProbeApplicability.swift` now constructs that path: record port 0, perform the existing Z word beside its record, then record port 0 of the reached table. The current table is (B,A,D,C); the available memory contains only the two facts about A,B and a fixed partner resource. This resource is itself Z applied to the four singleton rows. Two existing coordinate readings select its row and cell; the resulting answer is recorded beside the complete experiment.

All twelve distinct ordered reply pairs are checked with arbitrary two unmeasured fields. An independent question reads the reached table's first two fields, in their current order B,A, and yields the same answer. Those direct source readings belong to the verifier's question; they are not extra observations supplied to the actor's decoder. For permutation tables, the partner criterion above supplies the connection to full commutation. The generic tuple construction by itself does not assert bijectivity.

Identity and the actual exchange (2 3) produce the same two partner facts and different current tables; both remain compatible with Z. Conversely an input exchange (0 2) gives identical two records for identity and (1 3). Their current tables are (0 2) and (0 2)(1 3): the first does not commute with Z, whereas the second does. Actual compositions establish these contrasts. Thus the preparation relation determines whether the same amount of acquired evidence answers the current question.

### M64e

**M64e (when question-preserving movements permit acquisition).** Keep the finite point-query model G,H of M64d. The only observation port is i. Known input movements form a subgroup L of H and act by right composition: the current source r becomes rℓ, for ℓ∈L. Their words and composition are available to the controller; an unobserved source-dependent choice of ℓ is not part of this access model. Preparations before the first reading are permitted, and movement costs are separate from query counts.

Each such movement preserves membership in H, even when it changes the source. Indeed rℓ∈H iff r∈H. Conversely, a fixed right composition that preserves this question for every r∈G must use ℓ∈H: apply it to identity.

Let O=L·i be the orbit of the port. Then the exact worst-case query count is

    b_O(G,H)=min{|Q| : Q⊆O and G_Q⊆H},

with value infinity when no such Q exists. Finite acquisition is possible exactly when G_O⊆H. In particular, keeping the question unchanged does not by itself provide enough access to answer it.

*Proof.* At a known accumulated movement t∈L, the acquired value is r(t(i)). Thus the complete transcript consists of original-source point queries in O. Any chosen point of O can be reached from the current t by an available movement word, so a fixed qualifying Q attains the displayed bound. The current membership answer is still the original one. For the lower bound, follow identity's adaptive transcript. If its queried Q has G_Q not contained in H, an element g∈G_Q\H gives every same reply along that branch, but its membership answer remains opposite after every performed movement. If even G_O is not contained in H, the same obstruction survives every finite transcript, including a traversal of the entire orbit. ∎

For Z=(0 1)(2 3), G=S₄, H=C_G(Z), take only L=⟨Z⟩ and port 0. Its orbit is {0,1}; the residual group {identity,(2 3)} lies in H. The preceding two-reading construction therefore attains the exact bound while leaving two source completions unresolved.

For W=(0 2 3) and G=S₄, all right movements preserving the commutation question form H=⟨W⟩. From port 1 they cannot acquire the answer at any finite budget: the port never moves, and identity and (2 3) remain indistinguishable. `PartnerTrappedPort` checks the actual record–W–record step on arbitrary contents; induction repeats that unchanged reply for every word of these movements. From a port in {0,2,3}, three queries do suffice. Under the additional known-even restriction G=A₄, the same fixed port 1 needs just one query, because its residual group already equals H. Thus a family restriction can change the possibility of acquisition through a fixed interface, beyond the number of observations needed by a free probe.

This is a limitation of the stated movement interface. It does not prove that a useful experiment must preserve the question at every intermediate step. A known invertible movement outside H can carry the question to a different current relation; returning the source later can restore the original question while retaining newly acquired records. The following construction supplies such an excursion in an explicitly enlarged interface.

### M64f

**M64f (acquire through an excursion, then restore the question).** Allow a known subgroup K of input movements in G, without requiring K⊆H. The current table is s=rt, with the accumulated t∈K known from the performed word. The question about the initial source is now

    s t⁻¹ ∈ H, equivalently s ∈ Ht.

This question is transported through the excursion. It need not coincide with membership of the current table in H at every intermediate point. If the final t is in H, the two membership questions agree again; if t is identity, the entire source table returns. Previously acquired records need not be erased by either return.

With known movement words and their inverses, preparations allowed before the first read, and no source-dependent feedback from movements themselves, the exact worst-case point-query count for acquisition followed by return is still

    min{|Q| : Q⊆K·i and G_Q⊆H}.

For sufficiency visit a qualifying Q and then undo the accumulated input movement. The records are the original r-values at Q. For necessity every queried current value is an original r-value at a known point of K·i; M64d's indistinguishable adaptive branch therefore still applies. The construction changes movement access, not the information in a point reply. Movement costs and the storage used by recording are not query counts.

For the previously trapped W-port 1, add the known exchange T=(0 1). The existing phase constructors supply this action; its availability is an additional interface premise, not a consequence of W alone. On a point table (A,B,C,D), the actual field action called W is (D,B,A,C). This field order is inverse to the destination permutation W=(0 2 3). Perform

    T; read1; T,W,T; read1; T,W,T; read1; T,W.

The three contacted tables and the final table are, respectively,

    (B,A,C,D), (B,D,A,C), (B,C,D,A), (A,B,C,D).

Thus the fixed port acquires r(0),r(3),r(2), and the original source returns. The path has nine T/W blocks and three acquisitions. Nine is an attained block count, not an asserted optimum or the number of low-level contacts.

For r∈S₄, commuting with W is equivalent to those three replies being one of (0,3,2), (3,2,0), (2,0,3). A commuting permutation must preserve W's unique fixed point and is a cyclic rotation on its other orbit. Conversely each displayed triple, together with bijectivity, gives exactly one such rotation; the unqueried image r(1)=1 is then forced. Three queries therefore suffice and attain M64d's lower bound for unrestricted point-query access.

`PhaseProbeExcursion.swift` constructs the entire record–move–return path on arbitrary contents, with explicit equalities to the actual composed endpoints. The existing `ThreeStageFacts` reads the retained facts and excludes the returned table. `PhaseOrientationReply.swift` decodes those facts through a fixed directed-orbit table using the existing finite Route clauses. It records its verdict beside the restored experiment. The twenty-four permutation sources in `PhaseExcursionCalibration.swift` run these actual acquisitions and give exactly the three accepted cases. Their sources are independently tied to the actual I,W,WW word outputs. Arbitrary tuple shapes or arbitrary PredicateReading conformances do not establish this scope.

There is a useful counterweight to the earlier partial-knowledge examples. In this point-query model, every exact positive certificate of commutation with W already identifies the whole r. If two inputs remain unqueried, their transposition fixes every acquired reply. Multiplying a compatible r by it gives an odd, incompatible permutation with the same transcript. Thus every positive branch needs three distinct inputs; their images fix the fourth by bijectivity. This remains true for adaptive excursions with known movements. Some negative branches can finish earlier.

The verdict may subsequently be compressed to yes/no, but the positive acquisition itself distinguished the complete table. In contrast, M64d's known-even, fixed-point probe leaves three compatible frames unresolved. Whether full identification is avoidable depends on the admitted source family and the available questions, not only on the size of the final answer.

The checks exhibit identity and (1 2) with equal first two acquired records and opposite final verdicts. They also exhibit different memories for two accepted frames. Refusals reject applying the original commutation answer to the intermediate T-frame, treating two records as sufficient, equating the source return with deletion of its records, and merging distinct positive memories. The source table returns; the full recorded history does not.

### M64g

**M64g (acquire applicability through two uncalibrated channels).** Let h,k be bijections from one four-point carrier to a common four-point output carrier, and W a three-cycle of the input carrier with fixed point p. Assume the relative map r=k⁻¹h is even. Equivalently, after choosing any common labelling, h and k have the same parity; neither must individually be even. Then

    (k⁻¹h)W=W(k⁻¹h)  iff  h(p)=k(p).

Indeed the even centralizer of W is its three-element cyclic group, which is exactly the stabilizer of p in A₄. Thus commutation is equivalent to (k⁻¹h)(p)=p, and bijectivity of k gives the displayed comparison. This acquires the answer from the two actual channels, without an oracle that already supplies point values of k⁻¹h or an inverse implementation of k.

Suppose both replies pass through one unknown injective encoding c. The available pair is (c(k(p)),c(h(p))). Its equality is equivalent to the displayed channel relation. No separate identification of c,k,h is required. For a common bijective c, the relative map itself is unchanged: (ck)⁻¹(ch)=k⁻¹h. One paired trial suffices; zero cannot decide between, for example, (k,h)=(identity,identity) and (identity,Z). A paired trial here contains two channel replies and can require many underlying contacts.

The relation directly read from pairs (k(x),h(x)) without input coordinates is instead R=h k⁻¹ on the output carrier. For the desired input operation W, write C=kWk⁻¹. The full condition is R C=C R. R alone does not in general settle it. On equal labelled carriers take T=(0 1): k=identity,h=W and k=T,h=WT give the same R=W, but relative maps W and TWT. Only the first commutes with the fixed W. Input-labelled observations or observations of the transported C contain more information than R alone; this example does not discard such observations when they are actually available.

`PairedProbeApplicability.swift` combines two actual phase-1 resident probes and keeps a common frame C beside the entire paired acquisition. Both framing reads obtain C from that same source field. A new joint record contains only their encoded replies. The equality decoder receives this record and a fixed four-label resource; raw replies, the frame table and resident law addresses remain outside its input, preserved in the whole. The name `SecondProbe` refers to an older experiment: each use here is the sole prepared point probe of its channel, not an unperformed earlier trial.

The twelve even resident laws give four actual reply classes of three laws each. `PairedProbeCalibration.swift` derives those fact equalities and checks all sixteen ordered class pairs, which suffices for their paired composition. Different pairs of hidden laws have exactly the same positive decoder input. An arbitrary common frame also carries an equal raw reply class to an equal encoded pair, without requiring knowledge of its unused fields.

`CommonProbeFrame.swift` checks equality preservation on all sixteen pairs for the actual output-label generators T and the frame table produced by W. These generate S₄: conjugating the exchange with the three-cycle supplies all exchanges from the fixed label to the other three labels. Composition therefore preserves equality for every finite word of these generators. This is the stated finite permutation-frame grammar, not a proof that every arbitrary `C: Structure` is injective. The generic acquisition can also represent a lossy encoding; only the admitted frame scope supplies the corresponding commutation interpretation of its equality verdict.

Three boundaries are independently necessary for this complete test. Without the even-relative scope, identity and (2 3) agree at p=1 although their relative map does not commute with W. With different output frames, the unequal I/Z replies (1,0) can become (1,1) by exchanging 0/1 only on the second reply. With one common but constant encoding, the same unequal replies also become equal. The latter two misleading agreements are actual recorded paths in the checks, not false readings of their encoded outputs. Their original resident records remain in the whole. Source retention does not make the final observation sufficient for the original question.

There is a sharper one-sided result. Commonality of c alone already makes unequal encoded replies certify h(p)≠k(p), hence failure of commutation. Injectivity is needed to interpret equality as a positive certificate, not to interpret an observed inequality as a negative one. The even-relative premise is unnecessary for this negative side too: every permutation commuting with W must preserve its unique fixed point. Moreover full injectivity is only a sufficient condition: reflection of equality on the actually admitted pair family is enough. The next question is how an internal contact can establish that restricted reflection without first calibrating the entire encoder; M64h supplies a local return construction.

**Point acquisition of a relative contact without separate channel calibration.** The two-channel relation can also acquire selected values of the relative map itself. Let A and B be two addressed n-element input sets, n≥2, and let h:A→Y and k:B→Y be unknown fixed injections. The participant may query h(a) or k(b), retaining the returned token. Tokens are compared only by equality; no output coordinate system or inverse-channel operation is provided. A query costs one acquired point reply. Equality comparisons, record processing and preparation costs are not part of this count. Every query retains both channel laws and the earlier records throughout this inquiry. Let T⊆A be a specified m-element target set.

First suppose the full images are the same n-element set C. C can be a proper finite region of an arbitrarily large Y; the whole is not assumed finite. The required answer is the addressed list

    (k⁻¹h(a)) for a∈T.

Neither channel is to be individually identified. The exact deterministic worst-case point-query count is

    0,                         if m=0;
    n−1 + min(m,n−1),           if 1≤m≤n.

For 1≤m<n, query h at every target and k at any n−1 distinct inputs. Compare the acquired tokens. A target token found in those k replies has its input. Any target token not found must be the value at the sole unqueried k input, by the common full-image premise. There can be at most one such target token, since h is injective. This gives n−1+m replies.

For m=n, query n−1 inputs of each channel. Their two acquired image sets have size n−1 inside C. If the sets coincide, their missing h and k inputs correspond to the same remaining token. If they differ, their intersection has size n−2: the sole h-only token belongs to the missing k input, and the sole k-only token belongs to the missing h input. All other pairs are matched by equality. This determines the full relative permutation using 2n−2 replies, even without naming the token omitted by both.

For the lower bound, every successful transcript requires at least min(m,n−1) distinct h queries. Otherwise a target a and another input a′ are both unqueried; exchanging their h values preserves every reply and the full image but changes the required answer at a. Independently, choose one target a₀. Even if the entire h table is provided for free, an adversary can defer the k reply equal to h(a₀) until all but at most one k input have been queried. With two k inputs still unread, the corresponding two completions give different answers at a₀. Thus some transcript needs at least n−1 k queries. The first lower bound holds on every successful transcript, including this one, so the bounds add. Both arguments apply to adaptive choices of inputs and channel order. They are worst-case counts, not expected search times.

The algorithm uses no absolute output labels. A fixed common injective encoding of the replies preserves all its tests. Different encodings at different calls, a changing channel law, or a comparison that merges relevant tokens change the admitted inquiry. M64g/h and M64as already expose those independent obligations. The abstract inverse in the answer specification is never used as an available primitive.

**Removing common-image admission changes the exact cost.** Now allow all injections h,k into a fixed Y with at least n+1 elements, without requiring their images to agree. The target answer at a is the unique b with k(b)=h(a), if one exists, and an explicit absence answer otherwise. For 1≤m≤n the exact worst-case cost is

    n+m.

Query all m selected h inputs and every k input, and compare the tokens. This suffices. For necessity, every selected h input must be queried. If a selected value is unread, hold k and every other h value fixed. At least two outputs remain available to that h entry, and at least one lies in k(B), since the other n−1 h entries cannot cover all n values of k. These choices change either the matched b or presence versus absence, preserving all recorded replies and injectivity.

Even with h known for free, a fixed target token can remain unseen in the first n−1 distinct k queries. There are then completions in which the last input returns this token and completions in which it returns another unused token. Both exist because |Y|≥n+1. Hence some successful transcript requires all n k queries. Again the h lower bound holds on that transcript, proving the sum. The extra possible token is a relation inside the same Y, not an external source or a loss of information.

On two inputs the difference is concrete. Take three distinct outputs a,b,c. The sources

    h=(a,b), k=(b,a),      and      h=(a,b), k=(b,c)

give the same replies h(0)=a and k(0)=b. The first matches the target to input 1; the second has no matching k input. Reading k(1) separates them. Their internal tables and all earlier records can remain intact. Knowing both input inventories and injectivity does not supply equality of their images. Conversely, an independently supplied construction of both channels on the same complete carrier makes the shorter inference legitimate without demanding a fresh exhaustive calibration.

The stronger question “are h(A) and k(B) the same set?” has exact worst-case cost 2n in this open-image access model. In fact every positive transcript must read every input of both channels. Starting from equal full images, change any unread entry of one channel to a fresh output outside that image. Injectivity and all replies remain, but image equality becomes false. Full acquisition attains 2n. This is a different question from locating the m requested matches; its cost must not be imposed on a task for which those matches suffice.

Thus a shared full image saves one reply for 1≤m<n and two replies for m=n, compared with answering including possible absence. Certifying that shared image from arbitrary injection tables is a separate task, not a status that the matching procedure silently grants itself. These are exact counts for the declared nondisturbing point interface. They do not bound energy, running time, all possible instruments, or an inquiry in which an act changes an untracked channel.

With no supplied finite complete inventory of k inputs, point replies alone need not certify absence at all. In the open-injection model with infinitely many available inputs and enough output values, any finite transcript that has not encountered a target token admits two injective extensions: one assigns it to an unread input, the other keeps it outside the k image. A witnessed matching pair still certifies its own positive answer immediately. This is a distinction between the two questions, not a general claim that every negative conclusion needs a full model. An impossible equality between already established answers can still be excluded locally by M71.

**The new finite construction keeps the missing reply outside the decoder.** `RelativeChannelAcquisition` represents two resident two-entry tables and an arbitrary retained history. Two first-entry projections are jointly archived; the second k entry is acquired later from the same actual retained source. `RemainingMatchFromFacts` receives only the old reply-pair fact and this new fact. It reconstructs the pair consisting of the original target token and the newly observed k token. `MatchFactors` derives its equality with the independently defined source reading. Neither the unread second h entry nor either table is a decoder input. The direct reading and the decoder use one question name, with its meaning fixed by their displayed projections; the name alone does no proof work.

Five positive declarations cover the identical initial facts, actual refinement, preservation of both tables and history, irrelevance of the unread h entry, and the matching common-image example. Two refusals reject asserting the unmeasured match on the open-image counterexample and supplying the old fact where the decoder requires both facts. This establishes the finite acquisition and refusal boundary. The arbitrary-n query minimum is the argument above, not a Swift protocol asserting an optimal search algorithm or an unperformed runtime scan. The comparison-based procedures and adversaries are given directly; no independent priority over matching or search results is asserted.

The target-orbit construction in VC12 and the earlier M64ae tell which relative values a future action needs. This result prices acquiring selected values through two actual unknown channels instead of granting a relative-map oracle in advance. A known action on their shared output region can be folded into h before this inquiry only when that composite point contact is itself available and the stated image relation survives. Otherwise it introduces another acquisition or admission question.

### M64h

**M64h (acquired local returns reflect a distinction without global calibration).** Let a,b belong to one carrier X. Both pass through a common function c:X→Y, giving y₀=c(a), y₁=c(b). A common return function d:Y→X is available, but is not assumed to invert c. Two local comparisons actually acquire

    e₀ = [d(y₀)=a],    e₁ = [d(y₁)=b].

Each comparison uses its retained original input and the actual returned value. The receiving answer reader obtains only (y₀,y₁,e₀,e₁), not a,b or the tables c,d. The original question is whether a=b. The resulting rule is

| Acquired relation | Answers still possible for a=b |
| --- | --- |
| y₀≠y₁ | false |
| y₀=y₁ and e₀=e₁=true | true |
| y₀=y₁ and e₀≠e₁ | false |
| y₀=y₁ and e₀=e₁=false | false or true in the unrestricted carrier class |

The first row follows from functionality of the common c. For the other rows put y=y₀=y₁ and z=d(y). Both successful returns give a=z=b. Different echo bits say that exactly one input equals z, so the inputs differ. Both failed returns only place a,b in X\{z}. This is the shared-decoder argument of M71 applied to actual local return records. It does not require c or d to be injective, surjective or globally calibrated.

The last ambiguity is exact for the class of arbitrary common functions on a carrier with at least three elements. Choose c constant at y and d(y)=0. Inputs (1,1) and (1,2) give the same displayed observation and opposite answers. This construction works for each available label y; the displayed singletons are forced in their respective nonempty classes. Further established restrictions may shrink these classes. In particular, on a two-element X two failed returns with the same y force both inputs to be the sole element other than z, so that row becomes true. It would be incorrect to export the unrestricted ambiguity after adding this bound.

An entirely collapsing forward channel can therefore support a positive answer for a particular pair. With c constant 0 and d the identity on four labels, inputs (0,0) give two successful local returns. Nothing here recovers an untested input such as 1. Inputs (0,2) give different echo bits and a negative answer despite the identical forward records. The new distinction comes from the actual comparisons to the retained originals; it was not manufactured by more processing of the old encoded pair alone.

The common-return premise is substantive. With the same forward collapse, use d₀(y)=0 at the first site and d₂(y)=2 at the second. Inputs (0,2) now give two successful returns, although they differ. A common container holding both maps does not turn these two readers into one function d. Likewise, the name of one changing device does not establish that its two occasions realize the same input-output relation. The local comparisons also have a specified equality meaning; their correctness has not been derived from the mere presence of two signals called echo bits.

`LocalProbeEcho.swift` continues the actual paired acquisition of M64g. Both return reads use the same resident D field. Each local comparison reads its original probe fact and its returned value through the existing four-label equality clauses. Their answers are recorded together without requiring either success from the caller. The final memory exposes the forward fact and the new echo fact; both tables and the original raw facts remain in the retained whole, outside that memory.

`LocalEchoAnswer.swift` composes the existing coordinate clauses and binary table selection into a fact-only reader. Its answer has two admission fields, for inequality and equality: (1,0), (0,1), or (1,1). The last is a pair of surviving answers, not a negative verdict or a separate proof status. `LocalEchoDecision` links this reader to the actual acquired memory and records its result while retaining the acquisition.

`LocalEchoCalibration.swift` constructs all sixteen ordered raw reply classes through the constant forward table and the identity return table. The four echo-bit patterns are derived by actual comparisons. The (1,1) and (1,2) raw cases have exactly the same complete decoder input and leave both answers admitted. A second positive construction changes both hidden resident laws and both channel tables while preserving that positive memory. Thus the positive observation does not identify these components. The checks also acquire unequal encoded replies and construct the two-different-return-map counterexample above.

The generic composition interfaces can express readers outside the shared finite table grammar. Their successful typechecking alone does not certify that interpretation. The split-return example intentionally uses this larger grammar: its recorded bits are true and the mechanical completion table outputs equality, but that conclusion disagrees with an independent canonical comparison of its raw replies. The refusal checks the attempted equating of those answers. It is not a claim that Swift automatically rejects every such out-of-scope application before that obligation is posed.

For M64g take a=k(p), b=h(p). A singleton equality answer establishes the desired commutation under its even-relative premise. A singleton inequality excludes commutation without that parity premise. The ambiguous result leaves both possibilities in the admitted four-point family. The claim concerns these acquired occurrences; reuse at a changed source still needs the preservation or transport relation from M64c. No global recovery, unobserved future agreement or physical clock accuracy is inferred.

### M64i

**M64i (exhaustion by common returns; the origin need not be known).** Let X be the complete admitted carrier of n≥1 possible values of two retained originals a,b. A paired comparison at a common target t acquires ([a=t],[b=t]). The receiver obtains these bits, without a,b or the absolute target label. Targets may be selected adaptively from an available family O⊆X, but selection has no other access to the originals or additional source-dependent feedback. Moving between targets has no query cost in this model. Repeated queries do not create new target values.

For a list of distinct queried targets Q, define its signature

    s_Q(x) = ([x=t]) indexed by t in Q.

Each member of Q has its own one-hot signature. Every member of X\Q has the all-zero signature. Consequently

    s_Q(a)=s_Q(b) determines a=b for all a,b in X
    iff |X\Q|≤1.

This is a factorization criterion for the equality question, not an assumption that the original values are known. It yields three stopping rules. Different bits in any round establish inequality. A round with both bits true establishes equality. If n−1 distinct rounds all return two false bits, both originals must be the sole unqueried value, so they are equal without any successful return.

Exact decision for all a,b using O is possible iff |X\O|≤1. When it is possible, its minimum worst-case number of paired queries is n−1 (zero when n=1). For the upper bound query any n−1 available distinct targets. For the lower bound follow the adaptive history consisting solely of two-false replies. Before n−1 distinct targets have been queried, at least two values u,v remain. Originals (u,u) and (u,v) give the same history and opposite equality answers. The same initial target, target mechanism and other available resources can be held fixed in those two realizations. Repetition or stopping sooner cannot distinguish them. This bound does not apply to an interface which additionally reads an original or lets its unobserved value choose a target for free.

Suppose now the common targets are U^j(t₀), where U is one known permutation and t₀ is unknown. At that origin the exact condition becomes |X\orbit_U(t₀)|≤1. For n≥3 a uniform guarantee over every possible origin holds iff U is an n-cycle. If U has two or more cycles, a shortest one has at most n−2 members, leaving two unqueried values at an origin in that cycle. For n=2 either permutation suffices: one paired query leaves at most one other value. No absolute origin is required by the decoder.

A full cycle is sufficient, not necessary when the origin is restricted: an orbit containing n−1 values also suffices. More generally a known cycle is not required if the actual queried set Q already has the stated coverage. Establishing that coverage is a separate contact or structural obligation; the number of written records alone does not establish it.

For four labels `EchoOrbit.swift` builds the table (1,2,3,0) from three existing coordinate exchanges. It then applies this fixed table to each current return VALUE. This differs from reordering the input positions of an unknown d table: reordering a constant table leaves its returned value unchanged, whereas applying U to that value changes 0 to 1.

The seed is actually read through the return channel after the paired resident acquisition. `PrepareEchoOrbit` keeps that whole acquisition beside the seed and the cycle resource. `EchoOrbitRound` compares the same two retained originals with one shared current value, using the existing local comparison construction. Its actual advance reads U at that value and preserves both the raw-source archive and U. `ThreeEchoRounds` performs three comparisons with two intervening advances; earlier facts travel beside later actions. The original resident probes are not repeated.

`EchoOrbitAnswer.swift` reads only the three acquired echo facts and fixed comparison resources. It compares the two bits within each fact and conjoins those three answers. Under the displayed coverage criterion, this is exactly equality of the originals. `EchoOrbitDecision` binds that reader to the actual three-round path and retains the acquisition.

`EchoOrbitCalibration.swift` constructs all sixteen raw reply-class pairs with the same four-cycle. The actual answer matrix is the diagonal equality table. For originals (3,3) and seed 0, the three targets 0,1,2 all fail for both originals, yet the acquired verdict is positive. Originals (2,2) and (2,3) have exactly the same first two facts; the third fact and final verdict separate them. This supplies the finite witness of the lower bound.

Another actual path changes the seed to 1 and both originals to 0. Its three targets 1,2,3 also all fail. Its complete receiver input is identical to that for originals (3,3), seed 0. Thus the answer does not identify the absolute origin or the original values. Within one privately fixed origin, however, the length-three signature identifies each value relative to the orbit; it would be incorrect to call it intrinsically less informative than that relative identification.

The checks replace the cycle by the actual exchange (0 1). Targets 0,1,0 then leave originals 2 and 3 forever untested. For the unequal pair (2,3) the complete three-fact memory equals the positive full-cycle memory above. The mechanical conjunction still outputs true, but its proposed equality interpretation fails against the independently constructed full-cycle answer for the same originals. This is a failure of coverage, not a false echo record. The generic interfaces can express both paths; the certified interpretation must remain bound to the path supplying its coverage.

The theorem measures paired comparisons, each with two local results; it does not assert a minimum number of primitive contacts or a duration. The originals are preserved in an internal archive, so these paths answer the original question. They do not infer the same answer at an arbitrarily changed current source. The next acquisition question is whether the required distinctness of the targets can itself be obtained from their retained contacts, without knowing the law U in advance.

### M64j

**M64j (acquire coverage from recorded returns, without a known generator).** Retain the originals a,b and each of three actually used common targets t₀,t₁,t₂. Before changing a target, acquire both its paired echo ([a=tᵢ],[b=tᵢ]) and a private record of that target. Later comparisons read those retained target records, giving

    c₀₁=[t₀=t₁], c₀₂=[t₀=t₂], c₁₂=[t₁=t₂].

The receiver is given only the echo bits and these three comparison bits. It receives neither the target values nor the law that generated them. Assume the originals and targets all belong to a carrier with at most four values. On the unresolved branch where all six original-to-target echoes are false, three false comparison bits force a=b. The targets are three different values, and at most one other value is available for both originals. This is M64i's coverage condition acquired for the actual trial.

If a target repeats, the same branch can remain undecided. On the full four-value carrier, targets (0,1,0) and originals (2,2) or (2,3) give the same complete visible evidence and opposite equality answers. Thus, in the class retaining arbitrary four-value realizations, the exact answer set for this all-false branch is {true} when the three targets are pairwise distinct, and {false,true} when they repeat. The local TT and mismatched-echo branches retain their earlier answers from M64h; they do not need this additional coverage acquisition.

The four-value bound has not been learned from three distinctions. With a fifth value, targets (0,1,2) and originals (3,3) or (3,4) give the same nine visible bits and opposite answers. That is a mathematical countermodel to dropping the bound, not an execution in the four-address Route grammar. The bounded carrier is the declared value space of this question. It need not be the full physical or retained source, whose other fields can vary.

No fixed, reversible or known generator is required for the displayed implication. Its obligations concern the actual common targets, the preserved originals, their records and the meaning of the comparisons. Changing a target after its recording does not change that record. Reading the final current target in place of an earlier record would be a different contact and can give a different answer. A known inverse law is not used to reconstruct the earlier targets for these comparisons.

`ReturnTargetEvidence.swift` reads three private facts, each containing (paired echo bits, actual target value), from their addressed positions in the final recorded path. `AcquireReturnCoverage` then performs and records the three comparisons of their target fields through the existing finite equality clauses. A further recorded reading transmits only the echo bits and comparison bits. All private target records remain in the whole.

`ReturnCoverageAnswer.swift` supplies the `UnmatchedReturnAnswer` clause. Its input must actually carry three two-false echoes; this is a condition on the acquired data, not a supplied positive conclusion. Its fixed table reads the target-comparison bits and retains either the equality answer alone or both answers. `ApplyReturnCoverage` binds that reader to the actual transmitted record and records the result. The other echo branches are not newly reimplemented by this all-false clause.

`ReturnCoverageCalibration.swift` records targets before the intervening changes in three actual paths. Targets 0,1,2 yield equality for originals 3,3. A second path resets the target after its second comparison, giving 0,1,0. Originals 2,2 and 2,3 then have identical transmitted facts and retain both answers. Their original echo bits alone also agree with the positive path; the newly acquired target relations distinguish its applicability.

`ChangingReturnCoverage` uses two different non-injective generator tables: one sends every value to 2, the next sends every value to 1. Starting at 0, this produces recorded targets 0,2,1 for originals 3,3. Their three acquired comparisons establish sufficient coverage. The complete visible fact is identical to the positive 0,1,2 path, and the same answer reader applies. Earlier values survive in the private records despite the local non-injectivity of these changes. The first generator action itself differs between the two paths and is not identified by that visible fact.

The checks preserve arbitrary extra laboratory state, reject replacing an earlier target by the current one, and reject strengthening the repeated target observation to equality. The known values in these finite calibrations serve to construct and verify the actual acquisition paths; they are not parameters secretly passed into the receiving answer reader. The general implication is the exclusion argument above and applies to any generator preserving the stated acquisition relations. As in M64h, arbitrary `PredicateReading` conformances are not certified by sharing a name with the finite comparison clauses.

There is a useful further reading of the positive branch. Its support consists of nine inequalities: the three targets are mutually different, and each original differs from every target. Within a four-value carrier these relations force the missing equality between the two originals. This suggests asking whether the same support can be acquired through individually uncalibrated local encodings, and how many inequality contacts are indispensable for such a forced equality. It does not assume the answer to either acquisition or minimality question.

## Cross-page mentions

Labels mentioned here: <doc:permanence_is_resistance__retention#M60>, <doc:permanence_is_resistance__reusable_requests#M64ae>, <doc:permanence_is_resistance__reacquisition_residue#M64as>, <doc:permanence_is_resistance__forced_answers#M71>, <doc:verdict_is_invariant__local_lifts#VC100>, <doc:verdict_is_invariant__bounded_calibration#VC107>, <doc:verdict_is_invariant__finite_records#VC12>, <doc:verdict_is_invariant__local_lifts#VC99a>.

Mentions of this page’s labels: <doc:permanence_is_resistance__contact_rigidity> (M64d), <doc:permanence_is_resistance__contact_rigidity> (M64g), <doc:permanence_is_resistance__contact_rigidity> (M64h), <doc:permanence_is_resistance__contact_rigidity> (M64j), <doc:permanence_is_resistance__reacquisition_residue> (M64a), <doc:permanence_is_resistance__reacquisition_residue> (M64b).
