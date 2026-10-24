# Does a cover preserve the whole law?

This question uses the U3 carrier of VI §1c: a finite nonempty product Source, opaque nonempty sorts and a finite set E of same-sort source-occurrence equalities. X_E contains all fillings satisfying E, without hidden additional restrictions. It asks whether X_E equals the join of its domain projections under every interpretation of those sorts. This is the §12 question in U3 with E; it does not settle the physical LG28d transition or provide an act.

## One declared whole and its cuts

The same ContinuationCourt.Context, ReadProof and RouteProof that interpret the continuation question interpret this question. No ApplicationCourt role pass, second lexer, value getter or imported authoritative graph is used.

The request needs Source and Coverage. Equalities is the optional paired tree of endpoints already used by continuation-relations-v1; its absence means E is empty. Each family leaf names a field of this request holding a source-rooted cut. Paired combines two family branches. Within the cut field, Paired combines visible source places instead. The field reference is the explicit domain boundary, not a type-name classification. Source itself can name the whole cut. A request field reached from Coverage is one domain even when its body pairs other cut fields; write family branches with Paired at family level or with an alias outside the request (UnionAlias and NestedFamily).

    enum Cover<S: Structure> {
        typealias Source = Paired<S, Paired<S, S>>
        typealias Equalities = Paired<
            Paired<Source.Left, Source.Right.Left>,
            Paired<Source.Right.Left, Source.Right.Right>
        >
        typealias First = Paired<Source.Left, Source.Right.Left>
        typealias Second = Paired<Source.Right.Left, Source.Right.Right>
        typealias Coverage = Paired<First, Second>
    }

RouteProof in family mode ends at each referenced cut field and uses its child in the existing cut mode. Both modes share the same declaration expansion, argument guards and Source anchor. A family is not inferred by splitting a cut's output pair: Coverage = Paired<Source.Left, Source.Right> lacks the explicit cut-field boundaries. Declare those cuts as First and Second as above. Rooted aliases use the same live definition replay. An unrelated type, unread axis, changed endpoint or foreign whole is unresolved. Every written type axis must occur in the validated read proof. Missing coverage of a Source leaf is outside this question, even when an omitted independent leaf would not change the mathematical equality R = J.

The shared WholeReading supplies the source shape, occurrence sorts and addressed E-edges to both this question and U5. It does not require fictitious Observation/Question fields for the cover question. The common reader's full admission remains debt T0084/T0083.

## Criterion and certificates

For an E-class K, intersect K with each domain support. Put a local edge between any two places in one such intersection. A domain inherits the restriction of the complete E-equivalence, including paths outside that domain. The local graph must connect every K. WholeLawCover.swift builds these graphs with stars, not all pairs or payload fillings.

Indeed, a domain projection consists exactly of fillings constant on every E-class intersection: extend a local value to its whole E-class, and choose any element of each nonempty omitted class. Thus the join is exactly the fillings constant on the local graph components. If every K is locally connected, these are precisely X_E.

If some K is disconnected, a local component S is a nonempty proper subset of K, no domain splits S within K, and some E-edge crosses S. Interpret that sort with two values and set x to 1 on S, 0 elsewhere. Other sorts may be singletons. The crossing edge proves x is outside X_E. For each domain d, let y_d make all of K 1 iff d meets S and every other E-class 0. It belongs to X_E and restricts to x on d. Hence x lies in the join but not X_E. No filling enumeration is used.

For a **fixed interpretation** alpha, R_alpha = J_alpha holds exactly when every E-class with a disconnected local graph has a singleton sort. The countermodel applies in any interpretation with at least two values of its selected sort: choose two distinct values there and one value on each other E-class. The command answers the universal question and does not claim that the actual opaque payload has two values or that the countermodel is physically prepared.

The certificate first gives a sort-respecting partition of all source leaves. Every E-edge stays inside a block. An ordered E-forest attaches every later leaf of each block to a previously justified member by an addressed E-edge. Closure proves no E-class is split; the forest proves no distinct E-classes were merged. These common checks are shared with the exact-residue proof in continuation-relations-v1.

A holds certificate adds one ordered local tree per exact E-class. Each link attaches one new member, names a declared domain occurrence, and has both ends in that domain. The exact E-partition already proves its equality ground. A refused certificate names K, S as source addresses and a crossing E-edge. Replay explicitly checks S is a subset of K, contains no duplicate address, is nonempty and proper, and no declared domain splits it. These fields define x and the local extensions above, rather than asserting unexplained membership.

Replay checks live-source read derivations, every finite forest/link and the closed cut. It never calls a component constructor, derive or equivalence closure. A changed or omitted input domain cannot be accepted against the old family proof. Construction and independent replay use the same interpretation; constructing a certificate does not bypass replay.

## Commands and boundaries

    Tools judge cover-law --certificate proof.json Cover \
      Sources/VerificationIsIdentification/Primitive.swift cover.swift
    Tools judge replay-cover-law proof.json Cover \
      Sources/VerificationIsIdentification/Primitive.swift cover.swift

Both print the canonical archive with question whole-law-cover, format 1. This distinct archive contains the family and local trees/countermodel, which continuation's program and missing-question certificate do not express. It does not reinterpret the existing formats or judge coverage (FiniteCoverageCourt's candidate-tree question).

Exit 0 means universal holds; exit 1 means a verified countermodel to that universal claim, with its archive; exit 2 means unresolved input, malformed certificate, outside-question coverage or a resource boundary. It is not a proof of lost law. The source/route depth and replay-node budgets are those of ContinuationCourt; this question additionally bounds the source and family to 10,000 leaves each, 100,000 domain-leaf occurrences and 8 MB per encoded or decoded archive. An oversized output gives exit 2, “output limit; no obstruction inferred”, before any archive is written; it does not establish a countermodel. Budgets are engineering limits, not mathematical obstructions.

Only equalities on a finite product are admitted. A general admission predicate can contain constraints invisible to these equality graphs; even decidable predicates on two places with an infinite carrier do not give a total decision method for R = J. On effectively enumerable carriers and decidable R, a lost-law witness x and its finitely many local extensions can be found by enumeration; the general obstruction is to a complete effective acceptance method. This command does not implement that enumeration. For R presented as a conjunction of constraints, assigning each constraint to a domain containing its support is a sufficient finite preservation certificate: local extension satisfies that constraint, so every join member satisfies the conjunction. It is not necessary, and no such additional calculus is admitted by this version.

The named contract is data in contract.json, bound to cases.swift by SHA-256. WholeLawCoverTests constructs and replays it with the real Primitive.swift and exercises forged edges/partitions/local trees/countermodels, omitted domains and changed live definitions. These are regression observations, not proof by a finite sample. The rules above justify the conditional judgment; correctness of the shared reader/replayer and its implementation is still a named premise. Arbitrary Swift bodies, physical establishment of E, general relation entailment and Rust/wasm parity are not certified.
