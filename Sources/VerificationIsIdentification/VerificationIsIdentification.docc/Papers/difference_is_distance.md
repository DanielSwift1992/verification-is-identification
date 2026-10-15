# Difference Is Distance (Space)

A form can contain distinctions, records and reference relations within one whole. Comparing two such records gives a metric under a specified counting rule (S7). The number of agents does not supply the geometry: one form can already have internal relations, while several names need not denote distinguishable perspectives.

There are two questions here. Which relations constitute the form and constrain its possible contacts? Which numerical distance preserves the differences relevant to a particular inquiry? Liquid LQ16 addresses the first by reconstructing roles from substitution relations. The cache metric addresses the second. Neither requires a witness outside the whole.

## §0. An Internal Reading

**S1 (Invariance of a specified reading).** Fix an encoding E and a deterministic reading F. If E(x)=E(y), then F(E(x))=F(E(y)).

*Proof.* Both applications have the same argument. QED

This is an equality of particular answers. Keeping the encoding rule fixed while changing its input need not preserve those answers. A form can also compare a present reading with an internal record of an earlier one. Thus S1 supplies no inference from “one agent” to absence of space, change or a reference. The question and its full reading context specify what is invariant.

## §1. Encoding as Perspective

**S2 (Perspective has a source and a context).** A fixed joint reading E=(E₁,…,Eₙ) on a fixed source x has one image E(x). Two applications of that reading to that source agree. Changing the source, the available readings or the relevant context can change the image.

An encoding can itself be an internal form. Its name alone does not supply its applications, a proposal policy or identical acquisition histories. Seeing SiE3–SiE4 and Verdict §6c state when a required answer factors through an actual image. Those factorization relations determine the scope of this perspective.

## §2. Quality: Joint Distinctions

**S3 (Joint coordinates need joint freedom).** A family of readings Eᵢ:W→Aᵢ supplies a joint image E(W)⊆∏ᵢ Aᵢ when the readings can be combined under one input contract. Every tuple of separately occurring answers is jointly available exactly when this image equals the product of the component images.

Pairwise nondetermination does not establish that equality. The three binary readings a, b and a XOR b each take both values, and no one determines either other. Their joint image has four forms, while the product has eight. The missing joint relation is actual information. LQ15 reconstructs independent blocks only after the addressed recombination relations are specified.

The number of channels consequently does not determine the dimension of their admitted image. A single channel can also have many answers. Numerical, topological and operational dimensions require their respective structures. A count of encoding names supplies none of them.

## §3. Direction: Related Variations

**S4 (A direction requires a variation relation).** A declared family E(t) supplies a way to vary an encoding. Holding specified other coordinates fixed states what this variation preserves. A parameter name alone supplies neither an available change nor its physical duration.

**A component's contribution belongs to a joint process.** During treadmill walking, [Fukunaga et al.](https://pubmed.ncbi.nlm.nih.gov/11217891/) measured gastrocnemius fascicle lengths with ultrasound and combined them with joint and anatomical measurements to estimate tendon length changes. In their six participants, fascicle length was nearly constant during stance while the tendon stretched and recoiled. The whole muscle–tendon length change therefore did not describe each constituent's change. These are task-specific measurements, not a universal decomposition of walking into independent muscle functions.

The coupling can organize motion without a detailed command for every joint. [Collins et al.](https://pubmed.ncbi.nlm.nih.gov/15718465/) describe passive mechanical walkers that descend a slope without motors or controllers, and powered descendants that walk on level ground. The slope, gravitational interaction, joints and contacts belong to the setup. Their removal changes the demonstrated result. A repeatable movement pattern does not by itself locate its organizing relations entirely in a neural or software controller.

**A body-shape cycle can advance a retained ground contact.** Consider two endpoint positions (l,r) on one line, read relative to an internal marked substrate. Assume an actuator can change the separation between a short length ℓ>0 and a long length ℓ+δ, with δ>0. A selected anchored endpoint retains its substrate position without slipping. Then the following relations determine the settled positions:

    (a, a+ℓ) → (a, a+ℓ+δ) → (a+δ, a+ℓ+δ).

The first change retains the left contact and extends the body. The second retains the right contact and restores the short length. Its final left position is forced: subtracting ℓ from the retained right position gives a+δ. Restore the initial left-anchor mode at the new location. The length and anchor-mode cycle closes, but both endpoints have advanced by δ relative to the substrate. Keeping the left contact through contraction instead returns to (a,a+ℓ). Thus the same length history ℓ→ℓ+δ→ℓ permits different translations when the support history is omitted. Keeping both contacts fixed during extension would require the same separation to equal both ℓ and ℓ+δ, which δ>0 forbids.

This is a kinematic contact model. It does not establish the force, energy, stability or timing needed to realize those transitions, and is not an anatomical model of a leg. An actuator supply and any reaction of the substrate remain parts of the physical whole. [Zheng et al.](https://arxiv.org/abs/2111.00944) report a related robot mechanism in which deformation changes which endpoint anchors through friction. That physical mechanism motivates the contact question without certifying the ideal no-slip equations exactly.

`AnchoredCycleForcesTranslation` in `Checks/Interactions.swift` constructs the short–long–short cycle using actual `AddZero`/`AddSuccessor` expressions. Extension retains the left endpoint, and contraction retains the right endpoint while taking its canonical predecessor. The resulting pair is proved equal to both original endpoints advanced by one. `RetainedLeftSupportReturns` derives the stationary alternative, and `BothSupportHistoriesRestoreLength` proves that both final pairs have the original short separation. A finite zero-rooted instance supplies a positive change of ground contact. In two negative controls, the compiler rejects equating shape return with contact return (`RejectedShapeReturnAsContactReturn`) and imposing extension with both endpoints retained (`RejectedBothSupportsExtension`). These generic constructor proofs cover the unit-length fragment of the argument above. They do not certify every open `IntegerValued` conformance as a finite numeral.

LiR7's common-fixed-form test concerns simultaneous compatibility of specified return maps. A locomotor shape cycle asks another question: its image returns while its relation to a retained participant changes. If E records body shape and F represents the whole modeled cycle, E(F(x))=E(x) does not require F(x)=x. The location of the preserved contact belongs to the transition, rather than an annotation on an otherwise self-sufficient body update. A static VI proof can constrain the entire sequence at once without executing it or claiming that the physical motion takes no time.

**S5 (The dimension belongs to the represented structure).** In a declared product of d independently variable coordinate roles, the presentation has d such roles. Whether these are independent in the admitted forms is S3's joint question. A metric or a topology introduces a further notion of dimension. The `HasGrammar.Dimension` coordinate must state which one it represents.

## §3a. When Retracing Cannot Transport

**A closed walk on a tree cancels under fixed inverse contacts.** Let the retained configurations form a tree, with no parallel edges or self-loops. At each vertex i, let Xᵢ contain the states retained by the proposed account. Every oriented edge supplies one fixed bijection Tᵢⱼ:Xᵢ→Xⱼ, and the reverse edge supplies its actual inverse. Then every finite closed walk transports every starting state back to itself.

*Proof.* Root the tree at the walk's starting vertex. In any nonempty closed walk, choose a visited vertex of maximal distance from the root. Its predecessor and successor along that visit must both be its unique parent. The two successive contacts therefore compose to Tᵢⱼ⁻¹Tᵢⱼ=id. Delete that excursion. Induction on the finite walk length reduces the whole walk to the empty one. No length, force, probability or commutation between different contacts was used. An equivalent construction joins closed excursions and encloses a closed excursion between one contact and its inverse. This is the tree case of LiR7's transport relations.

In `Checks/Interactions.swift`, `JoinedClosedContacts` checks joining at one actual endpoint. `SwapAroundClosedContact` places an arbitrary certified return between a concrete field exchange and the actual reverse exchange. `IdentityReading` supplies the empty case. Finite nesting gives the inverse-cancellation fragment, including a nontrivial intermediate state. In the negative control `RejectedRetraceRestartsInterior`, the compiler rejects substituting a return at the original source for the required return at the exchanged source. The graph reduction above establishes why these two construction forms suffice for tree walks. The checked concrete inverses are field exchanges, not a certificate of arbitrary physical inverses.

**Separate inverse pairs need not cancel when interleaved.** On a shared triple (a,b,c), let g exchange the first two roles and h exchange the last two. Each applied twice returns every triple. In execution order, gghh returns (a,b,c), while ghgh follows

    (a,b,c) → (b,a,c) → (b,c,a) → (c,b,a) → (c,a,b).

Both words use each operation twice. Their answers can differ because the operations share a role and do not commute. Cancelling a contact across an intervening contact would require that additional relation. `AdjacentContactSwapReturns` now derives both words from the existing field exchanges, retaining its earlier LQ13 consequences. A concrete source distinguishes the results, and the compiler rejects their identification in the negative control `RejectedSeparateReturnsEraseOrder`. These are exact joint operations, not a claim that each anatomical component is an involution. G14b covers the contrasting case of the specified independent applications to disjoint fields.

**A measured residual refuses a conjunction of premises.** If a retained answer changes after a projected closed walk, that projection cannot simultaneously be a tree, assign a single inverse pair to each edge, and correctly determine that answer. The missing distinction may belong to the contact, the driving rate, a preparation or an evolving participant. Parallel contacts between the same visible endpoints cannot be collapsed into one edge because those endpoints agree. A single periodic coordinate can also have a loop, unlike an interval. The number of coordinate names does not settle this question. Conversely, one returning preparation does not certify an inverse law: LiR7's nonidentity loop can fix that preparation.

S4's crawler returns along the visible short–long relation using a different support. Both support-specific translations can be reversible on their respective domains, while the selected contraction is not the inverse of the selected extension. A nonzero cycle therefore does not establish fundamental irreversibility or require a hidden memory variable. The support selector can be an explicit current control input. This identifies a structure of permitted composition before assigning a distance to the endpoints.

LiR7 also shows what a change of description preserves here. Bijections at the vertices conjugate a closed transport at its starting vertex. If that transport changes a particular starting state, its conjugate changes the corresponding renamed state. An invertible relabeling cannot remove this difference. A reduced reading can erase it, at the cost of losing the ability to answer the question that distinguishes those endpoints.

There is a physical contact with this distinction. [Qiu et al.](https://www.nature.com/articles/ncomms6119) report scallop-shaped swimmers with one hinge. In their shear-thickening experiments, exchanging the fast and slow portions of opening and closing reversed the measured swimming direction. Newtonian-fluid and symmetric-actuation controls had no reported net propulsion. These records distinguish more than the unparameterized shape path. They do not alone identify whether an omitted variable is the current drive rate or a retained effect of earlier preparation. The authors' rheological measurements and response models are additional evidence, distinct from the displacement comparison.

The physical drive, fluid and any internal timing reference remain participants in the whole. A common reparameterization of their records changes a description. Changing the body's motion relative to the apparatus clock changes a source relation. Removing a time symbol cannot erase that comparison while preserving its consequences. Calling a reduced path reciprocal establishes a physical inverse only after the required contact law is supported. The theorem gives an exact test of that proposed law, not a claim that a moving body exhausts the process or that finite measurement establishes exact zero.

## §4. Depth: Retained Resolution

**S6 (Depth relative to a tower).** In a specified dependency tower, a certified initial segment identifies which levels have sufficient retained answers for their declared questions. A use at a higher level requires its own coverage and access witnesses. This is a depth of that inquiry, rather than a number of spatial dimensions or a proof that the entire domain is known.

## §5. Distance Between Records

Let U be a common vocabulary of addressed comparison records. Each record includes the question, the relevant source and context, and its certified answer. Fix finite caches G,H⊆U. Sharing a raw token from different contexts does not identify two records.

**S7 (Cache distance).** Define d(G,H)=|G △ H|. This is a metric on finite cache sets. Applied to holders through their caches, it is a pseudometric: different holders can have the same cache.

*Proof.* Symmetry and nonnegativity follow from symmetric difference. Zero means equality of the two sets. For any K, G △ K⊆(G △ H)∪(H △ K), so d(G,K)≤d(G,H)+d(H,K). If U is finite, d≤|U|. Finiteness of each represented record does not establish a finite U or a finite whole. QED

The count assigns one unit to each differing record in this vocabulary. Semantically redundant records can count separately. Canonicalizing them, weighting them or charging for their actual acquisition changes the represented question. G2 derives a different metric from the actual node addresses of finite trees and its stipulated edit relation.

**S8 (A metric does not supply an ambient space).** The cache classes with d form a metric space. Two distinct classes supply a two-point metric space. They do not supply the other points of a line, an orientation or an available motion. More classes do not automatically supply a Euclidean embedding.

For an exact obstruction, use the four caches ∅, {p}, {q}, {p,q}. Adjacent sets differ by one entry and opposite sets by two. If these were Euclidean distances, both {p} and {q} would be the midpoint between ∅ and {p,q}, since each lies at distance one from both endpoints and those endpoints are distance two apart. Uniqueness of a Euclidean midpoint would make {p}={q}, contrary to their distance two. The square root of d does have an explicit Euclidean embedding: map each cache to its 0/1 membership vector. Its squared Euclidean separation is d. Taking that square root changes the metric being interpreted.

Even a very complete vocabulary need not make its unweighted count geometrically informative. On a finite n-form carrier, the family of all 2ⁿ binary predicates contains exactly 2ⁿ⁻¹ predicates separating any fixed distinct pair: choose opposite answers at the two forms and arbitrary answers at the others. Counting all of these predicates equally makes every distinct pair equally far. Their addressed answers retain more information than that count. This calculation does not grant physical access to every predicate. The actual contacts, their composition and their costs can supply a much richer geometry.

## §5a. Geometry Before Length

A static account starts with the relations an admitted whole must satisfy. It can leave many of its fields open and still force one answer. There need be no distinguished order in which the parts are constructed, no initial guess for every field and no separate dynamics that repeatedly pushes the fields toward consistency. Checking the relation still takes work. Its content need not include a simulation of that work.

LQ16 gives an existing example. Its complete contextual substitution relations determine which forms have the same first role and which have the same second role. The two roles jointly distinguish the form. An admitted joining then has exactly the first role of one source and the second role of the other, and exact self-contact forces its unique result. The proof reconstructs these coordinates from the relation. It does not first place the forms at points with independently supplied coordinates. The roles need not be spatial directions, and the same laws allow coupled as well as independent roles.

A two-field syntax can carry such a relation, but it can also encode an arbitrary different contact. The meaningful restriction lies in the shared roles and permitted substitutions. Conversely, two joining forms with the same proposed endpoints can remain different through their internal correspondence. Identifying them because the endpoint pair matches would discard the relation that the inquiry needs. VI1 and IiS10 supply this obstruction. LQ16 states the corresponding limit of endpoint reconstruction.

The hypothesis that geometry arises with pairs can therefore be made precise at two levels. A pair has incidence: its roles belong to one form. A family of actual contacts can force agreements, refusals and independent variations across those roles. A numerical distance is one possible later reading of that structure. Its units, dimension and update law need an actual relation to those contacts.

**Composition before a length formula.** S30 gives a concrete route: compatible division and its reversal about an internal centre determine an associative addition without a separately supplied addition law. S27–S28 reconstruct an ordered coordinate from jointly consistent equal divisions, up to origin and scale. These results use different explicit premises. Their content is the reconstruction, rather than calling any stable label a geometry.

Even a common composition law and a preserved ruler can leave the length rule open. On ℝ², the same translations preserve both the Euclidean distance and d₁(x,y)=|x₁−y₁|+|x₂−y₂|. The displacements u=(3,0) and v=(0,4) have lengths 3 and 4 in both readings. Their composed displacement has length 5 in the first and 7 in the second. Both support commuting displacement composition and stable comparisons. The response to their joint displacement separates the proposed metrics. This is a counterexample to sufficiency of those premises, not two asserted physical alternatives.

There is an exact target once a real normed vector structure has been established. The identity ‖u+v‖²+‖u−v‖²=2‖u‖²+2‖v‖² for every pair is necessary and sufficient for that norm to come from an inner product, reconstructed as ⟨u,v⟩=(‖u+v‖²−‖u−v‖²)/4. This is the [Jordan–von Neumann theorem](https://www.mathematik.uni-muenchen.de/~michel/jordan-von_neumann_-_parallelogram_identity.pdf). Angles can then be read from the inner product. The vector and norm structure is an additional premise beyond S30's monoid. The physical research question is which internal comparisons establish or refuse this quadratic composition law. Calling two channels independent does not supply it, just as S3's separate readings do not supply joint freedom.

**An additional relational construction, with its premises exposed.** Suppose a specified family X has a symmetric irreflexive relation # of sharp contrast. Its operational meaning must be supplied by actual internal contacts. Giving forms different names does not supply it. For S⊆X, let S# contain exactly the forms contrasting with every member of S. Symmetry gives S⊆S##. Applying the order-reversing operation gives S###⊆S#, while applying the first inclusion to S# gives its reverse. Thus S###=S#, and S↦S## is a closure operation. Closed regions are closed under intersection, with their least common closed region given by (A∪B)##. Irreflexivity gives A∩A#=∅. For closed A, the complement of A∪A# is empty, so A∨A#=X. These are orthocomplemented regions without a supplied length, angle or probability. This is the standard orthogonality-space construction, developed in [Categories of orthogonality spaces](https://www.flll.jku.at/sites/default/files/u24/Categories-of-orthogonality-spaces.pdf).

It does not force every familiar law of geometry. On five forms numbered cyclically, let each form contrast exactly with its two neighbors. Every singleton is closed, and so is B={0,2}: B#={1} and {1}#=B. Yet A={0} is a proper closed part of B and B∩A# is empty. Thus the demand that every proper closed enlargement contain a form sharply contrasting with the entire earlier region is an additional condition. In the lattice of closed regions this condition is equivalent to orthomodularity. To see the substantive direction, put C=B∩A# and D=A∨C for A⊆B. Then D⊆B and B∩D#=B∩A#∩C#=C∩C#=∅. The stated condition forces D=B. Conversely the orthomodular equation B=A∨(B∩A#) rules out a proper enlargement with empty remainder.

The five-form failure can indicate an incomplete domain rather than an impossible contact pattern. The real vectors (1,0,0), (0,1,0), (1,0,1), (1,1,−1), (0,1,1) have exactly those neighbor orthogonalities. The omitted vector (0,0,1) is orthogonal to forms 0 and 1. With it included, the old region generated by 0 and 2 contains that additional form, which supplies the missing orthogonal remainder. This is an explicit test of the premises, not a derivation of vector geometry from #. Extending an observed contact table and proving that its relevant domain is already complete are different obligations within the same whole.

This construction identifies a sharper research question: does an actual medium supply such a remainder for every proper enlargement of a closed region, and what internal relation establishes that coverage? Replacing this question by a type-level loop over a supplied table would compute a chosen example while leaving the missing premise untouched.

**DNA supplies a physical contact with this question.** In [Rothemund's scaffolded DNA origami](https://rothemundlab.caltech.edu/downloads/folding_dna.pdf), short complementary strands join addressed portions of a long strand. Different staple designs produced different assemblies observed by atomic force microscopy. The design retained crossover positions and helical twist, beyond a list of complementary bases. It used molecular geometry to realize a desired larger geometry. Its measurements support that relation between design and assembly, without deriving the underlying spatial metric from the DNA alphabet.

[Dietz, Douglas and Shih](https://pmc.ncbi.nlm.nih.gov/articles/PMC2737683/) varied insertions and deletions between crossovers and observed changes in global twist and curvature by electron microscopy. Their structural explanation uses the coupled helices' length and twist constraints. The geometric data are distributions from prepared and selected particles. A designed angle is not an exact outcome for every molecule. This suggests a VI question about the joint compatibility of contacts: which local relations can all remain satisfied in one shape, and which require a change of the proposed geometry or of the contacts themselves? LiR7's common-return criterion answers an exact bijective version of that question. Flexible molecular contacts need their own permitted ranges and cannot be replaced by rigid transformations solely for convenience.

The surrounding preparation is part of this same whole. [Hyeon et al.](https://arxiv.org/html/1211.0662v1) recorded persistent differences between single-molecule Holliday-junction FRET trajectories over an approximately 40-second window. Removing and restoring magnesium changed trajectory patterns. Their proposed internal structural explanation is a model, while the changed fluorescence records are the reported contact. Thus sequence and final nominal solution conditions need not determine this measured history-dependent behavior. A finite observation without a transition is not an exact prohibition on every future transition. FRET is also a response reading, not a direct enumeration of every molecular coordinate.

**All internal distances can still omit a contact-relevant orientation.** In a specified three-dimensional Euclidean model, consider an ordered noncoplanar tetrahedron (p₀,p₁,p₂,p₃). Put uᵢ=pᵢ−p₀. Its six distances determine the Gram matrix through

    Gᵢⱼ = (d₀ᵢ² + d₀ⱼ² − dᵢⱼ²)/2.

They determine det(G)=det[u₁,u₂,u₃]², but not the sign χ of the oriented determinant. A reflection preserves every pair distance and reverses χ. A continuous motion within this fixed three-dimensional model that preserves all six distances cannot turn one labeled orientation into the other: det(G) remains positive, so the continuous oriented determinant cannot pass through zero. The two distance-equivalent configurations therefore belong to different components under this permitted motion. This is a conditional geometric obstruction, not a claim that a flexible molecule preserves every distance.

An external orientation is unnecessary for a relative question. Let another ordered noncoplanar internal reference have sign χ_R. The product χχ_R is unchanged by a simultaneous orthogonal coordinate change, including a reflection, since both signs acquire the same determinant factor. Reflecting only the first form changes this relative answer. The two isolated distance matrices omit it. Cross-comparisons between the form and its reference can add the missing content within the same relational description. The tetrahedron's order and the reference's order must themselves have identified roles, and an available reading of the relative orientation remains a physical obligation. This is another instance of S1: reflecting an entire description differs from changing a participant while retaining its comparison context.

There is a relevant optical demonstration. [Kuzyk et al.](https://arxiv.org/pdf/1108.3752) used DNA origami to position gold nanoparticles in left- and right-handed helices and measured their circular-dichroism spectra. The measured response compares the assembly with incident light of specified circular polarization. It is not a measurement of a shape detached from every reference. The experiments do not certify exactly mirrored molecular structures or an exact equality of all distances. They supply a physical example in which the arrangement carries an optical distinction, while the tetrahedral argument isolates the distance-only description's exact limitation.

The useful research object is therefore a family of contacts together with their jointly allowed changes. DNA origami supplies a way to modify that family physically and read a resulting shape or optical response. A sequence string alone is an incomplete description of this experiment. The physical interactions that make it effective, the preparation and the reader all remain internal to the represented whole.

## §5b. Coordinates Without an Exterior

Calling reality one whole supplies no reference object beyond it for assigning its position. Internal forms can still have positions relative to one another. An origin, a direction and a clock reading must identify the internal relations that distinguish their roles. Numerical labels can present those relations without being additional parts of the represented structure.

For a specified family of questions Q on an admitted domain X, a coordinate image C is sufficient exactly when C(x)=C(y) implies q(x)=q(y) for every q∈Q. Each such q then has a decoder on C(X), defined by d_q(C(x))=q(x). The implication makes this single-valued. Conversely, a supplied decoder forces the implication. This is S9's question factorization applied to a family. If Q separates the relevant forms, a sufficient C separates them too. If it does not, the same coordinates can represent several forms without losing an answer in Q. Joint availability of the readings remains S3's obligation.

This sufficiency concerns the named questions. Coordinates that answer current pairwise readings can omit a constraint on a larger joint contact or on a permitted continuation. LQ13 and M67 exhibit those omissions. Calling the coordinate family complete must include the relations it claims to represent.

There need be no preferred origin. If an automorphism preserves all the stated reference relations but moves a proposed unique origin, selecting that origin from those relations alone is impossible: the selected result would have to remain fixed. S15 and VI1a give this obstruction. A reference established inside the form can remove that symmetry. For a symmetric triangle with no marked vertex, the incidence relations single out no vertex. A resident reference at one vertex distinguishes an origin while leaving an exchange of the other two possible. An ordered reference pair can distinguish those remaining roles. None of these symmetries identifies the distinct vertices as one occurrence.

An ordered pair supplies a directed relation between its roles. Extending that direction elsewhere needs relations for comparing or composing such contacts. It does not automatically give a length, dimension, unit or complete frame. The same issue applies to time: an actual record can distinguish predecessor and successor roles, while a traversal assigns list positions. M67 separates that traversal from the event relations it reads. Both spatial and temporal coordinates are sufficient to the extent that their internal reference relations support the questions asked through them.

## §5c. Einstein's Premises and Internal Comparisons

Einstein's [1905 paper, §§1–3](https://fourmilab.ch/etexts/einstein/specrel/www/) introduces time through clock readings and exchanged light. It defines midpoint synchronization, assumes its consistency across a stationary clock network, and uses spatial and temporal homogeneity to obtain linear transformations. Its inertial geometry is supplied rather than reconstructed from all the internal processes. These are substantive premises, but none requires an observer outside reality.

The [1916 paper, §§3–4 and §16](https://pages.jh.edu/rrynasi1/PhysicalPrinciples/literature/Einstein1916%281923%29TheFoundationOfTheGeneralTheoryOfRelativity.pdf) makes instrument and event coincidences central to verification. It then grants local special relativity in a four-dimensional continuum and interprets the metric through rods and clocks. The metric describes the gravitational field and participates in its equations. Einstein also explicitly distinguishes his matter coupling from a consequence of the relativity postulate alone.

For VI, an additional premise and an external cause are different findings. A relation among internal forms can have a particular dimension, interval law or dynamics without being forced by the assertion that everything is internal. Conversely, writing a relation in coordinates does not place those coordinates outside reality. The useful test is whether changing the proposed description preserves the actual comparison questions. S25 tests whether transport can be reduced to endpoint identifications. S26 tests the sufficiency of light incidence for a clock question.

## §5d. What a Comparison Path Retains

A coordinate description can retain the action of transport along each path. Requiring that action to be nothing beyond the change between endpoint coordinates is stronger. The following theorem tests that extra identification. It is not a criterion for the existence of coordinates, one metric, or one reality. Even metric-compatible parallel transport can have a nonidentity return, as illustrated in [Tong's derivation of parallel transport and curvature, §3.3](https://www.damtp.cam.ac.uk/user/tong/gr/grhtml/S3.html).

**S25 (Transport reduces to endpoint identifications exactly when every loop is the identity).** Take a finite connected comparison graph with a nonempty set Fᵢ at each vertex and a bijection Tᵢⱼ:Fᵢ→Fⱼ on each directed edge. Parallel contacts and self-contacts are allowed and remain separately addressed: Tᵢⱼ denotes the map of the specified edge, not a merger of all contacts with those endpoints. The reverse edge is its inverse. All maps refer to the same specified comparison setup. There are bijections hᵢ:Fᵢ→K with Tᵢⱼ=hⱼ⁻¹∘hᵢ on every edge exactly when every closed path composes to the identity on its starting set.

*Proof.* With such hᵢ, successive factors cancel around every closed path. Conversely choose one vertex r and one path from r to each i. Let Pᵢ:Fᵣ→Fᵢ be its composite. For an edge i→j, the closed path r→i→j→r gives Pⱼ⁻¹∘Tᵢⱼ∘Pᵢ=id. Therefore Tᵢⱼ=Pⱼ∘Pᵢ⁻¹. Put K=Fᵣ and hᵢ=Pᵢ⁻¹. A different chosen path gives the same Pᵢ because its comparison with the first is another closed path. QED

The proof's root is one vertex of the network. It supplies no external reference or physically preferred origin. Under arbitrary bijective relabellings kᵢ of the local coordinates, an edge becomes kⱼ∘Tᵢⱼ∘kᵢ⁻¹. A loop H at i becomes kᵢ∘H∘kᵢ⁻¹, so its being the identity cannot change. A positive witness H(x)≠x rules out identification through endpoint coordinates alone while preserving these comparisons. This is M71's obstruction applied to that claim. It does not forbid a network with path-dependent comparison. A nonidentity H can also have fixed points, so it need not forbid every individual compatible assignment.

**A shared reading requires less than an identity return.** Fix a reading qᵣ:Fᵣ→A at one vertex. It extends to readings qᵢ:Fᵢ→A satisfying qⱼ∘Tᵢⱼ=qᵢ on every edge exactly when qᵣ∘H=qᵣ for every loop H at r. Necessity follows by composing the edge equalities. For sufficiency use the paths Pᵢ of the proof and set qᵢ=qᵣ∘Pᵢ⁻¹. For each edge, Pⱼ⁻¹∘Tᵢⱼ∘Pᵢ is a loop at r, so substitution gives the required equality. The same argument proves independence of the chosen paths and uniqueness of the extension.

All such qᵣ are exactly the readings constant on the orbits of the loop transformations. Thus forgetting a path can be legitimate for one question while erasing another. If qᵣ(H(x))≠qᵣ(x), no representation that identifies those cases can retain this qᵣ. If the retained questions separate all members of Fᵣ, their invariance forces every H to be the identity and recovers S25. This applies VC15 and Liquid's component argument. It does not identify physically different forms just because a selected question ignores their difference.

Verdict VC96 supplies a finite instance with resident control. Two return words in a three-leaf star connect all three central phase states while preserving an arbitrary payload. The original questions recoverable from the final working carrier without the word are exactly those depending only on that payload. The word remains in the complete command record; the insufficient observation omits it. A stationary stage contact in the middle of a return changes the phase, so omitting apparently unmoving contacts would give the wrong loop test.

**Preserving a distinction need not keep its answer constant.** Let G be the group of loop transformations on Fᵣ and let E:Fᵣ→I be a description with I=E(Fᵣ). There is a unique action U of G on I satisfying U_H∘E=E∘H exactly when E(x)=E(y) implies E(Hx)=E(Hy) for every H∈G. Necessity follows by applying U_H to the equal images. For sufficiency define U_H(E(x))=E(Hx). The condition makes it well-defined. Surjectivity of E gives uniqueness, composition gives U_H U_K=U_HK, and H⁻¹ supplies the inverse. This is VC15's compatibility criterion for the given group. The earlier invariant reading is the special case U_H=id.

For a two-form carrier with the exchanging loop, every invariant scalar reading is constant, while E=id retains both forms and the exchange itself. Hence a search restricted to conserved scalar answers can discard all form distinctions even under reversible transport. Distinctions can survive in their transformed relations. Whether H represents a physical transport or a change of notation must be specified. Covariance of a description is not automatically a conservation law for a physical process.

Reversibility also matters to the loop test. For general contact relations, join all addressed local forms in one graph and connect exactly the related pairs. A common equality reading must be constant on its connected components, and any function on those components supplies such a reading. This is the component criterion of LQ13. With the single map {0,1}→{*}, there is no nontrivial directed return, yet equal answers across that map force q(0)=q(1). S25's inverse comparisons are what let closed paths detect this obligation there. They cannot be omitted while retaining its sufficiency conclusion.

A finite algebraic probe shows how a shared interval could survive a nonidentity transport. Suppose two real roles (u,v) have the transport T(u,v)=(2u,v/2), and ask for an invariant real quadratic reading Q(u,v)=a u²+2buv+c v². The identity Q∘T=Q forces 4a=a and c/4=c, hence a=c=0. Every surviving reading is Q=2buv. If it is nondegenerate, b≠0, and the substitution u=(x+y)/√2, v=(x−y)/√2 gives Q=b(x²−y²), with one positive and one negative direction. There is no positive-definite invariant quadratic reading in this family. Its scale remains open. The two real roles, the particular transport and the quadratic question family are premises of this probe. It derives neither those premises nor physical spacetime from internal closure. It does show that uniqueness of a metric reading can be a question about what nontrivial transport preserves, rather than a demand to make that transport disappear.

The quadratic restriction carries much of this conclusion. For the same T, (uv)² is also invariant. Even uv does not determine every continuous invariant reading: take J(u,v)=uv sin(2π log₂|u|) for u≠0 and J(0,v)=0. This is continuous at u=0 because |J(u,v)|≤|uv|, and J∘T=J because doubling |u| adds one to its logarithm. The points (1,1) and (2^(1/4),2^(−1/4)) both have uv=1 but give J=0 and J=1. Thus the chosen transport alone selects neither the quadratic question family nor a complete invariant description. Its physically supported relations must be established independently of the interval one hopes to extract.

For additive clock comparisons in a common rate unit, write Tᵢⱼ(t)=t+δᵢⱼ, with δⱼᵢ=−δᵢⱼ. Changing each clock's zero by φᵢ changes δᵢⱼ to δᵢⱼ+φⱼ−φᵢ. The sum around a closed path is unchanged. All edge offsets can be removed by these zero changes exactly when every loop sum is zero. This conclusion presumes additive, reversible comparisons with the stated rate calibration. Physical forward signal transmission is not automatically the inverse of transmission back. Measured evidence needs its joint error bounds before a nonzero loop residual can establish refusal.

If calibrated comparisons instead use increasing affine maps, a loop has the form H(t)=At+B with A>0. Changing the starting clock's unit and zero by h(t)=λt+μ, λ>0, gives h∘H∘h⁻¹(t)=At+λB+(1−A)μ. Thus A is invariant. When A=1, a nonzero B cannot be removed. When A≠1, B can be removed but A cannot. A return offset and a return scale mismatch are distinct obstructions. Their interpretation as accumulated readings or persistent rate changes needs the corresponding physical transport protocol.

The question's coordinates must transform too. For x′=h(x), H′=h∘H∘h⁻¹ and q′=q∘h⁻¹, direct substitution gives q′(H′(x′))=q(H(x)). Keeping the formula q fixed while relabelling its input can select a different internal component. `RelabelledOperationKeepsReadAnswer` in `Checks/RelationalReturn.swift` checks this through the existing swap, composition and projection constructors for arbitrary component types and an arbitrary compatible pair-output reading. Its negative control retains the old projection after swapping the output frame and positively distinguishes the resulting answers. The construction changes representation of the comparison. A physical alteration of a source relative to a retained apparatus has a different contract.

The Sagnac discussion in [Ashby's GPS analysis, §2](https://link.springer.com/article/10.12942/lrr-2003-1) supplies a physical contact: local Einstein synchronization around a rotating network need not extend to one globally synchronized clock assignment. A closed optical path can compare opposite propagation directions at one returning detector, without a distant clock's chosen zero. Such an effect can occur in flat spacetime. A nontrivial comparison loop alone therefore establishes neither gravitational curvature nor failure of relativity.

The whole is not this comparison graph. Its apparatus, source and calibration remain internal parts of reality, and the graph retains the named questions about them. Nor is a loop of comparison maps a cycle of all physical events. The Cut §5's internal support and Matter M55's full recovery cycle need their own relations. The existing `ResidentTransportContact` and `ThreePhaseContactsForceCollapse` constructions address finite resident comparison seams. They do not establish the clock interpretation or the arbitrary-bijection theorem by naming it.

## §5e. Light Incidence and Clock Content

**S26 (Light incidence alone does not fix duration in the conformal family).** In the smooth Lorentzian setting, let g̃=Ω²g for a smooth positive Ω. For every tangent vector v, g̃(v,v)=Ω²g(v,v), so the null cones and the signs distinguishing causal directions agree. The unparameterized null geodesics agree as well: for a g-affinely parameterized null tangent k, the conformal connection gives ∇̃ₖk=2k(log Ω)k. This tangent acceleration changes the parameter along the same curve. For a timelike curve, however, dτ̃=Ωdτ in common units. Thus those light relations do not fix the proper-time functional.

An explicit clock comparison removes dependence on a coordinate-only difference. In units c=1 take g=−dt²+dx²+dy²+dz² and Ω(x)=exp(ax), with aL≠0. Two ideal clock paths have x=0 and x=L>0, respectively, and y=z=0. Consecutive pulses emitted at the first and received at the second follow the same straight null paths under both metrics. Their coordinate separations obey Δt_received=Δt_emitted. With the same proper-time clock calibration in the two candidate accounts, the ratio of the receiver's elapsed ticks to the emitter's elapsed ticks is 1 for g and exp(aL) for g̃. This ratio uses two local pulse intervals. No external clock or remote simultaneity reading is needed. QED

This is a counterconstruction in a specified kinematic family, not two asserted solutions of Einstein's equations with identical matter. It preserves light incidence, not the full experimental record: measured frequencies and ticks would already add the distinguishing content. A simultaneous redefinition of all clock standards and matter couplings requires another comparison contract. A common change of units alone cannot change the dimensionless ratio. The support keeping each clock on its path also belongs to the physical setup.

LiR9–LiR10 distinguish a further pair of questions. A bounded positive change in optical path weights preserves finite reachability on a fixed path family. Equal bulk optical metrics, however, need not give equal reflection at a common material boundary. A geometry sufficient for the interior path question can omit a relation required by a join. The explicit impedance comparison supplies that obstruction, and the boundary transfer relation supplies a sufficient replacement for finite monochromatic layer compositions.

The reconstruction question has a direct predecessor in [Ehlers, Pirani and Schild, 1972, §1](https://bpfoundations.org/plans/ehlers2012.pdf). Their construction relates light propagation and free fall through conformal and projective geometry, adds compatibility and an integrability condition, and exposes smoothness, dimension and signature assumptions. They also distinguish accumulated clock readings after different paths from a lasting difference in subsequent clock rates. Identifying the resulting geometrical clock with an atomic clock is an additional physical connection. These premises are objects of this inquiry, not new VI axioms or consequences claimed from The Cut alone.

There is a concrete measured constraint on that connection. [Bothwell et al., Nature 2022, Fig. 3 and Methods](https://tsapps.nist.gov/publication/get_pdf.cfm?pub_id=933368) report spatially resolved spectroscopy across a millimetre-scale strontium sample. Fourteen measurements give a corrected fractional frequency gradient of −9.8(2.3)×10⁻²⁰ mm⁻¹ in their coordinate orientation. Their weak-field prediction is −10.9×10⁻²⁰ mm⁻¹. The reported result includes density, magnetic, optical, thermal and spatial-calibration corrections. Data and analysis code are available from the authors on request. No independent reduction of the raw measurements has been performed here. The admitted evidence is this reported comparison with its uncertainty and preparation, not an exact equality imported as a type identity.

The next question is which actual light, free-fall and clock comparisons admit a common interval reading, and whether those relations determine it up to an internally calibrated unit. That asks what transport preserves, not whether all transport can be removed. Recovering that structure would still leave its dynamical law to establish. S25 separates those requirements, while S26 exhibits a clock distinction omitted by the light-incidence image.

## §5f. Order, Equal Intervals and Calibration

**S27 (Order leaves interval ratios open, while retained bisections can determine them).** An order specifies which occurrence precedes which. Additive duration additionally assigns a real value D(a,b) to an ordered pair, with D(a,c)=D(a,b)+D(b,c) for a<b<c. Positivity on every proper interval is another requirement. These relations are not supplied by naming a sequence a clock.

For the order (ℝ,<), no nonzero finite additive D is invariant under every order automorphism. Any ordered pair can be sent to any other by an increasing piecewise affine bijection. Invariance would therefore give the same value c on every proper interval. Splitting one interval into two gives c=c+c, hence c=0. This tests dependence on this order alone. It does not assert a dense order of physical events or forbid duration supported by further relations.

**One unit does not determine its subdivisions.** Retain two internal reference occurrences named 0 and 1. Both t(x)=x and the increasing bijection h given by h(x)=x outside [0,1], h(x)=x/2 on [0,1/2], and h(x)=3x/2−1/2 on [1/2,1] preserve the order and these references. Their durations t(b)−t(a) and h(b)−h(a) are positive and additive, and both assign the reference interval value 1. Yet the same addressed interval (0,1/2) has value 1/2 in the first reading and 1/4 in the second. Since the retained unit is the same, this disagreement cannot be removed by a common change of unit or zero. The order and that calibration omit an interval comparison.

The discrete case has a different symmetry. On (ℤ,<), translations preserve the order and act transitively on successive pairs. Translation invariance and additivity force D(m,n)=(n−m)c. Requiring c>0 then permits the intrinsic count of successive intervals in an arbitrary unit. A finite chain need not have this homogeneity: positive weights on its different successive intervals give different additive readings of the same order. Counting each occurrence once defines a count, while identifying those counts with equal physical durations requires the corresponding comparison.

**Retained equal halves fix a ratio without a complete continuum of events.** Let a<b belong to a linearly ordered carrier T. Suppose the source supplies an addressed hierarchy of bisections: r₀,₀=a, r₀,₁=b, each old endpoint is retained as rₙ₊₁,₂ₖ=rₙ,ₖ, and each new rₙ₊₁,₂ₖ₊₁ is strictly between its two old neighbors. The extra relation asserts equality of those two subintervals. Let t,s:T→ℝ be nondecreasing readings satisfying every supplied equality, with t(a)<t(b) and s(a)<s(b). Thus each reading sends a designated midpoint to the arithmetic mean of its designated neighbors, and the reference interval has positive duration. Then, for every x in the ordered interval [a,b],

    (s(x)−s(a))/(s(b)−s(a)) = (t(x)−t(a))/(t(b)−t(a)).

*Proof.* Normalize each reading to give a value 0 at a and 1 at b. Induction on the retained bisections gives the value k/2ⁿ at rₙ,ₖ in both readings. If x is such an endpoint, its answer is already fixed. Otherwise, at each depth n the order places it strictly between two successive rₙ,ₖ. Both normalized answers belong to the same interval of width 2⁻ⁿ. Two distinct real values cannot remain in all those common bounds. The normalized answers therefore agree. QED

No surjection onto ℝ, completeness of T, strict increase or independently assumed continuity of the readings was used. T can consist of dyadic points and any additionally addressed occurrences. What matters is the availability of these particular repeated equal divisions, preservation of their order, and real-valued readings with a positive reference interval. If the hierarchy is supplied for every pair, the same two internal references fix s=αt+β on all T, with α>0. For a target outside the reference interval, apply the same ratio result on the larger interval containing that target and the two references. Thus affine coordinate freedom can follow from retained interval relations instead of being imposed as the original class of coordinate changes. This is the elementary midpoint-affinity argument, related to the standard [Jensen midpoint result in Yang's lecture 5](https://jhc.sjtu.edu.cn/~kuanyang/teaching/MATH3806/notes/lec05.html), not a new mathematical theorem.

**Existence has an exact separation criterion.** For this order and this hierarchy on [a,b], a strictly increasing normalized real reading exists exactly when between any two distinct ordered occurrences there is a grid occurrence rₙ,ₖ. Necessity follows from the density of dyadic values between any two distinct real answers. Their corresponding grid occurrence must lie between the original occurrences because the reading is strictly increasing.

For sufficiency define t(x)=sup{k/2ⁿ:rₙ,ₖ≤x}. These sets are nonempty and bounded, so real completeness supplies their suprema. The nested grid order gives t(rₙ,ₖ)=k/2ⁿ. For x<y, the separation premise applied twice supplies grid occurrences p<q between them. Then t(x)≤t(p)<t(q)≤t(y). Thus t is strictly increasing and satisfies every prescribed bisection. This constructs the reading instead of assuming its existence. Completeness belongs to the chosen real value carrier, not to the occurrence carrier T.

The supremum construction always gives a nondecreasing normalized reading for this strict hierarchy, unique by the earlier proof. The separation criterion determines whether this unique reading retains every ordered distinction. If the grid fails to separate x<y, the reading assigns them the same value. Otherwise a dyadic value strictly between their answers would supply a grid occurrence strictly between them. A clock permitted to repeat a reading can therefore fit a source which refuses a strictly positive duration between every ordered pair. This is question-specific loss of distinction, not an identification of the actual occurrences.

Strict insertion matters to existence. If a proposed first division instead identifies its midpoint with a, the midpoint equation gives t(a)=(t(a)+t(b))/2, so t(a)=t(b). It cannot preserve the positive reference interval. Repeating that same endpoint under more division addresses adds no separating content. In the earlier conditional uniqueness argument, positive calibrated grid values already force strictness of every supplied insertion. The existence construction must state that source condition before assuming any calibrated reading.

**Finite evidence and exact determination differ.** Retaining only depth n fixes the calibrated grid and confines any target between consecutive grid points to that interval of width 2⁻ⁿ. Where a strictly increasing real reading exists and no further interval equations involving that target are retained, its position is not fixed: an increasing piecewise affine change can fix every grid point and move the target anywhere between its two neighbors. It preserves all order comparisons and the supplied bisection equations. Further comparisons can therefore reduce the interval of permitted answers before they provide an exact answer. A target already identified with a constructed midpoint has an exact finite witness. With only the grid relations, the uniqueness proof for a target not identified with any constructed endpoint uses the full hierarchy. This does not promise a finite certificate for an arbitrary real answer.

The quantifiers can be separated exactly. If a proposed real answer v differs from the full hierarchy's answer t(x), a sufficiently deep interval of width less than |v−t(x)| excludes v. Thus every incorrect proposal has a finite refusal. This does not supply one finite depth excluding all incorrect proposals. For an off-grid target in a faithful reading, each finite depth still admits another value in the same cell. For example, if the retained comparisons put x at the 1/3 cut of the dyadic grid, the full hierarchy determines t(x)=1/3, while every finite depth permits values on both sides of 1/3. Even the two-answer question t(x)≤1/3 is not settled there by a finite depth alone. A short name for 1/3 does not supply an additional comparison with x. Existence EF6 and Verdict VC23 already distinguish finite ground evidence from a finite argument using a quantified structural premise.

**A finite joint relation can determine a non-dyadic answer.** Suppose actual midpoint contacts give x=m(a,y) and y=m(x,b), and one real reading preserves these contacts with t(a)=0, t(b)=1. Their equations are 2t(x)=t(y) and 2t(y)=t(x)+1. Hence 3t(x)=1 and t(y)=2/3. The values 1/3 and 2/3 also satisfy the equations, giving both uniqueness and existence in this numerical interpretation. Neither repeated measurement nor a temporal iteration toward a fixed point enters the proof. In interval terms, the two contacts identify the three consecutive increments a→x, x→y and y→b. Additivity and the retained unit then fix their common value. The common middle interval must be the same addressed interval in both comparisons.

Finite trees formed from the two anchors using only arithmetic midpoints yield dyadic values, by induction on the tree. The finite coupled equations above determine a third through a different relation contract. Using these equations for actual contacts requires their source relation to be established. A finite constraint witness can determine more than an acyclic midpoint-construction tree. S29 gives the general finite-boundary version below.

Failure to find a separating point at a finite depth does not prove its absence from the full grid. That absence needs a retained relation or a proof about the whole specified hierarchy. The real-value premise also does work. Give ℝ² the lexicographic order and take midpoints componentwise. The identity and s(x,y)=(x,2y) preserve that order and all midpoint relations. They agree at the references (0,0) and (1,0), but differ at (0,1). The positive interval from (0,0) to (0,1) is smaller than every positive subdivision (2⁻ⁿ,0) of the reference interval. The real squeezing argument is unavailable in this value carrier. Retained order and equal halves alone do not exclude such descriptions. Identifying actual duration with an Archimedean value system remains a substantive premise of this reconstruction.

**Path agreement is a separate obligation.** For a connected event graph with prescribed real edge increments, an endpoint reading τ with increment τ(v)−τ(u) exists exactly when every signed closed path has sum zero. This is the additive instance already proved in S25. Reverse edges here are formal comparisons, not assertions that a past event can be performed backward. A directed acyclic graph can still fail: two paths with the same endpoints, containing respectively two and three edges all declared to have the same positive increment u, would require 2u=3u. Acyclicity does not establish that every elementary contact takes an equal unit of time.

Conversely, positive elapsed duration around a loop of repeated configurations need not invalidate the clock. It invalidates an endpoint reading on a configuration image that identifies those differently dated occurrences. The retained path can carry their cumulative increments. M55 and `RecordedSwapReturn` already distinguish a return of fields from a return of the full record. The order, equal-interval comparisons, additivity, value carrier and occurrence addresses are separate parts of the question. The Cut's internality puts their sources inside reality. It does not supply any missing comparison by renaming a shared endpoint a midpoint: the existing `Path<A,B,C>` constructor identifies the joint endpoint B and asserts no equality of its two legs.

Light Is a Ruler LiR8 supplies a complementary route without given midpoints. A commuting action and one cofinal internal reference determine a unique normalized monotone additive reading. It retains every ordered distinction exactly when each strictly advancing relative action eventually reaches the reference step through repetition. The criterion also explains why equal average rates can coexist with a retained phase difference, even on a real carrier. Neither changing to another cofinal unit nor renaming the difference restores what that scalar reading omits.

## §5g. When the Interval Relations Belong to One Reading

**S28 (Separate bisection calibrations need a joint comparison law).** Let T be ordered and let m:T×T→T name proposed equal divisions. A faithful common real reading is a strictly increasing t with t(m(a,b))=(t(a)+t(b))/2 for every retained pair. Even when every individual bisection hierarchy satisfies S27's separation criterion, the existence of one such t for all m does not follow.

Any faithful common reading forces the finite identity

    m(m(a,b),m(c,d)) = m(m(a,c),m(b,d)).

Both images under t are (t(a)+t(b)+t(c)+t(d))/4, and faithfulness supplies equality of the original results. Thus two different results of these same addressed compositions refuse the proposed common reading. The identity is usually called mediality or bisymmetry. Its role in midpoint representations is standard, as described by [Burai, Kiss and Szokol, §2](https://users.renyi.hu/~kigergo/Publications/Quasi.pdf). Their characterization on a real interval does not establish that the occurrence carrier of this inquiry is such an interval.

This crossing identity is not associativity. If m(a,a)=a and a<m(a,b)<b, then m(a,m(a,b))<m(a,b). Associativity would instead give m(a,m(a,b))=m(m(a,a),b)=m(a,b). A strict equal-division operation cannot be that associative composition. Rebracketing averages changes the weights of the original roles, whereas the displayed four-role crossing keeps each role's weight the same.

**A finite counterconstruction with individually complete grids.** On ℝ take m(x,y)=(min(x,y)+2 max(x,y))/3. It is symmetric, idempotent, strictly increasing in each argument, continuous, and strictly between distinct inputs. Repeatedly dividing any interval by this rule leaves every depth-n subinterval with length at most (2/3)ⁿ times its original length. The resulting grid separates every distinct real pair in that interval. S27 therefore supplies a faithful calibrated reading for each such hierarchy considered on its own.

Yet for the same four source values (a,b,c,d)=(0,2,1,1), the first crossing has inner values 4/3 and 1, with final value 11/9. The other has inner values 2/3 and 5/3, with final value 12/9. Thus the common midpoint reading is impossible. No change of scalar coordinates can remove this refusal while preserving the two distinct results and all the specified m applications. A hierarchy's local calibration was weaker than calibration of every operation between arbitrary points of that interval.

`BiasedMidpointTrace` in `Checks/Interactions.swift` constructs each ordered input (L,H) and the sums H=L+gap, H+H, and L+2H directly from finite `AddZero`/`AddSuccessor` terms. It checks all six application sources against the same four inputs and their computed intermediate numerators. Its fixed addition schemas accept the second operand and construct their own zero base, without accepting a supplied `NaturalSum` conformance as an arithmetic proof. After two levels the common denominator is nine. The calculated numerators become zero and one after the same eleven predecessor projections, supplying a positive source-bound distinction. `INTERACTION_LOCAL_MIDPOINTS_GLUE` refuses their equality. These types compute the biased rule's numerators, without a runtime division or a declaration that this rule is a midpoint. The general order and representation arguments remain mathematical proofs in this article.

The distinction between an equation's addresses and its derivation matters here. `NaturalSum` is an open operand-and-answer interface. An external declaration with operands (0,0) and answer 1 satisfies that interface, and `AddSuccessor` applied to it then reports (1,0) with answer 2. Requiring more successor steps does not repair the false base. The arithmetic proof belongs to the complete constructor expression starting at `AddZero`. S28's finite refusal uses that expression at every application. This is a claim about these constructed terms, not a claim that arbitrary external arithmetic conformances have been excluded from Swift.

**An exact joint test on one separating grid.** Take T=[a,b] in its own order and the nested grid rₙ,ₖ of S27, generated by this same m on each successive pair of neighboring grid points. Assume it separates every ordered pair and m is nondecreasing in each argument. The calibrated reading from that grid preserves every m application exactly when

    m(r[n,i], r[n,j]) = r[n+1,i+j]    for all n and 0 ≤ i,j ≤ 2^n.

Here m has the two grid points as its arguments. Necessity follows by their known real coordinates and faithfulness. For sufficiency, bracket x and y between successive depth-n grid points, allowing equal endpoints when a target is on the grid. Monotonicity brackets m(x,y) between the m values on those lower and upper endpoints. The displayed grid identities identify their calibrated values with the corresponding arithmetic averages. The gap between those bounds is at most 2⁻ⁿ. For every n they enclose both t(m(x,y)) and (t(x)+t(y))/2, so the two real numbers agree. This gives a common representation without requiring T to contain every real cut. It also identifies the extra joint applications omitted by isolated bisections. Agreement on a finite depth alone does not discharge the full criterion.

**Mediality supplies the grid equations algebraically.** Suppose additionally m is symmetric, idempotent and medial. The grid equations follow by induction on n. At depth zero they are symmetry and idempotence together with the definition of the first midpoint. Assume them at depth n. First, every depth-(n+1) grid point is the midpoint of its two neighbors when those neighbors exist. For neighbors with even indices this is the grid definition. For odd indices, write the two neighbors as m(r[n,u],r[n,u+1]) and m(r[n,u+1],r[n,u+2]). Symmetry and mediality turn their midpoint into m(m(r[n,u],r[n,u+2]),r[n,u+1]). The induction hypothesis identifies the inner midpoint with r[n,u+1], and idempotence finishes.

Now compare any two depth-(n+1) grid points. For two even indices, the desired equation reduces to depth n. For one odd and one even index, mediality, after duplicating the even-indexed point by idempotence, reduces the midpoint to that of consecutive depth-(n+1) points. Their midpoint is the next inserted point by definition. For two odd indices, mediality reduces it to the midpoint of two depth-(n+1) points two indices apart. The neighbor result just proved identifies their middle point. These exhaust the parities and establish the grid equation at the next depth.

Consequently, for a symmetric, idempotent, coordinatewise nondecreasing m whose bisection grid separates T=[a,b], mediality is necessary and sufficient for a faithful common real midpoint reading. Separate continuity and completeness of T are unnecessary. The identity must be an established law on its full source domain. A finite passing sample does not prove it, while the computed 11/9 versus 12/9 crossing refutes it with one source.

**Preserving divisions constrains the transport law.** Now suppose a faithful common reading t exists on T with m available on every pair. Let g:T→T be an order-preserving bijection satisfying

    g(m(x,y)) = m(g(x),g(y)).

The reading t∘g preserves the same divisions. S27's uniqueness argument therefore gives t(gx)=α_g t(x)+β_g with α_g>0. Neither a complete real carrier nor an initially declared affine transformation was required. Conversely, an affine action in these coordinates preserves m by substitution and faithfulness. This is preservation of the division relation. It still permits a change in the size of every interval.

**One internal comparison removes that change of scale.** Choose a<b in T. Under the preceding transport law, the single crossed equality

    m(a,g(b)) = m(b,g(a))

is equivalent to α_g=1. Applying t and cancelling gives

    (α_g−1)(t(b)−t(a)) = 0.

The retained reference distinction makes t(b)−t(a)>0, so the scale factor must be one. The equation compares the original reference interval with its transported version through actual m applications. No external zero or numerical duration is part of the equation itself. Without division preservation it is insufficient: S27's nonaffine increasing h fixes 0 and 1 and satisfies this crossed equality for them, but sends their midpoint 1/2 to 1/4. Conversely, g(x)=2x preserves ordinary midpoints but fails the crossed comparison for a=0,b=1. Both relations matter.

All bijections preserving m and that reference interval now act as translations in the faithful reading, and therefore commute on T. If one such action A advances an occurrence, its positive increment makes A cofinal on every group orbit. Each other strictly advancing relative action eventually reaches A through repetition. Thus all three faithful-clock conditions of LiR8 follow from these joint interval relations. Its reconstructed reading on each orbit agrees with t after the same internal normalization. Commutation is a consequence here, rather than an independently assumed clock property.

If faithfulness is weakened, the same numerical calculations constrain the image, but equality there need not identify source occurrences or force their actions to commute. Likewise, separately calibrated regions need common source correspondences before their midpoint and repetition laws can be combined. S25 tests the subsequent agreement of actual transports around paths. It cannot supply the common interval relation that S28 tests first. These are conditions on a faithful representation of specified internal comparisons, not a derivation of equal divisions or a universal clock from the existence of a contrast alone.

## §5h. Which Closed Supports Can Carry an Ordered Contrast

**S29 (Strict internal comparison propagates attained extrema through its support).** Let C be a nonempty finite family of addressed roles. Each x has a nonempty finite support N(x) contained in C. Draw x→y for each y∈N(x), from the dependent role to its support. Let r take values in one linearly ordered set. Require the following internal-comparison relation at every role: if its support readings all equal v, then r(x)=v. Otherwise r(x) is strictly between the least and greatest support readings. No equal weights, addition, metric or real-valued scale is assumed.

The roles with greatest reading form a nonempty set closed under every support edge. The same is true of the least-reading roles. Indeed, if r(x) is a global maximum and one support reading were smaller, strict internality would put r(x) below the maximum of its supports, which cannot exceed that global maximum. Hence all its support readings equal r(x). Repeat along any finite support path.

Consequently every terminal strongly connected component has one constant reading. Here terminal means that no support edge leaves the component, and strongly connected means that every role reaches every other along support edges. If the entire graph is strongly connected, r is constant. More generally, one terminal component already forces r to be constant throughout C: each of the two extremal sets contains a terminal component of the full finite graph, so the unique one carries both extrema. A retained ordered contrast therefore requires at least two terminal components with different values under this particular support law. Each role's value is bounded by the least and greatest values on the terminal components reachable from that role, by applying the same argument to its reachable subgraph.

This is a maximum-principle argument. The familiar positive weighted-average version appears in [Markov Chains, Proposition 8.2.2](https://www.math.northwestern.edu/documents/book-markov-chains.pdf). The proof above uses only the order and the stated strict internality. It does not assume random transitions or the convergence of a process. With a finite interior and a finite addressed boundary, if every interior role has a support path to that boundary, the same propagation places the extremal readings on the boundary. That boundary can consist entirely of other parts of the same whole.

For arithmetic midpoint equations, the finite boundary also gives existence and uniqueness. Supply one equation 2t(x)=t(y)+t(z) at each interior role, with its two addressed supports in the interior or boundary. Assume every interior role has a support path to the boundary, whose values are fixed. The difference of two solutions obeys the same midpoint equations and has zero boundary values. The extremum argument makes it zero everywhere. The square linear system on the finitely many interior unknowns therefore has zero kernel and is invertible, proving existence as well. With rational boundary values its matrix and right-hand side are rational, so its unique solution is rational. This is a finite algebraic argument, not an instruction to run a relaxation process.

Conversely, every rational p/q in [0,1] has such a finite witness. Take roles x₀,…,x_q, fix t(x₀)=0 and t(x_q)=1, and require each interior xᵢ to be the midpoint of xᵢ₋₁ and xᵢ₊₁. Adjacent increments are equal, their sum is one, and t(x_p)=p/q. Thus coupled finite midpoint constraints can determine any rational division, while a finite midpoint tree from 0 and 1 yields only dyadic divisions. Distinct roles in a general network may still receive equal values. These network results certify the selected equations. Preservation of all additional midpoint contacts remains S28's separate joint-law obligation.

**Closure and connectedness alone do not erase contrast.** With ordinary arithmetic midpoint m, retain a=m(a,a), b=m(b,b), and c=m(a,b). The joint readings (a,b,c)=(0,1,1/2) satisfy all equations. The support graph is connected when edge directions are forgotten, every support is internal, and its two terminal components carry different values. Nothing requires a support outside C. By contrast, the three equations a=m(b,c), b=m(c,a), c=m(a,b) form one strongly connected support and force equal ordered readings. The dependency direction names which relation supplies which argument, without defining a temporal order.

**The assumptions can be attacked separately.** On the infinite graph with roles n∈ℤ and supports n−1,n+1, r(n)=n satisfies every ordinary midpoint equation and retains all differences. Every role reaches every other, but no greatest or least reading is attained. Finiteness in S29 provides attained extrema, rather than an external bounding object. If strict internality is replaced by inclusive betweenness, the finite two-role equations a=max(a,b) and b=min(a,b) admit a<b. Both roles use both supports. Even with finiteness and complete mutual reachability, this weaker relation permits contrast.

**A joint division algebra need not admit the ordered interpretation.** On three labels 0,1,2 define m(x,y)=−x−y modulo 3:

| m | 0 | 1 | 2 |
|---|---|---|---|
| 0 | 0 | 2 | 1 |
| 1 | 2 | 1 | 0 |
| 2 | 1 | 0 | 2 |

This operation is symmetric and idempotent. It is cancellative in either input, since equality with one input fixed cancels that input modulo 3. Both medial crossings reduce to a+b+c+d modulo 3, so S28's joint crossing law is also satisfied. For distinct inputs, m returns the third label. Thus the three cyclic equations above are jointly realized with three distinct answers. No linear order on these labels can make every one of those outputs strictly between its inputs: the greatest label would have to be between the other two.

In fact every real midpoint reading of this table is constant, even without requiring it to preserve an order. Write its three answers as u,v,w. The first two cyclic equations give 2u=v+w and 2v=w+u. Subtraction gives 3(u−v)=0, and then u=v=w. This is a finite refusal of a real midpoint reading that preserves even one of these label contrasts. It is not a failure of the table's joint algebra. Mediality, cancellation and idempotence did not supply the ordered, separating interpretation required by S28.

For The Cut, the given contrast excludes a proposed finite, strongly connected, strictly internal support account **of that contrast**. It does not exclude returning support as such. Nor does one whole imply that every role depends on every other under this particular reading law. An alternative contract can retain the contrast, as the explicit constructions show. They test the proposed inference without asserting another physically realized world. Equality forced in a clock or support reading identifies its answers, not all the actual occurrences carrying them. The proofs here are mathematical arguments over the addressed relations, not a new compiler certification of arbitrary support graphs.

## §5i. A Centre, Change of Scale and Opposite Directions

Two legs a→c and c→b establish their shared role c. Their outside endpoints alone need not determine it. `Path<A,C,B>` retains C in both legs, while different C parameters admit the same A and B. The existing `RootExcursion` retains a nonempty intermediate form even though its endpoints agree. Calling this joint role a centre does not yet assert equal halves, a unique solution from the endpoints, or an absolute origin. Those are questions about the actual leg relations. The number of drawn edges is also presentation-dependent: inserting a retained intermediate incidence can subdivide one edge without creating another geometric requirement.

**A role exchange must descend through the participant reading.** Let H_c be admitted contact descriptions with one fixed centre, closed under an involution J exchanging the two end roles. Let p read the first participant. An action r on participant readings satisfying r(p(h))=p(Jh) exists exactly when

    p(h)=p(k) ⇒ p(Jh)=p(Jk).

This is VC9's factorization criterion. With this condition, J²=id forces r²=id on p(H_c). When it fails, returning the full contact after two exchanges remains possible while the first participant does not determine its partner. For example, contacts (a,b) and (a,d), with b≠d, and their reversals all retain the same centre. Their first readings agree and their exchanged readings differ. One perfectly definite contact has not established a partner law at every contact with the same first reading. Nor does reading a reversed description establish an intervention on its participants.

The joint reading (p(h),p(Jh)) always carries the exchange by swapping its fields. It is the least refinement of p supporting this one involution: any such refinement must determine both fields. This is the period-two case of the future-reading criterion behind VC38, with minimality by VC56. Every finite word reduces to id or J, so two features suffice even when H_c is infinite. They need not recover the contact occurrence or any further joining content. The role-reading question, its source occurrence and the action vocabulary remain distinct.

The following obligations organize S27–S32. They are not automatic stages of one derivation.

| Proposed passage | Relation that must be established |
|---|---|
| Two legs to a shared role | The actual common incidence, retained by `Path` |
| Contact reversal to a participant action | Equal participant readings have equal partner readings |
| Actions to one centre for any two ends | Existence and uniqueness of c solving r_c(a)=b |
| Coherent centre exchanges to compatible scale changes | The additional medial crossing, refused by S32's six incidences |
| Division to an ordered real calibration | The order, retained equal divisions and separation conditions of S27–S28 |

**S30 (Reversible division about one centre forces a composition law).** Let a nonempty X have a total operation m satisfying symmetry, idempotence, cancellation in either argument and the medial law of S28. These are laws of the proposed division relation, without a presumed real-valued reading. Choose c∈X and require h(x)=m(c,x) to be onto X. Cancellation makes h one-to-one. Write d for its inverse. Define

    x + y = d(m(x,y)).

Then + is commutative, associative and cancellative, with unit c. Its doubling is d(x)=x+x, and h is its unique halving. This is the midpoint specialization of [Fatelo and Martins-Ferreira, Proposition 5.2](https://arxiv.org/pdf/1407.7435). The proof below exposes the division and expansion relations that supply the operation in this inquiry. No addition or associativity law is given separately.

*Proof.* Mediality and m(c,c)=c give h(m(x,y))=m(h(x),h(y)). Its inverse d preserves m as well. Hence + is medial:

    (x+y)+(z+w) = d²(m(m(x,y),m(z,w)))
                = (x+z)+(y+w).

Symmetry gives commutativity, and x+c=d(h(x))=x. Insert the unit into the medial equation:

    (x+y)+z = (x+y)+(c+z) = (x+c)+(y+z) = x+(y+z).

Injectivity of d and cancellation for m give cancellation for +. Finally x+x=d(m(x,x))=d(x). Also h(x+y)=m(x,y)=h(x)+h(y), the last equality following from preservation of m by h and the definition of +. Thus h is an additive bijection inverse to doubling. QED

This reconstructs a commutative monoid from the specified centre and divisions. LQ13 obtains a possibly noncommutative monoid from a different contact contract. The equations here cannot be transferred to that contract by the shared word composition.

**Expansion and reflection have different availability conditions.** An opposite r to x about c would satisfy m(x,r)=c. Under the derived law this is exactly x+r=c. Such an opposite, when available, is unique by cancellation. Every x has one exactly when the monoid is a group. By contrast, expansion d already exists under S30 without that condition. Nonnegative dyadic rationals with ordinary midpoint and c=0 give a precise separation: halving and doubling are inverse maps on the whole carrier, while no positive x has an opposite there. Nothing in this example asserts that reality has a positive-number boundary.

The admissible centres for full expansion are also determined. For another a, let h_a(x)=m(a,x). Since m(a,x)=h(a+x), h_a is onto exactly when translation x↦a+x is onto. This occurs exactly when a has an additive inverse: an input mapping to c supplies one, and an inverse makes every target reachable by translation. Thus the centres about which every division can be reversed are precisely the invertible elements of this derived monoid. Requiring this property at every centre forces the group case. Selecting one internal reference does not silently establish that freedom at every other reference.

**Two centres can supply a displacement through changes of scale.** In the group case use c as the additive zero and write h_a(x)=m(a,x), with inverse d_a. The already derived laws give d_b(x)=2x−b and

    h_a(d_b(x)) = x + h(a−b).

Thus expansion about b followed by division about a is a translation, obtained without a supplied length or translation primitive. Exchanging a and b supplies its inverse. Distinct centres give a nonidentity action because h is injective. A strictly advancing clock along repetitions of this action requires that v=h(a−b) have infinite additive order. If nv=c for some positive integer n, the configuration returns and no strict endpoint clock survives. If no such n exists, each orbit has distinct forms indexed by integers, with the ordered choice of centres selecting the step orientation. A count of those steps does not establish equal physical durations or the novelty of their occurrences. This also does not orient the whole medium from a single unadorned centre.

**A reversible change of scale need not mean getting closer.** S29's three-label algebra satisfies S30 at every centre. At c=0, h exchanges 1 and 2, so h² is the identity. Its exact halves are cyclic. A strictly decreasing distance-to-centre reading on each noncentral application would require r(1)>r(2)>r(1), which is impossible. More generally, on a finite X any injective h is a permutation, so every orbit returns and no noncentral orbit permits strict decrease at every step. Unbounded repeated strict inward comparison therefore excludes a fixed finite complete orbit carrier. It does not follow from the word scale alone or establish an infinite physical whole from a finite local reading.

Even in the ordered interpretation, division does not identify a point reached after all finite inward steps. On positive dyadic values together with c=0, repeated halving of x>0 never equals c at a finite depth. A limit statement in an additional topology, an attained form, and an available terminating contact are separate requirements. The proposed centre must not become an unexplained final gate by interchanging them.

**The group case permits reversal without selecting a temporal orientation.** Write −x for the opposite relative to c. Negation fixes c and preserves m, since it preserves + and its unique halving. Suppose a proposed nontrivial future-increment family P contains c, is closed under +, and satisfies P∩(−P)={c}. These are stated requirements for a one-sided additive orientation. If the family had to be invariant under every symmetry of the midpoint structure fixing c, negation would give P=−P and therefore P={c}, a contradiction. A nontrivial such orientation needs a further internal relation that excludes this symmetry. A directed record relation may do so, but its availability is not supplied by the midpoint algebra.

Conversely, reading the same two-sided relation in reverse does not construct a backward physical intervention. M67 gives independent extensions away from an internal centre their exact componentwise inclusion order. Three regions suffice to exclude any scalar reading that preserves and reflects its strict order. With n independently retainable occurrences, n ordered coordinates are necessary for a reading that recovers inclusion by componentwise comparison. This is an order-representation bound, not an assignment of physical dimensions. Neither this radial growth nor the two written sides establishes a universal past and future. An actual retained extension must still specify its directed origin relation. These arguments classify the consequences of specified relations, rather than claiming that all centres in reality satisfy the midpoint premises. The existing Swift leg construction retains incidence, while this general reconstruction remains a mathematical proof in the article.

**A balance contact need not begin with a midpoint or a numerical origin.** Consider instead a nonempty carrier with a total ternary contact T satisfying

    T(x,y,y)=x,    T(y,y,x)=x,
    T(T(a,b,c),d,e)=T(a,b,T(c,d,e)),
    T(x,y,z)=T(z,y,x).

These are the standard abelian-heap laws; see [Breaz, Brzeziński, Rybołowicz and Saracco, §2.1](https://link.springer.com/article/10.1007/s10231-023-01369-0). Choose an internal reference o and put x+z=T(x,o,z), −x=T(o,x,o). The first two laws give the unit, the third associativity, and the last commutativity. The inverse follows through actual substitutions:

    x+(−x)=T(x,o,T(o,x,o))=T(T(x,o,o),x,o)=T(x,x,o)=o.

The same substitutions give

    (−y)+z=T(o,y,z),
    x+((−y)+z)=T(x,o,T(o,y,z))=T(T(x,o,o),y,z)=T(x,y,z).

Thus the contact supplies an abelian group relative to o, rather than presupposing numerical addition. Changing o changes the derived group operation and its identity together; the original T remains the same. A map preserving T becomes an additive map followed by a translation in these coordinates. This reconstruction is known mathematics, not a new VI theorem.

Its connection to IiS10 is precise. Define the four-place balance by

    B(a,b,c,d)  iff  T(b,a,c)=d.

In any of the reconstructed coordinates, this says a+d=b+c. The comparison has no preferred origin. IiS10's common-additive-part criterion now concerns preservation of this particular contact. It does not say that every physical quantity must carry that contact, or that the existence of one encountered distinction establishes its laws.

**Return and exchange alone do not supply coherence.** On the integers, the alternative contact T(x,y,z)=x−y+z+(x−y)(z−y) has both return identities and the outer exchange. But

    T(T(0,1,0),0,1)=1,
    T(0,1,T(0,0,1))=0.

It fails the required composition. Conversely, dropping only the outer exchange permits any group contact T(x,y,z)=xy⁻¹z, including noncommutative groups. With noncommuting p,q, its values T(p,e,q)=pq and T(q,e,p)=qp differ. The symmetry is substantive, not an automatic consequence of using three internal roles.

**Availability is also substantive.** Restrict the ordinary integer contact x−y+z to X={0,1}, admitting a triple exactly when its output belongs to X. The returns still exist, and all equalities agree whenever both sides are admitted. Yet T(T(1,0,1),1,0) is refused at its inner contact, while T(1,0,T(1,1,0)) is admitted and equals 1. Restoring a total group law would change the availability relation or the carrier. A correct identity on the successful fragment does not authorize that completion. This is the same obligation that LQ16 keeps when it compares complete contextual relations.

**A balance does not supply an ordered continuum.** The two-element group gives a total contact obeying every displayed law. A midpoint would require 2m=x+y; it has no solution for the distinct pair and two solutions for either equal pair. By contrast, S30 starts with the additional division operation and proves its particular halving law. The two routes must not silently exchange their premises. Length, real scalar multiplication, topology and a temporal orientation are further questions. IiS10 gives a direct application of this distinction: cyclic phase transport and additive amplitude balance cannot be treated as the same contact.

## §5j. What a Centre Must Retain Across Scales

**S31 (a cancellative division cannot be a complete centre-only joining law).** Let X be nonempty and consider nonempty finite families of addressed occurrences carrying values in X. Different occurrences may carry the same value. Suppose a centre reading C assigns x to a singleton carrying x, ignores the grouping of a fixed family, and obeys

    C(U ⊔ V) = m(C(U),C(V))

for every disjoint pair of such families. Here m is symmetric, idempotent and cancellative in either argument. Then X has only one value. Thus this contract cannot retain an exhibited contrast.

*Proof.* Apply the rule twice to the same three addressed occurrences. Independence of grouping forces m(m(x,y),z)=m(x,m(y,z)). Put y=x. Idempotence gives m(x,z)=m(x,m(x,z)). Cancellation at the first input gives z=m(x,z). Symmetry also gives x=m(x,z), hence x=z for all x,z. QED

The proof needs no numbers, distance, external centre or chosen temporal order. Its target is a specific attempted compression: retain only the current centre, then use the same division law to join parts at every scale while forgetting their grouping. A contact that retains grouping, has restricted joining availability or uses another aggregation law is a different contract. A pair of incidence legs alone supplies none of these centre laws. The theorem strengthens S28's nonassociativity observation by removing its ordered interpretation and making the future-use requirement explicit.

For ordinary arithmetic midpoint, the three source values 0,0,4 give m(m(0,0),4)=2 and m(0,m(0,4))=1. The constituent occurrences are unchanged. Their effective weights have changed: the outside term gets half the result at either grouping. `RegroupedDivisionTrace` computes the corresponding numerators 8 and 4 over the common denominator four with closed AddZero/AddSuccessor expressions. All six addition inputs are checked against the same source and earlier answers. Four common predecessor readings leave a zero/successor contrast, and `INTERACTION_CENTRE_ONLY_REGROUPING` rejects their equality. This checks the finite arithmetic obstruction, not a universal implementation of division.

**Future centres can force retention of the participation count.** In a specified nontrivial vector space over the rationals, give a finite nonempty family U its equal-part centre C(U)=Σu/|U|. Suppose fresh occurrences of every value can be adjoined. The summary (n,s)=(|U|,Σu) combines associatively by

    (n,s) ⊕ (k,t) = (n+k,s+t).

Its centre is s/n. This is an exact sufficient summary for the present centre and for the centre after adjoining any available further family. It is also least in question content: different present centres are already distinguished, and equal centres c with different sizes n and k are distinguished by adjoining one common value x≠c. Their new centres differ by

    (nc+x)/(n+1) − (kc+x)/(k+1)
      = (n−k)(c−x)/((n+1)(k+1)),

which is nonzero. Hence any summary answering this entire question family must recover both the centre and its participation count. The necessary count is established through a possible shared continuation, without requiring the interface to list every constituent. Availability of that continuation is part of the domain premise. The count refers to addressed participation, not a physical mass assigned by analogy.

The same summary need not recover internal contrasts. The two families carrying −1,1 and −2,2 have the same count and centre. Every further equal-part centre query gives the same answer for both, while their constituent values differ. For two ordered inputs in S30's group case, a complete alternative is the centre together with the oriented difference:

    c = m(a,b),  δ = b−a,
    a = c−h(δ),  b = c+h(δ).

Here h is the halving obtained in S30, relative to the selected additive reference. No real order or norm is required. Repeating this invertible change on a fixed finite binary tree retains its root centre and the difference at every joining. Its inverse recovers each original leaf by finite descent. The tree is retained too: on an unbalanced tree, this recursively obtained centre need not equal the equal-part centre of all leaves. Keeping only a centre discards those difference questions. Keeping the differences changes their representation without losing them in this algebra. Neither representation proves that all such contacts occur physically or that every requested inverse can be performed by a given interface.

**Closure under every finite balanced centre is stronger than closure under halves.** Keep the abelian group reconstructed in S30 and ask that every n≥1 and every n-tuple have exactly one centre c satisfying

    nc = x₁ + ⋯ + xₙ.

This is equivalent to each multiplication-by-n map being a bijection. Necessity uses the tuple (x,0,…,0), and sufficiency solves the displayed equation. For integer p and positive integer q, the scalar action (p/q)x is then the unique y satisfying qy=px. Integer multiplication and uniqueness give the rational vector-space laws. Thus this all-arity centre contract forces divisibility by every positive integer, without forcing a real continuum, dimension or metric.

Halves alone do less. The dyadic rationals admit unique halves but no centre solving 3c=1. In S29's three-label group, that equation also has no solution, while 3c=0 has three. Its valid binary division table therefore cannot supply these unique centres at every scale. The equal-part balance equation and availability at all finite arities are additional relations to establish, rather than consequences of naming the whole or drawing two links at a centre.

## §5k. A Centre Defined by an Internal Exchange

**S32 (unique reversible centres do not force medial division).** A pair of incidence legs need not carry a division law. Consider a stronger proposed relation: at each c there is an internal exchange r_c of the whole specified carrier X. Require

    r_c(c)=c,  r_c(r_c(a))=a,
    r_{r_c(d)} = r_c ∘ r_d ∘ r_c.

Also require that, for every a,b, exactly one c satisfies r_c(a)=b. The first two laws give a fixed centre and return after two exchanges. The third transports the centre's exchange together with the participants. These are explicit relations to establish, including their domain, rather than consequences of calling two contacts a centre. The exchange identities are known as an involutory quandle structure. [Bergman, §1](https://arxiv.org/abs/2006.00641) gives their group construction and equivalent forms.

Define m(a,b) to be that unique c. Involution gives m(a,b)=m(b,a), and the fixed-centre law gives m(a,a)=a. For fixed a, the inverse of b↦m(a,b) is c↦r_c(a). Thus division is cancellative and permits expansion about every internal reference. The transport law and uniqueness also give

    r_c(m(a,b)) = m(r_c(a),r_c(b)).

An actual exchange preserves every midpoint incidence. It does not follow that the scale change h_c(a)=m(c,a) does so. The following finite construction separates them.

There is already a restriction without numbers or mediality. The only fixed form of r_c is c: if r_c(a)=a, uniqueness of the centre of (a,a), also supplied by r_a(a)=a, gives c=a. Thus the centre of two distinct ends is distinct from each end. On a finite complete X, every r_c pairs all the other forms into two-cycles, so |X| is odd. A complete two-form carrier cannot meet this centre contract. A partial domain need not satisfy the count: missing centres or exchanges change its premises. This is a consequence of the exchange and uniqueness relations, not of binary incidence alone.

**One common relation, with a failed crossing.** Take the 21 pairs (a,b), with a modulo 7 and b modulo 3, and composition

    (a,b)(d,e) = (a+2^b d, b+e).

Since 2³=1 modulo 7, this is a well-defined group: both bracketings give first coordinate a+2^b d+2^(b+e)f, the identity is (0,0), and the inverse of (a,b) is (−2^(−b)a,−b). Its square map is

    (a,b)² = ((1+2^b)a,2b).

The second coordinate is invertible modulo 3, and the first multipliers 2,3,5 are invertible modulo 7. Every element therefore has a unique square root. Define r_c(a)=ca⁻¹c, now writing a,c as group elements. The three exchange laws follow by cancellation. The equation ca⁻¹c=b has the unique solution

    m(a,b) = a · sqrt(a⁻¹b).

This proves all the preceding centre requirements on the complete 21-form domain, without testing an arbitrary table of proposed centres. In pair coordinates the formula is

    m((a,b),(d,e)) = (a+f(e−b)(d−a), 2e−b),
    f(0)=4, f(1)=3, f(2)=5.

All first coordinates are modulo 7 and all second coordinates modulo 3. Put o=(0,0), x=(1,0), y=(0,1). The six incidences give

| Inputs | Their unique centre |
|---|---|
| o,o | o |
| x,y | (5,2) |
| o,(5,2) | (4,1) |
| o,x | (4,0) |
| o,y | (0,2) |
| (4,0),(0,2) | (5,1) |

Consequently m(m(o,o),m(x,y)) differs from m(m(o,x),m(o,y)). Every centre exists uniquely, each division can be undone, and every r_c transports the same centre relation correctly. Yet S28's medial crossing fails. Any reading preserving all six incidences as arithmetic midpoints must identify (4,1) and (5,1). This is a finite refusal for that particular retained contrast, independent of any proposed coordinate names. The earlier three-label example preserves mediality while losing an ordered interpretation. This example attacks the prior step: deriving mediality from unique centres and their coherent exchanges.

`SevenAffineFields` in Checks/Interactions.swift represents (a,b) by its permutation t↦a+2^b t of seven addressed fields. Its two selectors right-compose the shift R and doubling D. `SevenAffineRelations` derives R⁷=id, D³=id and DR=R²D for arbitrary fields. `ReversibleCentreCrossing` checks the six centre incidences through their actual c a⁻¹ c compositions on one shared field source. The two crossed results send the zero position to distinct successor terms for four and five. `INTERACTION_REVERSIBLE_CENTRES_FORCE_MEDIAL` refuses their equality, with a positive zero/successor separation after four predecessor readings. The compiler verifies these constructed equalities and the finite contrast. The group argument above establishes uniqueness of each centre and the general exchange laws.

The finite group tests the proposed implication, without asserting another physical universe or spatial curvature. An exchanged reading, a transformed form and a new application occurrence have the different obligations stated at the start of §5i and in LQ16/M55.

**Preserving every exchange can still lose the inverse scale question.** On the dyadic rationals D=ℤ[1/2], use r_c(a)=2c−a and m(a,b)=(a+b)/2. Define q(a) to be its class modulo integer differences. Only this equivalence of source readings is used. All exchanges descend exactly:

    q(r_c(a)) = 2q(c)−q(a).

Changing either representative by an integer leaves the result class unchanged. Every quotient contact lifts to a source contact: choose representatives a,c and take b=2c−a. Doubling also descends, q(2a)=2q(a). But halving does not: q(0)=q(1), whereas q(0/2)≠q(1/2). The complete doubling map on D is bijective. Its exact image on D/ℤ is two-to-one. Thus exact transport of a forward law need not transport its inverse. Each pair of image forms has two centres, differing by the nonzero class of 1/2. The quotient preserves every reflection law but loses the unique-centre relation. At centre zero its reflection has both [0] and [1/2] fixed. Even S32's unique-fixed-point step fails after this reading.

The required refinement has an exact depth dependence. To retain q(a) and answer q(a/2^j) for every j≤k, two sources a,b can remain identified exactly when

    a−b ∈ 2^k ℤ.

Necessity is the question at j=k. Sufficiency follows since 2^kℤ⊆2^jℤ for each j≤k. Thus a mod 2^kℤ is the least sufficient reading for this family. Each old q-fiber splits into exactly 2^k classes, the integer differences modulo 2^k. Any fixed residual alphabet supporting all those answers therefore needs at least 2^k values within that fiber, by M35. One more halving doubles this requirement. To answer every finite depth, equality must lie in ⋂_k 2^kℤ={0}, so the least such refinement separates the complete dyadic sources.

No source information is destroyed in this construction. Integer differences omitted by one reading become necessary fractional differences after a change of scale. The result concerns the specified questions and admitted operations. It neither establishes physical availability of unlimited division nor imposes an entropy or energy interpretation on the residual count. It identifies exactly what a proposed scale-independent description must preserve.

VC21 gives the general count |U⁻ᵏ(y)| for an exact forward image U of a bijection. Its least reversible refinement retains the realized backward answers. S32's repeated doubling of required distinctions is specific to this scale relation. A separate VC21 construction needs unbounded past depth across its sources while one binary residual suffices for every depth.

VC20 identifies the boundaries of this example. A finite exact image of a bijection is always reversible, even when the source is infinite. More generally, an irreversible exact factor is possible for a given bijection exactly when it has an infinite orbit. If every source returns after its own finite period, every exact factor is reversible, without a common period bound. A different sufficient condition is that the inverse already be a finite word in the operations this reading carries. Reflections meet that condition, while adding only forward doubling does not supply halving. The operations a description claims to support therefore belong to its completeness statement.

**The same exchange gives exact continuation in both directions.** On ordered neighbouring forms define

    T(a,b) = (b,r_b(a)),
    T⁻¹(a,b) = (r_a(b),a).

Involution verifies both inverse equations. If J exchanges the two input roles, then JTJ=T⁻¹. Thus a known adjacent pair and this complete contact determine every finite continuation in both directions, while exchanging the roles reverses its traversal. Such trajectories are also described in [Bergman, §3](https://arxiv.org/abs/2006.00641). On the displayed group they take the form a(a⁻¹b)^n, so the finite example returns. The integer index counts applications of the specified relation, without supplying an external clock. The algebra supplies a reversible continuation relation, without selecting physical future or promising a strictly advancing record. A retained record of the applications adds the occurrence relations of M55. This is a concrete two-direction construction under stated premises, not a deduction that every actual future is already determined.

**A traversal law does not select its reversal.** Let U be a bijection. A reversing involution Θ satisfies Θ²=id and ΘUΘ=U⁻¹. These equations can have several answers. For U(a,b,c,d)=(b,c,d,a), both

    Θ₀(a,b,c,d) = (a,d,c,b),
    Θ₁(a,b,c,d) = (d,c,b,a)

satisfy them. On (A,B,C,B), Θ₀ returns the source while Θ₁ gives (B,C,B,A). Distinct A,B make the answers different. `OneTraversalTwoReversals` in `Checks/Interactions.swift` derives both squares and both reverse-traversal equations from actual fields. A positive boundary distinguishes their first readings, and a refusal rejects identifying the two reversals from those equations. Here Θ₁=UΘ₀: they use different anchors. The counterexample need not represent competing physical laws. It shows that the traversal alone does not specify which internal occurrence is retained when asking for its reverse. More generally, two reversing involutions differ by a symmetry commuting with U, since S=Θ₁Θ₀ gives SU=US.

Involution is itself a restriction on a reversing contact. More generally, a bijection J can obey JUJ⁻¹=U⁻¹ while J² is a nonidentity symmetry commuting with U. LQ13 already supplies such a case: in its Q₈ family, I²=J²=Z, Z²=id and IJ=ZJI. These relations give JIJ⁻¹=ZI=I⁻¹, yet J²=Z. The central return is positively distinct from identity on the retained fields. Within that specified eight-operation family, the only involutions are central and cannot reverse I, while the noncentral reversing contacts have order four. This uses the already constructed contact family, without deriving a physical time-reversal law. A reversal at a reduced interface can close after two applications while the richer contact retains a residue. But in this particular example any reading with EZ=E also has EI⁻¹=EZI=EI. Removing the squared residue erases the distinction between the two traversal directions. That reduction cannot be presented as preserving this question.

**A sufficiently discriminating internal reading can select the reversal.** Fix an established bijection U:X→X and a reading E whose current answer the intended reversal must preserve. Define its two-direction comparison profile

    H(x)_n = E(Uⁿx),    n∈ℤ.

These indices count applications of the specified relation in its two directions. The profile is a mathematical question family, not an asserted infinite physical archive or a clock outside the whole. On profiles put (rz)_n=z_(−n). If H separates the source states, a bijection Θ satisfying ΘUΘ⁻¹=U⁻¹ and EΘ=E exists exactly when the realized image H(X) is closed under r. When it exists, it is unique, equals H⁻¹rH and is forced to be an involution.

To prove necessity, E(UⁿΘx)=E(ΘU^(−n)x)=E(U^(−n)x), so HΘ=rH. For sufficiency, closure defines Θ on the source image and gives Θ²=id. H carries U to the shift (Sz)_n=z_(n+1), and rSr=S⁻¹, proving the reversal equation. The zeroth coordinate gives EΘ=E. Injectivity of H supplies uniqueness. For the four-entry source above, the first-field reading under four successive applications of U recovers all fields. Retaining that current answer therefore selects Θ₀. The same contact law that supplies the continuation makes the additional reading discriminating.

This reconstructs a reversal inside the stated model without guessing its action on every hidden coordinate. Its premises still matter: U must be established, the retained reading must express the intended comparison, and the reversed profiles must be admitted. In particular, an order-four reversing contact cannot have such a separating profile made entirely from unchanged readings: its squared residue would be invisible to every profile coordinate. A repeated successful return tests only the preparations used. Neither existence of a formal inverse nor an unchanged scalar proves these premises for a physical apparatus. A proposed action on odd readings requires their corresponding value transformations, rather than treating every recorded coordinate as unchanged.

**Reversal of every visible history need not lift to the source.** Without separation, the same construction defines a unique reversal on the profile quotient H(X), whenever that image is closed. It need not define a bijection on X. Consider three disjoint three-state cycles, with U advancing once around each. Let E read the repeating pattern ABC on each of the first two cycles and ACB on the third, with A,B,C distinct. The six distinct two-direction profiles are closed under reversal. Yet the profile beginning ABC has two source states, one in each first cycle, while its reversed profile beginning ACB has only one. Any source reversal preserving E would, by HΘ=rH, biject these fibres. Their unequal sizes forbid it.

Even the entire stationary record law can be symmetric in this example. Give each of the six states in the first two cycles weight 1/12 and each state in the third weight 1/6. These weights sum to one and remain unchanged by U. Each of the six distinct profiles then has weight 1/6, so every finite word has the same probability as its reverse. Thus invertible source dynamics, all admitted record histories and their full symmetric law do not supply the missing source correspondence. This finite construction refuses that inference from the stated premises. It does not establish a physically realized alternative whole or deny another reversal that changes E's meaning.

The positive reconstruction and its obstruction specify where a contact with reality is needed. Additional source-related readings must resolve a fibre when a claim about that fibre changes the answer. If only the profile-level reversal is required, VC15 permits retaining that exact quotient and stating its scope. M39's recording and statistical criteria then apply to the reversal actually justified at that interface. Mathematical reversal of a profile remains distinct from an available intervention that undoes a realized process, as §3a and M55 require.

## §5l. A Relational Core for Comparing Gravity and Quantum Contacts

The task is to identify what the two descriptions must retain, which additions each uses, and where their common physical realization remains unsettled. This section does not claim to have reconstructed either theory or removed every possible contradiction. A bare-Swift refusal addresses its stated construction. A relation not yet expressible in that construction is not thereby physically impossible.

**Reduction must preserve the question.** Removing a numeral, coordinate or matrix is justified when the retained relations still determine every answer and admission claimed for the reduced description. S9 and VC15 supply that test. LQ13 shows that an injective numbering can retain an entire finite relation if its actual composition law is transported too. Conversely, deleting a number can delete a relation: S26 exhibits missing clock comparisons, and IiS24 exhibits missing response weights. The target is an explicit relational meaning for numerical content, with independent arithmetic assumptions exposed. Changing notation alone neither proves nor removes an assumption.

The common core is a collection of obligations on a representation of the given whole:

| Retained content | Required relation | What is not obtained by naming it |
|---|---|---|
| An actual contrast | The two roles and a contact that distinguishes them remain represented | A complete state space, a numerical unit or a whole history |
| An addressed occurrence | The actual participants, preparation and joining bind the answer | Identity of occurrences from equal output values |
| Composition | The output of one application is the actual input of the next | Permission to join independently chosen witnesses |
| Change of description | The source, operations and questions transform together and preserve the claimed readings | A new physical action or a preferred origin |
| A cut inside the whole | Retained images preserve the required contacts and continuations | Independence of the parts or exhaustion of the whole by those images |
| Alternative interventions | The setting belongs to the admitted process and its conditional reading | Simultaneous availability of answers to incompatible interventions |
| Reuse | The next application retains the source and context conditions supporting its claim | Unlimited repeatability from one prepared success |

The Cut §§1–3 supply the encountered happening and contrast and state the relational identification commitment. Its full internal support and historical commitments must remain distinguished from the particular source recoveries constructed in VI. None of the rows supplies an external observer, and none asserts that every possible interaction can be acquired by one internal participant.

**What remains of general relativity.** Retain event coincidences, internal light and clock comparisons, free-fall and transport relations, and the feedback between matter and gravitational geometry. The usual theory additionally supplies a smooth four-dimensional Lorentzian manifold, a metric and its associated connection, a particular coupling to matter, and field equations with boundary or initial data. These are substantial structures to reconstruct or justify in a chosen regime. General covariance alone does not select the dynamics. Einstein explicitly separates the matter coupling from the relativity postulate in [the 1916 paper, §16](https://pages.jh.edu/rrynasi1/PhysicalPrinciples/literature/Einstein1916%281923%29TheFoundationOfTheGeneralTheoryOfRelativity.pdf).

S25 retains comparison along paths, including a nonidentity return. S26 shows that light incidence can remain fixed while internal clock comparisons change. S27–S32 test additional interval and scale relations. These results therefore supply a transport and calibration skeleton, with the metric reconstruction still open. They do not derive the field equations, universal dimension, physical signature, or material clock law. An order of events is not yet a duration, and an arbitrary loop residual is not yet gravitational curvature. A classical metric in GR changes with the dynamics. Holding it fixed in a quantum-field calculation is an additional scope choice when back-reaction matters.

**What remains of quantum theory.** Retain prepared contacts and their alternatives, joint distinctions absent from separate readings, dependence on the order of actual operations, coherent comparison with an internal reference, and the distinction between recording an outcome and forgetting its record. The conventional representation additionally supplies an amplitude space, its inner-product and tensor structure, a class of admissible transformations, and a rule relating states and effects to outcome weights. Positivity and normalization then have exact mathematical meanings. Their names alone cannot replace the source constructions in IiS14–IiS20.

The finite relations in IiS9 and IiS21–IiS23 retain some relevant structure without selecting a cosine or a general probability law. IiS24 supplies a stronger countercheck: the same four contact supports admit both signaling and non-signaling weightings, and the balanced table is beyond the quantum set. Local silence and a common binary representation therefore leave two different gaps: the weights of outcomes and the joint restrictions that select the quantum class. Choosing a local-response table to close the gap would instead impose the Bell-local model class.

**The common realization is the unresolved seam.** [Quantum fields on a classical curved spacetime](https://arxiv.org/abs/1401.2026) already provide a substantial compatible regime. To extend the scope to a quantum source that also changes its gravitational comparisons, the source of matter contacts, geometry, reference apparatus and records must be one consistently bound realization. A fixed geometry cannot silently answer a question about its own response. Nor does replacing the source by its average prove that distinctions accessible to a later joint contact are irrelevant.

At least the following questions remain, with distinct success conditions:

| Missing relation | A result that would close the stated question |
|---|---|
| Which contacts are physically available? | A prepared, calibrated contact family with source sharing and refusal conditions justified, including the effect of changing settings |
| What fixes interval and scale comparisons? | An existence and uniqueness result for the retained clock and transport readings, up to changes that preserve every specified comparison |
| What selects quantum-compatible composition? | A justified relation excluding IiS24's perfect table while admitting the experimentally tested quantum contacts; merely imposing shared pre-existing answers fails this test |
| What fixes response weights? | A derivation of the weight relations from stated contact requirements, or an independently tested law; equal support and equal frequencies are different evidence |
| How do matter and gravitational comparisons respond together? | One source-bound coupled construction that preserves both sets of calibrated readings and their feedback in a specified regime |
| What distinguishes an actual record, alternative and history? | A rule tied to an actual recording process; reversible description, conditional updating and selection of one realized outcome must not be substituted for one another |

The most economical next target is the third row together with the first: identify a missing joint requirement through a finite countercontact and a physical way to test that requirement. Its failure witness should expose a precise omitted relationship. Its positive witness should preserve actual quantum-compatible contacts. The interval and back-reaction rows remain explicit obligations while this smaller question is settled.

**A physical audit case: suppression and hidden composition.** [BESIII's X(2370) study](https://arxiv.org/abs/2607.20366) reports no significant signal in a selected K*(892)K̄ decay channel and a product branching-fraction upper bound of 2.7×10⁻⁶ at 90% confidence. It relates suppression to a generalized G-parity selection rule and combines several properties to support a dominant pseudoscalar glueball component. The authors acknowledge that no single criterion identifies a glueball and that precise mixing fractions require further study. Their bound depends on reconstruction and fitting assumptions. It is not an exact measured zero or a proof excluding every possible composition.

For VI, the useful extraction is a dependency chain: establish the source symmetry, establish the corresponding transformation of the complete contact, derive its effect on the requested response, then determine which responses can satisfy all those relations. VI1a already supplies the determined-reading step. If gx=x and T(gx)=gT(x), then gT(x)=T(x). If no candidate in the proposed response class is fixed by every transformation preserving x, that determined response is impossible under these premises. This argument uses no amplitudes or numerical coordinates. The physical task is to establish its premises for the chosen response carrier and apparatus.

There is a decisive scope check. An equivariant admission relation need only retain the entire orbit of each admitted answer. It need not fix each answer separately. An exchange can therefore preserve a two-answer set while moving both answers. The same exchange can preserve their balanced probability law. Neither fact by itself forbids either outcome. Thus source symmetry alone cannot be used to replace a quantum selection-rule derivation with a ban on asymmetric recorded events.

The existing `SwapReturnForcesAgreement` gives the finite fixed-response instance: a returned pair related to itself by one exchange must be diagonal. Distinct zero/successor fields cannot realize that return, while `DiagonalSwapReturn` supplies all diagonal realizations. Calling this diagonal an absent detector response would require a further reading and calibration. Likewise, a physical amplitude selection rule needs the actual action on transition responses and a justified identification of its surviving response with absence in the specified channel. VI1a supplies neither that carrier nor that identification by naming a symmetry.

This gives a concrete way to study a hidden object through refusals. For each proposed internal structure, retain the full contact under which a response is prohibited, the exact reason for prohibition, and the evidence connecting the apparatus to that response. Compare the joint signatures of the candidates. Equal signatures leave the composition question open even if one signature is uniquely identified. A finite upper bound can discriminate candidates whose predicted responses are separated by that bound, under the stated statistical model. It cannot silently become logical impossibility. The next useful transfer is one fully traced selection rule with a permitted comparison channel, rather than a label asserting that VI has already identified the constituent.

## §6. Communication: Retaining the Required Answer

**S9 (Translation is question-bound).** A translation supports a requested answer when the original reading factors through the translated record by an actual decoder. Verdict §6c supplies this criterion. Equality of encoding names does not by itself establish common source and context, and different encodings can preserve a particular answer exactly.

This factorization is a relation of the records. Finding, applying or verifying a translation has a cost only under a specified access and resource model. The relation itself does not force a separate search each time it is used.

**S10 (Shared facts and equal caches).** G=H gives equal cache sets at that point. Retaining updates preserve the common records G∩H, but separate later acquisitions can make the caches different. Continued equality requires an update relation that preserves it. An earlier fact's retention and a present question's unchanged answer are separate claims.

## §7. Change of Perspective

**S11 (An encoding change is one possible change).** Changing an encoding can change the available answers. Keeping it fixed while its source changes can do so as well. To identify two proposed accounts of a change, show that their relevant readings agree through all the permitted continuations. S1 gives only its stated equality.

**S12 (Stillness relative to a question).** A question q is unchanged along a specified transition T exactly when q(T(x))=q(x) on the admitted inputs. A form's internal records can support that comparison. Neither a fixed encoding nor a count of observers establishes this invariance.

## §8. Bounds and References

**S13 (Finite joint answers).** If n jointly available readings have finite answer sets of sizes k₁,…,kₙ, their joint image has at most ∏ᵢkᵢ members. The number of encoding names is not this bound. A finite constructor alphabet can describe an unbounded family of finite records.

**S14 (Independent roles).** The d-role assertion of S5 concerns a specified jointly variable product presentation. Dependence between the outputs can restrict its image, as S3 shows. Reading the number of syntactic parameters does not prove an intrinsic dimension.

**S15 (An origin requires a reference relation).** If the automorphisms of a structure act transitively on more than one possible origin, no single origin is fixed by all of them. An invariant selection would have to be fixed, so none exists. An actual internal reference can distinguish an origin by changing the relevant symmetry. VI1a states the general criterion. No reference outside the whole is required.

**S16 (Transfer count under a declared interface).** Suppose each missing addressed record can be delivered and retained in one permitted transfer. Bringing G and H to their common union requires exactly |G △ H| such deliveries: every record present on just one side must be delivered to the other, and this schedule suffices. Reading, transport and verification costs need their own units. This statement does not require a finite vocabulary of all possible records.

**S17 (Depth under the tower premise).** In a tower where each further unresolved level strictly reduces a finite nonnegative integer K, at most K₀ such reductions are possible. M16 requires that descent premise. A finite initial library alone does not establish termination of every possible tower.

## §9. Physical Instances

The cache metric, an update rate, a dependency graph and a physical interpretation are different constructions. This section states the update and observation premises needed for the proposed connections. A familiar physical name does not add its corresponding dynamical law.

### Switching Cost

**S18 (A declared cost of changing encoding).** Fix the task distribution, the available records and operations, and a common cost unit. Compare the full cost of continuing with E against conversion and subsequent work under E′. Their difference can favor either choice. Retained answers can transfer when the relevant questions factor through a conversion, as in Verdict §6c. Switching therefore need not discard the whole library, and an empty library does not make all encodings equally costly.

A large record alone supplies no switching-cost law. Its access procedure, useful coverage and conversion witnesses matter. This is a model of the cost of changing representation. Matter §5's physical examples have additional equations and interpretations, and do not identify a library size with physical mass or a vacuum parameter.

### Operation Rate

**S19 (A bound relative to an update contract).** Fix the vocabulary of a cache and a permitted update that changes at most b≥1 entries per counted round. After n rounds, the symmetric difference between the initial and final caches is at most nb, by the triangle inequality for finite symmetric difference. Reaching a fixed target at distance k therefore requires at least ⌈k/b⌉ rounds. The special case b=1 gives k. This is a bound on full cache transformation under the stated update rule.

Matter M1's operation clock does not impose b=1. A compound comparison or a generic proof can establish a relation over many coordinates, while its implementation can perform many lower-level operations. G14a gives a compatible tree-edit model in which one round changes multiple disjoint addresses. Determining an operation rate requires its actual update contract and costs, not the name COMPARE.

### Influence and Agreement

**S20 (Agreement distance is not influence distance).** Suppose one cache contains k>1 records and another contains none. Transferring the first record already changes the receiver, while full agreement still requires the remaining records under the one-entry rule. Thus a k-round lower bound for full agreement does not imply that no influence can occur before round k. The previous locality argument proved a transformation bound and then used it as a first-influence bound.

A positive locality statement instead follows from actual input dependence. G14c models a whole whose internal components update only from specified input neighbors. The state at a component after n rounds factors through the corresponding initial dependency region. Two admitted initial whole states agreeing there give the same resulting answer. This is a conditional propagation bound, with every relevant controller and clock included in the state. Cache symmetric difference does not supply that dependency graph or convert its round count to physical duration. Under G14d's finite-dimensional nondegenerate symplectic-product hypotheses, local differential dependence across a cut into two complementary parts is mutual. The global independence statement also requires connected open factors.

### Selection of an Encoding

**S21 (Retention can affect preference).** Under a specified cost model and proposal policy, usable retained results may make one encoding preferable for subsequent tasks. Different acquisition histories can produce different preferences. Coverage alone neither chooses an encoding nor makes it uniquely cheapest, as IiI CS1–CS3 and Form FiG3 explain.

Calling this symmetry breaking requires an actual symmetry action, an invariant law and a state or observation whose symmetry changes. Equal untested status or the same number of cached entries supplies none of those relations. The encoding example therefore establishes a possible change of preference under its stated update and cost model, without deriving a physical symmetry-breaking mechanism.

### Cost Preferences

**S22 (Cost changes need a resource model).** A retained library can reduce acquisition work where its actual records answer the needed questions. Access, conversion, checking and maintenance have their own costs. If use of the cache is optional, an optimal policy can ignore it, so adding that option cannot worsen the optimal cost. An implemented policy can still spend more work. This is the bound already stated in IiI §1, not a force directing every encoding toward a large library.

Neither cache size nor its symmetric-difference distance specifies a curvature or an inverse-square interaction law. Such a connection would need a defined state space, update relation, measured response and invariant quantity, with equations connecting them to these resource costs. No such connection is derived here.

### Capacity and Questions

**S23 (An explicit slot trade-off).** Suppose two disjoint required feature sets need f_x and f_p separate slots, an encoding has F slots, and this model permits only retaining or omitting those features. If r_x and r_p are retained, with r_x+r_p≤F, define deficits δ_x=f_x−r_x and δ_p=f_p−r_p. Then δ_x+δ_p≥f_x+f_p−F by subtraction. This is the consequence of the stipulated slot model.

It gives no positive product bound: f_x=f_p=F=1 allows deficits 0 and 1, whose product is zero. Nor does it cover a representation that shares features, computes them from other retained data or encodes the required questions differently. Finite grammar alone therefore does not supply this slot contract, conjugate observables or wave-particle behavior. For exact question preservation, Verdict §6c instead asks whether both questions factor through the actual observation. Its joint-reading constructions express the positive case without identifying feature count with a physical uncertainty.

### Symmetry and Conservation

**S24 (A conserved question needs the update relation).** Let q be a question on the admitted whole states and T their declared update. Conservation of its answer means q(T(x))=q(x) for every admitted x. Invariance under representation changes instead means q(g(x))=q(x) for the specified transformations g. To infer conservation from that invariance, one sufficient premise is that each T(x) lies in x's transformation orbit. Substituting that transformation gives the conserved answer. Without a relation between T and those orbits, representation symmetry alone supplies no such conclusion.

The existing reading-factorization and transition constructions can express the actual equality square. A monotone cache size is not a conserved size, and a fixed vocabulary of possible structures is not by itself a physical energy observable. Finiteness of each represented tree also does not imply a finite total tree grammar or a fixed finite state space for the whole. This section does not derive a general Noether theorem from COMPARE invariance.

Matter §5's concentration family supplies a separate obstruction to using a conserved number as a bound on every physical question. Smooth divergence-free fields can have one fixed integral energy with unbounded pointwise size across the family. A bound on that size requires an additional controlling relation. This is the quantitative counterpart of S25's distinction between retaining an invariant reading and identifying the entire transported form.

### Resolution, Access and the Domain of a Limit

A proposed limit needs a particular question and a family of admitted preparations, contacts and records. Failure of one reader to distinguish sources does not exclude a richer internal experiment. Conversely, mathematical injectivity of a description does not supply a realizable decoder, as IiS18 shows. Apparatus, references and prior correlations remain inside the same whole.

The [Calmet–Graesser–Hsu argument](https://arxiv.org/html/hep-th/0505144) combines quantum localization, causality and a gravitational-collapse criterion based on the hoop conjecture. Its schematic requirement r≳max(ħc/E,GE/c⁴) has a minimum of order √(ħG/c³). The two terms respond oppositely to energy. Their product is ħG/c³, independent of E, with these order-of-magnitude conventions. This identifies a reciprocal relation to test across scales. It does not identify the two physical mechanisms. The obstruction is conditional on the specified resolving experiment, not an observed smallest spatial cell. The paper distinguishes resolving position eigenvalue spacing from measuring a small displacement. Extending its free-mass uncertainty calculation to every protocol requires accounting for preparation, correlations, measurement error and the causal participation of apparatus. No device-independent Planck limit is derived here from VI alone.

Nor is a black-hole horizon the same boundary. In the Schwarzschild model, [Tong, §6.1.2–§6.1.3](https://www.damtp.cam.ac.uk/user/tong/gr/gr.pdf), regular coordinates extend through the horizon, while outgoing signals from its interior cannot reach a receiver remaining outside. This is a causal-access relation between internal regions. It does not assert local disappearance of distinctions. Matter's tidal calculation separately shows that horizon tidal strength decreases with the hole's mass.

**A measured limit can depend on omitted correlations.** The ideal unsqueezed noise model in [Jia et al., Eq. (2)](https://arxiv.org/html/2404.14569v3) has S/h_SQL²=(K+1/K)/2≥1 for K>0. The inequality follows from (√K−1/√K)²≥0. Its joint-noise premise changes with squeezing. The reported Livingston quantum component reaches about 3 dB below SQL over part of 35–75 Hz. That component is inferred by model-based subtraction from total spectra, using common fits across squeeze angles and a classical-noise stability assessment. It is not the total raw noise lying below SQL. The published analysis, not an independent raw-data reduction, supplies this contact.

M32 and AC7 already state why separate summaries need not determine a joint response. Here the missing relation can change an attainable resolution. The useful search is therefore for a proposed forbidden experiment and the exact joint premise responsible for its refusal. A bound surviving all declared internal extensions is stronger than a bound optimized inside one apparatus family. Claiming the former requires establishing that coverage, rather than naming the latter fundamental.

LiR11–LiR12 now supply an exact test of this distinction. Finite lossless layer-transfer products cannot reach perfect reflection, with a quantitative lower bound on transmission. A finite side attachment to ideal leads permits a resonant transmission zero outside that product grammar. Eliminating its mode creates a divergent coefficient where the full equations have a finite solution. Restoring the mode preserves the predicted zero and explains why the earlier transfer premise fails. The hyperbolic geometry of reflection responses is also distinct from LiR §6b's hyperbolic optical path metric. Their common form must not identify their carriers or their boundaries.

## §10. Open Questions

1. **Dimension.** Which actual relations of access and distinguishability constrain an effective spatial dimension? Counting the two fields of PAIR and a depth coordinate does not establish three independent spatial dimensions.

2. **Time and interval.** Which actual comparisons establish the equal-interval relations and value assumptions used by S27? Its bisection criterion determines interval ratios in increasing real readings, while order with one calibrated unit still leaves those ratios open. S25 tests path agreement, and S26 exhibits the clock content omitted by light incidence within a conformal family. G14a's round count and G14c's dependency bound do not establish these physical comparisons.

3. **Dynamics and conserved answers.** Which concrete update relation makes a proposed observable satisfy S24's conservation equation? A measured resource cost and an invariant of dynamics need an explicit connection before they can represent the same quantity.

4. **Capacity and joint observation.** Which pairs of questions fail to factor jointly through a specified internal record, and what additional distinctions restore that factorization? S23's slot deficit is one restricted model, not a general physical uncertainty law.

5. **Shared records and correlations.** Existing common records can support the same later answer under the corresponding decoders. A newly acquired record in one component is not automatically present in another. Which actual preparations, observations and transition relations reproduce the desired correlations is the question. A composite type or a shared cache alone does not establish quantum entanglement.

6. **Resolution and physical scale.** A chosen observation can have a smallest represented distinction. What connects that resolution to a physical length or energy scale? The number of slots in one encoding does not identify a universal minimum scale across readers and realizations.

## §11. Dependency

| Source | Sections used |
|---|---|
| V=I | encoding-local identification, determinism and scope |
| IiI | CS1–CS3, retained coverage, dispatch and resource costs |
| PiR | M1–M4 operation clocks and complete traces, M11 finite record coverage, M16 conditional tower termination, M21 retaining updates |
| DiC | G14–G14c sequential edits, compatible rounds and actual input dependence, G14d reciprocity across a symplectic cut |
| Verdict | §6c exact question factorization, retained evidence and actual transition applications |

## Topics

### Related type declarations

- ``DistanceIsMetric``
- ``SpaceFromDifference``
- ``DepthIsBounded``
