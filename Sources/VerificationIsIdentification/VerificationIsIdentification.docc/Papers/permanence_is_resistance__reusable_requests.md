# Permanence Is Resistance (Matter) — Reusable requests

This part contains the original derivations for reusable requests.

Family and original section headings: <doc:permanence_is_resistance>.

Section setting: <doc:permanence_is_resistance#4g-Which-future-must-carry-a-real-distinction>.

### M64z

**M64z (the number of mutually sufficient coordinates forces an incidence geometry).** Let S have q² elements and let k≥2 readings C₁,…,C_k each take values in a q-element alphabet, q≥2. Require each joint reading (C_i,C_j), i≠j, to be injective. Its domain and codomain have the same finite size, so it is bijective. Every answer fiber of every C_i has q rows.

For one C_i, exactly q·q(q−1)/2 unordered row pairs agree on its answer. No row pair may agree in two coordinates, since that would violate joint injectivity. Comparing with the total q²(q²−1)/2 row pairs gives

    k ≤ q+1.

When k=q+1, every pair of different rows agrees in exactly one coordinate. Take rows as points and answer fibers as lines. Two points then determine exactly one line. The q lines of each coordinate partition S; lines from different coordinates intersect in exactly one point, by joint bijectivity. A point outside a line lies on exactly one disjoint line, namely the fiber of that same coordinate through the point. Since q≥2, there are noncollinear points. Thus the saturated reading family has precisely the incidence structure of a finite affine plane of order q. Conversely its parallel classes give these q+1 readings. Existence of such a saturated family for an arbitrary q is not being assumed by the bound or the equivalence.

For q=2 the three charts in M64w attain the bound. A fourth binary coordinate cannot form a rectangle with all three on the same four rows. More directly, after fixing Y=(0,1,0,1), Z=(0,0,1,1), a binary fourth coordinate forming rectangles with Y and Z must be (a,b,b,a) with a≠b. It then agrees in pairs at the same row addresses as X and cannot distinguish rows jointly with X. `FourthProfileCoordinateObstruction` derives those colliding keys for arbitrary choices of the two contents; the binary argument supplies the exhaustion of candidates.

This is an incidence conclusion from finite, equally sized alphabets and exact pairwise sufficiency. No distance, angle, physical dimension, or global structure of reality is inferred. M64v's adaptive access is a different object from one extra coordinate in this theorem. More coordinates may also be used when only selected pairs, rather than every pair, are required to identify the rows.

The upper bound also applies to a chosen q²-row subfamily of a larger source. Extra hidden rows cannot repair a collision already forced on those rows while preserving their readings and the stated alphabets. The affine-plane conclusion describes the restricted family; it does not assert that these rows exhaust a physical carrier.

### M64aa

**M64aa (one missing coordinate is forced by the remaining relations).** Under M64z's finite reading contract, suppose exactly q pairwise sufficient coordinates have been supplied. For rows a,b define

    a ~ b  iff  a=b or C_i(a)≠C_i(b) for every supplied i.

This is an equivalence relation with q classes of q rows. Its classes give the unique additional coordinate, up to renaming its answers, that forms a sufficient pair with every supplied coordinate.

To prove it, the q answer fibers through a meet only at a. They contain 1+q(q−1) rows in total. Let U_a be the q−1 rows outside them. Take b∈U_a. For any coordinate j, its fiber through b misses the j-fiber through a and intersects each of the other q−1 fibers through a in one point. These intersection points are distinct, since those fibers intersect only at a, which is not on the fiber through b. Together with b they fill that q-point fiber. Therefore no other member of U_a lies on any fiber through b. The q rows {a}∪U_a are pairwise different in every supplied coordinate. Their sets agree when based at any member, so they partition S. Each such class meets each old answer fiber once, establishing all new sufficient pairs. Any possible new answer fiber through a must consist of a and q−1 members of U_a; its size q forces exactly this class. This proves existence and uniqueness, rather than only a numerical upper bound.

The construction uses only equality relations, not chosen numerical labels. A row correspondence preserving each supplied coordinate's equality relation also preserves ~. Thus independently relabeled old coordinates transport the additional equality question without choosing an absolute label for its new classes. This derives a new organization of already established distinctions; it supplies neither new evidence about an unmeasured source nor an independently available physical instrument for that coordinate.

One fewer supplied coordinate does not have the same extension guarantee. On the sixteen rows (x,y)∈{0,1,2,3}², let X=x, Y=y and Z=x+y modulo 4. Every pair among these three readings is bijective. There is no fourth four-valued reading forming sufficient pairs with all three. If it existed, any one of its four-row fibers would use every X, every Y and every Z value exactly once. Summing X+Y modulo 4 over that fiber gives 6+6=0 modulo 4, whereas summing the required four Z values gives 6=2 modulo 4. This is impossible. The obstruction is a finite joint relation even though every old pair works.

These finite-geometry connections are established mathematics, not a priority claim for VI. In the language of nets, M64z identifies the zero-deficiency case and M64aa completes deficiency one. Bruck's [Finite nets. II. Uniqueness and imbedding](https://msp.org/pjm/1963/13-2/pjm-v13-n2-p05-p.pdf) gives a broader completion theory; its introduction (pp. 421–423) and Theorem 4.3 distinguish uniqueness from guaranteed existence. The arguments here derive the stated special cases directly from the reading contract. The four-row obstruction has a static field certificate; the general counting, completion and modulo-4 argument are mathematical proofs here, not claimed as generic Swift theorems.

### M64ab

**M64ab (one successful joint change need not be a reusable generator).** There is a useful larger family where the binary permission in M64y can be tested for accidental strength. Let q≥2 and work with the cyclic alphabet Z/qZ. Rows are (i,z). Suppose

    X(i,z)=i+a_z,    Y(i,z)=i+a_z+σ(z),    Z(i,z)=z,

where a is arbitrary and σ is a permutation of the q symbols. All three coordinate pairs identify the q² rows. Change X and Y inside fiber z by additions u_z and v_z respectively. Then

    a'=a+u,      σ'=σ+δ,      δ=v−u.

The change preserves release at this particular source exactly when σ+δ is a permutation. It preserves release for every source in this family exactly when δ is constant. A constant shifts all σ values equally, so suffices. If δ_z≠δ_w, choose two different permutation values with σ(z)−σ(w)=δ_w−δ_z, and complete them to a permutation. Their updated values coincide. This supplies the necessary witness for every nonconstant δ, including composite q.

Consequently there are q^q·q! admitted one-step action pairs at a fixed valid source, but only q^(q+1) pairs uniformly preserving the whole family: u is arbitrary and v=u+c for one common c. The latter form a group under addition and are therefore reusable under arbitrary finite composition. Independent local permission sets containing idling and allowing every combination have size at most q²: with the partner idle, each permitted local vector must be constant. Independent constant shifts attain q². This is a classification in the displayed cyclic-translation interface, not in the larger class of all possible within-fiber permutations from M64x.

At q=2 the fixed-source and uniform counts coincide. At q=3 they do not. Start with a=0 and σ(z)=z; apply u=0, v_z=z. The first result has σ'(z)=2z, still a permutation. Apply the same action again: σ''(z)=0, so XY loses all distinction between rows sharing i, while XZ and YZ remain complete charts. Both individual applications are actual reversible permutations of the complete source; the second fails only the stronger common-coordinate release question. Thus a certificate established at one current source cannot be promoted to a source-independent reusable command.

For q=3 every σ has the form az+b with a∈{1,2}. In this subcase the next addition v_z=z is admissible exactly when a=1. The required answer is one binary orientation, although one point query σ(z) leaves both orientations possible; two distinct point queries decide it. After the admitted change a becomes 2. A known inverse change can recover the previous prepared family using the still available XZ or YZ access. No fresh source reading is needed to derive that known update from its valid earlier record; unreported partner changes would alter the premise.

`CyclicProfileRepeatBoundary` constructs the three complete source endpoints by permutations of addressed triples, carrying X and Z through every change. It derives the two complete XY key sets, the threefold repetition of keys after the second change, and the inverse word returning the prepared source. Interpreting three distinguished symbols cyclically supplies the displayed modulo-three instance; no runtime arithmetic or search is used by that certificate.

The same witness gives two individually closed controllers with an unsafe shared execution. Each isolated controller keeps a private forward/reverse marker, applies the forward word at the forward state and its inverse at the reverse state, and updates its marker. Its own source/marker relation closes under this two-step cycle. Start two such controllers at the same forward source with separate forward markers. The first changes the device to reverse and updates only its own marker. The second still selects the forward word from its private marker, reaches the collapsed source, and changes its marker to reverse. Both markers now say reverse; the device is not in that state. `TwoCyclicControllers` constructs the isolated return, unchanged partner marker and complete shared endpoints. The two selected applications have the same operation expression and correctly connected actual source endpoints. It is their private phase applicability that fails. The control boundaries are the supplied words; no physical atomicity of a multi-contact word is inferred. This answers the composition question without treating local closure as a shared permission.

### M64ac

**M64ac (removing the cyclic source law changes the reusable permission).** Return to all q-permutation families (τ_z) whose graphs partition X×Y, with q≥3. Fix within-fiber permutations u_z of X and v_z of Y, chosen independently of the unknown family. They preserve this partition for every admitted family iff u_z=U and v_z=V are each constant across fibers. Thus the uniform fixed action group in this full interface is S_q×S_q. Within the translation subinterface of M64ab this leaves only the q² pairs of global constant shifts, rather than its q^(q+1) permissions under the additional cyclic source law.

Here is a direct necessity proof. Any two pointwise-disjoint permutations p,r can be completed to an admitted family: their graphs are disjoint perfect matchings of the complete bipartite graph X×Y. The remaining graph is regular. To see that a positive-degree regular bipartite graph has a perfect matching, take a maximum matching. If it leaves a left vertex unmatched, follow alternating paths from it. Every reached right vertex must be matched, or such a path augments the matching. Their matched partners are exactly the reached left vertices except the initial one. But all neighbors of a reached left vertex are reached, and regular edge-counting requires at least as many reached right vertices as left vertices, a contradiction. Removing a perfect matching and repeating decomposes the remainder. This supplies the completion used below without assuming an unknown Latin completion as an additional premise.

Fix fibers z,w and an output x. Put a=u_z⁻¹(x), b=u_w⁻¹(x). If a≠b, choose a value y and t=v_w⁻¹(v_z(y)). Since q≥3 there is a permutation p with p(a)=y and p(b)≠t. Choose a derangement d with d(b)=p⁻¹(t), for example a q-cycle with that directed edge, and set r=p∘d. The old p,r are pointwise disjoint, but the two updated maps agree at x. Complete them as above to obtain a valid old source with an invalid new release. Hence a=b for every x, giving u_z=u_w. With this equality, if v_z≠v_w, choose y with t=v_w⁻¹(v_z(y))≠y and disjoint p,r taking the common input to y,t. Their changed answers again coincide. Thus v_z=v_w. Sufficiency follows immediately by applying common bijections to both sides of every joint reading. The use of a third symbol explains why this necessity proof does not apply to M64y's binary exception.

For a concrete check of the missing premise, take q=3 and τ_z(x)=−x+z. These maps form an admitted partition. The equal local translations u_z=v_z=z have δ=0 in M64ab, but here they give τ'_z(x)=−x+3z=−x. The future XY keys merge across all Z fibers. The cyclic source law cannot be discarded while keeping its larger uniform permission.

This need not force isolation. For a known local action u_z, the source-dependent choice

    v_z = τ_z ∘ u_z ∘ τ_z⁻¹

retains τ'_z=τ_z exactly, without assuming an additive coordinate law. It is the same addressed row action expressed through the other chart. To choose v_z, determining the whole τ_z may be unnecessary. Two maps τ,ρ give the same required v exactly when ρ⁻¹τ commutes with u. For a transposition of a,b, the answer is just the unordered pair {τ(a),τ(b)}. Its direction inside the pair is irrelevant.

For three ports, one point query at the remaining port c determines this pair as the complement of {τ(c)}. With no query all three remote transpositions remain possible, so one is the exact minimum in this point-query interface. Two possible frame laws remain after every reply, but they prescribe the same action. For q≥4 two point queries attain the answer; one cannot decide it, since at least one unread input inside the requested pair and one outside can be exchanged without changing the reply. At q=2 no query is necessary.

`ThreePortSharedCoupling` supplies all six frame clauses on arbitrary payloads. It acquires the fixed-port image at the actual retained frame, routes only that fact and the supplied payload through one three-clause selector, and keeps the frame and fact beside the result. `SixActualCouplings` derives agreement with the requested local swap for all six clauses; neither the other two unknown frame entries nor an output-equality premise is a selector input. `CurrentFixedPointFactors` derives applicability of the same fact after this supplied update. These source-bound constructions execute the remote half of the three-port coupling and compare it with the requested local action through the retained frame. They do not also construct a changed raw table of both physical charts or an asynchronous delivery mechanism. The universal classification over q and all permutation families is the mathematical proof above; it is not a sealed Swift grammar for arbitrary user-defined readings or a physical delivery protocol.

### M64ad

**M64ad (a known change can change the question that the old fact must answer).** Fix a finite permutation group G, an unknown frame τ∈G and a requested local action u∈G. The remote action required by M64ac is

    Q_u(τ) = τuτ⁻¹.

Let H=C_G(u) be the permutations commuting with u. Two frames τ,ρ have the same Q_u exactly when ρ⁻¹τ∈H. The sufficient record for this one action therefore distinguishes right cosets τH, not necessarily individual frames. This describes the content of a record; it does not assume that the observer already has an instrument reading it.

Now let the actual frame change be τ'=βτα⁻¹, with the applied α,β known. Here this is one fixed change admitted for every candidate τ; an unspecified source-dependent map is not a free extra input. Then

    Q_u(τ') = β Q_(α⁻¹uα)(τ) β⁻¹.

The output change β always transports a known remote action by conjugation. The input change α can demand a different old question. For every τ, Q_u(τ') is determined by Q_u(τ), α and β exactly when

    α ∈ N_G(H),       equivalently α⁻¹Hα = H.

*Proof.* Replace a candidate τ by τh, h∈H, which leaves the old record unchanged. The new answers agree for every such h precisely when h commutes with α⁻¹uα. Its centralizer is α⁻¹Hα. Thus the criterion is H⊆α⁻¹Hα. Since G is finite the two subgroups have equal size, so this inclusion is equality. Conversely that equality makes the new answer independent of the representative of every old coset, and defines the required decoder on the realized records. This proves factorization; the finite constructions below provide particular decoders and acquisitions. It does not assign zero cost to obtaining the actual change α,β.

Preserving the old answer itself is more restrictive. With β=id, Q_u(τα⁻¹)=Q_u(τ) for every τ iff α∈H. Normalizing H allows a derived change of the answer, not necessarily an unchanged answer.

For a transposition u=(a b) in S_q, q≥3, H consists of permutations preserving the pair {a,b} and its complement separately. Its orbits on ports have sizes 2 and q−2. A normalizer must permute those orbits. When q≠4 their different sizes force it to preserve each, so N(H)=H. At q=4 the two orbits have equal size. Their exchange also normalizes H, giving eight allowed input changes instead of four. If α exchanges the two pairs, the new remote transposition exchanges the complement of the old remote pair. Thus the old action suffices for a different action without identifying the frame or making a new contact. A change mixing the pairs fails the criterion. At q=2 every frame gives the same sole transposition, and no frame acquisition is needed.

### M64ae

**M64ae (admitted changes determine the least reusable frame content).** Keep the finite group and fixed request of M64ad. Allow every finite word in a specified reversible input-change vocabulary, generating D≤G. The actual word's resulting d∈D is an available input at use. Acquire a record before that word; require it to answer the same local request after every such change. Two old frames may share a record exactly to the extent that their relative permutation belongs to

    H_D = ⋂_(d∈D) d⁻¹Hd
        = C_G(⟨d⁻¹ud : d∈D⟩).

Consequently the least sufficient record has |G|/|H_D| different answers. This is a closed-form instance of VC15/VC38's continuation quotient, not a second saturation algorithm or a new general minimization theorem.

*Proof.* For each available d the required answer is τd⁻¹udτ⁻¹. Replacing τ by τh preserves all these answers iff h commutes with every d⁻¹ud, equivalently with the subgroup they generate. This gives exactly the intersection above. Jointly recording these required answers attains that equivalence. Any record merging two different classes fails on a specific admitted d which separates them. The intersection is invariant under conjugation by D, so later known changes act on its cosets without further refinement. The word history may still be needed for another question; this quotient retains its required effect only.

For G=S_q, q≥3, a transposition request and D=S_q, its conjugates are all transpositions. They generate S_q, whose center is trivial: commuting with every transposition fixes every unordered pair, and the intersection of {a,b} and {a,c} fixes a when b,c differ. Hence H_D={id}. The one-action record must refine to the whole frame if it promises reuse after *every known input permutation*. This does not require acquiring the whole frame for a single actual future use. Once that particular change is known, a new question-specific contact can suffice, as M64ag constructs.

There is also a direct description for an arbitrary transposition request library. Draw a simple graph L on the q labelled local ports, with one edge for every requested swap. The answer retains the remote action of each labelled request, not just their unlabelled collection. Let e be the number of connected components consisting of one isolated edge, and r the number of isolated vertices. The unresolved frame group is exactly

    H_L ≅ (C₂)^e × S_r,

and the answer has q!/(2^e r!) possibilities. To prove this without a group enumeration, a relative permutation must preserve every edge as an unordered pair. Two incident edges fix their common vertex by intersection. Their other endpoints are then fixed, and this propagates throughout every connected component with at least three vertices. An isolated edge can still be reversed, and isolated vertices can be permuted freely. These independent changes also suffice to preserve every requested action.

Thus a full frame is determined iff e=0 and r≤1. At q=4, two overlapping requests identify all four ports; two disjoint requests leave four frames possible. The periods and number of the requests are identical. Their overlap is the distinguishing relation.

For q≥3 the fewest transposition requests which can identify a full frame is ⌈2(q−1)/3⌉. Indeed at least q−1 vertices must lie in components of size at least three. If they occupy N vertices and c components, at least N−c edges are required, while c≤N/3. Conversely partition q−1 vertices into triples, using one group of four or five when necessary, and put a tree on each group. This attains the bound; for q=3 use the two edges of a three-vertex path. This counts distinct action questions whose answers are supplied, not physical calls that acquire those answers.

This minimum is the known base size for S_q acting on two-element subsets: it is the k=2 case of [Halasi, Theorem 3.2](https://zhalasi.web.elte.hu/papers/05.ksets.pdf) for q≥4; the three-port case is given directly above. The graph proof identifies how that established result enters this acquisition question. No independent priority for the base-size formula is claimed.

The point-query cost is a separate quantity. Set m to the largest size among the r unused vertices, each isolated pair of size two and each individually fixed vertex of size one. On the unrestricted family of all q! frames, q−m point queries are necessary and sufficient to acquire this action-library answer. Query every port outside a largest such block. Its remaining images determine the answer, since all permutations within that block preserve every requested action. With fewer queries, more than m inputs remain unread. Two belong to different blocks, and exchanging their images preserves the entire transcript while changing a requested action. This argument applies at every reached adaptive transcript. It is the payload-class principle of VC100c with this graph-derived partition and *without* a known parity premise; the parity improvement there is not imported.

Even reaching every port does not force whole-frame saturation. On four ports let the admitted changes be powers of c=(0 1 2 3). For the request (0 1), its transported versions form the four edges of the cycle. Their overlap fixes every port, so the reusable record identifies all 24 frames and needs three point queries. For the request (0 2), the versions are only (0 2) and (1 3). They form two disjoint edges; the record has six answers, leaves four frames per answer, and needs two point queries. The same change group reaches every port in both cases. It is the orbit of the *question*, not point reachability alone, which determines the needed refinement.

For the opposite-pair request, only the parity of the actual power of c is needed at use: an even power preserves the old remote pair, an odd power selects its complement. One bit about the whole change word is sufficient and necessary in a change-only message channel, since identity and c require different actions at the same old record. Its complete count and order need not be sent. For the adjacent-pair request, all four powers demand different remote actions at each fixed frame; that same channel needs four possible messages. These are message alphabets for the actual effect of the change, not assumptions that its parity or phase is already known. Their acquisition and retention across the final cut remain subject to M64af. This also distinguishes the amount of initial calibration from the amount of later change information.

### M64af

**M64af (a last unobserved change differs from a known transport).** Suppose β=id and, between a record's last acquisition and the use, an unreported input change α from D≤G can occur, including identity. Even a full record of the previous τ cannot determine the new required action for every such α unless D≤C_G(u). Necessity follows by comparing the same old τ and history with α=id and with an α not commuting with u. Their required actions differ. If D≤C_G(u), they are equal and the old Q_u is sufficient; the full frame may change without changing this question.

In particular, in the three-port family arbitrary unreported frame permutations after the last read defeat any guarantee based only on that finite history and a subsequently chosen fixed remote swap. Doing one more read only moves the last-read boundary if the same intervention is still admitted afterward. This is a refusal for the declared read-then-use interface, not a prohibition on interaction with a changing source. A successful interface can restrict those final changes to the relevant stabilizer, supply their actual transport, or couple the selection and action to the current relation. Each is an additional realized relation to demonstrate. A timestamp, a private controller phase or the name “current” supplies none of them by itself. No external clock, fairness or atomic delivery is assumed.

M64ad and M64af have different inputs. A known pair exchange at q=4 can be decoded by taking the complement. If it might have happened but is unreported, the old and complementary swaps remain distinct possibilities. A harmless uncertainty is therefore relative both to the action question and to the participant's available change record.

### M64ag

**M64ag (actual reacquisition repairs the three-port crossing).** The old three-port frames τ₀=(0,1,2) and τ₁=(1,0,2) give the same fixed-port reply τ(2)=2. Change each actual frame by precomposing the exchange of local ports 1 and 2. The resulting frames are (0,2,1) and (1,2,0), whose fixed-port replies are respectively 1 and 0. The old record and the known change word are equal, but the remote swaps now required for the same local request (0 1) are (0 2) and (1 2). The old reply cannot choose between them.

`FrameProbeThenMove` composes the actual old acquisition with this actual resident-field change and retains its fact. `ThreePortInterference` derives equality of the two old fact inputs and of the change words, while exposing the two different current answers. `ReprobeMovedFrame` then acquires the fixed-port answer from the changed source. `ExecuteReprobedFrameSwap` passes only this new fact and arbitrary payload to the existing selector. Both branches give the required coupling at their actual current frames; the frame and both acquired occurrences remain beside the result. The new acquisition is one point contact with three possible answers, not three contacts or a binary bit. In this two-candidate subfamily it has two realized answers.

By contrast `FrameMovePreservesFixedPort` derives, for arbitrary three addressed contents, that exchanging the first two fields preserves the old fixed-port reading. It does not require equality of the complete old and new frames. Repeated such exchanges preserve that relation by composition, so this branch requires no new point contact. The supplied words terminate at specified use boundaries; they do not establish M64af's missing relation across an additional unreported change after the new contact. These static paths certify the instances just described. The group classifications and minimal request counts are the mathematical arguments above, not claims that the Swift checker enumerates arbitrary finite groups.

### M64ah

**M64ah (transporting the request can remove the need for more frame knowledge).** M64ad–ag keep the local request u fixed while the frame changes. This is the contract of using the same current local slots after a resident rewiring. It must not be confused with carrying the original addressed operation through a change of local coordinates. In that second contract the request changes together with the frame:

    τ' = βτα⁻¹,        u' = αuα⁻¹.

Substitution gives

    τ'u'τ'⁻¹ = β(τuτ⁻¹)β⁻¹.

The input change α cancels. Old knowledge of the one remote action therefore suffices for every such joint transport, with only the known output change β applied to it. Full frame identification is unnecessary. When β=id the very same remote command works. The formula does not require reconstructing α at the receiver if the joint request transport is actually enforced by the supplied process; it does require that relation, rather than an assertion that the request “must have moved too”.

For the stated bijective frames this request transport is also necessary if that transported remote action is required: multiplying τ'u'τ'⁻¹=β(τuτ⁻¹)β⁻¹ by the inverse frame maps forces u'=αuα⁻¹. Thus it is the unique compatible request, not a convenient extra choice that happens to make the example work.

With β=id, the whole joint family has a precise quotient. Two pairs (τ,u),(ρ,w) give the same remote action iff there is a unique α with ρ=τα⁻¹ and w=αuα⁻¹: set α=ρ⁻¹τ and substitute. Hence conjugated action is a complete invariant of this joint transport on G×G. The unidentified frame and moving request need not be known separately. Their preserved relation is sufficient. This statement concerns the supplied group interface; it does not classify arbitrary physical changes as coordinate changes.

For M64ag's exchange α=(1 2), the transported request is u'=(0 2), whereas its fixed-coordinate request was u=(0 1). The old remote swap (0 1) works in both changed frames for u', even though it works in neither for u. `FrameMoveTransportsRequest` derives the new middle-port reading from the actual changed frame and shows that its pullback is the old third-port occurrence for arbitrary contents. Thus correspondence is obtained from the constructed change, not from equal question names or a selected coincidence of payloads. `ExecuteMovedFrameSwap` then implements both transported requests using the old fact, with no second acquisition. `ThreePortInterference` retains these paths beside the two reacquired paths of M64ag, so the difference lies in the requested relation.

There is a compositional form. If successive source changes are τ_(j+1)=β_j τ_j α_j⁻¹ and each request is carried as u_(j+1)=α_j u_j α_j⁻¹, then its needed remote action evolves only by v_(j+1)=β_j v_j β_j⁻¹. Induction covers every finite admitted word, without a new calibration after each input-coordinate change. The source, request and record may all move while the relevant coupling remains closed. This is a different continuation contract from M64ae's fixed local request: applying its full-frame lower bound here would add an obligation that the transported question does not have. Nor may a fixed-coordinate failure be repaired by silently substituting this transported question. Which operation is meant must be established through its addressed participants.

`MarkedFrameRequest.swift` also realizes a small closed interface for that joint movement, without requiring the receiver to learn the intervening word. Its source has three rows (value, marker), exactly one marked, and its question reads that row's value. The three `MarkedFrameAt…` clauses use actual projections at their admitted marker patterns. Both adjacent exchanges move whole rows, including the marker. `MarkedFrameMoves` supplies all six generic commuting squares, with identity on the read value and the exact successor pattern at each step. Because these successors remain in the same three-clause family for arbitrary values, induction proves preservation under every finite word of these contacts. The word and final marker position can remain unknown to a receiver retaining the old value.

`RecordedMarkedFrameMove` binds this invariance to an actual earlier acquisition, a subsequent whole-row exchange and reading of the saved fact at the resulting source. `MoveFrameValuesWithoutRequest` gives the competing transformation: it exchanges the same two values but leaves the request marker in its old slot. Both transformations have the same unmarked current frame. Their marked questions can differ, and only the whole-row exchange preserves the old answer uniformly. The joint movement is therefore part of the constructed operation, not inferred from the unmarked result or from the name of the request. Interleaving these admitted contacts preserves the reading, including choices by different participants. No claim is made for an additional operation that separates value and marker, changes the selected value, or exposes intermediate cuts inside one of the supplied contacts.

## Cross-page mentions

Labels mentioned here: <doc:permanence_is_resistance__support_renewal#M64v>, <doc:permanence_is_resistance__support_renewal#M64w>, <doc:permanence_is_resistance__support_renewal#M64x>, <doc:permanence_is_resistance__support_renewal#M64y>, <doc:verdict_is_invariant__four_phase_catalogue#VC100c>, <doc:verdict_is_invariant__finite_records#VC15>, <doc:verdict_is_invariant__discovery_acquisition#VC38>.

Mentions of this page’s labels: <doc:permanence_is_resistance__frame_acquisition> (M64ae), <doc:permanence_is_resistance__joint_laws> (M64ah).
