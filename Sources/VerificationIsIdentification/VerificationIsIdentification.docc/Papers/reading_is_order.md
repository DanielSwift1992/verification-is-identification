# Reading Is Order (Dynamics)

A fixed structure can be traversed in different orders. Whether those orders give the same answer depends on the question, the reading operation and what the traversal preserves. This paper separates the representation of a reading position from the relations that make an answer independent of its schedule.

The grammar supplies a zipper and fold/unfold constructions. It does not choose the question or prove that every physical reading leaves its source unchanged. R3 states the conditions for an invariant answer. R4 excludes a proposed derivation of the discriminator from initiality. R5 gives a precise accumulation result and distinguishes the questions asked of a cyclic process.

## §0. Scope

Work in sets with `F(X) = 1 + X²`. Its initial algebra `Σ = μF` consists of finite ordered binary trees. Its final coalgebra `νF` consists of finite and infinite ordered binary trees. These are specified mathematical carriers. Finiteness of an individual tree does not make Σ a finite set, and the two carriers do not classify everything actual and everything possible in reality.

Existence Is Finite's distinction between a space and a process applies here: changing the candidate domain, predicate, available observations or stopping rule changes the problem. Fixing an encoding alone does not fix all these relations.

## §1. The Reading Position

**R1 (Two one-layer contexts).** Removing one child of a binary node leaves its sibling and the side of the hole. Thus `∂F(X) = 2X`. A position inside a finite tree retains a finite stack of such layers back to its root:

> `Zip(Σ) = Σ × (2 × Σ)*`.

The focus and stack reconstruct the whole tree by successively filling each hole. This is the binary instance of [Huet's zipper](https://gallium.inria.fr/~huet/PUBLIC/zip.pdf) and the one-hole interpretation developed by [McBride](https://citeseerx.ist.psu.edu/document?doi=7de4f6fddb11254d1fd5f8adfd67b6e0c9439eaa&repid=rep1&type=pdf).

The two context constructors do not imply exactly two possible actions. At an internal focus with a parent, down-left, down-right and up are three distinct available navigations. Descent requires a branch and ascent requires a nonempty context. Editing or stopping requires further specified operations. A recorded walk has an order, but this representation alone neither supplies physical duration nor proves that every agent is only a traversal policy.

## §2. Specified Generators and Readers

**R2 (Unfold and fold require their respective structures).** A coalgebra `c:A→FA` gives a unique unfolding `h:A→νF` satisfying `out ∘ h = Fh ∘ c`. An algebra `a:FB→B` gives a unique fold `k:Σ→B` satisfying `k ∘ in = a ∘ Fk`. The equations specify how observations or constructors are preserved. The standard recursion schemes are developed in [Meijer, Fokkinga and Paterson](https://maartenfokkinga.github.io/utwente/mmf91m.pdf).

A chosen algebra can express a structural answer. The constructor `in:FΣ→Σ` does not by itself select a predicate on trees. A claim that a particular discriminator is such a fold must provide its answer algebra and show agreement with the intended question. Likewise a proposed generator needs its coalgebra, not just the name unfold.

The canonical map `μF→νF` embeds finite trees while preserving their structure. It supplies neither a cost bound nor a division of all tasks into one inevitable discriminator and freely chosen generators. Reversing the direction of the structure map explains the algebra/coalgebra distinction. No adjunction between the proposed generator and discriminator is constructed here.

## §3. Which Answers Ignore Order

**R3 (Uniqueness within a fixed reading contract).** Finality equates two maps from the *same* coalgebra when both satisfy its homomorphism equation. To use this for two schedules, each schedule must first be shown to implement that coalgebra with the specified output interpretation. Fairness alone does not establish this premise.

For the finite verification case a direct argument suffices. Fix a finite candidate set C and a total predicate p whose answer for each candidate is unchanged by reading it. Every complete enumeration, retaining exactly the candidates with p(c)=true, gives the same survivor set S. Indeed, membership in S is exactly membership in C together with the fixed predicate answer, neither of which depends on enumeration order.

Selecting the first survivor can still depend on order. If both a and b pass, the complete orders (a,b) and (b,a) have different first survivors. A question q has the same answer under every selection from nonempty S exactly when q is constant on S. This is the answer-level criterion of Verdict Is Invariant. It does not require a unique candidate.

The schedule can change work and the time at which an answer becomes available. A reading that changes its source, obtains a new observation or changes its predicate falls outside the fixed contract. Outside that contract the order can change the answer itself. InI S2a gives a model in which the order of two acting observations enters their record, at leading order, through the commutator of their address operators. Neither the finite argument nor finality makes time globally inert.

Verdict VC92 and VC94a provide a constructive contrast. One resident phase
distinction permits a locally chosen path to the original answer; without
that access both constant actions remain in closed quiet orbits. The words
ab and aaab have the same working endpoint, but the latter needs an additional
order record to choose different actions at a repeated working state. Its
resident tape supplies that record and retains the consumed commands.
Irrelevance of order to a particular final answer does not make order freely
available to an executor, or identify the two complete execution histories.

## §4. Initiality Does Not Choose the Question

**R4 (Canonical map to a chosen algebra).** Initiality states `∀(B,a) ∃!k` with the fold equation. It does not state `∃!(B,a)`. Two algebras on B={0,1} show the missing implication even with the same leaf answer. Let both return 0 on a leaf. Let the first return 0 at every branch and the second return 1 at every branch. Each has its unique fold. On `node(leaf,leaf)` their answers are 0 and 1.

Thus neither the grammar nor its initiality chooses a discriminator. Finality also supplies a canonical carrier for fixed F while leaving many source coalgebras. There is no initial/free asymmetry establishing inevitable checking semantics on one side. Proposal Is Order GD3–GD4 separately distinguish coverage, dispatch and cost. Their premises cannot be replaced by uniqueness of a map after its algebra has been chosen.

This objection does not prevent relations from forcing an answer. It locates the required work: specify the relations that exclude the second algebra for this question. The generic existence of folds does not exclude it.

## §5. Accumulation and Cycles

**R5 (Fair accumulation under fixed finitary rules).** Start with a finite seed set D₀ and fixed inference rules, each with finitely many premises. Suppose D₀⊆D₁⊆… retains earlier facts and each stage adds finitely many conclusions of rule instances whose premises belong to the preceding stage. Require that every rule instance whose premises become available eventually has its conclusion added. Then `⋃ₙDₙ` is exactly the set of facts with finite derivations from D₀.

*Proof.* Every addition has a finite derivation, by induction over additions. Conversely, induct on a finite proof tree. Its finitely many premise proofs occur by some common finite stage. Retention keeps them available and fairness eventually adds their conclusion. Both inclusions follow. The union is therefore independent of the fair schedule under these rules. Basis Is Residue B8f's closure under finite products is one instance.

This gives no finite completion time for an infinite closure and no procedure recognizing that nothing remains. Finitary rules matter: take seed p₀, rules pᵢ→pᵢ₊₁, and an additional rule requiring every pᵢ to conclude r. The stages Dₙ={p₀,…,pₙ} never enable the last rule. Their union contains every pᵢ but omits r. Fairness on enabled rules alone does not repair this failure of closure.

Nor can every infinite tree be deposited as a finite tree with its full branching structure preserved. For `T=node(T,T)`, a shape-preserving image t in Σ would require `t=node(t,t)`, impossible for a finite tree. A finite observation or truncation answers a smaller question.

A cycle does not select least or greatest fixpoint semantics. On a single safe self-loop s with no goal, eventual goal reachability is the least fixpoint of `X↦X`, namely ∅. Indefinite safety is the greatest fixpoint of the same map, namely {s}. Both questions concern the same graph. Their different answers follow from their different obligations, not from the mere presence of a cycle.

## §6. Statement

1. A binary zipper retains a focus and its surrounding context. Two layer constructors do not exhaust its navigation actions (R1).
2. A coalgebra specifies unfolding and an algebra specifies folding. The grammar does not select either application (R2).
3. Fixed complete verification preserves the survivor set. A selected answer is invariant exactly when the question is constant over the survivors (R3).
4. Initiality determines a map to a chosen algebra. It does not make the choice of discriminator inevitable (R4).
5. Fair justified accumulation under fixed finitary rules has a common closure. Infinite behavior and cyclic questions require their own semantics (R5).

> **Order can vary without changing an answer when the preserved relations already determine that answer. Finding those relations is the proof obligation. A representation of traversal does not discharge it.**

## §7. Dependency and Representation

| Source | Used |
|---|---|
| Existence Is Finite | Finite tree grammar, the distinction between a space and a process |
| Verdict Is Invariant | An invariant answer need not identify the complete candidate |
| Proposal Is Order | Fixed verification versus acquisition, coverage versus dispatch and cost |
| Basis Is Residue B8f | Closure under finite products as a finitary accumulation instance |
| Huet, McBride | Zippers and one-hole contexts |
| Meijer, Fokkinga, Paterson | Fold/unfold equations for specified structures |

The `Reading` protocol retains historical time, order and revelation interfaces. Their intersection does not implement a zipper, a coalgebra law or a fairness proof. The mathematical arguments above state these separate conditions. Static applications can bind actual readings and their equal answers with `VerdictIsInvariant`, and actual source/image changes with `CommutingTransition`.

## Topics

### Related type declarations

- ``Reading``
