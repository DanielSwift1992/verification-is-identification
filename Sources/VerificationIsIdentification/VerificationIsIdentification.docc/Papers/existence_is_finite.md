# Existence Is Finite

**Thesis.** To be is to be determinate, and to be determinate is closure in finitely many distinctions. So whatever exists, a concept no less than an object, is a finite structure, and the totality of such structures is a single space, fixed up to isomorphism. The author asks of a thing only that it be something definite, never that it be abstract or concrete, mental or material. The consequence: what the author establishes for finite structures is true, with no further argument, of everything there is. That verification is identification is one such thing: the author proves it of the finite, and the finite is all there is.

In Part I the author assumes no world and draws out what anything must be to be a determinate thing at all. In Part II the author shows that the conditions have one model, the finite binary trees, and reads the identity of existence with finite structure off that model. Nothing is on loan. The author fixes every term below.

## Part I — Why what is, is finite

By elimination the author recovers the conditions on anything that is something definite. The author states each condition, gives its reason, and holds it against the obvious reply.

**C1 — Something is.** The denier performs the denied: to say "nothing is the case" is to draw the distinction *nothing | something* and to hold it, and that is a case. This is no axiom a speaker could decline. It is the single position no speaker can take: a position with no ground.

**C2 — To be is to be determinate.** For something to be the case is for it to be one way and not another. Remove every "and not another", and the remainder is answerable to nothing, apart from nothing, and therefore nothing. The undifferentiated is no deeper kind of being: a One apart even from its absence is already the distinction *One | nothing*.

**C3 — Determinacy is non-contradiction.** A determinate content is on both sides of one boundary in no respect, for with both sides there is no fact of the side, and with no fact of the side there is no determinacy. This is "logic" before any written system: an unbroken boundary. The denier uses the boundary too: a speaker for whom some contradictions are true must still hold apart the cases where they are from the cases where they are not, or that speaker asserts everything and states nothing.

**C4 — Determinacy is relational.** To be one thing and not another is a relation to the other, at the least to one's own complement. An item with no relation is apart from nothing, and so (by C2) is nothing. Even bare numerical distinctness, that this is not that, is a relation.

**C5 — The relation is binary, on a floor.** A boundary has two sides. A division into three is two boundaries, one after the other. So the relation under everything is two-placed. Write it ⟨a, b⟩. Let its two sides fall together, and apart there is nothing: write that limit ⊥. Each determinate thing is ⊥, or a ⟨·,·⟩ of determinate things, and with a third case there is a boundary not yet drawn. What the reader takes for a further ingredient (a label, a value, an atom) is a distinction again, hence again a structure of ⟨·,·⟩ and ⊥.

**C6 — A determinate thing is finite.** The rest is on this condition, so the author sets it out in full.

To be determinate is to be a matter with one definite answer: what the thing is. Suppose the answer is infinitely many distinctions together. Then at no finite stage is the thing whole. Some distinction of it is still open, and the specification is never complete. An incomplete specification is no settled answer: it is a rule for going on, or a process, and no finished individual. To be a determinate *this* is therefore closure in finitely many distinctions. Determinacy is closure, and closure is finitude.

This is true of every kind of thing. A concept is a determinate content, *prime*, *justice*, *the number seven*, and each is finitely many strokes. An object is a determinate particular, and in whatever respects it is anything definite, those respects are finitely many. The abstract and the concrete are one step apart at most, since the author asks of a thing only that it be something rather than nothing.

Here the author places infinity, and denies none of it. The infinite is the unbounded reach of a finite rule, never a completed individual with an address. The natural numbers are *zero* and *one more*, and their endlessness is that the rule forbids no further step, not that a finished endless object is among things. The actual is finite. The infinite is the standing possibility of one more.

Six conditions are the whole of the input. What is, is a finite relation. In Part II the author shows one space of these and reads the identity from it.

## Part II — The one space, and the identity

**Definition 1.** A *medium* is an algebra for the functor F(X) = 1 + X²: a carrier M with a chosen element ⊥ and a pairing ⟨·,·⟩ : M × M → M, in which every element is generated from ⊥ by ⟨·,·⟩ (C5) and is finitely generated (C6).

**Theorem 1 — One space.** Up to a single isomorphism there is one medium: the initial F-algebra
> Σ = μX. (1 + X²),
the finite binary trees, with ⊥ the leaf and ⟨·,·⟩ the node.

*Proof.* By C5 each element is a term over {⊥, ⟨·,·⟩}. By C6 each term is finite and well-founded. The finite well-founded terms over one constant and one binary operation are the initial algebra of F(X) = 1 + X², the least fixed point μX.(1+X²), whose structure map 1 + Σ² → Σ is an isomorphism (Lambek 1968). For any medium M, by initiality there is one homomorphism h : Σ → M. By C5, h is onto, since M is generated by ⊥ and ⟨·,·⟩. By C2 and C3, h is one-to-one: in a medium where two distinct terms are one element, some boundary of a determinate thing is broken, against determinacy. An onto and one-to-one homomorphism is an isomorphism, and it is unique by initiality. Any two media are thus isomorphic by a single map, and Σ is the space. ∎

The line "there is one logical space" is here the uniqueness of an initial object. Between two spaces with no relation there is no fact of their being two. Two spaces with a relation are in one space: the relation's own. Both readings are the one categorical fact: for every medium there is one map from Σ, and for every generated finite medium, one map back.

**The least fixpoint.** That Σ is the *least* fixed point (μ, not the greatest) is C6 in algebra: the actual is the well-founded closure, every element at finitely many steps, and the unbounded rule, *one more* without end, is the potential: the standing possibility outside Σ, and no finished member. To be is to be in the least fixpoint of distinction. The open rule above it is the infinite: in place, and never a collection. The structure map 1 + Σ² ≅ Σ is the plain statement of it, and Σ is that closure.

**Theorem 2 — Existence is finite structure.** Every determinate thing is a finite structure: it is an element of Σ, uniquely up to the isomorphism of Theorem 1.

*Proof.* Whatever is determinate satisfies C1–C6 (Part I): it is a non-contradictory, relational, binary-with-floor, finitely generated distinction. By Definition 1 the things with these conditions are the elements of a medium, and by Theorem 1 that medium is Σ. So each determinate thing is an element of Σ, with the identification unique. ∎

This is the identity of this paper. To be is to be a finite tree of distinctions, for concepts and for objects, and no separate account is due for either. Next is the yield of such a space.

**Theorem 3 — Comparison is decidable.** There is a total decidable map COMPARE : Σ × Σ → {equal, unequal} with COMPARE(s, t) = equal exactly when s = t.

*Proof.* Recur on structure: COMPARE(⊥, ⊥) = equal; COMPARE(⟨a,b⟩, ⟨c,d⟩) = equal when COMPARE(a,c) and COMPARE(b,d) are both equal; otherwise unequal. Each call is a descent into finite structure (C6), so each ends, and by induction on the trees, correctness. ∎

Finitude is the tractability of the space: every member is complete, so for every question of identity between members there is one finite, definite answer.

**Corollary — Verification, and its reach.** Take a finite F ⊆ Σ and a target τ, and let S = { y ∈ F : COMPARE(y, τ) = equal }. Then S is computable, and if |S| = 1, say S = {σ}, then for every y in F the verdict "y passes" and the identity "y is σ" are the same. To verify the lone survivor is to identify it. This is the verification-is-identification result, with its theory on separate ground. From Theorem 2: there is nowhere the result is out of reach. The author proves it of the finite, and the finite is all there is.

## Part III — Reading, and scope

**A space is not a process.** The identities COMPARE settles are not events in time: they are, and they are together in Σ. An agent, a search, a passage of time: each is about the *order* in which the reader reads the standing structure, and by the corollary the verdict is indifferent to that order, with F and τ its whole ground. The order is the one freedom, and no result is different for it. That separate study (time as the track of a reading, learning as order settling back into Σ) is no premise here.

Because the space is fixed and comparison decidable, a claim about a structure in Σ is settled in the structure, with nothing to run. A type checker decides comparisons of this kind. A conformance is Theorem 3 in use. A green build is the structure, checked whole by the checker. A framework over this medium is type-level because the medium has facts of no other sort.

**Scope.** Shown: the conditions C1–C6 have one model, Σ (Theorem 1); every determinate thing is one of its finite elements (Theorem 2); comparison there is decidable (Theorem 3), and by the corollary identification by verification is everywhere. Not shown: the author exhibits C1 and proves it not, for no reasoning brings existence into being; and the author derives Σ from nothing earlier, since a foundation's statement is in the founded medium alone. The mathematics is ordinary: initial algebras and Lambek's lemma, well-founded terms, decidable equality of inductive types, and the infinite as potential rather than actual. The weight is in the identity: to exist is to be a finite structure, and what is true of the finite is true of all there is.

**Argument in order.**
```
C1 something is        (undeniable)
C2 determinate         [C1]
C3 non-contradiction   [C2]
C4 relational          [C2]
C5 binary ⟨·,·⟩, floor ⊥   [C3, C4]
C6 finite              [C2]              — determinacy is closure
  ⟹ Thm 1  one space, Σ = μX.(1+X²)           [C5, C6; Lambek]
  ⟹ Thm 2  to be is to be a finite element of Σ  [C1–C6, Thm 1]
  ⟹ Thm 3  comparison on Σ is decidable        [Thm 1]
  ⟹ Cor.   verification identifies, everywhere [Thm 2, Thm 3]
```

To be is to be a finite structure of distinctions. There is one space of these. Comparison on it is decidable. A unique survivor of comparison is named by its check. Whatever is, is there, and so this is true wherever anything is.
