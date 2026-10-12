# Verdict Is Invariant (Correspondence) — Finite policies

This part contains the original derivations for finite policies.

Family and original section headings: <doc:verdict_is_invariant>.

Section setting: <doc:verdict_is_invariant#6zy-Finite-distributed-policies-with-shared-local-choices>.

## Detail: §6zy. Finite distributed policies with shared local choices

The recursion of VC31 concerns one observer's uncertainty. Choosing separate successful continuations at globally distinct nodes need not respect the equal local inputs of a distributed executor. Fix instead a horizon H, a declared finite nonempty initial domain D, finite nonempty command alphabets, and a scheduled order of participants that is locally known. Any phase used in a local view must be supplied by that schedule or an actual memory transition. The verifier's global node address is not an input. Sending, stopping and returning an answer are commands subject to the same access restriction. A send command includes its transmitted symbol and a return command its returned value; alternatively their production must be an actual local reading checked against that same view. A constant instruction named Send or Return cannot conceal source-dependent content. Fixed transmission slots and explicit symbols prevent uncounted signaling by timing or silence in this fragment.

Assume the declared transition relation is finitely branching through H. It gives action availability, all possible outcomes, and actual updates of the participants' local records. Its finite unfolding is sufficient here; no finiteness claim about the physical whole follows. Keep the original target q(x₀) as a verifier annotation. It is not inserted into any participant's view. For each unfolded history h at a decision by participant i, let V_i(h) be that participant's actually available input, and let L_i be the finite range of these views. A proposed policy is one total table π_i:L_i→U_i for each participant, with one entry for each identical local input wherever it occurs. A past observation belongs to V_i(h) only if a retained local record or another declared access supplies it. The verifier's ability to reconstruct h does not grant the participant perfect recall. Full local history is one permitted view when its retention is part of the contract; it is not the default meaning of L_i.

### VC90

**VC90 (a bounded joint policy criterion).** A deterministic distributed procedure meeting the declared legality, original-answer and horizon requirements exists exactly when one joint family of those local tables passes every execution from D, including every permitted outcome. The criterion has the following finite construction, which preserves dependencies between branches.

Unfold all commands and outcomes through H before selecting a policy. Include a bad absorbing outcome for an unavailable command or a nonterminal dead end. A required reply that never arrives within the promised horizon cannot produce a successful leaf. Pad completed executions by verifier identity steps; this padding grants no new observation or action to a participant. A successful leaf must represent an actual locally chosen completion with output q(x₀); an unfinished leaf at H is bad.

Use one table variable P_(i,ℓ)∈U_i for every local input ℓ of participant i. For a complete unfolded path γ, let its guard be

    g_γ(P) = ∧ [P_(i,ℓ) = u]

over the actual participant decisions along that path. The local input ℓ=V_i(h) is computed from the declared access at that prefix h, not chosen freely for the guard. Erased local observations are not silently restored from the path. For every unsuccessful leaf impose ¬g_γ(P). Equivalently, each full path satisfies g_γ(P) ⇒ successful(γ). The resulting finite constraints are satisfiable exactly when the required local procedure exists.

**Proof.** Given satisfying tables, execute their selected command from each actual local input. The unfolding contains every successor, including failure, so no actual path disappears. The guard of every actual complete path holds. Its constraint excludes failure, unfinished execution and a wrong original answer; therefore every execution is legal and completes correctly by H. Repeated local inputs consult the same table entry even at distinct global nodes.

Conversely, a locally executable deterministic procedure within this contract assigns one command to each reached local view. Extend its tables arbitrarily to unreached views using the nonempty command alphabets. A path whose guard holds agrees with those tables at every decision and is consequently an actual execution, including its declared possible outcomes. All such paths succeed, so every unsuccessful path has a false guard. These extended tables satisfy the finite constraints. ∎

The guards prevent unreachable branches from creating false impossibility. They do not delete troublesome outcomes of a reached action: those outcomes remain separate guarded paths with the same selected action. The bad outcome prevents choosing an undefined action to satisfy an empty universal check. An inconsistent path demanding different commands at the same local input has a false guard, as it cannot belong to one deterministic local policy. The annotation q(x₀) checks the leaf; it never supplies the executor's answer or branch choice.

**A complete two-record instance of the joint constraint.** Restrict VC89 to one fixed unequal payload pair and the records r_S at seam01 and r_F at seam40. Let e_S,e_F∈{0,1} be the sender's two table entries and J₀,J₁∈{First,Second} the executor's. Success is exactly

    J_(e_S) = Second,     J_(e_F) = First.

If e_S=e_F the same entry would equal both distinct actions, so no interpreter works. If (e_S,e_F)=(0,1), the only interpreter is (Second,First); if (e_S,e_F)=(1,0), it is (First,Second). Thus exactly two of the sixteen encoder/interpreter pairs work. The reply and answer phases are supplied by the actual probe and corresponding local decoder for each record. This is a complete finite classification under these alphabets, not sixteen runs of a search program. Each encoding and each interpreter appearing in a successful pair is individually viable, but mixing the first encoding with the second interpreter fails. Separate existential checks of the two components therefore lose their required joint relation.

Reachability has a different effect. If only r_S is admitted and its encoder sends 0, only J₀ must be Second. Both legal values of J₁ are permitted because that row is never consulted. `LocalSecondForward` accordingly requires only the zero row of the actual resident J; `LocalContactCycle` requires the other row when seam40 is also admitted. Requiring the unused row to solve r_S would reject a working local procedure. Conversely, permitting J₀ to change between globally different occurrences with the same received 0 would accept a procedure that the local input cannot execute.

**Retained history and the original question.** `LocalExchangeFromFirst` and `LocalExchangeFromSecond` now compose the known internal port exchange with the complete request, acquisition and return. They answer the original endpoint question at both initial endpoints; the displaced port remains inside the reserve and is not a decoder input. The changed-source return and an unchanged source can nevertheless give identical complete receiver facts with unequal original answers. If the intervention relation is not fixed or locally retained, these facts cannot select the two different decoders. A verifier recording which history occurred cannot use that record as a participant input. The distinction remains in the whole; the failure concerns this declared access and does not prohibit another actual contact with the reserve.

This is a finite existence criterion and an exhaustive mathematical search space, not an efficient synthesis claim. An impossibility conclusion is relative to H, the alphabets, schedule and declared access. It does not exclude longer protocols. A compact constructive proof may discharge these finite obligations without enumerating every table; it must still cover every allowed choice relevant to its lower bound. The concrete Swift consumer must establish its actual lookup and transition laws, rather than accept an arbitrary conformance naming those endpoints.

The dependency restriction has an established counterpart in Henkin synthesis: each synthesized output is a function only of its declared inputs. [Golia, Roy and Meel, *Synthesis with Explicit Dependencies*, §II](https://www.cs.toronto.edu/~meel/Papers/date23.pdf) states that function-synthesis problem. Here the declared protocol also supplies the local views, reachability, action effects and original-answer obligation. No equivalence to a particular solver or its performance is inferred from the correspondence.

## Detail: §6zz. What a returned bit must preserve

Returning a full probe fact and returning its binary value are different interface contracts. The former also carries the coordinate question. To remove that field, keep the actual question's local interpretation. In the fixed policies of VC89, the receiver knows its old record and the request rule. These determine which coordinate was requested. The missing question address can therefore be reconstructed locally. If the request rule is allowed to vary without preserving that distinction at the receiver, the same argument no longer applies.

`ContactReplyCarrier` supplies a separately prepared return channel with a fixed address. It reads the payload of the filled probe instrument into that carrier, retains the original instrument at the executor, and moves only the new carrier to the old record. Both preparations and every intermediate whole are explicit. The carrier's channel, phase and prior memory are constant across the five-port family; its two filled states vary only with the returned bit. `Recover` reconstructs the original fact under a fixed coordinate law. `PairedFactorization` combines the endpoint recoveries. `AnswerOnSourceRecovery` then composes their decoder with the original endpoint decoder: its premises bind the actual initial source and recovered old observation, without asking for equality of final answers. Each `Proof` in `ContactBitCycle` supplies that construction, including both allowed actions on seam34. Forming a fact with an arbitrary question label alone would not establish its applicability.

**A boundary on pooling these policies.** On seam34, First at p₃ returns 0 and requires a; Second at p₄ also returns 0 and requires b. The old record is the same. Each respective fixed request policy works, but the complete reduced receiver inputs coincide across these two policies when their difference is omitted. For a≠b, no common decoder of that reduced input can return both original answers. This compares two fixed protocol laws. A realization that changes which law is used must carry that controlling distinction inside its whole; excluding it from the receiver's input leaves this collision unchanged. Retaining the actual request or an adequate policy distinction can repair the input. Requiring the receiver to recover every possible metadata field would be stronger than necessary: if the desired answer is invariant under a missing field, that field can remain unresolved. The criterion is still sufficiency for the declared question.

Now fix one distinct payload pair for all five edge records, their endpoint-admission premise, and exactly the two unchanged coordinate probes of VC87. A deterministic protocol has one request slot and one later reply slot. The receiver forms its request only from its old record. The executor starts with no variable port-dependent evidence, can choose probes from the request and its acquired results, and replies using only those available inputs. The receiver's final answer uses its record, its known request rule and the reply. Timing, silence, probe count and instrument addresses supply no extra signal. A one-symbol message may be omitted at its agreed slot. Acquiring or copying already acquired memory is separate from probing the original unknown port.

Let m and n be upper bounds on the numbers of request and reply symbols, and k an upper bound on primitive port probes in the worst case. The alphabets have at least one symbol; k may be zero.

### VC91

**VC91 (the complete resource boundary for this contact family).** A correct protocol under these bounds exists exactly when

    (m ≥ 2 and n ≥ 2 and k ≥ 1)
    or
    (m ≥ 1 and n ≥ 3 and k ≥ 2).

The two minimal triples (request symbols, reply symbols, port probes) are therefore (2,2,1) and (1,3,2).

**Proof.** With no port probe, every input available to the executor and its reply is unchanged between the two endpoints of a fixed record. The required answers differ, so k≥1 is necessary. A constant reply likewise leaves that receiver unable to distinguish its two endpoints, regardless of the request alphabet or number of hidden probes; hence n≥2.

If m=1, the reply is a function of the port's acquired code alone. It is consequently a regime-only calibration in the scope of VC85–VC86. The odd five-cycle requires at least three reply symbols. With at most one probe, the first chosen coordinate is also independent of the old record. First collides at seam01 and Second at seam40, so k≥2. Reading both coordinates supplies the three codes 00,01,10 and the old decoder recovers the requested payload. This attains (1,3,2).

If m≥2, the necessary inequalities n≥2 and k≥1 already give the other region. VC89's two-symbol request selects Second on seams01,12,23,34 and First on seam40. Returning its bit in the fixed channel and interpreting it using the retained record gives the original answer. This attains (2,2,1). Larger budgets can use either construction without using their extra symbols or probes. The two cases exhaust m≥1. ∎

Under a separate fixed-length binary encoding of each slot, both minimal protocols can use two transmitted bits in total: zero request bits plus two reply bits, or one request bit plus one reply bit. The reduction established here is one fewer interaction with the original unknown port. It also requires preparing and communicating a request and handling the acquired reply memory. Alphabet size, total local operations, duration and physical energy are distinct costs; this finite result assigns only the first and the specified probe count.

This boundary combines the existing graph obstruction, action-cover criterion and actual return construction. It covers every allowed policy for the declared two-slot contract; it does not claim an optimal protocol for other instruments, additional feedback rounds or altered source dynamics.

## Detail: §6zza. More time cannot replace an unavailable distinction

VC90's failure at a fixed horizon does not by itself rule out longer protocols. A different certificate can exclude every horizon: show that each choice available at one repeated local input traps the actor in that same input.

### VC92

**VC92 (a local trap that no horizon removes).** Suppose every admitted initial source gives the same complete actor input ℓ, but their required original answers are not all equal. The actor is deterministic; action selection, termination and any reported value depend only on its current available input. For every permitted nonterminal action u, suppose there is a set T_u containing all initial sources, forward invariant under repeated u, throughout which the actor's complete input remains ℓ. There is no correct terminating procedure under that access, at any horizon.

*Proof.* A report at ℓ has one value and cannot answer all initial sources. If the actor instead chooses u at ℓ, invariance keeps every subsequent source in T_u. It therefore receives ℓ again and makes the same choice. It never obtains a different input on which to base a different action or a correct report. These alternatives exhaust the actor's first decision. A verifier's step index is not additional actor memory. ∎

This criterion does not require a finite whole. Its following finite instance also shows exactly how one available internal distinction repairs the trap.

**A closed reversible instance.** Let the whole be

    K = {x,y,z} × {0,1} × {0,1},       state (s,c,β).

The original question is β. Initially s=x and c=0; β is unknown. Operation a exchanges x and y, fixes z, and flips c. Operation b exchanges y and z, fixes x, and also flips c. Both leave β unchanged. Each is an involution on all twelve states. The readout exposes β at z; at x and y it returns one quiet symbol. The stage and the internal phase are initially excluded from the actor's input. No action word, elapsed-step counter, timing signal or retained history is available in addition to that readout and the fixed program.

For a, the set {x,y}×{0,1}×{0,1} is invariant and quiet. For b, the set {x}×{0,1}×{0,1} is invariant and quiet. Both contain the two initial states. VC92 therefore rules out every deterministic procedure with this memoryless interface, even though the global word ab reaches z from either initial state. Having a successful word does not supply an internal way to select its next letter.

Now make the already resident c available. Choose a at c=0 and b at c=1 until the readout supplies β. The path is

    (x,0,β) → (y,1,β) → (z,0,β).

Two actions suffice. Neither of the two possible first actions reaches z, so one action cannot suffice under the same source and readout contract. The added control image has two values. Its one-value coarsening is precisely the interface excluded above. Thus one binary internal control distinction is sufficient, and no constant control image is sufficient, for this declared deterministic action and observation family.

All two-row phase policies can also be classified. The rows (a,a) and (b,b) are the two constant traps. Rows (a,b) give the displayed two-step path. Rows (b,a) give x0→x1→y0→z1 and succeed after three steps. These four choices exhaust the two actions at the two quiet phase inputs. A report at either reached quiet input still has the same value for both β and cannot replace a required action. Thus the shortest phase policy and the slower valid policy are both distinguished from the two impossible constant policies.

The two successful policies can share a final answer decoder. They reach different ready phases, z0 and z1, but both read ready(β), which answers the same original β without identifying the program or its path. The phase distinction needed to control acquisition need not be part of the acquired answer's eventual interface. `LocalPhaseOppositeFindsOriginal` constructs the slower path with its actual local choices; `LocalPhaseProgramsShareDecoder` checks equality of the original question, returned image and decoder across both programs. This is a positive counterpart to VC91's policy-dependent bit collision: retain a program distinction precisely where the question needs it.

This feedback law has a total reversible continuation on the same whole. For each β it is the six-cycle

    x0 → y1 → z0 → z1 → y0 → x1 → x0.

The images of the two selected branches have different phase coordinates, as required by VC33. An output with c=1 came from a and is undone by a; an output with c=0 came from b and is undone by b. No extra hidden execution history is needed for this inverse. The successful readout at z is a window, not an absorbing whole state. Stopping the question there does not stop the whole.

For fixed β, the stage reading of this continuation has exactly the six contacts x→x, x→y, y→x, y→z, z→y and z→z. Matter's finite-carrier criterion following M39 therefore requires at least six whole positions. Each stage has two different successors, so its fiber needs at least two positions under one deterministic whole law. The displayed six-cycle attains both bounds. Thus the binary residual reaches the minimum for this exact contact support; its availability to the actor remains a separate relation. The contact graph alone does not prescribe a clock, a probability distribution or an actuator.

`LocalPhaseFirst` and `LocalPhaseSecond` read the actual edge fields of the existing `ReversibleExperiment` restricted to A, Signal and B (x, y and z). Both exchange the two resident phase fields and retain the payload. `LocalPhaseAtZero/One.ActualChoice` ties the controller's actual phase input to the performed primitive. `LocalPhaseFindsOriginal` derives the original payload from the readout after their composed path. This experiment declares its own readout; it does not reuse the old experiment's observation field as an unmentioned stage signal.

Both interfaces induce the same partition of the admitted initial sources: neither distinguishes β=0 from β=1, and the added phase is initially the known constant 0. Nevertheless their discoverability differs. The added coordinate does not answer the original question; it makes different next interactions locally selectable after the source changes. Initial evidence sufficiency alone therefore cannot characterize active discovery. The future reading relations and the controller's retained access matter, as VC19 and VC81 require in their respective continuation contracts.

The limitation is access, not loss from the whole: β and c remain present throughout. Granting a clock, a program counter, action history, a different instrument or a variable instruction stream changes that access. A randomized controller also changes the policy class and needs its own success criterion. No claim here turns one control bit into a universal bound on physical memory, time or energy. The result separates longer iteration at unchanged local input from acquiring a distinction that can change the next interaction.

## Detail: §6zzb. When a bounded check covers every continuation

The finite horizon in VC90 can be removed under a stronger configuration contract. Fix a finite nonempty set C of complete configurations for the declared game. It includes the participants' changing memory and any changing schedule state they actually use. Each local input is a fixed reading V_i(c). One joint table family selects commands from those inputs. The effect of a selected command and its complete set of permitted outcomes depend only on c, not on an omitted execution history. All permitted outcome sequences count; an additional fairness restriction is not assumed. Each primitive must complete its declared step or report. A possibly nonreturning primitive cannot be hidden inside one completed graph edge; this criterion counts command steps and does not assign physical durations.

At an initial configuration the required answer is attached by the verifier. This original-answer tag accompanies the reachability proof, never the actor's input. A report is correct only if it agrees with every original tag that can reach that report through the selected policy. An unavailable command or a nonterminal state with no successor is a failure.

### VC93

**VC93 (a complete finite control configuration supplies a horizon).** In this game, a joint local policy guarantees correct termination on every execution exactly when (i) every reached report is correct, no reached command is illegal and no reached nonterminal state is a dead end, and (ii) its reachable nonterminal transition graph has no directed cycle. Such a policy uses at most |C| commands including the final report. Consequently VC90 at H=|C| is complete for existence of a policy that guarantees termination without a stated horizon in this same finite configuration contract.

*Proof.* If a reachable nonterminal cycle exists, follow a path to it and repeat its edges. Every command remains the one selected at that configuration and every outcome is permitted. This gives an infinite execution without a report, contradicting the guarantee. This argument uses the completeness of c for the successor relation: a repeated label alone would not suffice.

Conversely, a path through a finite acyclic nonterminal graph cannot continue forever. With illegal commands and dead ends excluded, it reaches a report, which (i) makes correct for its actual original source. Before that report, no configuration can repeat. The configurations at successive command positions, including the report position, are therefore distinct, so there are at most |C| commands. The bound holds for every selected table family. Applying VC90 at that bound proves the last assertion. ∎

The graph has the usual finite descending certificate: assign a report rank zero and a nonterminal state one plus the largest successor rank. A finite unfolded tree carries the same descent by proper-subtree inclusion, as §6h already proves. No numerical rank needs to be available to the actor. For distributed control, two nodes with the same V_i(c) must still use the same row of participant i's table; a graph rank does not remove that obligation. This is an application of finite reachability and descent, not a new synthesis algorithm. The VC90 unfolding must keep the same inputs V_i(c); giving each depth its own local row would add a clock or memory absent from C. A finite source file or a finite alphabet of readout names does not establish this configuration bound.

A fairness condition changes the guarantee as well. At a waiting node with a self-loop and an exit, requiring the exit eventually excludes the infinite self-loop while allowing every finite number of repetitions. All fair runs then finish, but their lengths have no common finite bound. VC93 counts every permitted outcome sequence and therefore rejects that reachable loop unless an actual bounded-wait relation removes it.

In VC92 the full whole has a cycle, but the protocol ends at its first ready readout. Removing outgoing protocol edges there leaves the nonterminal chain y0→x1→x0→y1→z0, with z0 a report position. The other ready phase z1 also reports immediately. A cycle of the whole is therefore compatible with termination of this question. For either blind constant policy, a quiet two-cycle remains reachable from x0 and supplies the genuine obstruction. The same twelve configurations support both tests; it is their permitted local policies that differ.

For a sufficient success certificate, knowing every configuration is stronger than necessary. A reading into a finite acyclic progress graph suffices if every actual nonterminal step follows its edges, all admitted executions are covered, and each reached terminal has a source-bound decoder for the original question. There must also be no reached illegal command or nonterminal dead end. The graph bounds the number of steps even if the whole has infinitely many configurations. It can omit payload details and need not be available to the actor. Local selection and terminal correctness still need their own relations. Completeness is required for the converse exclusion, since a cycle introduced by an overapproximation may have no common-source realization.

**Why a finite readout alphabet supplies no such bound.** For every n≥2 and β∈{0,1}, take a cycle with states (n,j,β), 0≤j≤n. Its one available operation increments j modulo n+1. At j=n the local readout is ready(β); elsewhere it is quiet. The prepared initial sources have j=0, with n and β unknown. The question is the original β. Both n and β remain within the whole, and the operation is a bijection. One constant local rule works for every source: advance while quiet, then report the displayed β. It finishes after n advances and one report, but has no uniform finite horizon over these preparations.

The three readout values and their contact support do not count complete configurations. In particular, a quiet→quiet edge does not permit repeating that same edge forever at a fixed initial source: its hidden phase changes. Replacing the source by this finite contact graph adds an execution that the original configuration does not realize. An acyclic overapproximation can certify success; a cycle in an overapproximation need not prove failure of the actual game.

**Even all finite observation words can miss the difference.** Call the cycle family above A. Form B by also admitting two configurations b₀,b₁, with U(b_β)=b_β, readout quiet and original question β. These are alternative configurations in the same declared whole, not additional exterior objects. Both systems are reversible and every individual orbit is finite.

For every finite horizon H, their sets of possible readout prefixes of length H+1 from the prepared domain are equal. The only prefixes added by b₀,b₁ are quiet repeated H+1 times. Such a prefix already occurs in A by choosing n>H. The reverse inclusion follows because every preparation of A is admitted in B. This remains true if prefixes are grouped by their verifier-only original β tag. In particular, their exact one-step supports also agree.

The omitted relation is whether one common initial source realizes all the prefixes along a branch. In A,

    for every H there is an initial source quiet through H,

but there is no initial source quiet for every H. Exchanging these quantifiers would silently add a new admitted source. The pooled word set, even with its prefix-extension links, does not certify that common-source relation.

Yet A has the terminating local rule just constructed, whereas B has no rule guaranteeing a correct report: on b₀ and b₁ every available observation and every advance agree forever, but their required answers differ. More memory of that identical history cannot distinguish them. The property “this declared source family admits a procedure that always eventually answers” therefore does not factor through its set of all finite observation words. This is the finite-compatibility boundary of VC21/VC23 applied to discovery. M34 already exhibits the corresponding boundary for a preserved existence fact: adding its limiting all-zero source changes the given admission rule. The present cycle example applies that distinction to local completion rather than introducing a new compactness principle. It does not say that a theorem about eventual completion is impossible. The equality concerns possible words, not their probabilities or frequencies; the guarantee concerns every admitted source, not an almost-sure event. The obstruction is already one of representation sufficiency: unlimited computation on that same word set cannot choose between A and B.

For A, completion follows from a separate source relation: each admitted configuration belongs to a finite cycle that contains its own ready(β) position. An actual finite word with that marked position and a specified rotation constructs such a relation without assuming a successful run. A finite source-bound path or the complete configuration contract of VC93 supplies other positive certificates. Their adequacy cannot be replaced by counting observed labels or by treating every locally coherent continuation as a realization of one common source. Finiteness of a control description need not assert finiteness of all reality; using it for a larger whole requires an adequate reading for the actions and continuation questions in that game.

## Detail: §6zzc. Transporting a procedure through local contacts

VC52 carries an already specified word. To carry a procedure whose next command depends on what an internal participant sees, the state relation must also meet that participant's actual input. A relation available only to the verifier cannot choose the participant's next action.

Let X be a new game and Y a game with a verified joint policy π. Their complete configurations include the control memory and schedule used in the respective games. Supply a relation Z⊆X×Y with these properties:

1. Every admitted new initial configuration has an admitted old partner in Z. The paired originals satisfy q_X(x₀)=d(q_Y(y₀)), with one supplied local output reading d. The original questions are independently specified.
2. Related configurations give corresponding participants their turns. For each participant i, a supplied local reading e_i satisfies V_i^Y(y)=e_i(V_i^X(x)) on Z. It reads the actual available input; x, y and Z themselves are not extra actor inputs.
3. A supplied local command translation a_i(o,u) maps the selected old command u and actual new local input o to one new command. Whenever u is admitted at a related old configuration, that new command is admitted at x. Every permitted new successor x′ has a permitted old successor y′ under u with (x′,y′)∈Z. A report v translates to a report d(v).

Commands include transmitted contents and stopping decisions. Each translated command completes one declared step, so the translation does not insert an unbounded internal wait. It may have fewer possible outcomes than the old command; every new one still needs the stated old partner. Conditions may be restricted to the cases reached by the particular policy being transferred.

### VC94

**VC94 (local contacts carry a verified bounded procedure).** Under these relations, define the new local policy by

    π_i^X(o) = a_i(o, π_i(e_i(o))).

If π guarantees a correct report within H commands in Y, this new joint policy guarantees the original answer in X within the same number of commands after its related initial preparation. The source relation need not identify a unique old configuration.

*Proof.* Choose an old initial partner for the actual new preparation. At a related pair, condition 2 makes the old policy's input exactly e_i(o). Its command and the translated command therefore depend only on o, including in two globally different occurrences with the same local input. Condition 3 supplies legality and an old partner after every actual new outcome. Induct through at most H command positions, retaining one compatible old execution. That execution reports v by H. Its translated report is d(v), which equals the required original q_X by condition 1 and the old policy's correctness. No verifier-only state or original-answer tag enters either local table. ∎

This is a sufficient transport contract. A global state correspondence or an equal final answer alone does not supply condition 2. A failed proposed translation does not exclude every other new policy. The reverse transfer requires its own local and transition relations. These are the adaptive control obligations added to the existing composition and domain discipline, not a new rule that every pair of games must be equivalent.

**A complete coordinate change in the phase game.** Exchange the two resident phase coordinates and the two program rows together. The old c=0 input becomes the new c=1 input, and conversely. `RenamedPhaseZeroChoice` and `RenamedPhaseOneChoice` derive the old chosen action from the actual changed local input. Their decoders receive the changed phase and table; neither the stage nor the payload is among those inputs.

`RenameLocalPhaseFirst` and `RenameLocalPhaseSecond` supply the two actual commuting squares. Their generic bodies derive equality of the changed successors from the primitive projections and phase exchange, without a caller-supplied equality of output worlds. The three-stage admission and readout-at-z condition are preserved because the exchange leaves the stage unchanged. The payload question is also unchanged.

Consequently the original two-step procedure has the changed-coordinate path

    x1 → y0 → z1,

using the same action word ab under the table (b,a). `RenamedPhaseFindsOriginal` constructs the two actual local choices and derives the independently named original answer. Its final decoder is identical to the old one. The bound counts the commands after the mapped preparation; treating a physical preparation change as a free command is not part of the conclusion.

Changing phase coordinates alone while retaining (a,b) instead selects ba: x1→x0→y1. The two-step readout contract fails. The selected primitive can also change while keeping its old operation label: the commuting output equation then fails. These are separate errors from a wrong final decoder. Conversely, additional available information need not invalidate a policy: a supplied local reading e_i may discard it while preserving the old procedure's actual inputs and step relations.

### VC94a

**VC94a (expansion preserves termination only through its actual internal progress).** Replace each translated command in VC94 by an internal block. Supply its locally executable control, legal primitive steps, and an actual locally recognized return to the next command boundary. Every possible return must have the old successor required by VC94. In addition, every admitted internal execution must return: there is no reached illegal step, nonterminal dead end or infinite internal execution. Then an old procedure terminating within H commands still terminates with the original answer. If every such block, including a translated report, takes at most B primitive commands, the new bound is BH. Preparation, communication and memory updates counted as physical commands are included in these blocks.

*Proof.* The completed boundaries form the old execution constructed in VC94. Each old command is reached after finitely many new steps because the preceding block returns on every admitted execution. At most H blocks are needed. A finite sum of finite block lengths is finite; with the uniform bound B it is at most BH. The final original-answer equation is unchanged. ∎

This combines VC94 with the progress obligation already used in §6h and VC93. A nonnegative integer rank decreasing at every nonterminal internal step, together with legality, absence of dead ends and correct return markers, supplies a sufficient progress construction. The verifier may read that rank; the actor still selects steps from its actual available input. Unbounded ranks over the preparation family can prove eventual return without a uniform B, as the cycle family in VC93 shows. Calling the whole expansion a single primitive does not establish its completion.

Even exact successful endpoint relations and their admission domains are insufficient for the universal guarantee. A quiet internal position can have both a legal self-loop and a legal return with the correct answer. For each input its set of successful returned values is exactly the required singleton, and each input has a returning path. The repeated self-loop remains an admitted nonreturning execution. Domain reflection for successful paths and equality of all returned answers do not remove it. A fairness assumption would change the execution contract. The obstruction concerns completion, not the validity of the answers on the executions that do return.

**An equal endpoint can need a different memory of order.** In VC92, the two words ab and aaab have the same complete *working* endpoint, since a² is the identity there. Starting at x0 they run respectively

    ab:    x0 → y1 → z0,
    aaab:  x0 → y1 → x0 → y1 → z0.

Their final acquired payload and decoder coincide. But the second and fourth commands of aaab both start at the identical working state y1. They require different actions, a and b. No deterministic rule of that working state alone, and hence no rule of its phase-only reading alone, executes this prescribed word. This excludes the proposed execution under that access contract, not the task of acquiring the payload: ab already solves that task.

An additional internal order record permits the longer word. The existing `ResidentBoundaryCommand` reads the actual head of a resident tape, applies the correspondingly named supplied primitive, moves the head to the retained past and exposes the next tail. It now also carries its existing constructed endpoints as a `PredicateReading`, allowing ordinary `SequentialReading` composition. No second transition formula was introduced. `ResidentPaddedPhaseFindsOriginal` uses four such commands. Their actual seams agree, the pending word becomes empty, and all four consumed heads remain in the past. The original payload is read from the initial working field and factored through the actual final window. The controller's two repeated y1 positions now have different available tape heads. Removing their distinction again recreates the incompatible-action obligation.

Thus reducing aaab to ab preserves the chosen working answer while eliminating two actions and the extra order distinction needed for the longer word. It does not identify their complete controller states or their execution histories. The reduction is licensed by the established involution and the chosen endpoint question; a question about that history would not survive it. The shorter construction uses the already supplied phase access of VC92 and a different prepared control law. No physical change of a resident tape is claimed free, and an interface exposing only its next head does not silently gain phase access from this comparison. This is one concrete use of static relations to remove an unnecessary procedure, rather than first building an executor for it.

## Cross-page mentions

Labels mentioned here: <doc:permanence_is_resistance__records_entropy#M34>, <doc:permanence_is_resistance__records_entropy#M39>, <doc:verdict_is_invariant__finite_records#VC19>, <doc:verdict_is_invariant__recovery_memory#VC21>, <doc:verdict_is_invariant__recovery_memory#VC23>, <doc:verdict_is_invariant__discovery_acquisition#VC31>, <doc:verdict_is_invariant__discovery_acquisition#VC33>, <doc:verdict_is_invariant__reusable_images#VC52>, <doc:verdict_is_invariant__relative_questions#VC81>, <doc:verdict_is_invariant__relative_questions#VC85>, <doc:verdict_is_invariant__relative_questions#VC86>, <doc:verdict_is_invariant__relative_questions#VC87>, <doc:verdict_is_invariant__relative_questions#VC89>.

Mentions of this page’s labels: <doc:verdict_is_invariant__local_lifts> (VC90), <doc:verdict_is_invariant__local_lifts> (VC92), <doc:verdict_is_invariant__local_lifts> (VC94a).
