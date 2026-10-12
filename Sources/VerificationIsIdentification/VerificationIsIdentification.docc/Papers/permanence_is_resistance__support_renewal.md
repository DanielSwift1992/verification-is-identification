# Permanence Is Resistance (Matter) — Support renewal

This part contains the original derivations for support renewal.

Family and original section headings: <doc:permanence_is_resistance>.

Section setting: <doc:permanence_is_resistance#4g-Which-future-must-carry-a-real-distinction>.

Required setting: M64o uses M64n’s four source positions and W,Z. <doc:permanence_is_resistance__contact_rigidity#M64n>.

### M64o

**M64o (the location of one contrast determines its sufficient support).** Keep M64n's four source positions and W,Z, but assume none of the eight target contact equations in advance. A performed test includes admission of its target application and supplies the bit [h(Wx)=u(hx)] at (W,x), or [h(Zx)=v(hx)] at (Z,x). The same h, defined on X, and the same possibly partial u,v are used throughout, with arbitrary target carrier and no target cycle restriction. Availability outside the tested inputs is not assumed. An undefined application is not a false comparison; further domain-refusal evidence is outside this bit-only interface. One addressed contrast of h images has already been acquired. We ask for the smallest set of *positive* contact equations which, with that contrast, forces h to be injective in every compatible realization. The contrast is not counted again among the contact equations.

The sufficiency arguments below use only admitted rows. The lower-bound countermodels can even be completed to total functions, so allowing partial contacts does not weaken those bounds. No global availability premise is needed for either minimum.

For h(0)≠h(2), the exact minimum is four. All four W equations attain it. Any merger inside the three-cycle spreads around it, contradicting the given contrast. A merger of the fixed position with the cycle spreads in the same way using the fixed-point equation. Thus none is possible; no Z equation is needed. This also follows for any contrast within that cycle.

For h(0)≠h(1), the exact minimum is six. All four W equations plus Z at positions 0 and 2 attain it. W alone admits only a three-cycle image with a distinct fixed image, or a collapsed cycle with an arbitrary fixed image. The first case is injective. In the second, the given contrast makes h=(a,b,a,a) with a≠b, and the two Z equations would give v(a)=b and v(a)=a. They exclude it. No equations at Z's other positions were used.

Both lower bounds can be proved without listing target devices. Consider merging just one source pair p while keeping the other two positions distinct. The existing contrast allows five of the six choices of p. This rank-three quotient satisfies a set of tested contact equations unless some single contact was tested at both endpoints of p and sends those endpoints into different quotient classes. If no such conflict occurs, define its target function from the tested rows on the three classes; the absence of conflict makes it well-defined. Assign arbitrary images at the remaining arguments to obtain total functions. Thus a positive certificate must conflict with each of those five simple mergers.

Three or fewer equations cannot do so. Three W tests cover at most three pairs; two W and one Z, or the reverse, cover at most one; three Z tests cover at most two useful pairs. For Z, the pairs {0,1} and {2,3} map into themselves and never obstruct their own merger. A permitted pair is therefore left unchallenged. This proves the lower bound of four for an active contrast, irrespective of where the tests were chosen.

For the fixed contrast, five equations still fail. Four W tests and at most one Z test allow the rank-two quotient (a,b,a,a): one tested Z row cannot demand two answers at the same argument. With three W tests and two Z tests, at most 3+1=4 simple mergers are challenged. With two W and three Z, at most 1+2=3 are challenged. With at most one W and all four Z, only Z's four crossing pairs can be challenged. Each leaves at least one of the five allowed simple mergers. Fewer tests cannot do better. These cases cover all allocations and prove the lower bound of six.

The same argument excludes earlier certification by an adaptive bit-only strategy along an all-positive branch. At every insufficient prefix, one of these quotient realizations satisfies the same contrast and all queried equations. It gives exactly the same transcript and therefore the same next choice. Repeated tests add nothing. This is a lower bound on certification in that branch, not a claimed total decision procedure for every possible pattern of positive and negative replies.

Placement and the question remain essential. Testing all W equations and Z only at 0 and 1 gives six positive answers but still permits (a,b,a,a): choose v to exchange a and b. Conversely the sufficient six equations do not establish full Z intertwining. Take h identity, u=W and target image table v=(1,1,3,3). The tested Z rows at 0 and 2 pass, while those at 1 and 3 fail. Here h is injective but v is not a permutation on its image. A certificate for faithful passage must not be reused as a certificate for the entire unmeasured contact.

There is no total classifier for injectivity from these eight comparison bits and the one contrast alone in the stated unrestricted class. Let a faithful h map into four points of a larger Y, and send all of them to a fresh point e under both target functions. Every comparison is false. A noninjective h preserving the same specified contrast, with both target functions again returning a point outside its image, gives the same eight false bits. Additional unrelated points are allowed by the contract. These two realizations answer injectivity differently. Restricting their target functions or acquiring another kind of contact would change the problem; a negative square alone does not establish a lossy h.

**Support selection as an M71a corollary.** The four-position example has a general exact criterion. Let X be any finite set of known source positions, R a selection of rows f(x)=x' of specified possibly partial source functions on X, and let their positive target witnesses state u_f(h(x))=h(x'). Each u_f is one common possibly partial function on an unrestricted carrier, with no additional target laws. Retain one actual contrast h(a)≠h(b), where a≠b in X. The discrete interpretation is consistent: copy X and its selected rows.

For each distinct x,y in X, tentatively identify their image roles and close the selected diagram by M71a. Then R forces injectivity of h iff every such closure identifies a with b. One direction transports a proposed merger through common contacts until it contradicts the actual contrast. In the other direction, a closure that leaves a,b apart gives the quotient interpretation from M71a. It realizes all selected positive rows and the contrast while identifying x,y. This is a compatible lossy interpretation, rather than a failure to find a proof.

Equivalently, every nondiscrete partition π of X that keeps a,b separate must conflict with some two selected rows of the same contact:

    f(x)=x', f(y)=y',    x ≡π y,    x' ≢π y'.

If no such pair exists, each target contact is single-valued on the π-classes of its selected inputs and supplies the counterinterpretation. If a pair exists, that proposed identification demands two different answers from the same addressed contact. Thus a support is sufficient exactly when it excludes every remaining lossy partition in this sense. Individual rows do not carry independent rejection power: the conflict uses their common contact and input identity together. M64o's placement and counting arguments are instances of this criterion. It does not enumerate the unknown carrier or introduce a runtime optimizer; selecting a minimum support in a new family remains a separate finite problem.

The same criterion can preserve a question instead of all source distinctions. Fix an independently specified q:X→A. A decoder d with q=d∘h exists for every compatible realization iff the contrast is collapsed by the tentative closure for each pair x,y with q(x)≠q(y). Pairs to which q assigns the same answer need no such exclusion. Indeed, the sufficient condition makes q constant on every h-fiber, so d(h(x))=q(x) is well-defined on h(X). If one relevant pair survives, its quotient interpretation has one image and two q-answers, excluding a decoder even for that realization. For injective q this is the preceding faithfulness criterion; for a constant q no source distinction needs to be preserved.

This states ∀ compatible h, ∃ d, not ∃ one available d for all h. Different faithful codings may use the same target values with exchanged source correspondences. On a two-position source, identity and exchanged codings both preserve its sole contrast, yet a nonconstant q requires different decoders on their common target carrier. Acquiring a common usable decoder still requires the appropriate correspondence evidence and question factorization over the receiver's full available record. The support criterion establishes that a required distinction was not lost in any compatible passage; it does not secretly give its inverse or a law parameter to the receiver.

`ContactContrastSupport.swift` expresses the two sufficient supports as four and six equations on actual common projections. Five generic constructors per support show that any merger other than the given contrast forces its endpoints equal. The already excluded contrast pair needs no further propagation. `SparseFaithfulContactImage` supplies the six equations while its untested Right fields fail full Z; it is a positive implementation of the weaker scope. `MisplacedSixContactImage` supplies six differently placed equations and keeps only two images. `ThreeActiveEdgesMayLoseFixed` preserves all three active W edges but merges the untested fixed position with position 0. Consumers check these boundaries and refuse their proposed strengthenings. `CycleImageReturns` also derives W³ on the image without a contrast, including the lossy case. `ZeroTargetContactReadings` also realizes the eight-negative case. Its input is a retained packet of four h images, not an additional claim to acquire those images from an unknown h. The source W/Z words bind the expected endpoints. Both target contacts use the actual First projection of a successor, giving Never; every expected endpoint is a successor. `ZeroContactMismatch` ties that constructor distinction to the actual readings and returns the false comparison bit. The faithful packet (1,2,3,4), the fixed-contrast lossy packet (1,2,1,1) and the active-contrast lossy packet (1,1,3,1) yield exactly the same full recorded eight-bit fact. Their relevant original contrast endpoints coincide as well. Complete records retain their different packets, but those packets are not inputs of the stipulated bit-only receiver. The general lower bounds remain the mathematical arguments above, not a count inferred from these examples.

### M64p

**M64p (acquired profiles can make comparison available without full contact return).** Let h map four addressed source positions 0,1,2,3 into an arbitrary carrier Y. Let u and q be common partial operations on complete images, defined on the readings used below. Set

    P(x) = (q(x), q(u(x)), q(u²(x))).

Suppose actual acquired profiles are

    P(h(0))=(a,b,c),   P(h(1))=(d,d,d),
    P(h(2))=(b,c,a),   P(h(3))=(c,a,b),   a≠b.

Then P∘h is injective. Equality of two cyclic profiles forces a=b=c; equality of the constant profile with any cyclic profile forces a=b=c=d. These are all six possible collisions, and each contradicts the given contrast. Therefore

    P(h(i))=P(h(j)) iff i=j.

This also forces h injective: a common P cannot give distinct profiles on one complete image. When equality of the observation symbols is an available operation, comparing the two profiles supplies one decoder of source equality across every h satisfying the acquired pattern. It does not require h⁻¹, source labels, or complete image values as decoder inputs. The bit-valued implementation below provides that comparison operation explicitly; abstract distinct symbols alone do not provide an arbitrary equality oracle.

The full-image equations u(h(i))=h(Wi) and u³(h(i))=h(i) are unnecessary. For u=First and q=Second, the finite chain (((K,c),b),a) has profile (a,b,c) and reaches arbitrary K after three u steps. Four such chains realize the displayed profile pattern. Their unobserved tails can change while every available profile remains the same. Thus these premises are strictly weaker than the corresponding full contact equations, with sufficient positive implementations. M64o's 4/6 minima concern a different measurement interface and are not claimed here.

For a=0,b=1,c=d=0 the four profiles are 010,000,100,001. Positions 1 and 3 have the same first two observations and different third ones. Three is consequently the exact sufficient common-prefix length for this family; this does not optimize arbitrary alternative instruments or total calibration cost. A fifth image with profile 000 and a different continuation also shows why the source range matters. Profile equality need not identify every complete state of Y.

More generally, let n active profiles be the cyclic shifts of a word z of length n>1, and let one extra profile be constant. These n+1 profiles are all distinct iff z has minimal cyclic period n. A shorter period identifies two active profiles. Full period makes all shifts distinct and nonconstant, separating the extra profile. For prime n, nonconstancy suffices. At composite n, 0101 already gives a counterexample. This is a period of an acquired observation word, not a derived period of complete hidden states; finite chains again realize the distinction.

`ContactProfile.swift` constructs the actual profile readings, records calibration at the resident encoder of the prepared paired source, and then reads profiles of the outputs of `PairedProbeInFrame`. The old calibration and source records survive. Its positive calibration clause requires the observed pattern, not injectivity as an extra premise. `ContactProfileSeparation.swift` provides six generic collision-to-contrast implications. `ContactProfileUse.swift` composes the acquisition with a bit-profile comparison and resident payload selection, for arbitrary unread tails and payloads. Changing those tails preserves the complete local procedure input; the decoder receives facts and tables, with no encoder parameter. Source position equality is specified by the raw probe replies, independently of the computed comparison.

The implementation supplies positive static branches using the concrete projection and routing grammar. It does not certify arbitrary `PredicateReading` conformances or provide a total diagnostic program for every invalid calibration. Access to the four addressed images, the common profile operation, and the retained-source acquisition mechanism remain explicit interface premises. An untracked source change cannot be substituted into the same acquisition; a separately established profile-preserving change can preserve applicability, as the arbitrary-tail construction demonstrates.

### M64q

**M64q (a sparse distinguishing certificate need not recover the profile law).** Let a finite collection of unknown images have arbitrary binary profiles under fixed questions r₁,…,rₙ. Each rⱼ is applied to the complete image; one cell query reveals one profile value. There is no additional law relating unknown cells. A set of acquired cells forces all profile rows distinct iff every pair of rows has acquired unequal values in some common column.

Sufficiency uses that acquired disagreement. For necessity, choose a pair without such a column. Their partial rows can be completed to one common word, since none of their common acquired coordinates conflicts. The other rows can be completed independently. Finite chains as in M64p realize these completions even under the common sequential reader rⱼ=q∘uʲ⁻¹; the two selected rows may use one complete chain. Thus absent an additional restriction on the carrier or unknown cells, the same acquired record admits a passage losing that source distinction.

For the particular true table with rows 0ⁿ,e₁,…,eₙ, where eᵢ has a single 1 at i, the exact minimum positive certificate size is

    2n + n(n−1)/2 = n(n+3)/2.

Separating 0ⁿ from eᵢ requires reading both cells at coordinate i, giving 2n mandatory cells. Separating eᵢ from eⱼ additionally requires the zero at row i, column j, or at row j, column i. Each such additional cell separates exactly one previously unseparated pair. At least n(n−1)/2 more are necessary. Choosing either direction for each pair attains that number. Every successful adaptive transcript on this true table must contain such a certificate, so adaptation cannot evade its lower bound. This is a minimum certificate at the specified table, not the worst-case complexity of deciding separation on all binary tables.

There are exactly 2^(n(n−1)/2) minimum cell supports: each contains the 2n forced cells and chooses one of the two cross-zeros independently for each active pair. For n≥2 their common intersection is insufficient, since it separates the zero row from every active row but does not separate active rows from each other. Thus a determinate answer need not have one determinate minimum acquisition. A conjunction of fixed mandatory cell addresses cannot describe these alternative sufficient supports; the supplied separator for each pair must remain part of the construction. This distinguishes uniqueness of the certified answer from uniqueness of a minimum support.

For M64p's rows 010,000,100,001, the following nine observed cells attain the bound:

    (0,1,?), (0,0,0), (1,?,0), (?,0,1).

The three question marks are independent; the completed profiles need not be rotations. All six source pairs still have observed separators. The criterion also survives independent injective recodings of each column: only comparisons within a common question are used. Neither a common numerical scale nor an interpretation of values across different columns is required. The reading for a column must remain common to the rows being compared. Arbitrary untracked row-dependent recodings do not preserve that relation. This preserves the separation relation; it does not manufacture an available equality test for arbitrary new symbols.

`SparseContactProfile.swift` acquires exactly these nine values through actual projections, retains the complete image packet, and derives six separating pairs with arbitrary unread cells and tails. `MandatoryProfilesCanMerge` retains the identical six-cell fact when all three active rows are replaced by one shared image with profile 111, exhibiting the insufficient intersection directly. `AcceptedSparseContactProfiles` is the positive calibration clause consuming the acquired nine-value fact. `SparseContactProfileUse.swift` replaces the twelve-value calibration in the retained-source experiment by this reading. The resulting query facts, original comparison clauses, and selected resident payloads are preserved. The discarded calibration cells are not reconstructed or secretly supplied to the receiver. The general lower bound is the argument above; the static implementation covers the four-row case. No claim equates the cell count to contact depth, preparation cost, physical duration, or the cost of acquiring the addressed source range.

### M64r

**M64r (a distinguishing support can be renewed before its old carrier changes).** Keep M64q's binary cell-query interface and its true table 0ⁿ,e₁,…,eₙ fixed during a handover. Write m=n(n+3)/2. If two minimum supports differ in k choices of cross-zero, the least number of single-cell additions and removals transforming one into the other is 2k. For k>0, the least possible peak active support size, with separation certified at every step, is m+1.

Each of the k new cells must be added and each of the k old cells removed, giving 2k as a lower bound. For each differing pair, acquire its replacement cross-zero before retiring the old one. Every pair keeps a separator, attaining both bounds. The first effective step cannot be a removal: every proper subset of a minimum certificate is insufficient. It must be an addition, giving the peak lower bound. For k=0 no edit is needed and the peak is m. A simultaneous atomic replacement is a different edit interface. These are sizes of active cell certificates, not bounds on total historical memory or physical resources. Retiring a cell from a current proof does not erase its acquisition. The m+1 result does not assume arbitrary source changes during replacement acquisition.

There is also a source-changing implementation. Use common profile readings q₀=q, q₁=q∘u, q₂=q∘u² and acquire M64q's support S:

    A=(0,1,?), B=(0,0,0), C=(1,?,0), D=(?,0,1).

Acquire C₁=0 from that same retained source. Replace the A/C separator A₀≠C₀ by A₁≠C₁. The resulting support S′ is

    A=(?,1,?), B=(0,0,0), C=(1,0,0), D=(?,0,1).

It contains nine cells; S∪S′ contains ten. The six separators AB, AC, AD, BC, BD, CD use columns 1,1,1,0,2,2 respectively. Unlike S, S′ does not use A₀. An actual internal exchange of A₀ with an arbitrary resident reserve v can therefore change A to (v,1,x) while preserving all six separators. The former A₀ survives in the reserve. The other unread entries and complete chain tails may be arbitrary; v need not be binary, since the comparison below never reads it. This does not claim that S′ remains a minimum certificate at every changed table.

Write E_S for the original nine readings, g for the acquired C₁, U for this exchange, and R_S′ for the current nine-reading question. Repacking actual fields gives a decoder d with

    R_S′ ∘ U = d ∘ (E_S, g).

Here d drops A₀ from its answer, keeps the eight common cells and inserts g into the C profile. It receives the two acquired facts, not the reserve or the complete changed source. The source equation is essential: arbitrary records with the same question names do not establish it. For v=1, E_S after U differs from E_S before U, so the old fact alone is no longer the current answer to the old nine-cell question. For v=0 it still is. Applicability changes by the question and actual operation, without a general invalidation status.

The replacement cannot be inferred from S alone. Before the exchange, the tables (010,000,100,001) and (010,000,110,001) have identical S records and both separate their four rows. Exchanging A₀ with reserve 1 gives (110,000,100,001) in the first case, and (110,000,110,001) in the second. The first preserves distinction; the second identifies A with C. Thus the postcontact distinction question does not factor through the old fact. The new C₁ reading separates these cases; a response 1 would not license this particular S′ construction.

S′ also gives a concrete classifier for an unknown image in the four-row range, with each question reading that same retained image. Read q₁: result 1 identifies A. Otherwise read q₂: result 1 identifies D. Otherwise q₀ distinguishes B=0 from C=1. All visited values are binary under S′, even when v, x, or D₀ are not. This fixed decision tree avoids every unread coordinate; comparing two resulting row addresses answers source equality. The argument supplies this available procedure without a complete image equality oracle. It is not an optimality claim for every possible instrument or a compiled resident execution of this new tree.

`ProfileSupportHandover.swift` constructs the two actual acquisitions, their field-only decoder, the resident exchange and the retained facts. `CurrentSupportFactors` ties the direct reading at the changed root to those facts; no equality of final answers is requested as a caller premise. `SixCurrentSeparators` derives the contrasts for arbitrary unread cells, reserve and tails. The exchange has a checked inverse on the supplied finite chains. `MissingReplacementCanMerge` constructs the two indistinguishable old records and the actual merger. The finite checks reject the old fact as a changed current answer, inference of the missing replacement from the old fact, and a second acquisition at a different source. The static implementation retains both acquired facts; nine is the number of dependencies in its derived support, not its total storage usage. This is a maintained relation under an explicitly supplied contact, not yet a derivation of an organization that itself keeps that contact and its access available.

### M64s

**M64s (a different acquired branch can release an entire column).** Keep the old nine-cell support of M64q and binary unacquired cells α=A₂ and c=C₁. After exchanging A₀ with an arbitrary resident value v, the profiles are

    A=(v,1,α), B=(0,0,0), C=(1,c,0), D=(d,0,1).

All pairs other than AC have separators independent of v,α,c,d. The AC profiles coincide exactly when v=1, c=1 and α=0. Consequently the exchange preserves profile distinction for every v iff c=0 or α=1. More generally, without a binary restriction on α,c, the criterion is c≠1 or α≠0. Thus M64r's C₁=0 branch is sufficient but is not the only sufficient branch. Reading C₁, then reading A₂ only after response 1, decides this universal-reserve question in at most two of these point queries. Two are necessary in the worst case: first response C₁=1 leaves the answer dependent on A₂, and first response A₂=0 leaves it dependent on C₁. The old nine-cell fact is identical in all four binary cases. This count concerns these two available questions and a fixed source during acquisition, not arbitrary combined instruments.

There is a stronger release question: may all four first-column values be replaced independently by arbitrary values while retaining distinct profiles? This holds exactly when c=α=1. The remaining pairs are then

    A:11, B:00, C:10, D:01.

Conversely c=0 permits BC to merge after their first coordinates are made equal; c=1 and α=0 permits AC to merge. In the successful branch, eight acquired cells in the last two columns certify distinction. Every one is necessary within this two-column certificate interface: each row has a neighbor differing only at that coordinate. Omitting the cell permits completion to that neighbor. The two-coordinate address also classifies a promised row in exactly two queries in the worst case; one binary coordinate cannot identify four rows.

The complete first column and all four tails may now vary independently. This is a larger admissible change family than M64r's one-cell exchange, despite using a smaller active certificate. There is no conflict with M64q's nine-cell minimum at its different true table. Nor is eight a bound on stored history or the cost of acquiring the source addresses.

`ProfileRelease.swift` constructs these eight actual readings and six generic separators. `RectangularProfileExchange` acquires the eight-cell fact, exchanges A₀ with the resident reserve, and derives its continued applicability at the actual changed root. The fact remains beside that root. The constructor does not implement the two-query adaptive policy from the old nine-cell record; its lower bound and branching procedure are the argument above. `ProfileReleaseInquiry` supplies the equal old facts, the two ambiguous first-query branches and a merged image when the needed last coordinate is absent.

### M64t

**M64t (the exact capacity of support handover is a union-connectivity question).** Fix a finite set E of mutually compatible primary witness occurrences about an unchanged source. Let V be a nonempty upward-closed family of sufficient subsets of E for one fixed question, and let 𝓑 be its inclusion-minimal members. Only one primary witness may be added or retired per step, and any remaining member of E is available for acquisition. No derived conclusion is supplied as an extra independent witness. For capacity k, form a graph whose vertices are B∈𝓑 with |B|≤k, joining B,C exactly when |B∪C|≤k. Two minimal supports admit a sufficient handover of peak size at most k iff they are connected in this graph.

For an edge, add C\B while retaining B, then retire B\C while retaining C. This keeps sufficiency and never exceeds |B∪C|. Conversely, every sufficient finite intermediate set S contains a minimal B_S. Two successive one-edit sets are nested, so the chosen minimal supports have union contained in the larger set and hence of size at most k. Every sufficient handover therefore projects to a walk in the stated graph. At minimal endpoints the contained minimal member is the endpoint itself. These two constructions prove the equivalence.

Thus, for different endpoints, the optimal peak is the minimum over paths of minimal supports of the largest adjacent union size. For an unchanged endpoint it equals that endpoint’s size. This quotient preserves the capacity question; it does not claim to preserve the number of edits or the cost of discovering or enumerating the minimal supports.

M64q's independent choices give a path of adjacent unions of size m+1. There is no general +1 law. For r≥2, take two internally disjoint a-to-b chains of r primary equality witnesses each, with no other available witnesses. A subset entails a=b exactly when it connects their variable roles: different connected components can be assigned different values. The only minimal supports are the two complete chains. Their union has size 2r, so the exact handover peak is 2r. Keeping a freely reusable derived a=b as a new primitive changes E and the interface, rather than refuting this bound. The result is a finite structural proof, not a runtime enumeration of witness sets.

### M64u

**M64u (paired replacement has an exact two-cell reserve).** Fix d≥1 and let the true table contain the N=2^d binary rows of length d+1 with even parity. The candidate tables used to judge a primary-cell certificate are unrestricted binary tables with these addressed rows, including tables with coincident rows. The parity equation describes the true instance; it is not an extra premise available to the decoder. A cell certificate is sufficient for row distinction iff every pair of rows has an observed opposing value at some common coordinate. Otherwise the two rows can be completed identically without changing any record.

The minimum certificate size is m=dN. Indeed, if a row has two unread coordinates, its parity-code neighbor differing exactly there has no observed contrast against that row. Hence every row needs at least d cells. Reading every column except one attains the bound. Write B_i for this support omitting column i.

For i≠j, a sufficient one-cell-at-a-time handover B_i→B_j at this fixed table has exact peak m+2 and minimum edit count 2N. With capacity m+1, the first addition can only fill column i of one row r. Retiring a cell of another row leaves it with fewer than d cells. Retiring coordinate j of r fails against the neighbor differing at i,j: one of their two contrasts is missing at each endpoint. The same argument applies to any proposed retired coordinate. The only permitted retirement undoes the addition, so capacity m+1 cannot leave B_i.

For sufficiency, partition the rows into N/2 pairs agreeing on the other d−1 coordinates. Acquire the two i cells of one pair, then retire its two j cells. Different pairs remain separated by a retained common coordinate. Within each pair retain the old j separator until both new i values are acquired. At every settled intermediate support each row has d recorded cells, and the peak is m+2. Each of the N new cells must be added and each of the N departing cells retired, giving 2N edits. This attains both bounds without enumerating supports. M64t describes the same threshold through adjacent unions of minimal supports.

This is a primary-certificate capacity result, not a lower bound on all possible VI representations, physical memory, or policies allowed to change the source during handover. An independently established parity law, a free derived certificate, or a larger instrument changes the information interface. Histories are not deleted when cells leave the active certificate. For d=2 the minimum is eight, the exact peak ten.

### M64v

**M64v (a mixed support can retain an optimal adaptive instrument).** In the four-row instance, order rows by the common Z coordinate and write a settled intermediate support as

    r₀=(a₀,*,e₀), r₁=(a₁,*,e₀),
    r₂=(*,b₀,e₁), r₃=(*,b₁,e₁),

with a₀≠a₁, b₀≠b₁, e₀≠e₁. The stars are not retained observations and may vary independently. Read Z first. At e₀ read X and use the acquired a₀/a₁ contrast; at e₁ read Y and use b₀/b₁. This identifies every promised row in two reads in every table compatible with the support. In the binary interface one read cannot identify four rows, so this depth is optimal.

No fixed pair of coordinates works uniformly over those completions. XZ may merge r₂,r₃ by assigning their unobserved X values equally; YZ may merge r₀,r₁. For XY, set the unobserved Y of r₀ to b₀ and the unobserved X of r₂ to a₀. Those two keys coincide while Z still keeps the complete rows distinct. Thus loss of a common two-coordinate projection need not mean loss of a two-read instrument. The conditional choice of the second coordinate is made from the first acquired answer.

In M64u's general instance, the d−1 shared coordinates locate one pair; then its current local separator locates the row. Depth d is both sufficient throughout the paired handover and necessary for N=2^d binary alternatives. A remaining pair can consequently still be located after an earlier pair's old cells have changed. In the supplied projection/Route interface, the following cell reading has an actual resident source. This does not infer arbitrary physical instruments from the abstract existence of a decoder.

`AcquireRenewedProfile` records YZ, acquires the first X pair, exchanges the retired first Y pair, acquires the second X pair at that changed source, and exchanges the remaining Y pair. `MixedFactors` and `AfterExchangeFactors` derive applicability from the recorded fields; their decoder inputs do not contain the current source. Each two-cell reading is a macro for its two available projections at an unchanged source, so it may be expanded into the one-cell edits counted in M64u. `MixedProfileAccess` supplies actual Route inputs and outputs for both orientations of the first acquired pair, with the four unused cell values arbitrary. No full renewed column is required for the intermediate lookup. The field-transport identities alone do not assert that a missing pair contrast holds.

### M64w

**M64w (local facts can select an entry into a recurrent renewal family).** Use the binary X interface, with the acquired YZ rectangle

    Y=(c,d,c,d), Z=(e,e,f,f), c≠d, e≠f.

The current YZ answer does not determine whether Y can be retired. XZ distinguishes the rows exactly when both X pairs contrast. All four X cells are needed in the worst successful case using point queries: if one is unread, changing it to its partner's value preserves all acquired information but changes the release answer. Reading pair by pair attains this bound and admits the intermediate support of M64v.

Once both binary pairs contrast, exactly two relative arrangements remain, after naming the first pair (a,b):

    opposed: X=(a,b,b,a),     aligned: X=(a,b,a,b), a≠b.

Their relative orientation is already determined by the four acquired values; no extra source contact is required. It must still affect the chosen action. Always treating aligned blocks as opposed is wrong: for X=Y, flipping all of Y leaves X and Y opposite copies, so their joint keys cannot replace Z. The first XZ handover has succeeded, but the proposed next XY support fails. `RenewalAccessCanDisappear` supplies this positive key collision alongside the two successful local contrasts.

There is a constructive repair, rather than a requirement that the source was opposed from the start. Both branches first exchange the retired first Y pair after acquiring the first X pair. After acquiring the second pair:

* Opposed: exchange the second Y pair and reorder rows as [0,3,1,2].
* Aligned: leave the second Y pair and reorder rows as [0,2,1,3].

Then rotate column roles (X,Y,Z)→(Y,Z,X). Both branches reach

    X'=(d,c,c,d), Y'=(e,f,e,f), Z'=(a,a,b,b).

Every final value follows by these resident permutations. Thus both enter the same family R(a,b,c,d,e,f), defined by columns (a,b,b,a), (c,d,c,d), (e,e,f,f). Every two coordinates in R enumerate their four Cartesian keys. Each of its three coordinate pairs supplies a sufficient support, with no cell common to all three supports.

Within R, one opposed renewal step maps its parameters to

    (a,b,c,d,e,f) → (d,c,e,f,a,b).

The next source again belongs to R and its active YZ support is the reordered acquired XZ support. Three steps reverse all three coordinate pairs; hence every one of the twelve original cell values has changed when the pairs are distinguished. Six steps restore the device table. The three-step row and column permutations return their role positions, so the change is at the original table addresses, not only in a renamed coordinate chart. These are constructed updates; idling does not satisfy the stated renewal request.

If an acquired X pair does not contrast, that block cannot be handed over under this release contract. A failed first pair need not change the source. After a successful first pair and a failed second, undo the first Y exchange. The old source and applicability of the retained YZ fact are recovered, while the new facts remain archived. `RollbackEndpoint` and `RollbackSupportFactors` construct that branch. Failure of the selected release does not assert that every possible repair in a larger interaction vocabulary is impossible.

`RenewableProfileStep` and `AlignedProfileEntry` connect actual acquisition endpoints to the two source permutations. Their recorded cross-agreement or alignment is obtained from the actual new records. The next support is read from those records through the displayed reindexing, without the source as an extra decoder input. `RenewableProfileDeviceReturn` checks the generic six-step device word. Binary contrast admission and the finite conditional choice are justified above; no runtime branch executor or universal synthesis procedure is claimed.

**Normalization has a necessary residual.** For fixed distinguished coordinate pairs, the aligned and opposed device sources are different, but the two admitted entry words give the same final device table. The archive prefixes agree; their last acquired X pairs are (a,b) and (b,a). `NormalizedRenewalRetainsOrientation` derives both facts, so the complete outputs still differ. Across the union of these two entry families, the final device table has exactly two preimages: it recovers a,b,c,d,e,f by its displayed fields, but not the old block orientation. One binary residual specifying that orientation is therefore necessary and sufficient to recover the original device table. This is a bound for that recovery question and source family, not a proposed compression of the entire archive to one bit. The retained second-pair fact already contains the residual. A common normalized device does not identify the two acquired histories or their complete outputs.

Induction now permits any finite number of admitted renewal rounds: the source family, relevant contrasts, recorded support and next projection contacts are reproduced at each completed round. The permutation law and instrument vocabulary remain premises. This is renewal of all table cells, not replacement of every logical premise. The archive is carried through the constructions and may grow; the eight/ten cell counts are active primary-support counts. No infinite physical execution, bounded total historical memory, or apparatus outside the represented source is inferred.

### M64x

**M64x (two working charts have an additional joint release condition).** Let S have q² row occurrences, q≥2. Readings X,Y,Z take values in three q-element alphabets. Suppose both (X,Z) and (Y,Z) are bijections from S onto their Cartesian answer sets. Each Z fiber therefore contains one row at each X value and one at each Y value. The relation between the two local charts on that fiber is a permutation τ_z:X→Y.

The complete Z column may be replaced by arbitrary independent values without merging any full row profile iff, for every x, the q values τ_z(x), as z varies, are all different. Equivalently, the graphs of the q permutations τ_z partition X×Y. Indeed, (X,Y) is injective exactly under this condition. If it is, it separates every two rows regardless of Z. If it is not, setting the Z values of a colliding pair equal merges their full profiles. This is a universal-replacement question; some particular replacements can still be safe when it fails.

Change the X values inside fiber z by a permutation u_z and the Y values by v_z, retaining Z and the row occurrences. The two current charts remain bijective, and the updated relative map is exactly

    τ'_z = v_z ∘ τ_z ∘ u_z⁻¹.

The joint release criterion must be tested on these updated maps. Local chart bijectivity does not imply it. Nor does commutation of the two disjoint column changes: commutation fixes the common endpoint, not the relations that this endpoint must satisfy. This criterion concerns the declared complete row family and supplied current maps; old facts need their own applicable transport to describe these maps.

### M64y

**M64y (a shared binary correction preserves more freedom than independent permissions).** Specialize M64x to the four-row family of M64w. Name the rows by (i,z)∈{0,1}², and use binary orientations

    X(i,z)=i⊕x_z,     Y(i,z)=i⊕y_z,     Z(i,z)=z.

Different alphabets may be substituted independently for the two symbols of each coordinate. Both XZ and YZ always identify rows. The two relative permutations differ, and Z is releasable, exactly when

    χ = x₀⊕x₁⊕y₀⊕y₁ = 1.

An exchange of the two X cells in fiber z toggles x_z; the analogous Y exchange toggles y_z. For cumulative local exchange vectors u,v, put ε(u)=u₀⊕u₁ and ε(v)=v₀⊕v₁. Starting at χ=1, the exact set of joint changes preserving release is

    K = {(u,v)∈{0,1}²×{0,1}² : ε(u)=ε(v)}.

It has eight elements. If participants instead choose independently from sets U,V that each include idling, and every combination must preserve release, then U×V⊆K forces ε(u)=ε(v)=0 separately. Such an independent permission product has at most four elements; both even local subgroups attain four. Thus the complete eight-element permission cannot be expressed by two independent local allow-lists with idling. It includes a first-pair X exchange paired with either single-pair Y exchange, although neither exchange alone preserves the release question. The larger freedom is relational, not a broader unilateral permission.

For a receiver knowing u and the initial valid preparation, one binary message ε(v), bound to the actual cumulative partner action, is enough to decide release or to select one further local exchange restoring it. One is necessary if all four v remain possible: idling and a single exchange require different answers. This is a two-symbol communication bound with a sender able to distinguish its performed action, not a claim that a parity instrument is freely available.

For the complete current Y chart, all four v are distinguishable when the two Y values contrast. That different question requires four message values, or two fixed binary symbols. Two partner exchanges of different pairs have the same odd ε(v) but different current charts. If the only new contacts are individual Y cell readings at a fixed source, deciding ε(v) itself needs two point queries in the worst case: one in each fiber attains it, and after any one query changing the other fiber changes parity without changing that answer. A smaller answer alphabet therefore does not imply fewer point contacts.

These statements apply at a common actual cut. A delayed message about an earlier prefix is insufficient if a later unreported odd exchange has occurred. The two histories can deliver the same old message and have opposite current χ. Conversely, cumulative parity through the required cut determines this release question even if the detailed path is not retained in the receiver's working record. It does not identify those paths as historical occurrences.

During the gap between the two matching odd exchanges, XZ and YZ remain usable, while Z is not yet releasable. The existing access can therefore support the corrective contact without assuming the desired future access. No fairness, atomic delivery, or termination against unrestricted interfering actions follows from the endpoint equation.

`SharedProfileChanges` derives commutation, inverse endpoints and the unchanged other current chart from actual field exchanges. `SharedProfileChangeRecords` acquires both charts, performs X then Y at its changed source and derives each current chart from its own old fact through `ExchangedChartFromFact`. The decoder has no current source or other participant's fact as an additional input; the performed fixed exchange is supplied by the proved word. This implements the known-word transport, not an asynchronous one-bit messaging channel. `SharedProfileLookup` takes the two transported charts and derives the actual routing inputs and recovery of each row's arbitrary payload through either chart. Reusing the old payload table after the exchange instead returns a different row's payload in the displayed counterexample. `SharedRenewalGrids` derives the three complete XY grids for generators of K and the collisions after an unpaired exchange. The binary formula above proves the exhaustion and closure for arbitrary finite words. It also distinguishes the two same-parity partner charts. None of these declarations obtains its conclusion as a caller equality premise.

## Cross-page mentions

Labels mentioned here: <doc:permanence_is_resistance__contact_rigidity#M64n>, <doc:permanence_is_resistance__forced_answers#M71a>.

Mentions of this page’s labels: <doc:permanence_is_resistance__reusable_requests> (M64v), <doc:permanence_is_resistance__reusable_requests> (M64w), <doc:permanence_is_resistance__reusable_requests> (M64x), <doc:permanence_is_resistance__reusable_requests> (M64y).
