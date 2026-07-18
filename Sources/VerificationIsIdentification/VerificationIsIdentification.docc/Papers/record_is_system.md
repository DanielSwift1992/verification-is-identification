# Record Is System (Software)

Permanence Is Resistance §5 projects the framework onto physical systems, and The Architecture of Learning Machines projects it onto learners. This document is the same move applied to the software artifact itself: the thing a team builds, describes, proves, and audits. The **record** is the source text: what is written down. The **system** is what is true once the build runs. The claim, within the framework's scope (the determinate part of a system, written as pure types, Law §0′), is that the two are one object: the record *is* the system, its proof is the build's verdict on it, and its documentation, reports, and audit are readings of it, re-derived at every build. Practice keeps four artifacts and pays to hold them in step. The projection derives that, over the pure part, there is exactly one artifact and nothing to hold in step.

The evidence base is concrete: the repository around this paper. Its showcase is a whole organization (people, roles, documents, access policy, review cycles) written as pure types, and every page of the resulting site, every access verdict, every audit figure is read off those types at build time. After a policy edit, the next build re-derives two hundred pages, with no step where a description could lag the system it describes.

## §0. The Projection Basis

No new postulate. The author reads the coordinates off the theory:

| Element | Source | Role in the artifact |
|---|---|---|
| **medium** (pure types, nothing runs) | Law §0′ | the record is a position in Σ, a standing finite structure |
| **gate** (the compiler) | V=I §2.5, PP15 | the given COMPARE: decidable, borrowed, certified by no game here |
| **move** (expand / compress) | Law §1 | the write, the only way the record changes |
| **reading** (projection + COMPARE) | V=I §5.20–5.21 | docs, reports, audit: facts revealed, never created |
| **order** (the build schedule) | V=I §5.25 | free, and it changes no verdict |

A software practice is located by which of its artifacts are the record and which are second encodings kept beside it. The theorems are then in force conditionally, the same way PiR §5 reads I1–I3 on ice and the Architecture paper reads the six coordinates on a learner.

## §1. Two Verbs Exhaust the Practice

**SW1 (Every act is a write or a reading).** On a pure-Σ artifact, every act available to practice either changes the record or leaves it unchanged. If it changes the record, it is a move, and there are two, expand or compress (Law §1: there is no third). If it leaves the record unchanged, its result is determined by the standing structure before the act (V=I §5.20: revelation, not creation): it is a reading. Running is not a third verb: §0′ leaves nothing to run.

*Proof.* Law §0′ excludes execution from the medium, so acts partition by whether they alter Σ. Alterations are protocol writes, and Law §1 enumerates the moves. Non-alterations produce output from fixed input. By §5.20–5.21 that output is a pre-existing structural fact made explicit. QED. **[solid]**

The verbs of practice map accordingly: *implement* = write. *Build* = the referee's verdict on the position (Play Is Proof). *Document*, *report*, *audit* = read. *Review* = read the record against the law. *Test*, over the pure part, names nothing left to do: §4 says this precisely.

## §2. The Four Artifacts Are One Record

**SW2 (Proof, documentation, and audit are projections).** Practice maintains four artifacts: the source, the proof, the documentation, the audit trail. Over the pure part they are one structure under four readings:

- **The proof is the build.** A position that compiles is a true one (V=I Theorem 2 through the conformance gate, Play Is Proof PP10). The theorem is in no second artifact: correctness is the record's own shape.
- **The documentation is a reading.** A page is the rendered name of a type, and the site is the type graph, walked. Two pages are equal exactly when their types are: checking a page *is* identifying its type, V=I on the surface. **[solid]**
- **The audit is a reading of verdicts.** Which access is in force, which invariant is intact, which count settles: each is a conformance fact, read where it is pinned. The access matrix cannot disagree with the policy, because it is the policy, read.
- **The source is the record**: the only member of the four that is written rather than read.

*Instance.* `Login<Who, Entered>: Authorized where Who.Pass == Entered`: verifying the password *is* identifying the person, one `where`, and authentication lands as Theorem 2's collapse to \|S\| = 1. The whole showcase is on the same shape. **[solid]**

## §3. Drift Has No Second Frame

**SW3 (A reading cannot drift, only a second encoding can).** The first case of Difference Is Distance is the one-agent case: a single encoding has no second frame, so no distance exists to be nonzero (DiD §0, S1). Drift between "the code" and "its documentation" is the distance between two caches (S7): it requires two encodings of the system, separately maintained. A reading is not a second encoding: it is re-derived from the record at every build and stores nothing of its own. So over the pure part, drift is structurally absent: the second point of the distance is gone, and the sync cost with it.

Where practice authors a description *beside* the system (the hand-written wiki, the spreadsheet copy of the policy), DiD says exactly what follows: a second encoding opens a distance, holding it near zero is a translation game (S9), and the game is paid for as long as both encodings exist. The projection turns "documentation rots" from a lament into a theorem with a removable premise. **[solid]**

## §4. A Test Estimates, a Compile Identifies

**SW4 (The two labels).** A runtime test samples the reach: finitely many inputs through an executable, and the label is the observed outcome on the points sampled, an estimate of membership, with no word off-sample. A type-level claim compiles or it does not: the label is the survivor itself (Theorem 2, \|S\| = 1). This is PP7's contrast (proof-label against estimate-label), read on the toolchain rather than on self-play. Over the claims the notation carries, the build has already decided every one of them, and a test after a green build re-checks a theorem at selected points. Over everything else (the encoding's fit to the world, performance, the impure remainder) tests keep their full standing: they are the instrument of the part where the guarantee stops (E2 §5). **[solid** for the contrast, and the boundary placement per system is the encoder's affair, E2**]**

## §5. Trust Crystallizes by Region

**SW5 (The typed region is crystal, and adoption is a front).** One part of a system written in the notation is decided: a wrong version does not build. The part beside it is still craft. Learning Is Liquid names this configuration (crystal behind a front, liquid ahead of it, LQ3, LQ10), and adoption is the front advancing one part at a time. The boundary is visible in the source, exactly where the types stop. Each part moved across joins the region where verification is a build. What secures the part also maps it: the record lays out the part's legal forms and collapses them to the survivor. **[interpretive**: LL's vocabulary as tools, its discipline inherited (LL §6), and the per-part guarantee itself is Theorem 2, solid**]**

## §6. The Laws Tower

**SW6 (The medium's next floor writes its law in the floor below).** The tower has three floors, and each writes its law in the medium beneath it. The raw source text is under the grammar (Permission Is Existence): a law whose rules are declarations, whose prohibitions are absences, and whose jurisdiction includes the file that declares the lattice's own seed. The lattice built on that text is under ``Law``. The rendering surface (the layer that turns types into pages) is under `SurfaceLaw`, in the rendering module. All three share one two-part shape: a checkable subset enforced on every build, a remainder held by review. Each law is written *in* a medium a lower law governs, and each floor appears where the one below is saturated enough to build on: Permanence Is Resistance §4's tower, instantiated in a toolchain, where the crystallized floor becomes the fixed target the next level's law crystallizes against (M8 ignition, the cycle permanent → resistant → irreducible). Each law is itself a position in its own medium (Law §6), so the rulebook is on the board it governs, at every floor. **[interpretive**: the three laws and their shape are fact, and reading them *as* the tower is the projection**]**

## §7. The Walls Are the Encoding's

**SW7 (What the medium cannot carry bounds what may be claimed).** The Solvability Criterion localizes all difficulty in the encoder (E2 §0). On the surface this arrives as *walls*: named, checked, and stopped at, never patched around. The render target has no column-width primitive, so no combinator claims one (SurfaceLaw §S15). The type system has no higher-kinded holes, so no combinator takes an unapplied template (§S11). Composition depth has a real stack bound, so a page is one screen's worth and a site is linked pages (§S16), the anchor graph of Navigation Is Geometry, forced by the medium.

The sharpest wall is a scope law: **an open axis carries no verdict.** A type whose reading is pinned by several `where` clauses reads its specific case only at a site where every pin is closed. Through any generic layer, the reading falls to the base case (§S12, §S17). This is V=I §5.24 surfacing in the medium: the reading reads exactly what its encoding carries, and a generic site's encoding does not carry the pin. The working rule (a non-generic proxy, resolved once at a literal site) is "fix the encoding, then read," stated as engineering. **[solid**: each wall checked directly in the medium, and the §5.24 identification is the projection**]**

## §8. Boundaries

**The scope is the pure part.** The claims are true over the determinate part written as pure types. The encoding (carving the world into those types) is the craft the framework names and does not do (E2 §5). Performance, IO, the live application are outside the record's claims, and where they matter, the liquid instruments are in force.

**The gate is given, and its trust is borrowed.** The compiler is the postulate's COMPARE: decidable, external, certified by no game here (PP15). Its soundness is inherited from the toolchain that millions run: the floor's price, stated where it is paid.

**The collapse is per position.** Editing the record is a new position, and the author claims no permanence across edits: the append-only journal of a codebase is in its version history, outside this projection. The claim: at any position, the projections agree with the record, because they are the record, read.

## §9. Statement

1. On a pure-Σ artifact every act is a write (expand or compress) or a reading. Nothing runs, so nothing else exists to do (SW1).
2. Proof, documentation, and audit are readings of the one record: the proof is the build's verdict, the page is the type's name, the audit is the verdicts read (SW2).
3. Drift requires a second encoding, and a reading is not one. Over the pure part the documentation cannot lag the system, and beside it, DiD prices exactly what the second copy costs (SW3).
4. A test labels by sampled outcome, a compile labels by the survivor itself. Over the carried claims the build has already decided, and tests instrument the remainder (SW4).
5. Trust grows by region: the typed part is crystal, the boundary is visible where the types stop, and adoption is a front (SW5).
6. The laws are a tower: the surface writes its own law in the floor below, same shape, enforced the same way (SW6).
7. The medium's walls bound the claims, and an open axis carries no verdict: scope-bounded reading, engineered (SW7).

> **A team keeps four artifacts and pays to keep them agreeing. Write the determinate part as pure types and three of the four become readings of the fourth: the build proves it, the site is its name, the audit is its verdicts, and drift, the tax every codebase pays, loses the second ledger it needed to exist. What is left beside the record is craft, and the line between them is in the source, visible, exactly where the types stop.**

## §10. Dependency

| Source | Used |
|---|---|
| Law | §0′ (pure types, the medium), §1 (two moves), §6 (the law is a position in its own medium) |
| V=I | §2.5 (COMPARE given), §5.20–5.21 (revelation, COMPARE sole source), §5.24 (encoding-bounded scope, SW7's wall), §5.25 (order free), Theorem 2 |
| PP | PP10 (one closed substrate), PP15 (the gate is given, never self-certified) |
| DiD | §0/S1 (one encoding, no second frame), S7 (distance of caches), S9 (translation, the price of a second encoding) |
| PiR | §4 (the tower, M8 ignition, permanent → resistant → irreducible), §5 (projection onto systems, the structural precedent) |
| LL | crystal / front / liquid (LQ3, LQ10), §6 (tool discipline) |
| E2 | §0 (difficulty targets the encoder), §5 (the delegated remainder, where tests keep standing) |
| NiG | the anchor graph (linked pages over one monolith) |
| AI paper | the projection format (coordinates present/absent → guarantees derived, not assessed) |
| SurfaceLaw | §S11, §S12, §S15–§S17 (the walls, each checked directly in the medium) |

The series' result is what a determinate structure guarantees, and here the author reads those guarantees on the artifact software teams actually maintain. Where the record is pure types, the build proves it, the pages and audits read it, and the four-artifact tax collapses to one thing written and three things derived. The projection adds no machinery: it names what the repository around it already does, and the repository is the experiment. Every claim above is either a prior theorem or a wall checked directly in the medium, and the site rendered from this paper is itself a reading of the record it describes.
