# Play Is Proof (Self-Play)

Intelligence Is Inevitable gives a conditional coverage theorem: classes must be presented, solved and retained under a common interpretation, and cached rules need usable dispatch. Here the agent can generate training tasks by executing a known rule. That makes their labels exact for the generated task, within the rule's declared domain. It does not establish that the generated rule is an unknown law of the surrounding world.

The useful distinction is between learning a poser's privately chosen target, extracting new consequences of known rules, and measuring an unresolved part of Ω. All three can occur inside one closed whole. PP19 states the information boundary of generation from already accessible data. PP20 gives a finite reversible construction where reuse reduces computation while adding no evidence beyond its inputs. Coverage and physical cost require their own premises.

## §0. Derivation

No new postulate. One new premise: the agent holds a finite **generating basis** Π (a set of primitive rules) whose composition-closure ⟨Π⟩ contains the domain's rules (this is C1 of the solvability specification, E2 §1). Finite compositions have finite expressions, but their full closure need not be finite (EiF EF5–EF6). Finite exhaustive coverage needs a finite declared behavioral family or a uniform composition bound. A finite generator alone does not supply it.

1. Saturation requires a stream presenting every class (IiI §3 remark, §6). *[premise of the Saturation Theorem]*
2. An external stream may not present every class, and the world is not obligated to supply N·H_N tasks (E2, IiI §3 scope remark: "No conclusion about tasks outside D_id follows"). *[gap]*
3. A certified rule f\* ∈ L applied to an input I yields (I, f\*(I)): a valid example whose label is *executed*, not assumed (V=I §4.8, §3.1, Theorem 2). *[the generator]*
4. Therefore the agent can *direct* a stream over ⟨Π⟩ (choosing what to generate), so coverage becomes controllable rather than awaited (PP5), and the stream premise moves from the world's distribution to the agent's choice. *[1 + 3]*
5. Each generated task is solved through the gate, and PASS gives f\* with |S| = 1 (Theorem 2 + R4). The label is certified. *[V=I §3.5, §4.7, Theorem 2]*
6. Downstream coverage requires the class-visitation, solver-completeness and retention premises of IiI §3. A shared rule projection does not force identical feature records (System CS1).

The prior papers asked where the agent's data comes from and answered: the world's stream. Here the author answers: from a basis and the gate. A label computed faithfully from g is correct for g. Its transfer to an empirical target needs an additional adequacy argument (PP19, System CS3).

## §1. The Data Problem

**PP0 (Arrival coverage can fail).** Eventual coverage requires every class to arrive and be solved. Under independent uniform arrivals of N≥1 classes from an empty library, the expected cover time is N·H_N (IiI §6). A budget smaller than this expectation does not imply failure on every run. For two classes, coverage after two IID uniform draws succeeds with probability 1/2 although the mean cover time is three. Positive marginal probabilities alone do not guarantee coverage. The finite counterexample in IiI chooses one class once and repeats it forever. Both generated and environmental task streams need an explicit coverage mechanism or arrival law.

## §2. The Agent Is a Generator

**PP1 (A certified rule is a task source).** A library entry f\* ∈ L, applied to I in its declared domain of total evaluation, yields the pair (I, f\*(I)). This is a consistent generated example for f\*. It need not identify f\* uniquely among other candidate rules. L is therefore a *source* of tasks, not only a *sink*.

*Proof.* f\* ∈ L is certified (Theorem 2, IiI §1). Execution is total (V=I §5.5). (I, f\*(I)) reproduces under f\* by construction, so it is a consistent example (V=I §3.4). QED

**PP2 (Pose–solve–certify yields certified-labeled training).** Two roles: *poser* and *solver* (the same substrate at different ticks, or two agents). The poser draws g ∈ ⟨Π⟩ and inputs {Iₖ}, emits {(Iₖ, g(Iₖ))}. Assume g belongs to the solver's extensional candidate family and that its examples use the same evaluator and decoding. The solver runs the pipeline and returns PASS(f\*), REJECT, or |S| > 1. Under PASS and R4, f\* = g (Theorem 2). The label of the generated task is *certified*, not assumed.

*Proof.* g ∈ ⟨Π⟩ ⊆ Σ (closure under PAIR-composition, V=I §2.1, §5.11). The examples are consistent (PP1). The solver's PASS with |S| = 1 gives f\* = g (Theorem 2). QED

*Remark (what is exact).* Exact execution of g and exact identification of g are separate claims. Statistical self-play can also use exact game rules and terminal outcomes. For example, [AlphaZero](https://arxiv.org/pdf/1712.01815), pp. 2–3 and its Domain Knowledge section, scores terminal states by the supplied rules while learning an estimate of expected outcome. Approximate value prediction does not make every observed game outcome an incorrectly labeled sample. A certified finite solver adds a scoped proof about its selected target, not a universal contrast with all other self-play.

## §2a. Generated information and computed access

**PP19 (Generation cannot distinguish a law absent from its inputs).** Let Θ name an unknown law or a questioned part of Ω, B the prior accessible record, and R every additional program, memory and seed input used during generation. Suppose the complete synthetic history is G=F(B,R), without further readings that depend on Θ. The function can include adaptive generation, solver updates and repeated verification, provided all their inputs are included in B,R.

For fixed B,R, compatible worlds receive the same G. Thus adding G cannot separate a pair already equal on those inputs. For finite probability models,

```
I(Θ;G|B) ≤ I(Θ;R|B),       I(Θ;G|B,R)=0.
```

*Proof.* Determinism gives the second equality. Applying the chain rule in two orders gives I(Θ;R,G|B)=I(Θ;R|B)=I(Θ;G|B)+I(Θ;R|B,G). The last term is nonnegative, proving the bound. If R is conditionally independent of Θ given B, generation adds zero information about Θ beyond B. This is a finite data-processing argument, not a new information law.

Conditional independence matters. If B and Θ are independent fair bits and R=B XOR Θ, then R alone is independent of Θ, but B,R determine Θ. A program reading both can reveal the target. Calling R a random seed does not remove its conditional correlation. Pretrained parameters or a teacher's private model can likewise carry information absent from a student's B and must be counted among the inputs, not treated as independent by name.

A minimal counterexample to self-certification uses System CS3's laws (0,0) and (0,1), both compatible with the first observation 0. Choose the constant law (0,0) as generator and append its second label 0. The synthetic training set now has the unique survivor (0,0), even in the possible actual world (0,1). Rechecking the generated set confirms the chosen model, not the missing measurement. A correct account of empirical evidence keeps both original laws possible until some justified premise or measurement separates them.

A poser can still teach its own private draw g. If an internal bit R selects g independently of Θ, a solver can learn one bit about g while learning zero about Θ. The target question and the learner's accessible record determine which information transfer occurred. An agent can also still measure another internal component of Ω.

**PP20 (Reuse can reduce computation without adding evidence).** Data processing concerns statistical distinguishability, not the work of evaluating an already determined answer. Consider n≥1 retained input bits, one prepared zero accumulator, m≥1 prepared zero outputs and the known parity rule. All operations are controlled bit flips. Compare two programs:

- For each output: XOR all n inputs into the accumulator, copy it to that output, and reverse the n computation gates. This takes m(2n+1) gates.
- XOR the inputs once, copy the accumulator to all m outputs, and reverse the computation once. This takes 2n+m gates.

Both retain the input, restore the accumulator to zero and leave the same m exact parity bits. Precomputation, copying and cleanup are included. For n=3,m=4 the counts are 28 and 10. No output adds information conditional on the retained inputs, yet the second program avoids repeated computation. This is a reversible reuse construction, not a claim that either circuit is globally optimal or that a neural training method achieves the same gain. The compute, copy and uncompute pattern belongs to established reversible computation, as in [Bennett, 1973](https://www.cs.princeton.edu/courses/archive/fall06/cos576/papers/bennett73.html).

There is no external scheduler. A mode and phase register select each program and gate. At phase j<L, apply its reversible gate and increment phase. At phase L, the outputs are ready to read, and the next step wraps phase to zero. The inverse decrements phase and applies the same controlled flip, or reverses the wrap. This defines a permutation on every allowed whole state. The compared prefixes end at readiness, before the explicit wrap. Gate counts refer to this declared reversible machine. A physical duration or energy account needs a specified implementation.

`SyntheticConstantRecord` retains the actual table and constructs a constant teaching table from its first reading. Equal observed fields give equal synthetic tables while the source is retained. The synthetic second label need not equal the actual second reading. This boundary follows from the recorded projections in the declared model.

## §3. Frontier-Targeted Generation

**PP3 (Ambiguity names the discriminating input, LT5 lifted to data).** If the solver returns |S| > 1 on the poser's examples, the survivors disagree on some input I\* (R4 decidable, §3.6, the dynamics-level diagnostic of LT5, read over the example-input space rather than the state–action space). The poser, knowing g, generates (I\*, g(I\*)), and appending it eliminates every survivor disagreeing at I\*.

*Proof.* |S| > 1 is true iff some input distinguishing the survivors is unobserved (LT5, verbatim with (s,a) → I). The poser computes g(I\*) (oracle on its draw, PP2) and appends the example. Survivors that disagree with g at I\* fail the new COMPARE, so S strictly shrinks (V=I §5.22). QED

**PP4 (cert(g) is the floor, and frontier-targeting achieves it up to the greedy gap).** Iterating PP3, the poser drives |S| → 1 in a number of self-generated examples bounded below by cert(g) (the minimum discriminating set, InI S5b, the confusion-cover / set-cover) and above by the greedy frontier sequence. No external examples are consumed.

*Proof.* cert(g) = the minimum set covering the confusion family {D(g, f) : f ≠ g} (InI S5b): fewer cannot identify g, so it is a lower bound. Each frontier step (PP3) adds an example eliminating a current survivor, a greedy cover, which reaches the minimum only when the confusion sets are well-covered by high-discrimination examples and exceeds it otherwise (InI S5b(c): greedy matches cert for hard targets, exceeds it where target-specific shortcuts exist). So the count is in [cert(g), greedy bound], and it equals cert(g) when the poser selects the optimal discriminating set rather than a greedy one. QED

*Consequence.* The agent does not need many examples per task: it needs at most a greedy cover of the confusion family, with cert(g) the optimum. "Minimal but sufficient" is cert(g) as a floor, approached by frontier-targeting, not a quantity any greedy poser hits exactly.

## §4. The Guarantee

**PP5 (Coverage needs a presentation policy).** For a declared finite set of K classes, a policy that can select each class and successfully certify it can cover the set in K successful selections. Locating a selectable representative, solving its task and checking its result have their own costs. Counting new certificates does not bound that total work.

For IID random draws with class probabilities p_i>0, let T_i be the first visit to class i. Then E[T_i]=1/p_i, and the cover time T obeys max_i 1/p_i ≤ E[T] ≤ Σ_i 1/p_i because max_i T_i ≤ Σ_i T_i. If sampling syntax, use its actual pushforward to behavioral classes. A uniform syntax distribution exists only on a finite declared syntax set. Neither finite individual expressions nor a finite generating basis imply that the entire composition closure is finite.

A known finite basis can generate infinitely many consequences under a proved composition rule. Certifying that basis, enumerating every consequence, and recognizing that no undiscovered basis element remains are separate obligations. A norm-ordered sieve with finite searchable bands eventually visits every fixed finite set. Finiteness of an unknown residue alone supplies neither a known stopping bound nor a certificate that the sieve is complete.

**PP5c (Countable visitation is not finite completion).** A countably infinite class set has no uniform probability distribution, but admits proper full-support distributions, for example p_i=2⁻ⁱ for i≥1. Under IID draws from any such distribution, every class is eventually visited with probability one. No finite prefix visits all the infinitely many classes.

*Proof.* For fixed i, P(T_i>n)=(1−p_i)ⁿ→0. Thus the probability of never visiting i is zero. A countable union over i of these null events remains null, so almost surely every T_i is finite. Their supremum is nonetheless infinite, since n draws contain at most n distinct classes. For every fixed finite target set A, E[T_A]≤Σ_(i∈A)1/p_i<∞. This gives neither a uniform finite deadline nor a stopping certificate for unknown A. QED

*Consequences.* A rare class can appear within a finite budget: its chance is 1−(1−p_i)ⁿ, positive and at most np_i. Its chance is small, not identically zero. Effective norm-ordered enumeration also visits each class when every band is finite and searchable. It supplies a deterministic presentation order, but is not the unique well-defined way to cover a countable domain. Equal positive one-time marginals do not suffice: choosing one class once and repeating it forever never covers two classes. IID is an additional process assumption whose realization inside Ω must be specified (PP22).

**PP17 (The exponential rate leaves the critical boundary open).** Fix the objects actually sampled: syntax expressions or behavioral classes with a declared minimum norm. Let n(s) be their finite count at integer norm s≥1, with infinitely many objects, and γ=limsup_s ln n(s)/s finite (ln0=−∞). Define Z(λ)=Σ_s n(s) exp(−λs) and p_λ(g)=exp(−λ‖g‖)/Z(λ) when Z is finite. Then Z converges for λ>γ and diverges for λ<γ. Its value at λ=γ and its limiting mean and variance require more than γ.

*Proof of the open-domain threshold.* For λ>γ, choose ε>0 with γ+ε<λ. Eventually n(s)≤e^((γ+ε)s), giving geometric domination. Multiplication by any fixed power of s still gives a summable series. For λ<γ, infinitely many s have n(s)≥e^((λ+ε)s) for some ε>0, so the summands fail to tend to zero. This does not decide equality. For N(s)=Σ_(j≤s)n(j), the cumulative rate in B8d is the same: N≥n, and the same exponential upper bounds sum to a bound for N. QED

*Counterexamples at one rate.* Take n_p(s)=ceil(2ˢ/sᵖ), for p=0,2,3,4. Every norm band is finite and every sequence has γ=ln2. At the boundary,

    s⁻ᵖ ≤ n_p(s)2⁻ˢ < s⁻ᵖ + 2⁻ˢ.

Therefore Σ_s sᵏ n_p(s)2⁻ˢ is finite exactly when p>k+1.

| p | Z(γ) | Mean as λ decreases to γ | Variance as λ decreases to γ |
|---|---|---|---|
| 0 | Infinite | Infinite | Infinite |
| 2 | Finite | Infinite | Infinite |
| 3 | Finite | Finite | Infinite |
| 4 | Finite | Finite | Finite |

For p=0 the law of the norm is geometric. For p≥2 use monotone convergence of the unnormalized moment sums and finite Z(γ). When p=2, variance also diverges: for independent S,S′, Var(S)=E[(S−S′)²]/2, and the event S′=1 has probability bounded away from zero near γ while the second tail moment diverges. For p=4, exact sums with rigorous tail bounds give limiting mean between 1.6677247 and 1.6677251, and variance between 1.5905519 and 1.5905934. These abstract count sequences refute conclusions from γ alone. They are not asserted to be the densities of a particular VI composition grammar.

On λ>γ, termwise differentiation gives ψ=lnZ, −ψ′=E_λ[s] and ψ″=Var_λ(s). The score is E_λ[s]−s, so Fisher information in λ is that variance. For a competitor q with finite entropy and the same finite mean, D(q||p_λ)=λE_q[s]+lnZ−H(q)≥0 proves maximal entropy of p_λ, with equality only at q=p_λ. This does not assert existence for every requested mean. ψ is a log-partition function. Physical free energy, temperature and heat capacity require an implementation model and the corresponding units and parameter factors. They do not follow from this formal distribution.

*Sampling cost is separate.* Two objects of norms 1 and 2 have rare-class probability q=1/(2ᵏ+1) when λ=k ln2. The expected wait 1/q grows while norm variance q(1−q) tends to zero. Thus coupon waiting is not ψ″. A deterministic enumeration is a sequence policy, not the λ→0 member of a normalized family on an infinite set. In particular, when γ>0 that path leaves the normalization domain before reaching zero. No directed/random pair of physical temperatures is established here.

**PP22 (Independent readings consume finite preparation capacity).** In a finite autonomous deterministic whole, let Ω₀ have any initial distribution, U be its transition and E a fixed reading. The n-reading tuple is a function of Ω₀, so H(E(Ω₀),…,E(Uⁿ⁻¹Ω₀))≤H(Ω₀)≤log₂|Ω|. If these readings are IID with positive entropy h, then nh≤H(Ω₀). With m positive-probability symbols their full support also requires mⁿ≤|supp Ω₀|. Hence such a whole cannot supply an infinite nondegenerate IID sequence. This argument does not require U to be invertible, only that all inputs are included in Ω. This exact-independence bound does not assess pseudorandom generator quality or exclude useful approximate independence for a specified class of tests.

*Positive finite construction.* Ω contains a length-L tape and a clock phase 0,…,L−1. Each tick rotates the tape left and advances the phase cyclically. Rotation right and decreasing phase give the inverse. Prepare the tape from pᴸ and phase at zero, and read its first field. The first L readings are IID, and reading L+1 repeats reading 1. Whole entropy remains L H(p). The observed tuple here is a mathematical map of the initial state, not an unaccounted physical recorder. Retaining a transcript would require its storage inside Ω. The product preparation is stated, not generated by the clock or inferred from closure.

*Closure alone does not imply the finite bound.* On the infinite whole Ω=A^ℤ with product measure p^ℤ, the two-sided shift U(x)_i=x_(i+1) is bijective and preserves the measure. Reading coordinate zero gives IID coordinates indefinitely. This standard Bernoulli shift requires nothing outside Ω, but uses an infinite tape state space. It is a mathematical counterexample to closure⇒no IID, not a finite device or a derived physical implementation. The distinction is finite capacity, not physical openness.

`RotateThree` derives cyclic retention in pure types, including the repeated fourth reading. The infinite-limit claims require their stated mathematical arguments.

**Prediction against an internal opponent.** VI1a's symmetry criterion has a finite weighted counterpart. Let Ω be a finite whole with probability weights w, a binary action A, and the opponent's complete available reading E. Suppose an involution h preserves w and E while exchanging A's two values. For any deterministic guess g(E), h pairs every successful guess with an equally weighted failure. Success therefore has total weight one half. The guarantee concerns this information boundary. If E reveals A, no such involution preserves E, and copying A succeeds. A repeated alternating action can have balanced overall frequencies while a history-dependent opponent predicts it perfectly. A randomized opponent is covered when its seed is included in E and the same pairing premise remains valid. No opponent or seed is placed outside Ω, and the weighting premise is not derived from symmetry of the unweighted support.

**Testing forecasts by permitted strategies.** [Shafer and Vovk's bounded forecasting game](https://www.probabilityandfinance.com/2001_book/chapters/chap3.pdf) offers a relevant alternative formulation: a specified betting strategy keeps capital nonnegative on every admitted path, and a failed frequency limit makes its capital unbounded. Application requires a separate hypothesis excluding such unbounded gain. The authors distinguish that hypothesis from the mathematical theorem. Their [finite deviation construction](https://www.probabilityandfinance.com/2001_book/faq/question3.pdf) likewise makes the forecast, available bets and error event explicit. These results motivate a VI acquisition contract. They derive no physical frequencies from closure and do not treat capital as physical energy. In a finite resource implementation, continued availability of the promised bets requires evidence too.

Sources: [Fithian, differential identities on the parameter-space interior](https://www.stat.berkeley.edu/~wfithian/courses/stat210a/exponential-families.html), [MIT, radius of convergence](https://ocw.mit.edu/ans7870/18/18.013a/textbook/HTML/chapter30/section04.html), [Solomyak, two-sided Bernoulli shift, Example 1.5](https://u.math.biu.ac.il/~solomyb/TEACH/20/ET/Lec1.pdf). These standard mathematical facts correct the earlier PP5c/PP17 claims.

**PP6 (Endpoint agreement is conditional on completion and decoding).** Fix a particular sieve, including its representation, order, tie-breaking and reference semantics. Suppose two players both finish certifying its same finite residue A and retain every accepted member in a cache decoded by set union. Their decoded basis caches agree with A, and a sound shared composition interpretation gives the same Cl(A). Their raw records, costs and readiness times can differ. Arbitrary poser policies need not reach this endpoint (PP5 and PP5c).

*Proof.* Each complete retained cache contains every member of A, and its accepted members belong to A by hypothesis. Set union is order-independent. Applying the same composition closure to equal sets gives equal reach. This proves neither discovery of A nor uniqueness among different possible sieves or equally expressive bases. It also does not materialize all of an infinite Cl(A) in finite memory. QED

**PP7 (The guarantee follows its declared premises).** A generated label is exact for g when evaluation is faithful on its domain. A selected solver rule equals g when g is represented, examples use the same semantics, PASS occurs and R4 is established. Retention preserves the record under its explicit update. Coverage additionally needs class presentation and solver success. These are different obligations, as System CS1–CS3 and PP19 show.

Composition also needs scope compatibility: the inputs supplied to a learned component must fall within its certificate or a proved extension of it. Verdict VC35 gives the finite criterion and an entirely reversible failure of promoting one-input agreement to contextual equivalence.

No negation of one obligation establishes the opposite behavior of every other learning architecture. Mutable state does not force forgetting, and self-play without this gate can still have exact game outcomes. The useful engineering proposal is to attach checkable premises and conclusions to generated training examples. It does not certify an unmeasured law or prove benchmark superiority.

**PP18 (Search policy and certificate scope are separate).** With fixed representation, faithful evaluation and R4, a successful gate conclusion depends on those premises rather than the order in which its candidate was found. Finding a candidate still has a search and resource cost. Alignment can help under the conditions of the chosen search model, but neither infinite reach nor finite generation forces every task into enumeration.

An infinite domain cannot have every distinct answer stored explicitly in a finite table. It can still have finite caches for common tasks and compact algorithms or macros for other tasks. Basis B6–B8 separates bounded search reach, unbounded generation and execution cost. Removing all derived macros can reduce bounded reach even while preserving eventual expressivity. A sound gate does not supply an optimal search policy or establish a measured speed advantage for a particular implementation.

## §5. Two Agents, and the One Thing One Cannot Self-Supply

**PP8 (An additional reading can refine an old distinction).** Fix a common source set K and two actually available observation maps E,E′. The combined reading (E,E′) strictly refines E's partition exactly when some x,y have E(x)=E(y) and E′(x)≠E′(y).

*Proof.* The joint kernel is ker(E)∩ker(E′), contained in ker(E), and the inclusion is strict precisely at such a pair. If E′ is computed only from E, the pair cannot occur. Different syntax, agents or disjoint cache keys do not establish it. Two constant readings with disjoint labels still distinguish nothing. Nor does a refined observation necessarily settle the particular target question: verdict sufficiency and experimental accessibility remain separate (VC25–VC31, CS3).

A single agent can gain such access by reading another internal component of Ω. A second agent can provide it only if its message carries a relevant additional distinction. If both messages are generated from the same complete inputs, PP19 applies regardless of the number of agents or encoding names.

**PP9 (Across the tower, the second agent is one's own past).** A single agent climbing the tower self-plays against its crystal: at level N+1 the fixed target is L_N: the agent's own saturated, permanent past (M7, M8). The poser/solver pair is realized in time as present-agent / past-crystal.

*Proof.* Ignition (M8): the saturated L_N is the level-N+1 target. The level-N+1 agent (same substrate) submits candidates against L_N (M10). The two roles of PP2 are the agent now and the agent crystallized. QED

*Caveat (the meta-level is coverage, not identification).* The level-N+1 game is meta-saturation (IiI §4): it certifies that an interaction-pattern *works*, with |S| ≥ 1, coverage, not the |S| = 1 identification of the base level. PP6's endpoint agreement therefore applies per level to the base game under PP6's completion and decoding premises, and to the meta-game only when a selection criterion is also imposed (OiO O8: argmin over cost, norm, lexicographic order). The temporal two-role structure (present-agent / past-crystal) is exact, and the inherited certainty weakens by one regime going up, as the tower analysis of E2 §4 records.

*Resolution.* "Two agents or one?" One across the tower (the second is your crystallized past, PP9). Across encodings, novelty needs an additional reading that separates an old fiber (PP8). Another internal component of Ω or a second agent whose message carries that distinction can supply it. Temporal self-play needs no second body.

## §6. One Closed Substrate

**PP10 (Everything runs on one closed body).** PP1–PP9 are realized on a single substrate: Σ with the append-only journal G (V=I §2.3). The **surface** is the frontier (DiC §4): the prefix-minimal divergences where an incoming structure meets the body and the diagnostic surfaces (V=I §1, REJECT-address). The **protocol** is grow/shrink (DiC §2) under I2. The system is **closed** in the conservation sense: Σ, the universe of structures, is fixed (DiD S24: nothing is created or destroyed), and G, the record of what has been revealed, only grows (I3). An "input" is therefore not new matter entering a closed box: it is a structure *already in Σ*, brought into the record by COMPARE (PiR §6: revelation, not creation, and M19: a structure becomes matter only at the encounter). The system is closed in Σ and monotone in G, and "taking input" is revealing, not importing. Each interaction **relaxes** the body to a fixed point (M12) in at least W ticks (DiC G14), heavier bodies relaxing slower (DiD S18). Self-play is the closed dynamics: a posed structure is revealed at the surface, the body relaxes and absorbs it via the dual flow (one COMPARE both narrows the answer and deposits structure, InI S6a), and the new frontier names the next experiment (PP3).

There is no external scheduler and no separate memory: the poser, the solver, the journal, and the generated tasks are all trees in one Σ, written to one G, tested by one COMPARE (PiR §0). The agent's body and the system are one on the substrate, and self-play is that body changing its own surface and settling.

## §7. Witness, Cost, and Closure

The loop of §§1–6 has a further structure, visible once the gate is read as a *witness* (a form whose record fixes a distinction, I3) and saturation as coverage of a declared domain, with compression requiring its own representation contract. The statements below follow, and PP15 states the boundary on universal representation.

**PP11 (Self-play is redundant fixation).** A self-generated certified entry is fixed twice: by the poser, which produced g by construction, and by the gate, which certified the solver's PASS. The two routes are constructive and verificational. Their different roles do not establish statistical independence or independent evidence about an unknown law (PP19).

*Proof.* The poser holds g (PP2) and computes g(Iₖ) by execution, a generative trace in G. The gate records the solver's PASS, a verificational trace in G under the retaining update. One f\*, two routes. QED

*Consequence and limit.* The entry has a constructive route and a verificational route within the same form, under the declared generation and gate premises. An additional actually available reading strictly refines the old partition exactly when it separates an old fiber (PP8). A relevant message from a second agent or a reading of another internal component of Ω can supply it. Certifying the target class additionally requires the remaining compatible cases to agree on that class question (V=I U2c). Generation from the same complete inputs preserves their unresolved pairs (PP19). Copying can produce further output records without adding evidence about a law absent from those inputs (PP20). Any robustness of these records depends on their availability and the admitted failures.

**PP12 (Minimal exact class coverage under a fixed entry contract).** Fix the finite class set C of IiI CS1 and require each stored entry to represent exactly one class. Any complete library needs at least |C| entries: the projection from entries onto C must be surjective. One representative per class attains this bound. A canonical retaining acquisition policy reaches that count when it obtains each class and avoids duplicate representatives.

This is an exact class-coverage result under the one-class-per-entry contract. It is not a proof that the raw library is the shortest program, the smallest approximate ball cover or the least-cost physical encoding. G12's representative approximation has a different contract. A generative entry can serve many tasks, and shared descriptions can change storage cost without merging their distinct outputs. Even within the fixed entry contract, minimizing each representative's norm requires a declared selection criterion. A globally optimal shared representation needs a further argument. Saturation alone supplies none of these optimality conditions.

**PP13 (The ledger separates mismatch, ambiguity and search limits).** On a fixed example family, a zero mismatch can be shared by several candidates. Therefore loss=0 does not identify a candidate. Conversely, several surviving candidates can agree on the requested question, so |S|>1 need not leave that answer unresolved. VI2 and VC15 state the question's invariance criterion.

EMPTY identifies failure in the exhausted candidate scope, if that scope was actually exhausted. BUDGET identifies a stopped search and need not imply that no fitting candidate remains. Neither flag by itself measures the cost of a solution or proves it exceeds the budget. A cost interpretation needs the stated operations, costs and search guarantees. These distinctions prevent success on the given examples from being presented as complete identification.

None of these statuses establishes felt presence. PP15 concerns expressive completeness and PP21 permits relative internal inspection. The diagonal restriction supplies no prohibition on every internal loop and no inference about whether this ledger is experienced.

**PP14 (A ceiling on new evidence, not all self-modification).** Under PP19's fixed-input premise, rewriting programs or generating richer syntax cannot split two worlds that agree on all those inputs. This follows by composing the rewrite and generator into one function F. It does not prohibit new representations or faster computation of their consequences (PP20).

A second encoding or higher-level agent computed from the same complete record obeys the same restriction. New empirical distinction requires a relevant input absent from that record, which can be another component of the same Ω. A declared grammar bounds its own generated expressions by definition. It does not alone prove that every physical agent is incapable of revising its encoding or accessing more of the whole.

**PP15 (The diagonal boundary depends on the answer relation).** Let C be a set of codes and E:C×C→{0,1} a total evaluator. It cannot represent its own diagonal complement d(c)=1−E(c,c): there is no a∈C with E(a,c)=d(c) for every c. Consequently, such an evaluator cannot represent every Boolean predicate on its own code set. This is a restriction on expressive completeness, not a prohibition of every finite self-application or internal inspection.

*Proof.* If a represents d, substituting c=a gives E(a,a)=1−E(a,a), which neither Boolean value satisfies. For finite |C|=n, the n rows of E also cannot exhaust the 2ⁿ Boolean predicates. By contrast, the two-code evaluator E=((0,0),(0,1)) has a valid total self-application E(1,1)=1. Its diagonal complement (1,0) is absent from its represented rows. This is the set-level Boolean instance of Lawvere's fixed-point argument. The needed hypothesis is representation of the diagonal, not that an evaluator and its target belong to the same physical whole. QED

The obstruction has no essential dependence on Boolean values. For a total E:C×C→A and a specified transformation t:A→A, suppose a code a represents d(c)=t(E(c,c)). Substituting a gives y=E(a,a)=t(y). Representation therefore supplies a fixed point of t. If t has none on the admitted answer domain, that representation is impossible. Only this diagonal question needs to be demanded, not a language containing every function. This is the fixed-point form of [Lawvere's Theorem 1.1](https://conceptualmathematics.wordpress.com/wp-content/uploads/2025/03/diagonal_arguments.pdf), applied to the specified evaluator. It does not assume a universal classical truth predicate.

`FirstDiagonalFixedPoint` and `SecondDiagonalFixedPoint` derive this consequence in the existing two-code table. Two supplied applications transform the table's actual diagonal entries. If their output row equals the first or second represented row, projection derives a fixed point of the corresponding application. The caller supplies the row representation and input bindings, without a fixed-point premise. A swap on equal-coordinate answers supplies generic positive witnesses. A swap between two positively different coordinate pairs refuses representation at either row. These pure type checks cover those constructions, not arbitrary evaluator completeness. A name for the unrepresentable demand can still occur as text. What cannot coexist are its stipulated answer relations.

Adding an unsettled answer that t leaves fixed can remove this particular obstruction in an enlarged answer domain. It does not establish universal representation or supply one of the originally required definite answers. Requiring such an original answer restores the refusal.

**For a relation, the diagonal can preserve an answer set without fixing an answer.** Let C be nonempty. Replace the single-valued evaluator by an admission relation with nonempty answer sets E(c,x)⊆A for every pair of codes. Also allow the postprocessing to be a relation T⊆A×A, with direct image T[S]={v: uTv for some u∈S}. A code a represents the transformed diagonal when

    E(a,c)=T[E(c,c)] for every c.

At a, the nonempty set S=E(a,a) must satisfy S=T[S]. Conversely, if T has any nonempty such set, the constant evaluator E(c,x)=S represents its transformed diagonal at every code. Hence existence of some evaluator with this representation is equivalent to existence of a nonempty invariant answer set. For a particular already supplied evaluator, that invariant-set condition is only necessary. Its other entries must still obey the displayed representation equation.

The equation requires every successor of a member of S to remain in S and every member to have a predecessor in S. It does not require a self-contact uTu. All fixed sets have a greatest union: direct image preserves unions, so the union of all S satisfying S=T[S] also satisfies that equality. This union can be empty. Empty answer sets would make the empty evaluator a trivial example, which is why nonempty answers were specified.

| Postprocessing relation | Nonempty invariant answer set | Fixed individual answer |
|---|---|---|
| a→b and b→a, with a≠b | {a,b} | None |
| a→b, b→a, b→c, with three distinct roles | {a,b,c} | None |
| n→n+1 on the finite-generated natural numbers | None | None |
| n→n+1 on the integers | All integers | None |

On a finite answer carrier, the fixed sets are exactly the sets reachable by finite paths, including zero-length paths, from a chosen collection of directed cycles. Such a reachable set contains all its successors, and each member has a predecessor in it. Conversely, repeatedly taking predecessors of any member of a finite fixed set reaches a cycle within that set. Forward closure then gives the asserted equality. For a function, cycles have no outgoing branches, so this reduces to unions of cycles. The second row shows why that last description cannot be used for arbitrary relations. The integer example shows why a nonempty fixed set need contain no cycle on an infinite carrier.

There is an exclusion independent of a finite carrier. Suppose every edge uTv strictly increases a well-founded relation, meaning every nonempty subset has a minimal member. A nonempty fixed set would have a minimal v and a predecessor u∈S with uTv, a contradiction. This proves the natural-number row. The finite-generated numeral interpretation matters here: an added recursive or infinite value need not satisfy its well-foundedness premise. No order of physical time has been derived.

**Selecting one answer restores a stronger obligation.** Suppose a deterministic selection s chooses s(S)∈S and is required to respect postprocessing through s(S) T s(T[S]). At a fixed set, its complete input is unchanged, so it requires s(S) T s(S). A relation with no self-contact on S forbids such a selection, although the full answer set may be invariant. For a function t this is the familiar equation s(t[S])=t(s(S)), and the conclusion is a fixed point of t. An additional internal context can change the selection input. Two separately occurring answers can instead be related without being equal. Neither case supplies the demanded selection on S alone. This connects VI1a's selection boundary and M58's return condition to the same source correspondence. The admission set, a selected answer and that answer's occurrence are different retained objects. Physical membership in one whole does not identify them.

**PP21 (Internal inspection is relative).** A finite closed system can inspect its own resident implementation against an internal reference. The inspection's correctness is relative to its specified transition, reference interpretation and prepared readout window. Physical closure neither removes these proof premises nor requires a universal evaluator.

*Construction.* Ω contains a four-bit gate table C, four-bit reference S, four mismatch bits r, verdict v and internal phase j∈{0,…,5}: 49152 states. The candidate's output on input i is its resident table bit Cᵢ. At phase i<4, flip rᵢ by Cᵢ XOR Sᵢ and advance. At phase 4, flip v iff r=0 and advance. At phase 5, wrap to 0. Decreasing phase and repeating its flip is the inverse, so the whole transition is a permutation. From r=0, v=0, j=0, five ticks leave rᵢ=Cᵢ XOR Sᵢ and v=1 iff C=S. With the equality reference S=(1,0,0,1), precisely the correct gate passes. All controller operations, the reference register and the clock are internal to Ω. The declared transition still supplies the inspection semantics. No theorem here derives that transition's fidelity from its own acceptance bit. QED

*Failure boundaries.* A coherently wrong C=S passes the relative test. Unprepared r or v can also give a false acceptance, and the next cycle need not retain the verdict. A naive circular test asks candidate G to certify each proposed equality by applying G again. The constant-true gate accepts every such proposal, including false equalities. This counterexample requires an explicit soundness relation, not a universal ban on self-inspection. `DiagonalReadings` supplies the projections for the restricted two-code evaluator. It does not certify the compiler or physical machine.

The earlier PP15 conflated physical closure, relative self-inspection and universal Boolean truth evaluation. Cantor/Lawvere supports the last obstruction. It does not imply that a decidable gate cannot inspect itself, or that part of Ω must be physically external. Relative verified bootstrapping is already established, for example in CakeML: compilation of the verified compiler is justified in HOL4 against stated language and machine semantics. Neither that work nor this construction claims to establish every premise without any premises.

Sources: [Lawvere, Theorem 1.1, primary reprint](https://conceptualmathematics.wordpress.com/wp-content/uploads/2025/03/diagonal_arguments.pdf), [CakeML, POPL 2014, abstract and §2.1](https://cakeml.org/popl14.pdf).

**PP16 (Resonance radius, conditional).** For two-agent self-play (PP8), there is an intermediate encoding-distance W(E, E′) that maximizes joint coverage gain. Too small: E′ resolves nothing E collapses, so PP8's strict enlargement fails (no novelty). Too large: translation between them (DiD S9) approaches full re-derivation, so transferred coverage approaches zero. The optimum is strictly between and is measurable from the two W-matrices, in the standing of the modulus (G10): a property of the pair, not guaranteed by I1–I3.

*Proof.* Enlargement strictness needs a resolved collapse (PP8), and at W = 0 there is none. Transfer value is bounded by cache overlap, which falls as encoding-distance grows (DiD S9, §5.18), and at large W it vanishes. A quantity positive on (0, large) and zero at both ends attains an interior maximum. Its location is computed from the encodings' W-relations, not deduced. QED

## §8. Boundaries

**Data, not encoder.** PP5 saturates ⟨Π⟩: it does not discover Π. If C1 fails (D ⊄ ⟨Π⟩), self-play saturates the *wrong* closure and returns EMPTY on the uncovered part (E2 §1, §5). The basis is still the agent's standing contribution (V=I §1), and certified self-play removes the *data* bottleneck, never the *encoder* bottleneck.

**A gate must exist.** PP2's certified label requires a decidable verifier (V=I §3.7). Certified self-play is therefore in force exactly where the domain *is* a gate (programs, proofs, rule-governed games, formal environments) and not where the label itself is uncertain (raw perception, natural images), for which no COMPARE certifies the target. This is the exact scope: the proof in "play is proof" needs something that can prove.

**The poser as oracle.** PP2–PP4 assume the poser knows g (it drew it) and can execute it. For *self-generated* tasks this is true by construction. For *external* tasks the label must come from the environment, and certification then requires the environment to be a decidable gate: the same condition, relocated (LiT LT4: identify the law as a V=I game, and LiT §6 for its boundaries: stochastic and partially observed environments forfeit the certificate).

**Self-play does not enlarge the closure.** Drawing from ⟨Π⟩ can only produce members of ⟨Π⟩ (closure is closed). New *primitives* (a richer Π) come only from a new encoding (PP8) or a level up (PP9), never from more play at one level (InI §4: the permanent boundary is the grammar).

**Basis completion needs an effective certificate (B8).** A finite known basis can support a theorem about infinitely many derived expressions. Finding and certifying that basis needs presentation and solver assumptions. Even if an unknown sieve residue is finite, its final new atom is not necessarily recognizable as final. PP5 and PP5c separate a finite target's visitation from a stopping certificate. A finite basis does not imply a finite composition closure, and listing every element of an infinite closure never finishes in finite time. PP15 and PP21 address a different question: what premises justify an internal inspection.

**Frontier-targeting assumes alignment (GA).** PP3–PP4's minimal-sufficient generation descends the frontier loss toward the discriminating examples. This is a descent only where the loss is *aligned* with the metric: where lowering loss moves structurally toward what discriminates (Gradient Is Alignment, α > 0, GA3). On a non-aligned (rugged) domain the frontier carries no usable gradient and generation degrades to enumeration: the cert(g) examples must be searched, not descended. The directed poser's *order* (the only free variable, InI) buys speed exactly to the extent the domain is aligned (GA6), the precondition under which loss-built order beats enumeration. ARC's loss is graded and cheap (GA5), so the gradient exists, and whether it is aligned is the open measurement that decides whether self-play here descends or enumerates.

## §9. Prior Instances

Certified-verifier self-play occurs in practice: systems that pair a sound checker with self-generated problems. Formal-proof and geometry provers use a symbolic/proof gate, and library-learning program synthesizers invent their own tasks (the latter without I3, hence mutable and uncertified across runs). This document is not a method report. It states the framework-internal theory of the pattern: the checker is the gate, and PP5–PP7 say when such self-play saturates, why its endpoint is certified and domain-determined, and where it cannot reach (the encoder, §8). References are where a mechanism is borrowed, and the theorems are the contribution.

*Measured.* The pattern is instrumented on ARC-AGI-1 (E1/E2). Across the search ladder the gate was certified-safe throughout (TEST-WRONG ≈ 0 of the train-PASSes): PP7's guarantee is structural and poser-independent. The reach is vast (B §5) while pure-poser coverage of eval is alignment-limited and a stronger poser under the same gate lifts it higher (E2 §0): PP18's split, confirmed. And the ledger's terminals are the cost report of PP13.

## §10. Statement

1. Stream coverage requires visitation assumptions. A mean waiting time is not a guaranteed deadline (PP0).
2. A known total rule can generate exact examples on its declared domain. Identification additionally needs faithful evaluation, representation and separation of the allowed candidates (PP1–PP4).
3. Retention, finite coverage and efficient dispatch are separate obligations. A finite basis alone need not have a finite composition closure (PP5–PP7, IiI SAT5/6 and V=I CS1–CS3).
4. A joint reading adds a distinction exactly when it separates an old observation fiber. The added source can be internal to the same Ω. Another agent's name or a recoding alone does not supply it (PP8, PP14).
5. Generated evidence cannot reveal an unknown target beyond the information in its full inputs. A private synthetic target can still be taught, and consequences of known data can become cheaper to compute (PP19–PP20).
6. Constructing a label and checking it provide two routes whose soundness needs explicit premises; they need not be independent evidence (PP11).
7. Finite internal self-application and relative inspection are possible. A total Boolean evaluator cannot also represent its own diagonal complement (PP15, PP21).
8. Full-support IID sampling can visit each of countably many classes almost surely, while finite completion remains impossible. A growth rate alone leaves the critical normalization and moments unresolved (PP5c, PP17).
9. A finite deterministic whole has a finite independent-reading budget. An infinite closed tape need not have that bound (PP22).

The broader compression, feeling, resonance and ensemble proposals in PP12–PP13 and PP16 require their own arguments. The statistical ensemble in PP17 has the stated mathematical scope, without a physical phase law. Passing the finite checks for PP5c, PP15, PP17 and PP19–PP22 does not establish those proposals. In particular, physical closure supplies no proof that a computational cost ledger is felt, nor an automatic interior optimum for transfer.

> Self-play can teach a generated target and reorganize access to known consequences. Identifying an unknown part of the same whole still needs evidence that distinguishes it. An internal checker can inspect an internal implementation under explicit premises. The diagonal limit concerns universal representation, not physical exclusion from Ω.

## §11. Dependency

### External

| Source | Used |
|---|---|
| V=I | §0 (postulate: PAIR/NULL/COMPARE given), §1 (encoding is the agent's, REJECT-address), §2.1/§2.3 (Σ, G), §2.5/§5.11 (composition, the act of distinction), §3.1–3.6 (game, R4), §4.7–4.8 (gate, execute), §5.4 (encoding-local), §5.5 (totality), §5.17 (agent-system duality), §5.18 (cache transferability), §5.22 (S non-increasing), §5.24/§5.25, Theorem 2 |
| IiI | §0 (agent = outer half), §1 (crystallization), §3 (Saturation Theorem, SAT5/6, scope remark), §4 (grammar boundary), §6 (coupon collector) |
| PiR | §0 (one substrate), §2 (irreducibility), §6 (revelation), M7–M8/M10 (ignition, crystal-as-target), M12 (convergence), M24 (conditional physical resource model) |
| DiD | S1 (stationarity), S7 (cache distance), S9 (translation), S18 (inertia), S24 (Σ conserved) |
| DiC | §2 (grow/shrink), §4 (frontier = surface), G1a (norm and conditional node cost), G4 (graded comparison), G10 (modulus), G12 (compression criterion), G13 (loss), G14 (travel time), G15 (resistance has magnitude) |
| InI | S5b (cert / confusion-cover), S6a (dual flow), §7 S9 (several agents: shared or complementary records) |
| LiT | LT4–LT5 (law as game, ambiguity as experiment), §6 (stochastic/partial boundaries) |
| E2 | §0 (the measured campaign), C1 (basis coverage), §4 (critical-slowing budget), §5 (encoder-tower floor) |
| B | B3 (ordered bounded sieve), B6–B8 (bounded expansion versus unbounded generation), B8d–B8e (reach growth and sampling) |
| GA | GA3 (alignment α), GA5–GA6 (graded loss, alignment as the precondition order beats enumeration) |

### Internal

| Statement | Depends on |
|---|---|
| PP0 | IiI §3, §6, E2 §4 |
| PP1 | Theorem 2, V=I §4.8, §5.5 |
| PP2 | PP1, V=I §2.1, §3.5, §4.7, Theorem 2 |
| PP3 | PP2, LT5, V=I §3.6, §5.22 |
| PP4 | PP3, InI S5b |
| PP5 | PP2, IiI §1, §3, §6, I3 |
| PP5c | Countable class set, positive class probabilities and IID draws |
| PP6 | Fixed sieve, successful complete certification, retention and set-union decoding |
| PP7 | PP5, PP6, I3, V=I §5.22, Theorem 2 |
| PP8 | V=I §5.4, §5.24, DiD S1, S9, InI §7 |
| PP9 | PiR M7–M8, M10 |
| PP10 | V=I §2.3, DiC §2, §4, G14, DiD S18, S24, PiR M12, InI S6a |
| PP11 | PP2, PP8, PP19, PP20, I3, V=I U2c, IiI §1–§3 |
| PP12 | IiI CS1, fixed one-class-per-entry contract, DiC G12 |
| PP13 | fixed-example mismatch, VI2, VC15, explicit exhaustion and cost scope |
| PP14 | PP8, PP9, V=I §5.4, §5.24, DiD S1, IiI §4 |
| PP15 | total evaluation, representation of the transformed diagonal, fixed-point-free answer transformation, Lawvere Theorem 1.1 |
| PP19 | Finite conditional entropy identities, complete generator inputs |
| PP20 | Explicit reversible gate programs, preparation and internal clock |
| PP21 | Explicit finite transition, internal reference and preparation |
| PP16 | PP8, DiD S9, V=I §5.18, DiC G10 |
| PP17 | Declared finite norm bands, exponential rate and comparison tests |
| PP22 | Deterministic observation map, initial distribution and finite whole capacity |
| PP18 | PP3, PP6, Theorem 2, V=I §5.25, GA GA3, GA6, B B8b, IiI §3, E2 §0 |

The operational question is which distinctions a learner can access, which consequences it can compute cheaply, and which assumptions justify its certificates. These are different questions within one physical whole. The formal inspection of an internal component is possible. The universal Boolean evaluator excluded by PP15 is a stronger requirement.

## Topics

### Related type declarations

- ``CertifiedRuleGenerates``
- ``AmbiguityNamesInput``
- ``SelfPlaySaturates``
- ``SecondEncodingIsNovelty``
- ``TowerSelfPlay``
- ``PlayIsProof``
