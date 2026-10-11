# The Solvability Criterion (Specification)

This paper specifies one sufficient architecture for certified search: represent a candidate family, relate it to the intended task, delimit a search region, and check supplied candidates until an adequate witness is found or the declared budget ends. Distance Is Cost G10–G13 provide several ways to bound or compare that work. They do not force every solver to use metric balls, and they do not make model adequacy a consequence of compilation.

## §0. The Factorization

An implementation can separate proposal generation from checking. The checker establishes a declared relation for a candidate regardless of its proposal order, provided the actual candidate, applications and evidence are bound to that relation. V=I U1–U2 and Distance G13 state the relevant identity, membership and coverage obligations. Connecting that declared relation to the user's intended problem is another obligation.

The encoder and checker belong to the same relational whole. Their separation is an interface choice within it. The representation, available questions, proposal policy, checking procedure and retained evidence can all contribute to the difficulty of a task. A proof about checking does not establish that implementing the checker is cheap or that the encoder contains all remaining difficulty.

## §1. The Conditions

Fix an evaluation domain D, a grammar E and a single-valued intended rule map f* on D. These are the domain of this specification, not a postulate about every task. A task allowing several equally adequate rules needs a set-valued acceptance contract instead.

**C1 (Representability).** For every τ∈D, the grammar can construct a rule representing f*(τ). A supplied construction proves reachability for that target. Exhaustion proves non-reachability only for a covered finite search domain. Failure to find a witness within a budget does not prove absence from an unbounded grammar.

**C2 (Adequate identification).** The declared candidate domain contains the intended rule, the observations are sound for it, and the restrictions isolate it within that domain. The actual checker implements those restrictions on admissible candidates, accepting exactly their survivors. With finite examples, this requires the separation and coverage premises of V=I U2. A singleton in an inadequate model can disagree with the intended behavior. Test failure signals a problem but does not by itself identify which representation, application, observation or coverage premise failed.

**C3 (Optional representative economy).** At a specified useful radius r, fewer representatives may cover the relevant rule set. G12 characterizes exactly that approximation contract. This is an optional efficiency premise for a representative-based design. It is not equivalent to a modulus, a favorable proposal rank or the ability to solve new tasks. Requiring only some positive radius makes this condition trivial for finite sets with more than one point.

**C4a (Anchored coverage).** For every τ∈D, at least one retained training anchor a has W(f*(τ),a)≤2r. This is a relation between the actual evaluation targets and retained anchors. G11 supplies one sufficient construction: cover those targets by radius-r balls and retain an anchor in each ball. A stochastic arrival law may establish eventual coverage under its additional premises. Representability alone does not supply those retained anchors.

**C4b (Access to a covering region).** The policy either selects an anchor satisfying C4a or searches the finite union of all anchored radius-2r balls. A modulus is one sufficient way to certify a selected radius, when its bound fits the chosen region. It is not the only possible dispatcher. Scanning N anchors incurs their access costs and the candidate checks inside the examined balls, not automatically O(N) total work.

**C5 (Covered enumeration and a work bound).** Supply a finite list c₁,…,cₘ covering the selected region, a procedure examining that list in order until acceptance or exhaustion, and bounds bⱼ on the work of producing and checking each entry, including admissibility and application checks. If setup costs at most b₀, require b₀+Σⱼbⱼ≤B for the declared budget B. The checker terminates on every listed entry, including invalid rule codes. This premise does not assume that a successful entry has already been found. G8 proves finiteness of tree balls, while the enumeration, its coverage and these work bounds need their own constructions.

C1 and C2 concern representability and adequate identification. C4a, C4b and C5 concern this particular search design. C3 can make a design economical but is not needed for its logical correctness. A target map can be mathematically specified before it is represented or identified, so these conditions must not be called constitutive of its very denotation.

## §2. The Conditional Theorem

**E2.1 (Conditional solving).** Assume C1, C2, C4a, C4b and C5. Then the specified search returns a rule representing f*(τ) for each τ∈D within the declared budget.

*Proof.* C4a places the intended rule in an anchored region, and C4b selects a region containing it. C1 supplies an admissible representation. C5's coverage places that representation at some list position j≤m. If the procedure accepts earlier, C2 identifies that earlier candidate with the intended rule. Otherwise it reaches j and accepts there, since C2's sound observations preserve the intended candidate and its checker implements the restrictions. The work through j is at most b₀+Σᵢ≤ⱼbᵢ≤B. Thus success and its work bound follow from coverage and per-entry bounds, rather than being assumed as C5. None of these steps uses C3. QED

The safety implication concerns the actual checked relation and its adequacy premises. Completeness additionally requires reaching an accepted witness. A budget stop can report BUDGET, an explicitly exhibited pair of surviving candidates can report ambiguity, and a covered empty candidate set can report EMPTY. These are different evidence states. The theorem supplies neither an unconditional runtime solver nor an unconditional guarantee about undeclared physical behavior.

**E2.2 (Training cost).** G11 gives cover-time bounds under an explicit IID law for certified arrivals and permits overlapping balls. N·H_N is the exact expectation for the uniform exclusive-class model of IiI §6. It is not a general lower bound for overlapping balls: one arrival may anchor every ball. These counts also omit the cost of solving, checking and storing each arrival. A smallest cover does not automatically minimize any of those costs.

**E2.3 (Exact reuse can generalize).** A table storing one answer per full input can answer only its stored keys unless it has another operation. A table storing a rule is different. The single rule “return the first component” applies to every admissible pair, including pairs absent from its training record. FirstEvidenceImage computes that answer generically from the actual input. IdentityReading gives another exact family. Thus r=0 reuse of a rule does not imply one answer per task or inability to handle unseen inputs. Learning or identifying the rule from examples remains subject to C2.

Matter M65 and CalibratedRoutingBasis already supply a case of identification followed by such transfer. Distinguishing probes recover a member of an explicitly uniform routing family, and its input-position map applies to new contents. The family interpretation, actual probe readings and subsequent application are the grounds of reuse. Probe agreement alone does not prove family membership, as VC74 shows.

## §3. What the Architecture Does and Does Not Force

**E2.4 (A sufficient architecture, not the necessary form of every solver).** C1, C2, C4a, C4b and C5 specify certified search within anchored regions. They do not imply that every non-memorizing solver must be an r>0 ball-router. E2.3 supplies exact reusable operations, while G12 supplies a shared reader even on a family with a constant off-diagonal distance matrix. A constructive derivation may produce the answer directly. Such a solver need not first discover an anchor or a metric grouping.

What any claimed derivation must identify is its actual input, permitted construction and resulting answer under the task's acceptance relation. That obligation is relational and can be expressed through application seams, as in TreeReadingProgress. For exact reuse through a changed representation, Verdict §6c and ReadingFactors already characterize preservation of the required question. A particular geometry is additional structure.

**E2.5 (Where difficulty can remain).** Representation, acquisition of discriminating evidence, candidate generation, checking cost, coverage, and interpretation can each require work. A correct generic checking relation can still have expensive instances. A supplied grammar can have an expensive search problem. The factorization exposes these obligations but does not prove that all difficulty belongs to the encoder.

**E2.6 (Three different quantities).** G10a relates the target's actual proposal rank and check costs to expected work. C4a concerns membership in accessible anchored regions. G10 supplies a task-to-rule radius bound. These are different contracts, not equivalent forms of compression. A favorable average rank gives no worst-case radius bound. A containing region gives no cheap ordering. A loose modulus may contain the whole rule set and save no work. Independence in a specific probabilistic model would require a separate construction.

## §4. The Open Antecedent

The useful research question is which relations make a particular question resolvable using the evidence and operations actually available. Finite grammar coverage alone does not supply observations separating its candidates, an affordable search, or a reusable dispatcher. Conversely a simple operation can answer a whole family without storing its members individually.

A no-information lower bound needs a model specifying what the solver can observe and how targets vary. Distance flatness is not such a model. IiI §4's distribution-relative search bounds cannot be strengthened into a prohibition on all nonmetric or exact generative reuse.

The comparison substrate supplies ways to represent and compare distinctions. Which existing distinctions are available to a reader, which questions factor through them, and how an application changes them are further relations inside the whole. A tower may construct new representations or strategies when the required witnesses exist. M16's strict decrease of finite class counts is one sufficient termination premise. G12 does not identify its endpoint with the first flat distance matrix, and cover-time formulas do not transfer to a collection of encodings without an arrival model for that collection.

**Interactive extension.** For a state/action system, the same analysis must bind actual states, actions, observations and transition applications. A model fitting a finite observed trace does not thereby identify all unobserved transitions. The appropriate rule domain and distinguishing evidence must be supplied.

## §5. Statement

The useful result is E2.1 with explicit premises and a reviewable proof. C3 describes an optional approximation economy. E2.3 and E2.4 exclude the stronger claim that all generalization requires positive-radius routing. The open work is to construct adequate representations, observations, applications and search witnesses for the chosen domain, and to account for their costs. Successful compilation of the legacy Spec protocol intersections alone does not construct these objects.

## §6. Dependency

| Source | Used |
|---|---|
| V=I | U1–U2, candidate identity, membership, coverage and model scope |
| IiI | CS1–CS3, retained class coverage versus dispatch, §4 search models, §6 arrival laws |
| DiC | G8 finite tree balls, G10 radius bound, G10a proposal cost, G11 anchored recovery, G12 representative approximation, G13 actual output certification |
| PiR | M16 sufficient finite-descent premise |
| Verdict | actual reading and application relations, evidence factorization, VC10 open-reading boundary |

The question is no longer whether a grammar has the one geometry that every intelligence must possess. It is which explicit relations suffice for the intended answer, and which of those relations the current construction already supplies.
