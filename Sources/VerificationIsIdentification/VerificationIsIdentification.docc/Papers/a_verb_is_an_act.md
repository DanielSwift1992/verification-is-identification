# A Verb Is an Act (Voice)

A record of a system is an encoding of its facts into sentences, and the reader receives the sentences alone. Here the author gives the facts a carrier and derives from it the grammar of a faithful record. The author's claim, pinned: the facts of a written system are a typed graph, a sentence is the image of one edge, an action verb is the image of an act edge, and the source of an act edge is an actor alone. So a verb on a structure is an edge its writer invented: a distinction of the image with no preimage in the world. The author first named the two claims in the lattice (`Voice.swift`). The current interfaces bind actual supplied readings. Their interpretation and graph obligations are stated below.

With this paper the author closes the encoding axis from its second side. In Seeing Is Encoding the author named the first wrong, an image too poor: a distinction the law drops. The dual wrong is an image too rich: a distinction the law invents. A record is faithful exactly between the two, and prose about a system is a record like any other.

## §0. Derivation

The cited papers motivate a model of written system descriptions. Definition 1 supplies the allowed edge types. Those choices are premises of this writing model, not a derivation of the possible relations in every physical or logical medium. From Existence Is Finite: the vertices, each a finite structure. From Dynamics Is Substitution: the act, one rule that one actor applies, and the laws, presented, that admit and refuse. From Program Is Path: the pedigree and the paragraph, each a path. From Seeing Is Encoding: the record, an encoding, judged by the reader through its image alone. From Distance Is Cost: the count of steps as a distance.

## §1. Definitions

**Definition 1 (the world).** The world W of a written system is a typed graph. The vertex sorts are three: structures, laws, actors. The edge sorts are three, each with a label. An identity edge is between structures, and its label is sameness, membership, or composition. An act edge is from an actor to a patient, and its label is one operation of that actor's contract. A firing edge is from a law to a patient, and its label is the binding of the firing. The typing of W is a presented law whose contract is admission: for each edge sort, one source sort. The actor vertices are one rooted tree: the root is you, the human vertices are your roles (the author at the writing hand, the reader at the page), and the machine vertices are executors under contracts that you invoke.

**Definition 2 (the record).** A record E is a presented law from the edges of W to sentences. Under E, the image of the source is the subject, the image of the label is the verb, and the image of the patient is the object.

**Definition 3 (the reading).** The reading R is the reader's map from sentences back to edges: from the subject a source, from the verb a sort and a label, from the object a patient.

**Definition 4 (faithfulness).** A record E with its declared reader R is faithful for source recovery when R∘E is the identity on W. A structurally faithful record of Definition 1's graph additionally preserves vertex sorts, edge labels and incidence, with no extra readable vertices or edges in its presented image. Recovery and structural faithfulness are separate requirements. A reversible change of labels can satisfy the recovery equation through its inverse reader without preserving the declared labels. The claims about verb grammar below concern structural faithfulness.

**Definition 5 (the defect count).** The defect count of a record is the number of its sentences with no edge behind them plus the number of its action verbs with no actor at the verb. A structurally faithful record has defect count zero. Zero by this count alone does not establish source coverage or the correctness of a declared reader.

## §2. The source lemma

**Lemma (sources).** For an act edge the typing admits an actor source alone, for a firing edge a law source alone, and for a structure source the typing admits identity alone.

*Proof.* The lemma is one line of the admission contract of Definition 1, and the author reads that contract by source sort. An act edge's label is an operation of its source's contract, and among the sorts a contract of operations is the actors' alone. A firing edge's label is a binding, and a binding is of a presented law alone. The third edge sort is identity, and identity is between structures by its definition. ∎

A structure is a source of sameness and of nothing else.

## §3. Theorems

**Theorem 1 (the copula is the structure's one verb in this grammar).** In a structurally faithful record of Definition 1's graph, the verb with a structure's image at the subject is the copula, under Definition 2's encoding of identity labels.

*Proof.* By the source lemma, the one edge sort at a structure source is identity. By Definition 2 the verb is the image of the label, and the labels of identity are sameness, membership, and composition: each is a form of is. Identification is sameness, read back by the reader (V=I), so the copula is its sentence form. ∎

**Theorem 2 (structural faithfulness gives an isomorphism onto the presented image).** Suppose E and its declared reader satisfy Definition 4's recovery equation. Then E is a structurally faithful record exactly when it preserves sorts, labels and incidence and its presented image contains exactly the transported vertices and edges of W.

*Proof.* The recovery equation makes E injective on vertices and edges. Preservation gives a typed graph map. The image condition makes it surjective onto the presented graph, so its restriction is an isomorphism whose inverse is R on that graph. Conversely, an isomorphism with this declared inverse preserves the sorts, labels and incidence and leaves no additional presented vertex or edge. Both the recovery equation and these structural conditions are premises of this characterization. Sort and label preservation alone does not establish that a particular reader recovers the source. ∎

**Theorem 3 (faithful links give faithful composition).** Write the encodings as E₁:W→V and E₂:V→U, with their declared readers R₁:V→W and R₂:U→V. Under Definition 4's source-recovery criterion, faithfulness of both links implies faithfulness of the composite encoding E₂∘E₁ with reader R₁∘R₂. Composite faithfulness alone does not imply faithfulness of either declared link. Structural preservation also composes when supplied for both encodings.

*Proof.* The two local equations give R₁∘R₂∘E₂∘E₁=R₁∘id_V∘E₁=id_W. For the converse, let all three carriers contain the same two distinguishable labels. Let both encoders exchange those labels, and let both declared readers be the identity. Each local round trip exchanges the labels and fails Definition 4. The complete round trip exchanges them twice and is the identity. Its correct endpoint therefore does not certify either intermediate reading. These are explicit maps within one description, with no external corrective oracle. ∎

An actual merger has a stronger obstruction. If E₁(x)=E₁(y), any decoder after E₂ receives the same input for x and y. It cannot recover different original answers q(x) and q(y). Exact recovery of the whole source therefore forces E₁ to be injective and E₂ to be injective on E₁(W). It does not require E₂ to be injective on unreachable parts of V, or establish that the declared local readers are correct. These are the source and question restrictions of Verdict VC15 applied to a chain.

The former converse confused losing a required distinction with translating it incorrectly. Two wrong translations can cancel. A distinction already merged cannot be recovered by later processing of that merged image alone. A separate source contact or retained record changes the available evidence and must enter the chain explicitly. For a task asking only the final question, an adequate endpoint proof is sufficient. Claims about intermediate outputs or reuse require those questions to be covered. The existing swap readings and identity readers give the counterexample in `Checks/ClosedInformation.swift`.

The example also gives a concrete revision failure. Replace only E₁ by the identity. Its local reader now recovers its input correctly, but the unchanged E₂ still exchanges the labels. The complete result is now exchanged. Improving one local round trip does not preserve the old endpoint certificate when that certificate depended on compensation elsewhere. Transporting the certificate requires a proof about the revised composition, as in Seam SG2–SG3. This does not require certifying every possible use of the whole system.

The proposed two failures are an image with unsupported distinctions and a record missing required distinctions. ``EncodingInvents`` binds two supplied readings to one represented source and binds its image fields to their actual answers. It does not require unequal answers, establish a deterministic response law or prove an unsupported edge in Definition 1's world. SaltedSeeing exposes its salt as a construction parameter. Different images alone do not exclude a relevant preparation distinction in the whole.

``FaithfulEncoding`` now requires the identity target in ``ReadingFactors``: the decoder of the actual observation returns its original source. This checks recovery for the supplied reading. Coverage and correct constructors are required for a full source family. Preservation of graph sorts, labels and incidence remains separate, as Definition 4 requires.

## §4. Properties of the sentence

**P1 (four forms).** The faithful sentence forms of a structure are the images of the four admitted shapes: the copula for an identity edge, the passive for an act edge (the reader reads the edge from its patient side, with the actor at the verb), the prepositional for a composition identity, and the existential for a vertex alone. And the typing admits a fifth shape for no structure.

**P2 (a pose is an invented loop).** Among the edge sorts of W there is no duration: states are vertices, and time is in acts and firings alone. A pose is a loop on a structure vertex with a duration label, so with a pose the writer invents. The reader's test is substitution: the reader replaces the pose with the copula and reads back. When the two readings are equal, the reader identifies an addition of nothing, and an addition of nothing is the phantom.

**P3 (the typing refuses a will of a thing).** A will of a thing is an act edge with a structure at the source. By the source lemma there is no such edge in W, so in a faithful image there is none either.

**P4 (an event is a firing).** A physical event is a firing edge, and its faithful images are three: the edge as a noun, the law at the subject, and the patient's passive with the firing at the verb.

**P5 (the agentless passive fails identification).** A passive whose label the writer cut is the forgetting image in one sentence: the act is real, and the reader returns it without its actor. At that verb the reader's candidate set of agents is larger than one, so the read is no identification (V=I). The passive's licence is the named agent, and nothing less.

## §5. Properties of the discourse

**P6 (a paragraph is a path's image).** A paragraph is the image of a path in W. An anaphor is a second name for one vertex, and it is faithful when the reader's candidate set for that vertex is one. A connective is the image of one step: so and because are the images of steps of a derivation. A gap in the image is an edge the reader invents to close the path: the writer's break, and the reader's phantom. A paragraph is faithful when its preimage is one connected path.

**P7 (an instrument is a law).** An instrument is a presented law, and an instrument's verbs are a law's contract: admits, keeps, drops. A sentence with an instrument at the subject and a contract verb at the verb is the image of a firing, and it is faithful.

**P8 (an attributive participle is a folded edge).** A participle before a noun is one edge the writer folded to a mark. The reader unfolds it into a sentence and reads back: the participle is faithful when the actor of the unfolded sentence is one. A participle the reader cannot unfold to a named actor is the agentless passive, folded once more.

**P9 (an imperative is a presented act).** An imperative is no image of a fact: it is a rule the writer presents with the reader at the actor's place. Its faithfulness is a presentation's: the writer states the rule whole, and the reader's act is its firing.

**P10 (modality is a law's image).** Can is the image of admits, cannot is the image of refuses, and must is the image of the one admitted. A modal sentence is faithful when its law is in W, with its name on the page.

**P11 (a reason is a path).** A because-sentence is the image of a derivation path. It is faithful when that path is in W, and with no path the writer invents an edge between facts.

## §6. The audit is a rewriting

The reader's audit of a record is a rewriting: the reader finds a defective sentence and replaces it with the image of an admitted shape. With each replacement the reader removes one defect and introduces none, because the replacement is an admitted image by construction. So the reader lowers the defect count by at least one per step, the count is finite by Definition 5, and the audit ends at zero. The end is not one record: two faithful records of one world are distinct images of the same facts, so the audit is confluent up to the equivalence of faithful records, and the space of faithful records of one world is one more structure. The defect count is a distance: the record's distance from faithfulness, measured by the reader in replacements, one step one defect (Distance Is Cost).

## §7. Statement

A verb is an act. The world of a written system is a typed graph with one human root. The typing admits identity from structures, acts from actors, firings from laws, and a fourth sort from nothing. A structurally faithful record preserves sorts, labels and incidence, permits recovery by its declared reader, and presents exactly the transported source graph. Such a record is an isomorphism onto that image. Faithfulness of every link is sufficient for a faithful composite. A correct endpoint alone does not certify the intermediate records or their declared readers. The reader's audit is a rewriting, its defect count is the record's distance from faithfulness, and the reader lowers that distance to zero in finitely many replacements. In a faithful record every verb is the image of an act, at every such verb the actor is present, every pedigree is a path to you, and the reader's read of the record is identification of the world and nothing else.

## Scope

Claimed: the five definitions, the source lemma, the three theorems, the five sentence properties, the six discourse properties, and the audit with its measure. Not claimed: the thesis line of a paper (there a concept may be a subject by design), the author's first-person speech, and natural language at large. The English glosses of this law are in the house canon, and the canon is not this paper.

## §8. Dependency

| Source | Used |
|---|---|
| Existence Is Finite | the vertices: each fact's terms are finite structures |
| Dynamics Is Substitution | the act edge: one rule, one actor, under laws that admit and refuse |
| Program Is Path | the pedigree and the paragraph as paths |
| Seeing Is Encoding | the record as an encoding, and the forgetting image, whose dual is here |
| Distance Is Cost | the defect count as the record's distance from faithfulness |
| V=I | the reader's read of a record as identification |

The author pinned the two claims in the lattice before stating them in prose. This document exists so the voice of a record is one in prose and in types.

## Topics

### Related type declarations

- ``FaithfulEncoding``
