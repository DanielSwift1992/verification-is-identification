# Acquisition Keeps Its Question

## Question

What must an experiment leave for the next action to meet the original requirement?

An acquired fact concerns an actual source. The experiment may also change that source. The next action therefore uses the fact together with the reached state. A truthful reply is sufficient only where their actual relation makes it sufficient. The original requirement remains attached to this continuation.

## Result

One choice works at an available input exactly when that choice is allowed at every compatible reached state. The choice can be a whole program or one autonomous contact acting on unknown contents. Recovering the complete source or its law is unnecessary when such a common choice is available. Its availability and application must be proved. Naming the intersection of adequate choices does not acquire them.

## The law

Let X be the declared full initial conditions and Y the full states reached by an admitted experiment. Let F⊆X×Y be its actual source–residue relation. Each admitted initial condition has an outcome, and every admitted outcome is included. F can be the graph of one available program. No probability distribution is assumed.

Let E:Y→M give the complete variable input to the choice of continuation. Any further input that changes this choice belongs to M. Let A contain declared operations or programs with their actual laws. One chosen operation can have different physical results on different unknown contents. That dependence belongs to its law.

For (x,y)∈F, let W_(x,y)⊆A contain the continuations that are available from y and meet the original requirement attached to x. Their actual results must retain the stipulated residue and access. If the task requires completion, every admitted execution must complete. Correctness of possible final states alone does not prove completion. These conditions define W_(x,y). The definition proves none of the action laws.

For each reached input m, write

    S_m = {(x,y)∈F : E(y)=m},
    W_m = ⋂_{(x,y)∈S_m} W_(x,y).

**Adequacy.** A response relation R⊆M×A is adequate on F exactly when R(m)⊆W_m at every reached m. An adequate response relation with a nonempty response set at every reached input exists as a mathematical relation exactly when every W_m is nonempty. The largest relation is m↦W_m. A selected and executable continuation additionally requires a supplied choice d(m)∈W_m and its realization.

*Proof.* An admitted continuation at m must work for every pair producing that same complete input. It therefore belongs to each W_(x,y). Conversely, any member of their intersection meets the requirement at every such pair. This is the adequate-response law following Matter M25, applied to F. Verdict VC100i already applies VC89 to a library of whole programs. The argument does not enumerate the initial conditions or compute every later step.

**Reading an answer.** If the continuations are answer declarations with W_(x,y)={q(x)}, a nonempty adequate response at m exists exactly when

    S_m≠∅ and {q(x):(x,y)∈S_m}={a_m}.

This is Verdict §6c on the actual acquisition path. The original answer is unique. The initial and reached states need not be. A question about the changed source serves this answer only after its return to the original question has been proved (VI U4).

**Acting without an intermediate reading.** When E is constant, one provided continuation works precisely when it belongs to every W_(x,y). Its law can use unknown contents. This is a common program, not a constant physical output. A larger supplied program library can admit such a choice where a smaller library does not.

**Continuing after acquisition.** A retained reply need not remain sufficient after the experiment changes y. Restoring its applicability means restoring the relation needed by the next action. It need not restore the whole source. Further use must cover the actual successor states. A valid reply does not provide unlimited retention or repeated applicability (Matter M22).

## Three instances and one boundary

In Matter M64e, the unknown law ranges over a finite permutation group G. A subgroup H≤G defines the question r∈H. One point-observation port i and known right movements from a provided L≤H give access to the orbit O=L·i. Acquisition is possible exactly when the residual stabilizer G_O lies in H. After a suitable query set Q, all laws in rG_Q have the same membership answer even when the law remains unknown. A fixed port can instead leave opposite answers compatible forever. Preserving the question alone does not supply the missing access.

In Verdict VC100c, the unknown law τ ranges over all permutations of r≥2 positions with one known parity. Each permitted query reads τ(i). The value tuple x and its equality pattern are supplied to the query chooser, and the question is the resulting value tuple, not τ. Let m be the size of a largest equal-value class. Queries outside that class can determine the effect without identifying every route. The exact worst-case count is min(r−2,r−m). Two seven-position patterns each have 210 possible value outputs but need three and four point queries. The actual access relation belongs to the acquisition cost.

In Verdict VC100l, the first probe reply is truthful but has already advanced the shared clock. A legal lookup at that seam can consequently perform the wrong action. Two further contacts return the clock and make the very same retained reply applicable. The probe residue remains changed, and two initial clocks remain unidentified by the reply. The experiment proves the required continuation under its supplied preparation and refocusing contract.

Verdict VC100j gives the boundary to compulsory identification. In its acquired frame, W=(acd) and one unknown but fixed Q∈{(bac),(bad)} admit the performed words QQWQW and QQWWQWW. They act respectively as Q₁ and Q₂ under either law without intermediate readout. Their proof uses the actual joint relations. Separate periods of W and Q would not establish the words. The full working contents participate in the common action.

## Scope

The law connects the original requirement, the acquired input and the actual residue. It neither manufactures the experiment nor adds an operation to an old interface. Different adequate responses can coexist. There need not be one coarsest adequate reading (Matter M25). The criterion certifies adequacy in the stated class. Performing and continuing the action remain part of the requested work.

## Dependency

| Source | Used |
|---|---|
| Matter | M22 (further use), adequate-response law following M25 (adequate responses and their greatest relation), M64e (the orbit acquisition criterion) |
| Verdict | §6c (exact answer factorization), VC89 and VC100i (adequacy for a library of whole programs), VC100c (point queries with supplied parity), VC100j (one common word on unknown contents), VC100l (continuation after refocusing) |
| VI | U4 (return to the original question) |
| Mathematical argument | Intersection of the adequate choices over the complete input fiber |

The stated action laws and preparations remain part of each example. The adequacy criterion proves none of their availability.

## Topics

### Related type declarations

- ``AdequateResidueContinuation``
