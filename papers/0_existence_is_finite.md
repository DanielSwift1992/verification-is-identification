# Existence Is Finite

**Thesis.** To be is to be determinate, and to be determinate is to be settled by finitely many distinctions. So whatever exists — a concept no less than an object — is a finite structure, and the totality of such structures is a single space, fixed up to isomorphism. The argument asks of a thing only that it be something definite, never that it be abstract or concrete, mental or material. Its consequence is that anything established for finite structures holds, with no further argument, of everything there is. That verification is identification is one such thing: proved of the finite, it owes no separate defence of its reach, because nothing is not finite.

Part I is a transcendental argument — it assumes no world, and draws out what anything must be to be a determinate thing at all. Part II is mathematics — the conditions are shown to have one model, the finite binary trees, and the identity of existence with finite structure is read off it. Nothing is borrowed; every term is fixed below.

## Part I — Why what is, is finite

By elimination we recover the conditions on anything that is something definite. Each is stated, given its reason, and held against the obvious reply.

**C1 — Something is.** The denial performs what it denies: to say "nothing is the case" is to draw the distinction *nothing | something* and hold it, which is a case. This is no axiom one could decline, but the single position that cannot be taken — that there is nothing to take a position on.

**C2 — To be is to be determinate.** For something to be the case is for it to be one way and not another. Remove every "and not another" and what remains answers to nothing, stands apart from nothing, and is therefore nothing. The undifferentiated is no deeper kind of being; a One set off even from its own absence already carries the distinction *One | nothing*.

**C3 — Determinacy is non-contradiction.** A determinate content does not lie on both sides of one boundary in the same respect, for then there would be no fact which side it lay on, and it would not be determinate. This is what "logic" means before any system is written down: a boundary that holds. Its denial uses it — a view on which some contradictions are true must still hold apart the cases where they are from the cases where they are not, or it asserts everything and states nothing.

**C4 — Determinacy is relational.** To be one thing and not another is to stand against what one is not, and that standing-against is a relation, at the least to one's own complement. An item bearing no relation is set off from nothing, and so (by C2) is nothing. Even bare numerical distinctness — that this is not that — is a relation.

**C5 — The relation is binary, on a floor.** A boundary has two sides; a division into three is two boundaries drawn in turn; so the relation that builds everything is two-placed. Write it ⟨a, b⟩. Let its two sides fall together and it holds nothing apart: write that limit ⊥. Each determinate thing is ⊥, or a ⟨·,·⟩ of determinate things, with no third case — a thing built otherwise would carry a boundary not yet drawn. What looks like a further ingredient — a label, a value, an atom — is itself a distinction, hence again a structure of ⟨·,·⟩ and ⊥.

**C6 — A determinate thing is finite.** The rest depends on this, so I set it out in full.

To be determinate is to be a settled matter: there is a definite answer to what the thing is. Suppose the answer demanded infinitely many distinctions holding together. Then at no finite stage is the thing wholly fixed; some distinction constituting it is always still open; the specification never closes. A specification that never closes returns no settled answer — it is a rule for going on, or a process, not a finished individual. To be a determinate *this* is therefore to be fixed by finitely many distinctions. Determinacy is closure, and closure is finitude.

This holds whatever the kind of thing. A concept is a determinate content — *prime*, *justice*, *the number seven* — and is given in finitely many strokes. An object is a determinate particular and is, in whatever respects it is anything definite, settled in finitely many. The abstract and the concrete are reached by one step, since the step asks of a thing only that it be something rather than nothing.

Infinity is not denied here, but placed. It is the unbounded reach of a finite rule, never a completed individual to be pointed at. The natural numbers are given by *zero* and *one more*; their endlessness is that the rule forbids no further step, not that a finished endless object stands among things. The actual is finite; the infinite is the standing possibility of one more.

Six conditions are the whole of the input. What is, is a finite relation that holds. Part II shows there is one space of these, and reads the identity from it.

## Part II — The one space, and the identity

**Definition 1.** A *medium* is an algebra for the functor F(X) = 1 + X²: a carrier M with a chosen element ⊥ and a pairing ⟨·,·⟩ : M × M → M, in which every element is generated from ⊥ by ⟨·,·⟩ (C5) and is finitely generated (C6).

**Theorem 1 — One space.** Up to a single isomorphism there is one medium: the initial F-algebra
> Σ = μX. (1 + X²),
the finite binary trees, with ⊥ the leaf and ⟨·,·⟩ the node.

*Proof.* By C5 each element is a term over {⊥, ⟨·,·⟩}; by C6 each term is finite and well-founded. The finite well-founded terms over one constant and one binary operation form the initial algebra of F(X) = 1 + X² — the least fixed point μX.(1+X²) — whose structure map 1 + Σ² → Σ is an isomorphism (Lambek 1968). For any medium M, initiality gives one homomorphism h : Σ → M. C5 makes h onto, since M is generated by ⊥ and ⟨·,·⟩. C2–C3 make h one-to-one, since a medium that identified two distinct terms would dissolve a boundary that holds, against determinacy. An onto and one-to-one homomorphism is an isomorphism, and it is unique by initiality. Any two media are thus isomorphic by a single map, and Σ is the space. ∎

The line "there is one logical space" is here the uniqueness of an initial object. Two spaces with no relation between them have no fact of their being two; two with a relation share the space the relation lives in. Both readings are the one categorical fact: every medium receives the unique map from Σ, and every generated, finite one returns it.

**Theorem 2 — Existence is finite structure.** Every determinate thing is a finite structure: it is an element of Σ, uniquely up to the isomorphism of Theorem 1.

*Proof.* Whatever is determinate satisfies C1–C6 (Part I): it is a non-contradictory, relational, binary-with-floor, finitely generated distinction. By Definition 1 the things satisfying these are the elements of a medium, and by Theorem 1 that medium is Σ. So each determinate thing is an element of Σ, with the identification unique. ∎

This is the identity the paper carries. To be is to be a finite tree of distinctions — for concepts and for objects, with no separate account owed for either. What remains is what such a space allows.

**Theorem 3 — Comparison is decidable.** There is a total decidable map COMPARE : Σ × Σ → {equal, unequal} with COMPARE(s, t) = equal exactly when s = t.

*Proof.* Recur on structure: COMPARE(⊥, ⊥) = equal; COMPARE(⟨a,b⟩, ⟨c,d⟩) = equal when COMPARE(a,c) and COMPARE(b,d) are both equal; otherwise unequal. Each call descends finite structure (C6), so it halts, and induction on the trees gives correctness. ∎

Finitude is what makes the space tractable: because every member closes, every question of identity between members has a finite, definite answer.

**Corollary — Verification, and its reach.** Take a finite F ⊆ Σ and a target τ, and let S = { y ∈ F : COMPARE(y, τ) = equal }. Then S is computable, and if |S| = 1, say S = {σ}, then for every y in F the verdict "y passes" and the identity "y is σ" are the same. To verify the lone survivor is to identify it. This is the verification-is-identification result, whose theory is built on its own ground; what Theorem 2 adds is that there is nowhere it fails to apply. It is proved of the finite, and nothing is not finite.

## Part III — Reading, and scope

**A space is not a process.** The identities COMPARE settles do not come true in time; they hold, and Σ holds them together. Talk of an agent, a search, a passage of time concerns the *order* in which the standing structure is read — and the corollary shows the verdict is indifferent to that order, fixed by F and τ alone. The order is the one thing left free, and it alters no result. Working it out — time as the track reading leaves, learning as the settling of order back into Σ — is a separate study, not relied on here.

Because the space is fixed and comparison decidable, a claim about a structure in Σ is settled by the structure, not by running anything. A type checker decides comparisons of this kind; a conformance is Theorem 3 in use; a green build is the structure holding. A framework over this medium is type-level because the medium has facts of no other sort.

**Scope.** Shown: the conditions C1–C6 have one model, Σ (Theorem 1); every determinate thing is one of its finite elements (Theorem 2); comparison there is decidable (Theorem 3), so identification by verification reaches whatever is (Corollary). Not shown: C1 is exhibited, not proved, for existence cannot be reasoned into being; and Σ is not derived from anything earlier, since a foundation can be stated only in the medium it founds. The mathematics is ordinary — initial algebras and Lambek's lemma, well-founded terms, decidable equality of inductive types, and the treatment of the infinite as potential rather than actual. The weight is carried by the identity: to exist is to be a finite structure, and what holds of the finite holds of all there is.

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

To be is to be a finite structure of distinctions. There is one space of these; comparison on it is decidable; and a unique survivor of comparison is named by the act that checks it. Whatever is, is there, so this holds wherever anything holds.
