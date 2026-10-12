# Permanence Is Resistance (Matter) — Joint laws

This part contains the original derivations for joint laws.

Family and original section headings: <doc:permanence_is_resistance>.

Section setting: <doc:permanence_is_resistance#4g-Which-future-must-carry-a-real-distinction>.

### M64ai

**M64ai (uniform reversible movement can use the request without learning the values).** The fixed whole-row permutations in M64ah are not the largest uniform interface preserving the selected answer. Fix q≥1. For every value set A let a rule act on A^q×{0,…,q−1}, a value tuple and its selected position. Require transport under every value interpretation h:A→B, including interpretations identifying values, with the position left unchanged by h. On the binary carrier A={0,1}, require no merging of complete inputs and preservation of the selected value. The rule itself may read the selected position. Bijectivity and preservation on every A will follow, rather than being extra premises.

Exactly the following rules satisfy these conditions. Choose a permutation σ of the q selected positions. For each old position i choose a permutation π_i of the q value occurrences satisfying π_i(i)=σ(i). The rule sends position i to σ(i) and sends each value occurrence k to position π_i(k). There are exactly

    q! · ((q−1)!)^q

such uniform rules. At three positions this gives 48, including the six fixed whole-row permutations as a proper subgroup.

*Proof.* Interpret q different generic markers as any value tuple. Naturality forces each output coordinate, at each given i, to select one of those markers. It also makes the output selected position depend only on i: the interpretation into a one-value set removes all value distinctions while retaining that position. This gives a map σ and coordinate selections f_i. On the binary carrier, an all-zero tuple remains all-zero under each coordinate selection. Two different positions i with the same σ(i) would therefore merge complete inputs. Binary injectivity forces σ to be a permutation. If an f_i omitted an input coordinate, two binary value tuples differing only there would merge at the same output position σ(i). Thus f_i selects all q coordinates once; its inverse is the occurrence movement π_i. Preservation of the selected value forces π_i(i)=σ(i): otherwise a binary tuple separating i from f_i(σ(i)) already gives a wrong selected answer. Conversely these conditions define a bijection: recover i by σ⁻¹, then undo π_i. They commute with every h and retain the selected value. There are q! choices for σ and (q−1)! choices for each π_i, proving the count. The proof extends M65's generic-marker argument with an explicit internal request; no value equality test is hidden in the rule.

The interpretation premise can itself be reduced to binary readings. Write B={0,1}. It suffices that T_A commute with every coordinatewise binary reading b:A→B, including the selected position unchanged:

    (b^q × id) T_A = T_B (b^q × id).

To see this, first take A to be the q distinct generic markers and read its generic tuple. Its output supplies some selected position σ(i) and coordinate indices f_i(j). Every binary q-tuple is the image of this generic tuple under a choice of b, so the equation forces T_B on *all* binary tuples to use these same indices and σ. Now take any A and input tuple. Every binary reading of its output coordinate equals the same reading of input coordinate f_i(j). Binary readings separate two different elements, forcing equality of these actual coordinates. The position is likewise σ(i). Thus all T_A have the same selection form, which then commutes with every interpretation h:A→C. Binary injectivity and answer preservation give the previous classification. This is a quantified structural reading contract, not a claim that a finite number of physical trials establishes every such binary reading for an unknown apparatus.

A nonseparating reading family cannot replace that condition. On a three-value carrier, restrict the binary readings to those identifying two specified distinct values. Exchanging those values in the selected coordinate preserves every retained reading and is reversible, while changing the selected answer. The missing contrast is precisely what the reduced test would fail to constrain.

After fixing reference names for the q−1 unselected positions at each i, composition has the familiar wreath-product form (S_(q−1))^q ⋊ S_q. The content here is its derivation from the stated interpretation, recovery and question requirements. It is not a priority claim about wreath products, and the uniformity under all interpretations remains a substantive interface premise. Requiring only invariance under renaming would allow further value-dependent rules, as M65's equality-controlled example shows.

For q=3, one additional generator suffices beyond whole-row moves: exchange the two unselected rows only when the selected row is at position 0; otherwise do nothing. It is an involution and preserves the marked value. Conjugating this gate by the fixed whole-row permutations supplies independently the gate at each of the three selected positions. The gates commute because their trigger domains are disjoint. Their eight products together with the six transports realize all 48 rules: after matching σ by a whole-row permutation, the remaining rule fixes i and independently either exchanges its other two positions or leaves them. `GatedUnmarkedFrameMove` gives the actual three clauses and their return. This is a closed source-dependent movement library, with no measurement of the value needed to choose its branch.

The larger library does not enlarge the set of configurations reachable from any one fully specified source: each branch still performs a whole-row permutation. It enlarges the uniform operations available across unknown sources. The gated rule cannot be replaced by one fixed row permutation for all marker positions. Nor does knowing the selected value always reveal the gate's branch. For values (a,a,b), a≠b, marking position 0 or 1 gives the same unmarked tuple and the same selected value a. The gate respectively produces unmarked tuples (a,b,a) and (a,a,b). A participant allowed only those old readings cannot select both full transformations. The admitted native rule uses the actual marker; an external implementation must establish access to that distinction or an equivalent coupling.

Consequently preservation need not freeze the unused parts, the request's coordinate, or the whole frame. What must remain intact is the addressed value-request relation. Arbitrary compositions of these admitted rules preserve it. A physical implementation must still realize that relation at its contact boundaries; the finite classification does not supply physical timing or a universal model of material transformations.

### M64aj

**M64aj (one shared ternary carrier forces the uniform binary rule).** The interpretation premise of M64ai has a more concrete realization criterion. Let B={0,1}, C={o,l,r}, and supply two fixed readings p,s:C→B with joint profiles

    o ↦ (0,0),       l ↦ (1,0),       r ↦ (0,1).

The two binary readings cannot both equal 1 on one C-value. Apply them coordinatewise to q-tuples, retaining the same selected position i∈I={0,…,q−1}. Fix any injective total rule T_B on B^q×I which preserves the selected bit. There exists a total T_C on C^q×I making both actual reading squares commute with this *same* T_B iff T_B belongs to M64ai's classified family. No recovery, naturality or question-preservation premise is added for T_C; its form and these properties follow. Here C and the two readings are fixed before the rule is tested, rather than defined from its desired outputs.

*Proof.* Write T_B(x,i)=(F_i(x),κ_i(x)). Any two disjoint binary vectors x,y are the two readings of exactly one C-tuple. Their successor readings must remain disjoint and have the same successor selected position. Comparing x with the zero vector shows that κ_i(x)=κ_i(0)=σ(i) for every x. Taking both vectors zero shows F_i(0)=0, since a nonzero coordinate in both would require the missing C-profile (1,1). Binary injectivity now makes σ a permutation and each F_i a bijection of the finite set B^q.

The q unit vectors are pairwise disjoint. Their images under F_i are nonzero and pairwise disjoint, hence are exactly q distinct unit vectors. They determine an occurrence permutation π_i. For any x, disjointness from every unit vector outside its support gives support(F_i(x))⊆π_i(support(x)). This inclusion is equality. Induct on the size of the support: if the inclusion were proper, its preimage under π_i would be a proper smaller support whose already established image equals F_i(x), contradicting injectivity. Thus F_i is precisely the coordinate permutation π_i. Preservation of the selected bit forces π_i(i)=σ(i), by a unit-vector witness. The joint C-reading is injective, so it forces T_C to perform those same occurrence movements and selected-position changes. Conversely every classified rule gives that T_C and both squares. This proves necessity, sufficiency and uniqueness of the lift.

Any additional value carrier with a jointly separating family of binary readings, commuting with this established T_B and retaining the common selected position, is forced to use the same π_i and σ. For a one-value carrier include at least one reading to bind the selected position; no source input exists on an empty carrier when q≥1. The resulting family then respects all interpretations without having assumed them as its initial law. Separation binds the values; the shared selected-position output binds the request.

The source need not be exactly this finite profile carrier. Let K be an arbitrary carrier with an actual profile E:K→C^q×I and a change U:K→K. If the two readings through E commute with T_B, the same argument applies whenever the required input profiles are realized. Hidden details of K, its cardinality and its own recovery are not used. Once π_i and σ are forced, the injective joint profile reading gives E∘U=Π∘E, where Π is the derived occurrence movement. Thus autonomous motion of the profile is a conclusion, not a separately supplied law for an imagined complete source.

For this classification even all 3^q profiles are unnecessary. The proof uses (x,0), pairs of different unit vectors, and (x,e_j) with x_j=0. It suffices to realize, at every selected position, all C-tuples containing at most one r. There are 2^q+q·2^(q−1) such profiles before counting positions. They already include every binary input and the individual contrasts used in the proof. This is a sufficient coverage family, not a claimed minimum number of experiments. The single forbidden-profile witness below requires only its one stated initial profile and the preserved reading ranges. Adding hidden states cannot supply the missing joint value while retaining those ranges and both actual squares.

The ternary condition excludes real alternatives to mere binary recovery. With two positions and position 0 selected, flip only the second bit; at the other selected position let the rule be identity. This is a bijection and preserves the selected bit. At selected position 0 the all-zero vector becomes (0,1). Two all-zero binary readings of the same all-o source would therefore both become 1 in its second coordinate, outside the fixed C carrier. No T_C can make both squares commute. `BinaryChangeWithoutTernaryLift` builds this witness with reversible swaps of the internal two-field bit representations and reads the forbidden joint profile after both actual binary changes. Each individual binary transition returns and preserves its selected first bit.

This supplies a specific shared-realization requirement in place of an unrestricted naturality declaration. It is still a requirement on complete admitted maps and their source-bound readings. A few sampled coincidences of two instruments do not establish the squares on all their inputs, and independently chosen binary evolutions are not the common T_B assumed here. No physical realization of these carriers is inferred from their mathematical consistency alone.

### M64ak

**M64ak (the common law is forced, not assigned to both channels).** In M64aj the two binary channels were required to use the same law. This equality can itself be derived. Retain the three joint profiles 00, 10 and 01, the same selected-position set I, and q≥1. Let

    T(x,i)=(F_i(x),κ_i(x)),       V(y,i)=(G_i(y),λ_i(y))

be two independently specified total injective maps on B^q×I. Require that their images can still be joint readings of one successor: for every supplied disjoint pair x,y at position i, the vectors F_i(x),G_i(y) are disjoint and κ_i(x)=λ_i(y). Only T is required to preserve the selected bit. Then the following finite coverage already forces T=V, with both of M64ai's form:

    (x,0)                  for every x;
    (x,e_j)                whenever x_j=0;
    (1−y,y)                for every y.

Here a pair denotes the two readings of one actual ternary profile, not separately prepared binary sources. The last row uses only l,r values, and complements are descriptions of preparations, not an unacquired change to a measuring channel. At each selected position the union contains

    2^(q+1) + q·2^(q−1) − q − 1

profiles. This is an explicit sufficient family, not a minimal one. It has 24 profiles for q=3, rather than all 27.

*Proof.* The first family makes κ_i(x) independent of x; write its value σ(i). The last family makes every λ_i(y) equal to the same σ(i). Injectivity makes each F_i an injection B^q→B^q, hence a bijection. Two different i cannot have the same σ(i), because their full image blocks would then coincide. Thus σ is a permutation, and each G_i is also a bijection. Disjointness of F_i(x) from G_i(0) for every x forces G_i(0)=0.

For each j there are 2^(q−1) different x with x_j=0. Their distinct F_i images must all be disjoint from G_i(e_j). A vector of weight w has exactly 2^(q−w) disjoint binary vectors. Consequently G_i(e_j) has weight at most one. It is nonzero by injectivity and G_i(0)=0. These q different unit images define a permutation π_i.

The second family now gives support(F_i(x))⊆π_i(support(x)). This inclusion and bijectivity force equality: by induction on support size, a proper inclusion would duplicate the image of the smaller preimage under π_i. In particular the empty support is fixed. The last family then gives support(G_i(y))⊆π_i(support(y)); the same induction gives equality. Thus F_i=G_i=π_i. T's selected-bit preservation, tested on e_i, forces π_i(i)=σ(i). V's preservation is a conclusion. Conversely these common role movements preserve every disjoint pair and hence all the supplied profiles. The count is M64aj's at-most-one-r family plus all 2^q profiles without o, with their q+1 overlaps removed. ∎

**A complete returning source can supply the two recoveries.** Let K be arbitrary, E:K→C^q×I an actual profile, and U:K→K onto. Suppose E realizes the displayed coverage and both fixed readings satisfy

    P∘U=T∘P,       S∘U=V∘S,
    P=(p^q,id)∘E,  S=(s^q,id)∘E.

T,V need initially be only total maps. Coverage makes P and S onto the finite binary domain. Since U is onto, these equations make T and V onto, therefore bijective. M64ak applies, and joint separation then derives E∘U=Π∘E. No enumeration or finiteness of K is required; E need not realize all ternary profiles. Equality of the channel laws and autonomous movement of the joint profile are conclusions.

Onto means every state in this declared K has a predecessor under this same U. Here a predecessor is a preimage of this operation, not a separately assigned temporal past. A reversible complete law supplies it. Injection alone on an infinite K does not. Nor does a return available only on the prepared episodes establish it for an arbitrarily enlarged scope. The binary maps, fixed readings, shared successor, coverage and selected-bit relation remain explicit premises. No sampled prefix alone establishes their universal applicability.

**Separate coverage is not the joint coverage used in this proof.** At q=2 and selected position 0, admit only the six ternary tuples

    oo, or, ll, lr, rl, rr.

Let the source law exchange oo with or and ll with lr, and fix rl and rr. It is a permutation and preserves the selected first row. Both binary readings separately realize every two-bit input. Each position also realizes all three joint codes o,l,r. Nevertheless their autonomous binary laws are different:

    T(x₀,x₁)=(x₀,x₁ XOR x₀),
    V(y₀,y₁)=(y₀,y₁ XOR (1−y₀)).

Both are involutions preserving the selected bit. The six displayed source transitions directly verify both squares. For example, oo→or leaves P=00 fixed and sends S=00 to 01; ll→lr sends P=11 to 10 and also sends S=00 to 01. The other two exchanged directions reverse these changes, while rl and rr give the stated fixed channel inputs. To include selected position 1 in the original domain, supply every ternary tuple there and let both laws be identity on that component.

What fails is joint preparation coverage at position 0: ol, lo and ro are absent. For instance, the proposed channel changes at ol would demand second-row profile 11. Individually complete channels and complete single-position alphabets therefore do not replace the family of joint profiles in M64ak. This is a finite reversible counterexample to that weaker coverage condition.

The same witness also forbids extending this carrier by the profile ol while keeping both old autonomous channel laws and the excluded pair 11. A hidden enlargement cannot supply the required successor. At least one of those relations must change. This is an obstruction to that proposed extension, not a claim that ol is impossible in every other realization of a ternary carrier.

### M64al

**M64al (one missing joint possibility is the restrictive relation).** The particular missing pair 11 in M64ak is not distinguished. For any three of the four binary pairs, two injective autonomous channel laws compatible with all profiles again coincide and move roles as above. Complement the first and/or second channel on both its input and output so that the missing pair becomes 11. This conjugates the two laws separately, preserving injectivity and the selected-bit condition. Apply M64ak to the transformed profiles. A coordinate permutation commutes with whole-vector complement, so undoing the two conjugations leaves the same law on both original channels. The correspondingly transformed sparse coverage also suffices.

The range condition cannot be replaced by having two binary channels. If their joint range is all four pairs, their vector readings can be chosen independently. Compatibility still forces a common σ, but for each i the two vector maps can be arbitrary bijections, separately, with the stipulated selected-bit preservation. Pair their output bits to construct the unique common four-valued lift. For example, at q=2 and selected position 0, one channel can flip the second bit while the other does nothing. The common lift is reversible and preserves the selected pair, although the laws differ and are not common role movements. Set both laws to identity at selected position 1. Its forbidden ternary input is the second row (0,1), which becomes (1,1); on a four-profile carrier it is allowed.

For q≥2, three distinct profiles are also minimal among carriers whose two binary readings are individually onto and jointly separating. A two-profile carrier has either equal or complementary readings. In the equal case use the same selected-bit-preserving non-routing binary bijection on both channels. In the complementary case use conjugate laws V=c∘T∘c; their paired outputs remain complementary. Flipping the unselected bit supplies such a counterexample for q=2. Thus two, three and four joint possibilities play different roles: two may tie the channels without restricting their dynamics; three force a common role law under the supplied recovery and coverage; four admit independent channel dynamics. This concerns these exact finite profiles, not the number of values of a general physical system.

**Without the returning-profile premise, retained history is not enough.** At q=2, selected position 0, let T flip only the second binary bit and let V keep the first bit and set the second to zero. Both preserve their selected bit. On the ternary carrier their common lift keeps the first row and sends the second row

    o→l,       l→o,       r→l.

It is total and the two squares commute, but V and the joint lift are not injective. At selected position 1 let both laws and the lift be identity. The complete carrier K=(C^2×I)×(C^2×I)* nevertheless has an injective realization

    U(z,h)=(J(z), h followed by z).

The old source is recovered from the last history entry. Reading only the current z gives the stated different channel laws at every step, with complete profile coverage. U is not onto K. This is a retaining construction inside the supplied whole, not information sent outside it. The example isolates exactly why global injection cannot substitute for the onto premise used above. A history-sensitive question has a different reading from the present profile question.

### M64am

**M64am (exact acquisition using only the profiles needed by the proof).** Suppose M64ak's class has been established and one unknown fixed member is now accessed by prepared ternary-profile queries. A query chooses the initial tuple and selected position and acquires the complete successor profile, including its selected position. Preparations and readout are available for the family S_q used in M64ak: at most one r, or no o. Queries concern the same law; they do not replace it. For q≥3, the exact worst-case number of queries to identify its whole action on C^q×I is

    q·k_q,       k_q=min{k≥0 : 2^k+k ≥ q−1}.

The count is for this preparation/readout interface. It is not the cost of establishing M64ak's premises or physically realizing a trial.

*Attainment.* At a fixed selected position i, give the other q−1 positions different length-k_q signatures. There are 2^k_q ordinary signatures over {o,l}. If more are needed, add up to k_q signatures, each using r in its own one column and o elsewhere. The selected position has the all-o signature and may duplicate an unselected signature: the returned marker independently locates its image. Every column is a permitted preparation with at most one r. The returned marker gives σ(i); the other output signatures give π_i on all remaining positions. Repeat for each i. The receiver decodes only acquired output profiles and the chosen preparations, not a private address of the unknown law.

*Necessity, including adaptation.* Fix a reached transcript and a selected position i queried k times. Each permitted preparation is either binary over {l,r}, or binary over {o,l} with at most one exceptional r. Across these k queries, at most k unselected positions are ever exceptional. Every other position has one of at most 2^k binary signatures, with the appropriate two-symbol alphabet in each column. Thus there are at most 2^k+k different unselected signatures. If q−1 exceeds this number, exchange two positions with the same signature before π_i, changing no other π or σ. This gives another member of the established class with the same answers to every query in the transcript but a different action on other data. Adaptation selects the same next queries on that branch. Hence every i needs at least k_q queries. The construction attains their sum. ∎

For q=1 the class contains only identity, needing no query. For q=2 the only unknown is σ; one returned marker determines it and both π_i. These are the exceptional cases omitted by q·k_q.

If arbitrary ternary preparations are independently available, the same signature argument instead gives q·⌈log₃(q−1)⌉ for q≥3. For arbitrary binary preparations it gives q·⌈log₂(q−1)⌉. A larger palette is not by itself the same as access to all its patterns. For example, q=8 takes 24 queries using S_q, while full ternary preparations take 16; for q=4 both ternary interfaces take four, whereas binary preparations take eight. These are questions about the complete law. The transported selected value is already invariant throughout the class and needs none of this calibration.

## Cross-page mentions

Labels mentioned here: <doc:permanence_is_resistance__reusable_requests#M64ah>, <doc:permanence_is_resistance__uniform_routing#M65>.

Mentions of this page’s labels: <doc:learning_is_liquid__reconstructed_sides> (M64ak), <doc:permanence_is_resistance__reacquisition_residue> (M64ai), <doc:permanence_is_resistance__reacquisition_residue> (M64ak), <doc:permanence_is_resistance__reacquisition_residue> (M64al), <doc:permanence_is_resistance__reacquisition_residue> (M64am).
