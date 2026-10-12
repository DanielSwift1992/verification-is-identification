# Permanence Is Resistance (Matter) — Contact rigidity

This part contains the original derivations for contact rigidity.

Family and original section headings: <doc:permanence_is_resistance>.

Section setting: <doc:permanence_is_resistance#4g-Which-future-must-carry-a-real-distinction>.

### M64k

**M64k (the least inequality support forcing an equality).** Let G be a finite simple graph of distinct variable roles, including a,b. An edge requires its two values to differ. Admit every assignment of its vertices to at most n values that satisfies these inequalities, where n≥1 is given. Require this class to be nonempty. There are no other pins, equations, predicates or hidden identifications of roles. How few edges can force a=b in every admitted assignment, even with auxiliary vertices?

The exact minimum is

    n(n+1)/2 − 1.

For n=1 it is zero. For n≥2, a construction is the complete graph on n+1 roles with only edge ab removed. Its n−1 other roles are pairwise different; both a and b differ from all of them. Only one value remains for a and b. The assignment that merges a,b and otherwise uses distinct values witnesses nonemptiness.

For the lower bound, suppose G forces a=b and has an n-value assignment. Then ab is not an edge, and adding it produces a graph with no n-value assignment. Choose an inclusion-minimal subgraph H with that property. It contains ab, since every subgraph of G still has the original assignment. Every vertex of H has degree at least n: after deleting a vertex the remaining graph is n-colourable by minimality, and fewer than n neighbours would leave an available colour with which to restore it. Consequently H has at least n+1 vertices and at least n(n+1)/2 edges. All but ab belong to G. Auxiliary vertices therefore cannot lower the displayed bound.

Each edge in the attaining construction is essential. Delete any other edge uv, merge exactly u,v, and give all other roles distinct values. This is an n-value assignment preserving every retained inequality and having a≠b, because uv is not ab. The minimum concerns inequality relations, not physical duration or the number of arbitrary queries. Allowing stronger predicates, given equalities, or pre-identified roles changes the class to which the bound applies.

These relations need not be read through one calibrated frame. For each edge e=uv let an unknown common function c_e act on both actual endpoint values. Acquiring c_e(u)≠c_e(v) establishes u≠v. No injectivity, known inverse, or agreement between different c_e is required. Even a binary output carrier suffices for every edge: any unequal pair can be separated by a suitable two-valued function. The receiver needs only the acquired contrast bit and its endpoint binding. It need not receive the source values, output coordinates or function tables.

The qualification "common" is within each edge, not across the network. The two images must be applications of the same function to the same recorded values that the adjoining edges use. Two maps in one container can give unequal images of one equal input. Conversely, equal images of a lossy common map do not establish equal inputs. Thus the raw TT and mismatched-echo rules of M64h cannot be applied to these encoded echoes. Here only acquired separations are used. Their common finite value bound is still a given, not a calibration inferred from those separations.

For n=4 the attaining support is precisely M64j's nine inequalities on {a,b,t₀,t₁,t₂}. `EncodedSeparation.swift` reads all five roles from one actual node record and all edge tables from the resident resources. Each edge's two finite `Route` clauses read the same table field. Their binary images are compared through the existing bit-equality table. Nine such readings are joined at the same root and recorded by `AcquireRecordedNetwork`; the earlier source is retained beside the new fact. The positive all-separation clause of `UnmatchedReturnAnswer` is reused on this acquired record, without receiving the private nodes or tables.

`SeparationGraphCalibration.swift` obtains the positive node record from the previous actual resident-and-return path: originals 3,3 and targets 0,1,2. Its nine functions are non-injective four-to-two tables. Some produce images (1,0), others (0,1); the common conclusion uses neither orientation. The actual nine comparison bits are all false and the recorded answer is equality. The finite type witnesses check this acquisition path; the general implication and its lower bound are the exclusion proofs above, not a compiler enumeration of arbitrary graphs.

Two countermodels cover the two kinds of removable edge in this support. For a missing target edge, use originals 0,1 and targets 2,2,3. For a missing spoke, use originals 0,1 and targets 0,2,3. Separate binary functions acquire every remaining inequality. In each case the omitted relation cannot be supplied from the other eight; relabelling the roles covers the other edges of the same kind. A further check applies two different resident functions to the same actual node, obtains unequal images, and rejects transporting that image comparison as raw inequality. The five-value countermodel in M64j still defeats removal of the carrier bound. Losing the shared node binding would also change the graph itself.

This differs from VC85's conflict graph for the number of calibration symbols: the present question is the minimum inequality support for one forced equality at a given capacity. It uses ordinary finite graph colouring and the elementary minimal-obstruction argument just proved; no priority claim is made. Nor does generic `PredicateReading` conformance establish the meaning of an arbitrary purported encoder. The static witnesses use the admitted projection, composition, record and finite table-reading clauses and their actual source bindings.

### M64l

**M64l (apply the acquired agreement without identifying the frames).** The equality acquired in M64k can discharge M64g's comparison h(p)=k(p). Within its bijective, even-relative frame scope this establishes

    hWh⁻¹ = kWk⁻¹.

This is an equality of actions on the entire four-point carrier, not only of their response at p. It does not identify h or k, or identify their common transported action if the output position itself was not revealed. An agent can invoke the available current W implementation through k, knowing that it implements the intended W through h. To execute this particular realization, the forward and inverse frame interfaces must be available and related as specified. Acquisition alone does not manufacture an inverse port, and agreement in a past trial does not establish arbitrary future covariance.

`AcquiredFrameAction.swift` makes this use explicit for the distinct resident frame words h=ZWW and k=WZWW. Their prepared phase-1 probes both return 3. `ProbePairWitnessNodes` runs those actual probes and reads both resulting facts beside the three resident anchors. The nine non-injective encoding tables of M64k acquire the separation network at this new node record. The answer reader receives only that fact and its fixed answer resource. The alternative pair (WZWW,WWZWW) produces exactly the same receiving input through the same acquisition layout. Thus this positive evidence does not determine the two resident frame addresses. The older return layout has the same nine bits but a different recorded question expression; these two complete fact types are not falsely identified.

For subsequent use, `AcquiredFrameContexts` reads each actual retained frame context from the final acquisition. `PrepareAcquiredFrame` reads that context and combines it with working data and a center already prepared beside the acquisition. An inverse-library selection at that same resident address, the actual W word, and a forward-library selection at that same address implement the framed action. Neither selection receives a recovered frame address from the equality decoder. The existing finite forward and inverse libraries supply their semantics and availability.

`AcquiredFrameActions<A,B,C,D,R>` composes both alternatives from acquisition to the returned working boundary. For arbitrary payloads and additional R, both have the same input and output, with working result

    (A,B,C,D) → (C,A,B,D).

Both retain the entire acquired whole, including both frame contexts, the private node record, encoding resources, network fact and answer. The temporary working context returns to the value read from that whole; closing the working boundary keeps the original copy there. No new log of the different execution paths is part of this contract. Equality of the returned states is not an assertion that their histories or contact costs are equal, nor that this implementation is cost-optimal.

The same acquired frame agreement does not authorize every question. Replacing W with Z in these actual paths gives respectively

    (C,D,A,B)   and   (B,A,D,C).

Distinct payloads separate them. The checks reject treating those results as one, identifying the retained frame contexts, or selecting the other frame's inverse address at the current root. This applies the existing centralizer criterion to the newly acquired evidence; it is not a new claim about all uncalibrated interfaces. The concrete static acquisition and full symbolic actions supplement the general exclusion argument of M64k and group argument of M64g rather than replacing their stated scopes.

### M64m

**M64m (sparse contact comparisons can determine the whole intertwining).** Let D:X→X and C:Y→Y be permutations, each with one cycle of length l≥2 and f fixed points, on complete finite carriers of size l+f. An unknown bijection h:X→Y is accessible through the following comparison at a chosen input x:

    B_h(x) = [h(Dx)=C(hx)].

The receiving strategy sees this bit, not the endpoint coordinates. D,C,h are the same functions across these contacts. The question is whether Ch=hD everywhere. No parity of h, chosen output frame or implementation of h⁻¹ is assumed. This is a different access model from M64d's point oracle for k⁻¹h. In M64l one may take C=kWk⁻¹ and D=W when that actual current C interface is available.

The exact worst-case number of such comparisons, including adaptive strategies, is

    m(l,0) = l−2,
    m(l,f) = max(l−2, ceil(l/2))  when f>0.

For the identity action the number is zero. Thus a three-cycle with a fixed point needs two comparisons, whereas a three-cycle on the entire carrier needs one. A cycle of length at least four needs l−2 comparisons even if arbitrarily many additional fixed points are present. These count comparison outcomes, not primitive invocations or physical time.

For l≥4, leave two nonadjacent cycle edges untested and test the other l−2. The tested graph consists of two directed paths, each containing at least two vertices. If every tested square holds, a vertex incident with one of these edges must map into C's cycle: injectivity of h makes the two endpoint images different, so their C step cannot be fixed. Hence the images of all l cycle vertices exhaust C's cycle. Their two path images are complementary directed segments. C must join their ends crosswise. Joining either segment back to its own beginning would make a shorter C cycle, contrary to the given cycle type. These forced joins are exactly the two omitted equations. Bijection then maps the remaining f vertices to the remaining fixed points, where the equations hold too.

When f=0 the same two-segment proof permits a singleton path: there are no fixed target points into which its image could disappear. It gives l−2 tests for all l≥2, including no test for a two-cycle. When f>0 and l=2 or 3, testing l−1 consecutive edges covers the entire active cycle; its C image closes by the given cycle length. These constructions give the displayed upper bounds, and any false comparison already rejects global intertwining.

For the lower bound, follow a strategy on a fully compatible h. Relabel the output carrier by this h solely for the proof, so C=D and that h is identity. If at most l−3 cycle edges have been queried, at least three directed path components remain, with isolated vertices allowed. Embed these paths around the target cycle in a different cyclic order while preserving each path's internal order. This produces another bijection that satisfies every queried cycle equation but fails an omitted one. Keep every fixed point in place, so any queried fixed-point equations also hold. The entire all-true transcript remains the same. Adaptive choice therefore cannot reduce the worst-case bound below l−2.

The two small cases with f>0 need the remaining lower bounds. With a two-cycle, no tests cannot exclude exchanging a cycle point with a fixed point. With a three-cycle, one cycle test leaves its third vertex unconstrained; exchanging that vertex with a fixed point preserves the test and breaks intertwining. If the sole test is instead at a fixed point, keep all fixed points in place and reverse the active three-cycle. It passes that test and again breaks intertwining. This completes the lower bounds, including the adaptive all-true branches.

The placement condition is substantive. For l≥4 and f>0, a minimum-size test set must use l−2 cycle edges; using fewer leaves the preceding three-component ambiguity. Its two omitted edges must be nonadjacent. If they are adjacent, their common vertex is isolated in the tested graph and can be exchanged with a fixed point without changing any test. Conversely the nonadjacent placement was proved sufficient above. Thus the minimum count alone does not certify a particular test arrangement.

For D=(0 2 3) with fixed point 1, test at x=0 and Dx=2. Three recorded images h(0),h(2),h(3) and the two actual C applications to the first two images supply the two comparisons. The middle image can be reused from its record. If both pass, the third cycle relation and fixed-point relation follow. Identity h,C=D passes. The odd map h=(0 1), with C=(1 2 3), also passes. By contrast h=(1 3),C=D passes the first square and fails the second. Parity is neither assumed nor identified by the positive evidence in this experiment.

`ContactCycle.swift` constructs these three paths using existing finite table clauses. `ThreeCycleImages` reads h at the actual x,Dx,D²x using the same resident D and h fields and records the image triple. `TwoCycleSquares` reads the retained C field, applies it to the first two recorded images, compares with the next two, and records only the two bits for the receiver. The original source and all three private images remain. Identity and the odd example give exactly the same final fact despite different private images. In this finite witness the equality comparisons use the given four-value comparison clauses; acquiring their meaning through further unknown encodings is a separate obligation, for which M64k supplies one sufficient construction.

The file also gives a symbolic five-position countermodel to using two adjacent tests for a four-cycle plus one fixed point. Its three center exchanges produce the four-cycle; exchanging the untested cycle position with the fixed position preserves the two tested fields but changes a different field. The generic equations use actual composed source fields, and the check supplies a concrete distinct pair to reject full equality. This is the placement failure just proved, not a failure of the optimum.

The general counts and minimal placements are mathematical proofs above. The static checks cover the displayed acquisition and countermodels, not an enumeration of arbitrary l or a proof that any Pair denotes a cycle. The given cycle type and bijection scope remain necessary restrictions. Two tests cost more than two primitive calls: in the three-cycle protocol they use three h readings, two C applications, input preparation and comparison. No efficiency comparison with M64d's different oracle follows from comparing their displayed numbers. Nor does a finite successful history establish these function laws for an unrestricted changing source.

**If the passage h may merge values.** Keep D,C and the bit-only contact interface, but admit every total h:X→Y rather than only bijections. The exact worst-case count is now l−1+f for l≥2. Test l−1 consecutive active edges and every fixed input. The active path forces h(Dʲx)=Cʲh(x) for j=0,...,l−1; Cˡ=id closes its last edge even when h collapses the cycle to a fixed point. The fixed-input tests supply the remaining equations separately.

Every fixed-input test is necessary: otherwise change only that input's image from a C-fixed point to a cycle point. None of the other equations sees the change. If at most l−2 active edges are tested, their graph has at least two path components. Map each component along C but give them different phase offsets. All tested edges hold and an omitted join fails. Injectivity no longer excludes the overlap. This also preserves the adaptive all-true transcript, proving the lower bound.

In the four-point three-cycle example, h=(0,0,2,3) as an image table gives the same two positive cycle bits as identity. At the untested fixed input 1 it instead gives h(D1)=0 and C(h1)=2. The extra comparison at 1 is needed in this larger function class. Conversely h=(1,1,1,1) intertwines everywhere because 1 is C-fixed, while retaining no distinction between inputs. Both tables are represented in `ContactCycleCalibration`. Their two-bit records equal the earlier positive record; direct table composition exhibits the first map's failed fixed-point equation. That third comparison is not claimed to have been acquired by the two-test construction.

An additional acquired contrast can exclude such total collapse. With l=3,f=1, two active comparisons, the fixed-input comparison and h(x)≠h(Dx) force the three active images around C's three-cycle, while the remaining input maps to its unique fixed point. Thus bijectivity of h then follows instead of being assumed. This is a sufficient joint certificate, not a claimed optimum for combined equality and contrast queries. It also separates two legitimate questions: preserving the requested action can permit a lossy passage, whereas faithfully retaining the source's distinctions needs its own acquired relation.

More generally, once Ch=hD is established, the remaining maps can be classified without inspecting a table of all functions. One chosen active input determines its entire cycle's images; its image may be any of the l+f target points since Cˡ fixes them all. Each fixed input independently maps to a C-fixed point. Thus for f>0 there are (l+f)fᶠ intertwiners, of which lf! are bijections; for f=0 there are exactly l, all bijective. The invertible part recovers the centralizer count when the two carriers are identified, while the other maps express genuine losses of distinction.

For f>0, bijectivity within this established intertwining family is equivalent to two relations: one active contrast h(x)≠h(Dx), and pairwise distinct images of all f fixed inputs. The first forces the active images to exhaust C's cycle, the second exhausts its fixed set. Their images are disjoint, so h is a bijection. Conversely every bijection satisfies them. If the new observations are only pairwise equality tests of h images, the exact worst-case number needed for this further question is 1+f(f−1)/2; it is zero when f=0. The displayed tests attain it. Each fixed-input pair must be compared: starting at a bijective h, merging just that pair changes none of the other pairwise answers. Tests only between fixed inputs still allow the active cycle to collapse to a fixed point, so at least one additional test is necessary. This counts further contrasts after full intertwining was established; it does not claim optimality for jointly acquiring all these relations from scratch.

### M64n

**M64n (two joint contacts forbid every partial merger).** Let X consist of four distinct source positions 0,1,2,3, with W=(0 2 3) fixing 1 and Z=(0 1)(2 3). Let h:X→Y be a total passage into an arbitrary carrier Y. The target carrier need not be finite or exhausted by these images. Two common, possibly partial target functions u,v satisfy the eight contact equations

    h(Wx)=u(hx),    h(Zx)=v(hx)    for every x∈X.

The supplied equations include admission of these applications. They already make u and v defined on h(X); no availability elsewhere in Y is required. The passage h is specified on the four source positions, not as a total operation on every possible source in the containing whole.

Neither h nor the target functions are assumed injective. No target cycle type, inverse, parity or global group action is given. Then h is either constant or injective. In particular, one established contrast h(a)≠h(b) forces all four images to be distinct.

Here is a direct proof from the contacts. If h identifies the fixed position 1 with any position in W's three-cycle, apply the common u repeatedly. The image of 1 remains the same, while the other position visits all three cycle positions. All four images therefore coincide. If h instead identifies two positions in that cycle, the same propagation under W makes h(0)=h(2)=h(3). Applying the common v to h(0)=h(2) then gives h(1)=h(3), so again all four coincide. Every proposed pairwise merger belongs to one of these cases. The acquired contrast excludes their common conclusion; no merger remains.

This is a restriction on possible implementations, not a finite search through Y. More target states cannot repair a partial merger while preserving the same h and common functions. For example, W alone admits h=(a,b,a,a), with a≠b and u identity on the two images. But Z would require v(a)=b from source position 0 and v(a)=a from source position 2. Those are the same argument of the same function. M71 rules out their joint realization under the retained contrast. An additional input or a changed reading can resolve the demand only by changing this contract.

Both contacts are substantive. Z alone admits h=(a,a,b,b), with v identity. It cannot distinguish the two source positions within either swapped pair. Thus each of these interfaces separately permits a nonconstant lossy passage; their joint structure forbids every such passage. In fact two is the minimum number of source permutation contacts with this property on four positions. A single nontransitive permutation with two or three orbits admits the orbit-label quotient. Identity admits any two-block quotient. A transitive permutation is a four-cycle and admits the alternating two-position quotient. In each case a common target function realizes a rank-two or rank-three passage. W and Z attain the two-contact bound. This minimum concerns whole permutation contacts, not the number of point comparisons needed to establish their equations.

The equations already make h(X) closed under u and v and give u³=id and v²=id there, even before a contrast is supplied. Observable return does not by itself recover the source: the fully collapsed image also returns. After a contrast rules out collapse, h is a bijection from X onto h(X), and these restrictions are faithfully hWh⁻¹ and hZh⁻¹. Every source word relation is preserved, and conversely no new equality between source actions appears on that image. The functions may be undefined or noninjective elsewhere in Y. The correspondence h⁻¹ exists on the image, but its description or an executable inverse port has not thereby been acquired.

The proof's general mechanism is that equality of h images must propagate under every shared contact: the kernel of h is an invariant equivalence relation on X. Here the explicit pair propagation leaves only equality and total equivalence. In group-action terminology this is a primitive action; W and Z generate the familiar four-position A₄ action. See the [GAP reference on primitive actions and invariant partitions, §§41.10–11](https://gap-system.github.io/gap/doc/ref/chap41_mj.html) for the existing terminology. This comparison is not an extra premise or a novelty claim. The two-case proof above does not require a classification of groups.

`JointContactRigidity.swift` presents this implication directly in types. `TwoContactImage` contains four node types and exactly the eight edge equalities. The two target contacts are the actual Left and Right projections on a node. Equality of nodes therefore gives equality of their projected successors without postulating extensionality for arbitrary named `PredicateReading` instances. Six generic constructors `ContactMerge01` through `ContactMerge23` each accept just one possible merger in addition to the edge relations and derive equality of all four images. No constructor asks the caller for the total-collapse conclusion. Faithful and fully collapsed graph presentations both conform. The consumer also derives W³ and Z² returns from the same actual fields.

These recursive nominal declarations present a finite contact graph; they do not claim to construct runtime recursive values. The proof does not depend on an execution or enumeration. The separate quotient constructions use existing W and Z words on arbitrary symbolic contents; a positive constructor distinction makes their shared-input obstruction concrete. A same-node projection retains arbitrary additional context K while still deriving one answer. The negative checks reject an actual partial graph conformance, the conflicting required answers and an attempt to recover two source positions with one fixed decoder answer.

This result removes M64m's given bijection and target cycle-class premises by establishing a different, joint contact contract. It does not obtain those eight equations from the bare existence of a distinction. They must themselves be established at their common source and target addresses. Nor does an observed finite history prove their unrestricted future persistence. The next acquisition question is which subset of actual contact and contrast comparisons suffices to derive this faithful passage when the target functions have no prescribed cycle structure.

**The response alphabet can follow from the joint contact law.** A finite list of encountered replies does not itself bound the unobserved replies of an arbitrary instrument. However, a bound need not always be postulated separately. Consider a total reading C:X×X→Y on these four positions, with arbitrary output carrier Y. Supply the two actual laws

    C(Wx,Wy)=C(x,y),    C(Zx,Zy)=C(x,y),    for all x,y∈X.

The same reading C and the same output comparison are retained. These are invariance equations for joint input changes, not an assumed Boolean answer and not a new name for the question C is meant to answer. They force exactly this form, for some output values a,b:

    C(x,y)=a when x=y;     C(x,y)=b when x≠y.

Consequently C has at most two output values. If it is nonconstant, a≠b and it is an exact code of equality, with its polarity still free. If constant, it supplies no comparison. No upper bound on Y or on the rest of the whole was used.

**Proof by the two joint orbits.** W and Z act transitively on X: W cycles 0,2,3 and Z connects that orbit to 1. The stabilizer of 1 contains W, which cycles every other position. Therefore the joint action is transitive on ordered unequal pairs: first move their first member to 1, then use a power of W to move the second to any other desired position. Mapping both a source pair and a target pair to (1,0), then reversing the latter map, joins any two unequal pairs. Diagonal pairs likewise form one orbit. There are exactly two orbits, the diagonal and its complement. The two displayed generator equations extend to their finite words, so C is constant on each orbit. This gives the entire table without enumerating its possible output assignments. ∎

The mechanism is general: on any carrier of at least two elements, an action transitive on ordered unequal pairs has these same two joint orbits. An invariant unary reading is constant by transitivity. A nonconstant invariant pair reading can exist and has exactly the two values just described. This identifies the first nontrivial relational arity under that action. It does not claim that every physical carrier has such a symmetry, or that every distinction divides the whole into two regions. Extra structure can support other invariant questions.

**Joint does not mean independent.** If C must also be unchanged when W acts only on its first argument, then

    a=C(0,0)=C(W0,0)=C(2,0)=b.

The readout collapses. More generally, independent transitive changes of both arguments make all ordered pairs one orbit. A comparison can ignore common changes of its frame while remaining sensitive to a change of the relation between its two inputs. Requiring invariance under both independent frame changes would remove the relation being measured. The commonness of the transformation is thus a positive condition of comparison, beyond an economy in calibrating two unrelated devices.

**Coordinate covariance alone gives no such bound.** For any C and any g, define a new reading C^g(u,v)=C(g⁻¹u,g⁻¹v). Then automatically

    C^g(gx,gy)=C(x,y).

Here the readout changes with the coordinates. This identity holds even for C(x,y)=x, whose range has four values and which does not compare its arguments. It does not establish the fixed-readout equations above. A law saying that actual joint contacts leave the same answer unchanged is stronger than a consistent relabeling of a description.

The source projection is also a complete obstruction to manufacturing the missing relation by further joint probes. From (x,x) and (x,y), with x≠y, every common word g gives the same projection gx. Every adaptive history of those replies remains identical. Averaging, orbit aggregation or further processing cannot recover equality from that access. The nonconstancy of an arbitrary pair reading is therefore insufficient; it must either have the joint invariant law or be supplemented by a contact which actually reaches the missing relation.

**The law identifies meaning without choosing signal names.** A nonconstant C meeting the equations already has only two possible answers, even if the output carrier contains arbitrarily many other forms. To decide which answer means equality, an actual self-contact can acquire C(r,r), for any available r. A later response C(x,y) then answers equality by comparison with that retained signal. This requires the same C, or an established transport of its two response classes. It does not require knowing r's coordinate or naming the two signals. A self-contact is additional available access, not two written copies of a symbol declared to be one physical operation.

Conversely, the polarity cannot be inferred just from these invariant laws. Interchanging the two output values preserves both equations and nonconstancy. A single unanchored response can therefore come from equal inputs under one code or unequal inputs under its exchanged code. The meaning is determined up to that remaining correspondence; an actual reference response can determine the correspondence needed for use.

**Static construction from the current rows.** `PairReadoutViews` builds the two joint pullbacks by applying `CoarseContactViews` to every row and then to the row positions. Both use the already constructed W,Z words; `FirstW` moves only the rows. `JointInvariantPairReadout` accepts arbitrary rows and the two whole-table equalities. It derives the table

    (a,b,b,b), (b,a,b,b), (b,b,a,b), (b,b,b,a),

where a,b are the actual first diagonal and first off-diagonal fields. It neither asks for a Boolean range nor repeats the table form among its premises. `TwoOrbitReadout` constructs that form with two arbitrary fields and the positive consumer derives both joint invariances. `IndependentReadoutCollapse` takes the additional actual one-sided invariance and derives a=b, rather than demanding their equality again.

Five consumer declarations check the two free codes, the derived fields, the changed self-reading under one-sided movement, a compensated reframing of the four-valued projection, and the admitted constant boundary. Two refusals reject independent invariance with distinct codes and treating the covariant projection as a fixed invariant comparator. The arbitrary finite table and its field implications are checked; physical availability and agreement of a real instrument with that complete table remain separate relations. No finite sample of an unspecified hidden continuation scope has been called this structural proof; VC107–108 distinguish those access conditions.

This does not replace M64n's earlier faithful-or-constant passage result. There the target can have nontrivial induced actions. Here the target answer is invariant and the source is a pair, with two joint orbits. Nor is it a claim of priority over the elementary orbit classification. Its use in VI is to establish the question and finite response form from actual transformations of the reading. The following coarse-sensor construction supplies such an equality answer by a performed sequence, instead of assuming that one primitive instrument already provides it.

**A coarse common sensor can supply exact comparison through actions.** The passage in M64n must admit autonomous target contacts. That requirement can be dropped when the participant may act on the original positions before comparing their coarse readings. Retain X={0,1,2,3} and the available reversible source contacts W=(0 2 3), Z=(0 1)(2 3). Let E:X→Y be any fixed nonconstant sensor. Its output need not identify a source position, and no sensor partition or output labels are supplied. Nonconstancy concerns this four-position carrier, not a contrast somewhere else in the whole. It may be grounded by an independently retained contrast; its coordinate location is not an extra input to the interface below.

Two initial positions x,y are unknown. A comparison round chooses an available word g, applies that same g to both originals, and acquires only the bit

    b_g = [E(gx)=E(gy)].

This is comparison of coarse sensor outputs, not an instrument already answering x=y. The same E is retained across both sides and all rounds. The participant receives neither x,y nor the sensor's table. The task is to decide equality of their original position values for every x,y and every admitted nonconstant E.

The following four rounds are sufficient, and four is the exact worst-case minimum even with adaptive word choices in this agreement-bit interface:

    F={id,W,Z,Z∘W}.

Here Z∘W performs W and then Z. Return true exactly when all four bits are true. One false bit already proves x≠y by functionality of the common sensor and contact. Four true bits prove x=y by the joint relations below. The count is of comparison rounds; each may contain multiple movement, return and reading operations. It is not four primitive actuator calls.

**The comparison graph gives the criterion.** More generally, for a specified finite X and a word family F, associate to each distinct x,y the undirected graph on X with edges {gx,gy}, g∈F. All acquired bits are true exactly when E is constant along every edge, hence on each connected component. Therefore all nonconstant sensors decide equality by these bits if and only if every such graph is connected. If a graph is disconnected, give one component one sensor value and its complement a distinct value. The sensor is nonconstant while this unequal pair passes every comparison. This also proves necessity without choosing a pre-calibrated sensor or enumerating all its possible tables.

For the four words above the six graphs have these edges, retaining repetition because four rounds were actually specified:

| original pair | id | W | Z | Z∘W |
| --- | --- | --- | --- | --- |
| 01 | 01 | 12 | 01 | 03 |
| 02 | 02 | 23 | 13 | 23 |
| 03 | 03 | 02 | 12 | 13 |
| 12 | 12 | 13 | 03 | 02 |
| 13 | 13 | 01 | 02 | 01 |
| 23 | 23 | 03 | 23 | 12 |

Each row connects all four positions. Its four equalities thus force E(0)=E(1)=E(2)=E(3), contrary to the supplied contrast. The cases x=y always pass. This proves the exact answer for the complete declared family while the sensor itself can remain unidentified and lossy.

**Why every three-round alternative fails.** This lower bound permits any three even permutations, so it also covers every three words built from W,Z and their inverses. Consider the three partitions of X into two unordered pairs:

    {01,23}, {02,13}, {03,12}.

Even permutations act on these three partitions by a cyclic group of order three. The kernel consists of identity and the three double exchanges. A nonidentity double exchange fixes each of its two exchanged pairs as an unordered pair.

If two chosen words induce the same permutation of the partitions, their relative permutation lies in that kernel and fixes some pair e. Consequently those two words give the same edge on e. With at most two distinct edges, the three-round graph on four vertices is disconnected.

Otherwise the three induced permutations are different. For each e, its three image edges belong to three different partitions. No two such edges are disjoint, since disjoint edges on four vertices belong to one partition. Three pairwise intersecting edges are either a star or a triangle. For the complementary pair of positions, every image edge is the complement of the corresponding edge for e. Complementing all three changes a star into a triangle and a triangle into a star. One of these two graphs is therefore disconnected. A nonconstant binary sensor constant on that graph's components supplies an unequal pair with all three bits true.

For an adaptive procedure, follow the branch consisting only of true bits. Equal originals make that branch possible with any nonconstant sensor. The first three chosen words are then fixed by the available history. The argument just given supplies unequal originals and an admitted sensor with exactly the same history. No exact procedure can finish on that branch by the third round. Four fixed rounds attain the lower bound. This concerns the interface exposing agreement bits only. Revealing individual sensor values, an anchored calibration contrast, the initial positions, or further controls changes the information available to the policy and needs its own bound.

**One changing whole can support acquisition internally.** Keep (E,x,y,H), where H retains earlier observations. A round moves x,y by g, appends the actual comparison bit, and applies g⁻¹ to both positions. E and H are retained during movement. The original positions return; the newly acquired bit remains. No copy of an unknown initial position and no external reset are needed. Inverses are available from W⁻¹=W² and Z⁻¹=Z. Different rounds can thus test the same original question while the complete recorded history grows. The declared comparison operation still has to implement the relation of the common sensor outputs. Neither its physical availability nor the sensor's nonconstancy is created by calling the returning bit a certificate.

The contrast premise cannot be omitted. A constant E makes every pair pass every word. The common-sensor premise is independent. For initial pair 01 choose the successive four sensor tables

    (a,a,b,a), (b,a,a,a), (a,a,b,a), (a,b,a,a),  a≠b.

Use these respectively at id,W,Z,Z∘W. Every acquired comparison is (a,a), although each sensor is nonconstant and the initial positions differ. It is their being the same actual E throughout the inquiry that allows equalities from different contacts to be joined. A common apparatus name or common container does not establish that relation.

**Static witness.** `CoarseContactViews` uses the existing phase-word catalogue for the actual sensor pullbacks. Its I, WW, Z and ZWW push words give the respective tables

    (a,b,c,d), (c,b,d,a), (b,a,d,c), (d,a,c,b).

The difference between chronological push words and the displayed source-action composition is checked explicitly. Six generic constructors `CoarseAgreement01` through `CoarseAgreement23` take the four appropriate coarse equalities and derive total sensor collapse. They do not ask the caller for that collapse or for source equality. An actual nonconstant sensor rules out each unequal source pair through these implications. Arbitrary hidden parts beyond X do not repair a failed implication while the same contacts, readings and contrast remain in place.

Five consumer declarations check the word meanings, the accepted constant-sensor boundary, three true comparisons with the last value still free, the final distinguishing comparison, and the changing-sensor counterexample. Two refusals reject the four-agreement premise on a nonconstant counterexample and identification of readings from different sensor tables. These are field and word proofs. The agreement-bit acquisition model and the optimality argument are stated above; the Swift file does not claim to implement a physical comparator or an arbitrary policy interpreter.

M64h/i weaken the needed knowledge of the forward and return channels while retaining local comparisons. This construction instead upgrades a nontrivial coarse comparison by available common source actions. It does not require an autonomous action on a sensor output: E may merge states whose later readings differ. The graph argument is an instance of invariant-relation reasoning; no general priority over observability or permutation-action results is asserted.

For The Cut, the useful conclusion is constructive: full recognition of each form need not be a primitive capacity of a witness. An actual contrast and jointly available contacts can force an exact comparison. The contrast alone does not supply those contacts. Equality of the represented position values also does not identify two experienced occurrences or establish feeling. Those are different relations of the source, not additional meanings of the same final true bit.

**The output polarity need not be known in advance.** The preceding construction knew which bit meant agreement. Now retain the same two unknown originals, common source actions and fixed sensor, but expose only c(b_g), where c is one fixed unknown bijection from the two Boolean answers to two distinguishable signal values. Its polarity is not given. There is no self-comparison, known-answer reference, individual sensor value or disclosed coordinate of a calibration contrast. Signals can still be compared with one another. Removing their interpretation does not remove the participant's capacity to distinguish the signals.

Assume 2≤|E(X)|≤r, for an integer r≥2. This upper bound is an additional relation of the sensor. One actual contrast establishes nonconstancy; it does not establish two-valuedness or any other upper bound.

For a nonempty finite word family F and arbitrary finite X, an exact equality decoder for every sensor and code in this family exists exactly when, for every unequal original pair, its comparison graph Γ satisfies

    Γ is connected, and χ(Γ)>r.

Here χ is the minimum number of colors in a proper vertex coloring. Under these conditions the decoder is particularly simple: the originals are equal exactly when all acquired signals are identical.

Indeed, equal originals give only true bits, hence a constant encoded history. For unequal originals, all true bits would make E constant on every connected component. Connectivity and nonconstancy exclude this. All false bits would make the sensor values a proper coloring with at most r colors. The chromatic condition excludes this as well. There must therefore be both kinds of bit, and the common bijection preserves that nonuniformity. No choice of the unknown polarity changes the answer.

Conversely, a disconnected graph admits a nonconstant binary sensor constant on each component, giving only true bits for unequal originals. If χ(Γ)≤r, a proper coloring gives only false bits. Since F is nonempty and its actions are permutations, Γ has an edge and this coloring is nonconstant. In either case choose the unknown code so that this constant history equals the constant history of equal originals with an admitted code. No decoder of those signals can distinguish the two realizations. This necessity concerns any decoder, not just the proposed uniformity rule. It is a finite graph proof, not a test of sampled sensor tables.

**Five rounds for a binary sensor.** On the four positions with W,Z, add W² to the preceding four words. The resulting rows are:

| original pair | id | W | Z | Z∘W | W² |
| --- | --- | --- | --- | --- | --- |
| 01 | 01 | 12 | 01 | 03 | 13 |
| 02 | 02 | 23 | 13 | 23 | 03 |
| 03 | 03 | 02 | 12 | 13 | 23 |
| 12 | 12 | 13 | 03 | 02 | 01 |
| 13 | 13 | 01 | 02 | 01 | 12 |
| 23 | 23 | 03 | 23 | 12 | 02 |

Each row is connected and contains a triangle: respectively 013, 023, 023, 012, 012, 023. No triangle has a proper binary coloring. Five fixed rounds therefore suffice for every nonconstant binary sensor, without acquiring its table or the output polarity.

Four rounds cannot suffice. The even action on the three partitions into pairs has three possible values. Among four chosen words, two have the same value. Their relative action is identity or a double exchange and fixes some unordered pair. On that input pair the two words give a repeated edge, so there are at most three distinct edges. A connected graph on four vertices with at most three edges is a tree, hence bipartite; a disconnected graph fails the other required condition. Thus some unequal pair admits a constant encoded history.

For adaptivity follow one constant signal s, a possible history for equal originals with c(true)=s. The words chosen along that history are fixed. For at most four words the preceding argument supplies an unequal pair and a sensor giving uniformly true or uniformly false answers. Choose its fixed code to map that answer to s. It then follows exactly the same adaptive branch. Consequently five is the exact worst-case round count, not just the length of one successful schedule.

**Nine rounds when three sensor levels are admitted.** A graph on four vertices has chromatic number greater than three exactly when it is K4. If an edge is missing, its endpoints can share a color and the other two vertices use separate colors. Thus every unequal pair must visit all six possible output edges.

Let V={id,(01)(23),(02)(13),(03)(12)}. It is the kernel of the action on the three pair partitions and has three cosets in A4. For a fixed edge e, its stabilizer in A4 consists of identity and the double exchange which exchanges e and its complementary pair. The map g↦g(e) therefore has exactly two elements in each fiber; those two lie in one V-coset. Omit one element from each of the three V-cosets. No entire fiber is omitted, so the remaining nine actions carry every e to all six edges.

In particular, omit {id,W,W²}. The remaining nine actions are exactly the catalogue words containing Z, in chronological notation:

    Z, ZW, ZWW, WZ, WZW, WZWW, WWZ, WWZW, WWZWW.

The set is inverse-closed: its omitted subgroup is inverse-closed. Thus using the catalogue's push tables or the corresponding source pullbacks gives the same set of nine actions. This resolves direction without treating an individual word and its inverse as identical.

For the lower bound, any set of at most eight even actions omits at least four of the twelve. Two omitted elements u,v lie in one V-coset. Their relative nonidentity double exchange fixes some edge e. The pair {u,v} is the entire fiber carrying e to u(e). The tested graph for e therefore lacks that edge and admits a proper coloring with at most three colors. This gives only false bits. Repeated words add no edges. Along a constant-signal adaptive branch the same omitted-fiber argument applies to its chosen words; choosing c(false)=s matches equal originals with c(true)=s. Nine is the exact worst-case count in this interface.

**An admitted injective sensor changes possibility itself.** If four sensor levels are allowed, take an injective E. Every permutation gives true for equal originals and false for unequal originals. Opposite unknown codes make their entire signal histories identical. This remains so after every available word, under adaptive choices, and for arbitrarily long histories. It even survives adding more source permutations. The obstruction is not an insufficient finite search: this access cannot separate the two realizations at all.

The known capacity bound is doing positive work. It forces a merger on a graph which cannot be properly colored by that many sensor values. This is not a claim that discarding accessible information improves an answer. Individual values were never supplied, and the source family with a known capacity bound is more restricted. An upper bound on a sensor is also not a bound on the size of the whole or a claim that reality itself has only two or three values.

**One added kind of contact removes that impossibility.** Suppose the interface additionally admits an actual self-comparison, passed through the same fixed unknown code. Its answer identifies c(true), without identifying E or any original position. Follow it by the four source comparisons above. Five rounds now suffice for every nonconstant E, with no capacity upper bound. This is a new available relation, not a free semantic label attached to one of the old signals.

Five is also necessary in this augmented interface. Follow the constant signal c(true). If a procedure makes a self-comparison within four total rounds, it has at most three comparisons of the unknown originals. Their graph is disconnected for some pair by the preceding three-round lower bound, so a nonconstant sensor makes every one of those answers true as well. If it makes no self-comparison, the four-round binary counterexample still belongs to the admitted family. Either way an unequal pair shares the equal pair's history. A fifth round is required. Thus a new contact can replace a nine-round indirect inquiry, or turn an impossible inquiry into a five-round one, while retaining the same unknown sensor. Its physical availability must be established separately.

**Static boundary and reuse.** `FiveContactTriangles` extracts the six actual triangles from `CoarseContactViews` and the existing W² table. `TriangularContactCalibration` derives equality of the two markers from three successive reversals which close. It reuses `OddContactCalibration` by inserting a back-and-forth edge into the triangle. Equality is a conclusion, not an extra requirement. In a genuine binary alphabet, unequal neighboring colors determine opposite marker orientations, so this construction witnesses the obstruction to three unequal edges. Arbitrary Pair conformances are not assumed to exhaust that alphabet.

The earlier six connected-graph constructors supply the all-true obstruction. Four new consumer declarations check the triangles, their collapsed boundary, an actual four-round all-opposite example, and its fifth equal reading. Two refusals exclude closing three reversals with distinct markers and retaining the old opposite pair at the fifth read. The general coloring criterion, the nine-round fiber bound and adaptive lower bounds are mathematical proofs above. They are not represented as generic Swift claims about all colorings or all policies.

The round may retain (E,c,x,y,H), move both positions, record the actual encoded signal and restore the positions through the inverse word. Neither E nor c changes between the joined readings; H keeps the new record. A changing code can make unequal bits look uniform, just as changing E defeated the preceding construction. The available distinction between signals is therefore still an actual premise. What has been removed is prior knowledge of their meaning, in the precise interfaces and families just proved sufficient.

**Complete pair readings need not cover the relation of a triple.** The joint W,Z action has the same orbits on X and X² as all permutations of X. That agreement does not extend to X³. Its triple orbits are:

* all three entries equal;
* exactly two equal, with each of the three possible singleton positions;
* all three different, with two possible orientations.

There are six orbits, whereas the full permutation action has five. To establish the last split, complete a distinct ordered triple (x,y,z) by the unique missing fourth position r. Relative to one ordered reference, the resulting four-position permutation is even or odd. An even common action preserves that sign. Two completions of the same sign are connected by their relative even permutation. An odd common action exchanges the two classes. Their names are conventional; the distinction between the two A4-orbits is not removed by changing those names together.

The repeated-entry cases have the same orbits under both groups. Once a map between their at most two used values is fixed, there are at least two unused positions. Exchanging those unused positions changes the parity of its extension without changing the tuple. An even extension therefore always exists. This also proves directly why pair readings cannot see the additional distinction.

For example, (0,1,2) and (1,0,2) have identical values under every invariant unary and binary reading of their entries, including every choice of pair and every repeated self-entry. After any common word the entries are still all distinct, and all those readings remain equal between the two preparations. In this interface the retained history contains response records; source moves act on the three current entries together. It supplies no separately retained source reference or selective movement of just one entry. Any adaptive history using only these readings and common words is identical: induction fixes the next choice and its next reply in both cases. Thus even a complete pair calibration does not determine the orientation class through this access.

**The required arity can grow.** On n≥3 positions, A_n and S_n have the same orbits on every tuple of length k≤n−2. A tuple uses at most n−2 positions, so the unused-position exchange just described can correct the parity of any extension. At arity n−1, an all-distinct tuple leaves only one unused position; its extension is unique and its two parity classes split. Hence n−1 is the first arity at which an invariant reading can expose a difference between their tuple-orbit partitions.

This cannot be repaired by composing more of the invariant relations of arity at most n−2 while keeping the same unmarked scalar carrier. Every such relation is already S_n-invariant. Conjunction, negation, disjunction and quantification over that same carrier preserve this invariance, as follows by transporting each assignment. No parameter-free expression in that relational language can select just one of the two orientation classes. This is a limitation of the specified relations and access, not of the amount of reasoning or the number of their instances.

A named contact, a retained asymmetric parameter, or a richer internal carrier can change the language. In particular, a nested VI Pair may retain an entire ordered tuple. Its binary constructor is not a promise that every available predicate concerns only two unstructured scalar positions. Tuple packaging alone does not select an orientation; its contact relations must supply the missing distinction. VC23a makes the corresponding distinction for Boolean constraint media; the present obstruction instead follows from a common permutation preserving all the admitted relations.

**A relational contact makes orientation available to a pair comparator.** Suppose x,y,z are three distinct positions and an available q cycles exactly those three, fixing their missing fourth position. Then

    [q(x)=y]

distinguishes the cyclic order (x,y,z) from its reversal. A single calibrated equality comparison suffices after this q is available. With an uncalibrated two-code comparator, a retained response on a known unequal pair of the triple supplies the off-diagonal reference; comparison with the new response then determines the same answer. Acquiring that reference is an additional call if it was not already retained.

This does not contradict the pair-reading obstruction. The complete probe uses q as well as the two compared values. It is a relation of the tuple and the contact, rather than an invariant reading of two otherwise unmarked values. The third value enters through the established cycle support; a cycle with another support or the opposite direction is a different probe.

There is a useful connection to M64g. The A4-conjugacy class of W contains exactly one three-cycle with each possible fixed point. To see this, if g and h send W's fixed point 1 to the same r, then h⁻¹g fixes 1 and is a power of W, hence commutes with W. Therefore gWg⁻¹=hWh⁻¹. Existence comes from transitivity. The inverse cycles form the other class. Once one such directed class is supplied, the missing fourth position selects its q uniquely; the unused choice of transporting frame need not be identified. Mere existence of that q does not, however, supply an implementation or an acquired address for it.

For the prepared support {0,1,2}, the selected cycle may be q=(0 1 2). The two orientations above give [q(0)=1]=true and [q(1)=0]=false. In the existing catalogue its input pullback is the push word WWZ, whose four rows are (row1,row2,row0,row3). The inverse pullback is ZW. These are actual established words, not new primitive cycle names.

**The contact must be transported too.** Under a common frame change g, set q′=gqg⁻¹. Then

    [q′(gx)=gy]=[q(x)=y].

This works for odd as well as even g: it is the relative relation of the contact and inputs that is preserved. For g=(0 1), the cycle q=(0 1 2) is conjugated to q⁻¹. The reflected triple (1,0,2) gives true with q⁻¹, but false if the old q is used instead. Keeping the old contact while renaming only the input is a changed physical relation, not an alternative notation for the same complete probe. Transporting q adds precisely the relation absent from the pair-only language.

**The boundary of the carrier matters inside a closed whole.** Local evenness does not follow from evenness of a larger complete permutation. In a six-position whole, take the four-position region {0,1,2,3} and an internal reserve {4,5}. The allowed whole action (0 1)(4 5) is even and preserves both regions as sets. It nevertheless reverses the local triple orientation. The compensating exchange is entirely internal. Therefore the local A4 scope requires a restriction on its actual contacts or a retained relation to that reserve; closure and global parity alone do not establish it. This is the same distinction between a complete joint law and a local projection that VC99 exhibits in its coupled actions.

**Acquired static witness.** `TripleOrientationContact` starts with the current two-code comparator table, applies WWZ, acquires the actual row0/column1 or row1/column0 response, and applies the inverse word to the table beside the new record. `ReturnedTableAndAcquiredAnswers` derives both complete table returns and the distinct response fields a,b. No unknown table entry is supplied to a decoder as an extra argument. The two paths are prepared representative probes; the orbit proof above covers the stated relation of general triples and transported contacts.

The same constructor applies the existing exchange T=(0 1) to both axes of the pulled table and derives its equality to the inverse-contact table. This checks the contact transport, not just the names of the two answer classes. Five consumer declarations verify indistinguishable direct pair readings, acquisition with return, the actual conjugated table, the preserved response after joint transport, and the admitted collapsed comparator boundary. Two refusals exclude merging the acquired opposite answers and using the stale contact for the reflected input.

The result complements VC100h: separately characterized actions or views can leave a joint relation unresolved, and a contact can acquire that relation. M65's equality-pattern classification uses compatibility with all injective interpretations, including larger carriers. The orientation split here uses the narrower fixed-carrier action and is not an exception to that classification. No physical geometry, universal ternary atom or priority over permutation-orbit results is inferred from this finite model.

## Cross-page mentions

Labels mentioned here: <doc:permanence_is_resistance__frame_acquisition#M64d>, <doc:permanence_is_resistance__frame_acquisition#M64g>, <doc:permanence_is_resistance__frame_acquisition#M64h>, <doc:permanence_is_resistance__frame_acquisition#M64j>, <doc:permanence_is_resistance__uniform_routing#M65>, <doc:permanence_is_resistance__forced_answers#M71>, <doc:verdict_is_invariant__action_interfaces#VC100h>, <doc:verdict_is_invariant__bounded_calibration#VC107>, <doc:verdict_is_invariant__recovery_memory#VC23a>, <doc:verdict_is_invariant__relative_questions#VC85>, <doc:verdict_is_invariant__local_lifts#VC99>.

Mentions of this page’s labels: <doc:interference_is_substitution__models_calibration> (M64n), <doc:permanence_is_resistance__forced_answers> (M64k), <doc:permanence_is_resistance__support_renewal> (M64n).
