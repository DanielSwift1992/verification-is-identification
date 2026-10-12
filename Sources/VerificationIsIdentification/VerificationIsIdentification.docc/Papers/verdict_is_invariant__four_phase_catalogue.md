# Verdict Is Invariant (Correspondence) — Four phase catalogue

This part contains the original derivations for four phase catalogue.

Family and original section headings: <doc:verdict_is_invariant>.

Section setting: <doc:verdict_is_invariant#6zzd-Available-interventions-constrain-the-hidden-carrier>.

## Detail: §6zzj. Twelve actual words supply the complete four-phase ambiguity

VC100's twelve possibilities need not be supplied as twelve unrelated tables. Keep the already constructed four-leaf words Z and W of VC99, written in performed order. Their phase actions are Z=(0 1)(2 3) and W=(0 2 3), and both return every stage.

### VC100a

**VC100a (a complete finite word presentation).** The three words Wᵃ and the nine words WᵃZWᵇ, with a,b∈{0,1,2}, realize each even four-phase permutation exactly once. Their two point images at inputs 0 and 1 exhaust all twelve ordered pairs of distinct phase positions.

*Proof.* H={I,W,W²} has three elements and fixes phase 1. Its conjugate ZHZ fixes phase 0. A nonidentity element of either set is a three-cycle, with just that one fixed phase. Consequently H∩ZHZ={I}. If WᵃZWᵇ=WᶜZWᵈ, multiplying by the appropriate inverses puts an element of H equal to an element of ZHZ; both must be I, hence a=c and b=d modulo three. None of those nine words lies in H: otherwise Z would lie in H, whereas Z has order two. The twelve actions are distinct and even. There are exactly twelve even permutations of four positions, as in VC99a, so this is the complete class. VC100 then makes the two point images distinct for different actions. The explicit actions are:

| Word | Image of 0 | Image of 1 | Image of 2 | Image of 3 |
|---|---|---|---|---|
| I | 0 | 1 | 2 | 3 |
| W | 2 | 1 | 3 | 0 |
| WW | 3 | 1 | 0 | 2 |
| Z | 1 | 0 | 3 | 2 |
| ZW | 1 | 2 | 0 | 3 |
| ZWW | 1 | 3 | 2 | 0 |
| WZ | 3 | 0 | 2 | 1 |
| WZW | 0 | 2 | 3 | 1 |
| WZWW | 2 | 3 | 0 | 1 |
| WWZ | 2 | 0 | 1 | 3 |
| WWZW | 3 | 2 | 1 | 0 |
| WWZWW | 0 | 3 | 1 | 2 |

Each row follows by composing the two supplied actions; it is not the output of a permutation search. Each ordered distinct pair occurs once in the first two image columns. ∎

`PhaseWordCatalogue` presents the actual compositions on arbitrary symbolic labels and derives all twelve output tuples without asking for their values as generic premises. `FourLeafJointZ` and `FourLeafJointW` compose each stage contact beside its corresponding phase contact, retaining K at every boundary. The joint catalogue uses those coupled words. This is stronger than pairing two independently chosen final permutations after their answers match.

The table describes actions before it describes an observer's acquired facts. An internal phase marker at the returned center is not itself a stage reading. The resident continuation below exposes its position through a leaf, and its two actual preparations retain one common law. A final stage fact does not also carry the unknown word's expression as an implicit answer: the word and its instructions remain outside the available fact.

Decoding the two images may choose the canonical word in this table, but it identifies the phase action, not which word the unknown source performed. Additional returning words can change a command history without changing that action. Correspondingly, rejecting a different Path in the direct court and accepting it as equivalent for this action question are compatible: their questions preserve different relations. The action quotient does not identify execution history, word length or physical duration.

### VC100b

**VC100b (two acquired facts identify the resident law in this catalogue).** Supply two probes prepared at the center with respective phase markers 0 and 1, the fixed resident U of VC95a, and one address L selecting an actual word from VC100a's complete catalogue. The source retains L across both invocations. After each invocation, apply U and record only the resulting stage address. The two acquired facts determine L. One such phase-image query cannot identify all twelve possible addresses.

*Construction.* Each word returns the center and sends the prepared phase i to p(i). The actual resident U then selects contact p(i), placing the stage at that leaf. Its new internal phase is not the recorded answer. Thus the two stage facts contain p(0) and p(1), with one common stage-reading question. VC100a proves that their ordered pair identifies exactly one admitted action. The fixed decoder table, whose entries are actual catalogue addresses, is

| First / second reply | 0 | 1 | 2 | 3 |
|---|---|---|---|---|
| 0 | — | I | WZW | WWZWW |
| 1 | Z | — | ZW | ZWW |
| 2 | WWZ | W | — | WZWW |
| 3 | WZ | WW | WWZW | — |

One query has only four possible stage replies for twelve admitted laws, so it cannot distinguish them all. Two suffice by the twelve distinct cells. A diagonal pair is incompatible with the fixed-permutation contract; it is not an additional identified law. ∎

`FourLeafTwoProbe` composes the actual first probe, `FourLeafReserveFocus`, and the second probe at their full intermediate sources. The reserve is already inside the initial source. Focus parks the old probe together with its fact, retains L and both selector programs, and has an explicit inverse. No reset or second independently supplied law is inserted between the observations. `FourLeafAcquiredLaw` retains the fixed decoder table beside each complete path. Its twelve `ReadingFactors` derive equality between the independently specified current-law projection and the decoder reading through the two final facts. The current L is also derived equal to the initial L. `FourLeafReplyDecoder` reads a row and a cell using the existing address readings; its actual input contains only those facts and the fixed table, with no source phase or chosen L.

The code also retains a useful weaker equality: I and W give the same second fact from phase 1. Substituting W for a resident I is nevertheless refused at the actual focus boundary. Agreement of that answer cannot repair the changed source relation. Wrong row selection and treating a diagonal as a catalogue law are refused separately. The fact's question type is identical across all twelve laws and both probes, so it does not encode the answer as a word name.

`FourLeafInstallLaw` continues at the consumer with that actual decoder input and a newly prepared probe. It records the decoder's answer beside its input, installs the recorded address, and retains the acquired facts and decoder table. `FourLeafRecoveredWords` binds the next actual catalogue selection to that installed address. For arbitrary four symbolic labels, its twelve `ReproducesAction` branches derive the phase action previously identified. The consumer checks include input 2, which neither acquisition query read. Choosing another word despite the learned address is refused at selection, including a preparation on which the two words happen to have the same image.

This is reproduction of the acquired action through the supplied library. It does not silently identify that action with a later uncontrolled source whose law may have changed. Nor must every new question acquire the whole law: on a four-slot source whose values are all equal, every catalogue action has the same image. That weaker value question needs no such identification.

The finite joint witness fixes the unused outer laboratory remainder to Never; the word, contact, recording and focus constructors retain their generic interfaces. Generalizing the entire nested witness over that unused remainder caused repeated Swift associated-type substitutions without a verdict and is not needed for the complete twelve-law result. A compiler resource delay was not counted as a mathematical refusal.

The resource count here is two **phase-image queries**, not two primitive contacts. The admitted macro-words have different lengths; their explicit contact compositions and internal selection are supplied by the word-query contract. This construction does not yet derive a primitive instruction-tape interpreter or infer that an arbitrary physical source supplies this contract. It establishes acquisition and reuse for the displayed relations, while VC100a identifies the complete action class those relations present.

### VC100c

**VC100c (the acquisition cost belongs to the requested effect).** Let r≥2, let the unknown law range over all permutations τ of r positions with one known parity, and let each permitted query read τ(i) at a chosen input i. Supply a value tuple x and its equality pattern to the query chooser. Write m for the largest number of positions carrying one equal value. The question is the resulting value tuple y, where y_{τ(i)}=x_i, rather than the route of each separately identified occurrence. Its exact optimal worst-case number of point queries is

    min(r−2, r−m).

If parity is not supplied and all permutations are admitted, the number is r−m. These counts allow adaptive choices and count distinct queried inputs.

*Upper bounds.* Query every input outside a largest equal-value class. There are r−m such inputs. Their answers locate those values, and every remaining output position must carry the common value of the unqueried class. Alternatively, with known parity, r−2 queries recover the complete law by VC100. Both constructions use the actual replies, not the unknown law as an additional decoder input.

*Lower bound.* Consider any reached transcript using t<min(r−2,r−m) distinct queries. At least three inputs remain unqueried, and their values cannot all agree, since r−t>m. Choose three unqueried inputs containing two different values, and cycle these three inputs before applying a law τ consistent with the transcript. This changes the resulting value tuple, preserves parity, and preserves every acquired reply. The same transcript therefore cannot determine the requested effect. Adaptive choices do not help: they are identical along this shared transcript. Without known parity, a transposition of two differently valued unqueried inputs supplies the corresponding lower bound t≥r−m. ∎

More locally, after a consistent transcript under known parity, completion of this value question is unique exactly when at most two inputs remain or all remaining input values agree. Thus parity saves one query in the optimal experiment from no prior point replies exactly when all supplied values are distinct. If a value repeats, the optimal value-question strategy already leaves that repetition unread. This statement does not claim that parity never helps after an independently imposed, less useful choice of earlier queries.

There is a related distinction between the number of possible answers and their acquisition cost. If an input value repeats, exchanging two equal inputs reverses a law's parity without changing its entire value output. Every multiset layout is consequently attainable with either prescribed parity. If the value multiplicities are m₁,…,m_k, there are exactly r!/(m₁!⋯m_k!) such outputs. This count does not determine the query cost. For seven positions, the equality patterns (4,1,1,1) and (3,2,2) each give 7!/24=210 possible value outputs, but require respectively three and four point queries by the proved criterion. The law family and point-query instrument are the same. The relation between each question and that instrument, not only the cardinality of its answer space, fixes the cost. The first strategy reads its three singly occurring values. The second must read the four positions outside its triple; these readings also distinguish the destinations of equal-valued inputs that the final value question does not distinguish.

If the law is additionally sampled uniformly from its prescribed parity class, the two examples also have identical answer entropies. For each fixed value output, the laws producing it differ exactly by permutations within the input equality classes. There are m₁!⋯m_k! such permutations. Exchanging two equal inputs pairs their even and odd members, so exactly half have the prescribed parity. The two examples therefore each have 12 laws per output: 4!/2=12 and 3!2!2!/2=12. Their 2520 even laws induce 210 equally likely outputs, giving H(Q₁)=H(Q₂)=log₂210.

Nevertheless their optimal zero-error expected point-query counts are three and four, just as their optimal worst-case counts are. The lower bound above rules out early completion on every consistent transcript, not just one difficult branch; the attaining strategies use exactly their respective bound on every branch. Thus the distinction is beyond the comparison between an average uncertainty measure and a worst-case cost. Even identical answer distributions do not determine acquisition cost through the declared instrument. Uniform sampling is an additional premise of this entropy comparison, not a consequence of the source relations; the deterministic query bound did not require it.

For VC100b's twelve even laws and a supplied tuple (A,B,B,B), one query at input 0 suffices. Replies 0,1,2,3 give respectively (A,B,B,B), (B,A,B,B), (B,B,A,B), (B,B,B,A). The compatible address classes are respectively {I,WZW,WWZWW}, {Z,ZW,ZWW}, {W,WZWW,WWZ}, and {WW,WZ,WWZW}. `PhaseWordCatalogue.Outputs` already derives their action on arbitrary symbolic labels; this substitution identifies the value effects while retaining three possible laws in each class. The existing two-probe resident pipeline acquires the full law. `Checks/FourLeafValueQuestion.swift` composes `ReadRecordedAnswer` on each actual first-probe fact with the existing addressed reading of the supplied four-output value table. For arbitrary A,B, all twelve decoded tuples equal the independently derived word actions. The same full first fact is admitted for I and WZW, while identifying their actions on four distinct labels is refused. Selecting a row inconsistent with that actual fact is refused separately. These checks establish the one-fact value decoder at this interface.

The resident continuation is supplied by `FourLeafOneFactRoot` and the twelve paths in `FourLeafOneFactWords`. The actual first probe is followed by an invertible reassociation: its original source, prepared reserve and full reply table are parked behind the new consumer's program. Only its acquired fact and a fixed four-entry table enter `FourLeafEffectDecoder`. The table selects respectively I,Z,W,WW at the four observed addresses. The existing installation and root-bound selection apply that representative to one marked value and three equal blanks. All twelve resulting phase values agree with the original laws' value effects.

`FourLeafParkEffect` then reassociates the completed source to recover the original source and first fact. The used payload, representative and its decoding record remain in a separate resident remainder. Both reassociations derive their explicit inverses. `FourLeafRefinedInquiry` continues from that actual endpoint with the existing reserve focus and only the second probe. Its twelve lifted factors decode the original law from the two actual facts; they retain the first fact and the already completed value effect. `Checks/FourLeafQuestionRefinement.swift` composes these readings with `RecordReading` at the same endpoint. It records the recovered law while retaining the complete source, using the same law question across all cases.

In particular WZW first installs I for the weak question and later recovers WZW for the law question. Their agreeing first facts and weak outputs do not identify these two roles. Replacing the parked source by I is refused at the actual reserve-focus boundary. Likewise, executing WZW when the resident selector chose I is refused even though their weak value outputs agree. That refusal concerns the selected operation contract, not a claim that WZW has the wrong value effect.

The full resident witness fixes the marked tuple and unused remainder; the reassociations, consumer root and phase-word equations retain their generic interfaces. The declared strengthening is from this value question to the law question. Its additional cost is one phase-image query; recording and reading existing facts do not count as new queries of the unknown law.

An unknown future tuple does not supply its equality pattern to the present chooser. A uniform guarantee for every future tuple must include the all-distinct case and still needs r−2 queries with parity, for the same fixed law. Likewise, equal values may belong to distinct occurrences: a question retaining each occurrence's destination is the law question and does not receive this reduction. The saving comes from the declared question and available source relations, not from discarding a distinction that the question still uses.

### VC100d

**VC100d (additional acquisition after a question changes).** Retain VC100c's fixed law, point-query instrument and known parity. Suppose a consistent transcript has already read an input set J. Let U be the unread inputs, u=|U|, and let m_U be the largest equality class of the newly requested payload restricted to U. For u=0 put m_U=0. The exact number of additional point queries needed to determine the new value output is

    min(max(0,u−2), u−m_U).

This is a conditional count at the actual transcript, not permission to reuse replies after the law changes.

*Proof.* The images of J and their carried values are already known. All remaining completions are bijections from U to the unused output positions; two such completions of the prescribed parity differ by an even permutation of U. Read U outside a largest new equality class, or read all but two remaining inputs and complete using parity. These use respectively u−m_U and max(0,u−2) additional queries. Below both bounds, at least three inputs remain unread with at least two different new values. A three-cycle on those inputs preserves the complete old and new transcript and parity but changes the new value output. This applies at every adaptive branch. ∎

The first experiment can be optimal for its question without being an optimal prefix for a later, stronger question. Write P for the first input equality partition and Q for a refinement: every Q-class lies within one P-class. Reading the Q-value output determines the P-value output by the fixed merging of its labels. Thus this is an actual strengthening of the question, not an unrelated task.

Let M≥3 be the largest P-class size. Every transcript completing P in its optimal r−M queries leaves exactly one entire largest P-class C unread. Indeed, M inputs remain; VC100c requires all of them to have the same P-value. Put c_C=max{|D|: D is a Q-class contained in C}, and put m_Q=max{|D|: D is a Q-class}. Applying the conditional bound above, optimal completion of Q after that transcript takes r−max(2,c_C) queries in total. Acquiring Q directly needs r−max(2,m_Q). The exact excess for this prefix is

    max(2,m_Q) − max(2,c_C).

Consequently an optimal first experiment has a continuation with no excess exactly when its unread C contains a largest Q-class, or all Q-classes have size at most two. If several largest P-classes exist, choosing among them can matter even though their first-question costs agree. For M≤2 both the first and refined questions already require r−2 queries.

For a forced example, use seven positions and the two payloads

    P: (A,A,A,A, B,B,B),
    Q: (a,b,c,d, B,B,B),

where a,b,c,d,B are distinct and the fixed merging sends a,b,c,d to A. The only three-query completion of P reads the three B inputs: any other three-query transcript leaves four inputs with different P-values. After these actual replies, Q has four unread, pairwise distinct inputs. It requires two additional queries. Every optimal first-question experiment therefore needs five queries in total to answer Q. Acquiring Q directly reads a,b,c,d and needs only four. No reply became false, and no previous fact was erased; the additional cost comes from which relations the first question made it optimal to acquire.

The excess is not bounded by one. With r=2M−1 and M≥4, take P-classes of sizes M and M−1; refine the first into singletons and leave the second intact. Every optimal first experiment costs M−1, its completion of Q costs another M−2, while Q alone costs M. The excess is M−3. This does not say that retaining knowledge harms a fixed question: VC100d's additional cost never increases when another truthful reply from the same law is supplied. It distinguishes that monotonicity from optimality of the earlier choice of questions.

Even a reply which strictly narrows the possible value outputs can leave the necessary number of further queries unchanged. For the seven-position pattern (4,1,1,1), reading one input from the repeated class fixes one of its output positions. The possible value outputs fall from 210 to 6!/3!=120: the other three repeated values still permit either parity. But six inputs remain, with largest equal-value class three, so three further queries are still necessary. Reading a singleton instead leaves largest class four and requires only two further queries. Both replies provide true new distinctions; their contribution to this acquisition objective differs. No probability prior is needed for this comparison.

### VC100e

**VC100e (successive refinement has a sharp relative bound).** Keep the same fixed permutation, known parity and point-query instrument. Supply a finite sequence of value questions whose input equality partitions refine one another. At each stage retain every previous reply and use an optimal additional experiment for the current question as in VC100d. Question selection supplies no additional information about the unknown law.

Let C be the resulting total number of distinct point queries, and let C* be the optimum for the final question supplied from the beginning. Then

    C ≤ 2 C*.

If C*=0, C=0. For C*>0 the ratio is strictly below two, but no smaller uniform factor works for all finite instances. The bound holds along every transcript; it does not assume a distribution of laws or future questions.

*Proof.* Write U for the current unread set. If its largest class under the next question has size m≥3, an optimal additional experiment leaves exactly one entire largest such class unread. If m≤2, it leaves two inputs and the whole law is determined by parity. Thus C≤r−2.

Choose a largest final equality class D, of size d. If d≤2, C*=r−2 and the procedure is already optimal. Suppose d≥3. If no input in D is ever queried, the final unread set is exactly D, so C=C*=r−d. Otherwise consider the first stage which queries any input of D. Just before that stage all of D is unread and lies in one class of the current question, because the questions refine toward the final one. The optimal experiment keeps a different class whose unread size is at least d. Those two disjoint sets imply 2d≤r. Hence

    C ≤ r−2 ≤ 2(r−d)−2 = 2C*−2.

Finally VC100d's family r=2M−1 has C=2M−3 and C*=M. Their ratio approaches two as M increases, with a unique largest first class, so tie-breaking cannot remove this limit. ∎

For fixed r≥3 the sharp deterministic guarantee is more precise:

    R_r = max(1, (r−2)/ceil(r/2)).

Local optimal acquisition attains C≤R_r C*. In the proof above, every nonoptimal case has d≤floor(r/2), hence C*≥ceil(r/2), while C≤r−2. For r=3,4,5 this means every such sequence is already globally optimal. The first possible excess occurs at six positions.

No deterministic policy which must answer each question before seeing the next can improve this worst-case guarantee, even by deliberately taking extra early measurements. For r≥6 first supply two equality classes of sizes ceil(r/2) and floor(r/2). On completing that question, any correct transcript has either at most two unread inputs or all unread inputs in one class. In the first case stop: the policy has spent at least r−2 queries against an optimum floor(r/2). In the second case refine that unread class into singletons and keep the other class intact. Finishing then requires at least r−2 queries in total, while the final optimum is at most ceil(r/2). This gives the required lower bound. The next question depends only on the already visible query history; it supplies no additional information about the unknown law. For r≤5 the lower bound one follows from any question requiring a query. ∎

If all future questions are supplied before acquisition, their joint question can be acquired optimally from the start; the bound concerns unavailable future requests. For unknown parity the same argument, with the last two unread inputs replaced by the last one, gives max(1,(r−1)/ceil(r/2)); its first excess occurs at four positions.

The same guarantee covers an arbitrary sequence of these value questions when the benchmark retains **all** requested answers. For payloads x¹,…,xᵏ, form the joint value at input i as

    z_i = (x¹_i,…,xᵏ_i).

Transporting z by the common law is equivalent to supplying every requested value output at their shared output coordinates. The equality classes of z are the intersections of the individual equality classes. If their largest size is m_joint, the exact optimal joint acquisition cost is

    C_joint = r−max(2,m_joint).

Apply VC100e to the cumulative joint questions. They refine at each step, regardless of whether the individual next question refines the last one. Since the retained transcript already determines the earlier answers, obtaining the next answer is equivalent to completing the new joint answer; their optimal additional query costs agree. Thus locally optimal sequential acquisition satisfies C≤R_r C_joint, with the same sharp finite-size bound and uniform factor two.

Individual costs do not determine this joint cost. On seven inputs let both questions have pattern (4,1,1,1), so each individually needs three queries and admits 210 value outputs. If their repeated classes intersect in k inputs, every other joint class is a singleton, so m_joint=max(1,k).

| Common inputs in the two repeated classes | Joint query cost |
|---:|---:|
| 4 | 3 |
| 3 | 4 |
| 1 or 2 | 5 |

The questions refer to the same actual input positions and the same law; that correspondence supplies the intersection. Their separate answer counts and separate optimal costs cannot supply it.

`ZipFourQuestions` expresses the alignment as an invertible reassociation of two supplied four-slot tuples into four paired values. `JointPhaseQuestions` derives, for arbitrary component values, that the actual W and Z generators commute with this pairing: acting on the pairs equals pairing their actions on both components. Composition preserves the equations, so the same relation applies to their generated phase actions. The consumer refuses to replace one component's W action by Z. Separate admissibility of both component operations does not establish a common action.

For a benchmark containing only the final answer, refinement remains essential: otherwise the benchmark omits previously requested answers. Both bounds require the declared point instrument and retained facts from the common law. Local minimal acquisition can have an unbounded additive excess while retaining the stated relative bound.

Retaining the measured facts is stronger than retaining only the current answer. On four inputs, an optimal two-point acquisition for (A,A,B,B) already determines the whole even law. But its value output alone leaves two even laws per answer. At output (A,A,B,B) these are I and Z=(01)(23). They disagree on the refined payload (a,b,B,B). The already acquired two point facts answer that refinement without another unknown-law query; the compressed value answer does not. If only that answer is accessible and additional access is restricted to point queries, exactly one more query distinguishes I from Z. Access to a retained original point fact can instead restore the needed distinction without measuring the law again.

The static consumer `CurrentValueOmitsAcquiredDistinction` derives the equal earlier value outputs, while `RetainedFactsAnswerRefinement` uses the existing acquired-law consumer to derive the differing refined outputs. This concerns the available reading of memory. It does not assert that forming the value answer destroys the underlying source or archive.

## Cross-page mentions

Labels mentioned here: <doc:verdict_is_invariant__local_lifts#VC100>, <doc:verdict_is_invariant__local_lifts#VC95a>, <doc:verdict_is_invariant__local_lifts#VC99>, <doc:verdict_is_invariant__local_lifts#VC99a>.

Mentions of this page’s labels: <doc:permanence_is_resistance__reusable_requests> (VC100c), <doc:verdict_is_invariant__action_interfaces> (VC100d), <doc:verdict_is_invariant__action_interfaces> (VC100e).
