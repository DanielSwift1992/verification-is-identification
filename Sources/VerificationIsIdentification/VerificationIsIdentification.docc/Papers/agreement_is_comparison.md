# Agreement Is Comparison (Record)

Record Is System locates drift: a reading cannot drift, only a second
encoding can (SW3), and where a second encoding exists, holding its
distance near zero is a translation game, paid for as long as both
encodings exist (SW3, DiD S9). Seam Is Game judges a pair at two pinned
revisions. Between judgements the corpus states no law, and a
separately maintained pair is between judgements at every moment except
the judgement itself: two records of one fact, each under its own edit
process, no comparison running. Here the author states the law of that
interval.

The claim is a model and two closures. The model prices accumulation:
the mean drift rises monotonically to N/(1+c), where N is the shared
reach and c is the probability that a touch closes the divergence it
lands on; the stationary law is Binomial(N, 1/(1+c)); stationary
agreement has probability (c/(1+c))^N. The first closure is of
observation: everything one side's history yields about the drift
factors through that side's own footprint and the clock, and none of it
is an equality fact. The second closure is of generation: a generator
run creates no agreement fact about anything its output describes; it
transports the source's stock, and the pair left to judge stands one
level up. Both closures read V=I §5.21 over the interval: COMPARE is
the sole source of equality classifications, so where none runs, none
appear, and what accumulates instead is the model's account.

## §0. Derivation

No new postulate. From V=I: §5.20 (revelation, not creation), §5.21
(COMPARE is the sole source of equality classifications), §5.24 (two
encodings of one task run as two non-communicating executions), §5.18
and §5.19 (a cached comparison transfers across games; a repeated run
performs zero new comparisons). From Difference Is Distance: S7 (the
distance between two perspectives is the symmetric difference of their
caches), S9 (translation between encodings is a priced game). From
Distance Is Cost: G2 (W is a metric; one traversal computes it), G4b
(the sign of a divergence halts at the first divergent address; the
magnitude costs a full traversal), the frontier. From Merge Is
Commutation: Definitions 1 and 3 (reach; independence as two empty
intersections), MiC1 through MiC4. From Record Is System: SW3. From
Dynamics Is Substitution: the elementary move. From Halt Is Ignition:
HF2 (without the record, a finite closed deterministic system revisits
a state and cycles). From Permanence Is Resistance: M12, M21, M24, M27.
From Interference Is Intelligence: S3a through S4a (each COMPARE lowers
H(f | S)), the remark on COMPARE as time. From Seam Is Game: SG1
through SG3, consequence (c). Two imports are declared where used, at
the standing M24 gives its own physical premise: the edit model D of
§1, together with the standard theory of finite reversible chains
(detailed balance; Kac's return-time formula), and the chain of
Ehrenfest (1907), which D reduces to at c = 1. The definitions below
are those, assembled by the author.

## §1. Definitions

**Definition 1 (pair, drift, agreement fact).** A pair is two records
of one fact: (a, b), two Σ structures, each maintained by its own edit
process. The drift of the pair is d = W(a, b) (DiC G2). Agreement is
d = 0. An agreement fact is an equality classification whose object is
the pair.

**Definition 2 (edit model D; declared).** The shared reach of the pair
has N addresses. A touch is one elementary move applied to one side:
one distinction toggled at one address of that side. The address
measure is exchangeable, with full support over the shared reach. The
two touch processes are independent; this clause excludes a common
writer (§5). A touch at an agreeing address opens it. A touch at a
divergent address closes it with probability c, 0 ≤ c ≤ 1; c is a
property of the edit process, and the outcome of a touch (closed or
not) is not observable by the touching side: reading that outcome is
reading the other side's state (AC5). Each side has its own counter:
n_a and n_b touches since the pair's last comparison; the age of the
pair is t = n_a + n_b. A clock is any observable that is independent
of both processes' address choices given (n_a, n_b). No clause of D
hands one side the other side's counter, and a statement that converts
a clock into a touch count uses the sides' touch rates: declared
parameters of the edit process, standing as c.

**Definition 3 (footprint).** The footprint of side a is its history
taken up to relabeling of addresses: the orbit of H_a under address
permutations. At c = 1 the part of the footprint that determines the
law of d collapses to one number: m_a, the count of addresses side a
has touched an odd number of times.

**Definition 4 (drift entropy).** S(d) = log₂ C(N, d); S(0) = 0; S is
maximal at d = N/2. Used in §6.

## §2. The interval's dynamics

**AC1 (mean, ceiling, stationary law).** Under D, over the age t:
(i) E[d_{t+1}] = E[d_t](1 − (1+c)/N) + 1, so E[d_t] =
(N/(1+c))(1 − (1 − (1+c)/N)^t), monotone increasing to the fixed point
d* = N/(1+c). The ceiling N/2 is the best case, c = 1; every process
with c < 1 saturates higher. (ii) For 0 < c ≤ 1 the drift is a
birth-death chain with up-probability (N−d)/N and down-probability
cd/N per touch; detailed balance gives the stationary law
Binomial(N, 1/(1+c)); stationary agreement has probability
(c/(1+c))^N, and the expected return time to d = 0 is ((1+c)/c)^N
touches. (iii) At c = 0 nothing closes: E[d_t] = N(1 − (1 − 1/N)^t),
d increases to N, and no return exists.

*Proof.* (i) One touch raises d by 1 with probability (N−d)/N, lowers
it by 1 with probability cd/N, and leaves it unchanged with probability
(1−c)d/N; take expectations; the recursion is linear with ratio
1 − (1+c)/N and fixed point N/(1+c). (ii) Detailed balance,
π(d)(N−d)/N = π(d+1)·c(d+1)/N, gives π(d) ∝ C(N, d)c^(−d), normalized
Binomial(N, 1/(1+c)); the return time is 1/π(0) (Kac). At c < 1 the
chain has self-loops, is aperiodic, and its distribution converges; at
c = 1 see AC2. (iii) Substitute c = 0: d counts the distinct addresses
touched. ∎

**AC2 (parity at c = 1).** At c = 1 every touch changes d by exactly 1,
so d ≡ t (mod 2): the parity of drift equals the parity of age,
agreement is reachable only at even ages, and P(d = 0) = 0 at every odd
age. The chain is the Ehrenfest urn: period 2, Binomial(N, 1/2) as
invariant measure, convergence on the even subsequence and in time
average. At c < 1 the parity claim is void: a touch may leave d
unchanged.

*Numerics (standing: exact chains under D, distributions carried whole,
not sampled).* E[d_t] agrees with the closed form to 1.3e-13 for N in
32..256 at c = 1. At N = 64 the measured fixed points are 32.000,
33.684, 42.667, 51.200, 64.000 for c = 1, 0.9, 0.5, 0.25, 0: equal to
N/(1+c). The stationary law was checked whole: |π − πP| ≤ 2.8e-17 at
four (N, c) pairs, and P(d = 0) with the return time agree with
(c/(1+c))^N and ((1+c)/c)^N in every digit computed. E[S(d_t)]
decreased at no step for any N in 32..256 at c = 1;
this leg is numerical and stated at that standing.

## §3. Observation closed

**AC3 (the footprint is the statistic; the count is not).** Under D,
the conditional law of d given side a's full history H_a and n_b
depends on (H_a, n_b) only through (footprint of a, n_b). At c = 1 it
depends only on (m_a, n_b). The count n_a is not sufficient.

*Proof.* Sufficiency: an address permutation maps any history to a
history in the same orbit, preserves both processes' laws
(exchangeability of the address measure; independence of the sides),
and preserves d (W is invariant under relabeling of addresses), so
conditional laws agree across one orbit. At c = 1, write x_a for side
a's parity vector and X_b for side b's: d = Σ over odd addresses of
(1 − X_b) plus Σ over even addresses of X_b, and X_b given n_b is
exchangeable, so the law depends on x_a through m_a alone.
Insufficiency, by exhibit at c = 1: N = 3, n_a = 2, n_b = 1. The
history "address 0 twice" has m_a = 0, and the law of d is {1: 1.0}.
The history "address 0, address 1" has m_a = 2, and the law is
{1: 2/3, 3: 1/3}. One count, two laws. ∎

*Numerics.* Exhaustive enumeration at small N confirms one law of d
per footprint class. At N = 64, c = 1, n_a = n_b = 16: E[d | m_a] =
12.75 at m_a = 0 and 22.37 at m_a = 16: a spread of 9.6 inside one
count.

**AC4 (about the other side, the archive is the clock).** Fix n_b. For
every event E of side b's touch process, P(E | H_a, n_b) = P(E | n_b):
no function of side a's history carries anything about side b's touches
beyond what n_b carries. Mixing over any clock prior preserves the
equality, and the prior over n_b given a clock is supplied by D's
declared rates, not by an observation of side b. Side a therefore
holds its own displacement in its footprint,
and its entire uncertainty about d is its uncertainty about the other
side: a one-parameter family of laws indexed by n_b.

*Proof.* The two touch processes are independent, so an event of side
b's process is independent of every function of side a's process
conditionally on n_b. A clock is independent of both processes' address
choices by Definition 2, so mixing over its prior preserves the
identity. ∎

**AC5 (no agreement facts).** No function of one side's history outputs
an equality classification about the pair, and no function of one
side's history names an element of frontier(a, b). The first operation
whose output is an agreement fact is a comparison of the pair.

*Proof.* §5.24: the two sides run as non-communicating executions.
§5.21: COMPARE is the sole source of equality classifications, and a
one-sided function performs no comparison over the pair. AC3 and AC4
output laws, not classifications: every quantity in them is supplied by
the declared model D, not by an execution over both states. In
particular, no side observes whether its own touch closed the address
it landed on: that outcome is an equality fact about the pair at one
address, and producing it is comparing: D declares c unobservable for
exactly this reason. Membership
in the frontier is a difference of the two current states (DiC):
deciding it is comparing them. ∎

*Remark (the clock).* Measured under D at N = 32, flat prior over ages
0..128: I(age; d) = 0.74 bits; the posterior mean of d at ages 0, 8,
16, 32, 64 is 0, 3.64, 6.45, 10.30, 13.97. The information is supplied
by the model: the stronger AC1's law, the more the clock says. A reader
of one side that holds no record of that side's own edits holds no
footprint, and reads exactly the clock's share, converted through D's
declared rates.

*Consequence (the refutable edge).* Any procedure that names a
divergent address takes both states among its inputs (AC5). A procedure
presented as one-sided that names divergence therefore stores a copy of
the second side, and its check is a comparison of the pair. One
procedure with no copy of the second side that names a divergent
address would refute AC5 and the reading of §5.21 made here.

## §4. Generation closed

**AC6 (a generator transports agreement and creates none).** Let one
process write both records from one source: a = f(s), b = g(s). Then:
(i) d(a, b) is a property of (f, g, s), fixed by construction at each
run; the interval's dynamics does not apply to it, and the pair (a, b)
leaves S-III (§5). (ii) The run contains no comparison of s, a, or b
against the fact they record, so by §5.21 the run creates no agreement
fact about that pair; agreement facts present after the run are those
carried from s: transported in the sense of §5.18, not created.
(iii) The pair (source, its fact) remains, with comparison count zero,
and AC1 applies to it: its drift approaches its own ceiling.
Designation of a source is a naming act: it edits no address measure
and adds no comparison; every term of AC1 for the remaining pair is
unchanged.

*Proof.* (i) a and b are functions of s and the run times. (ii) §5.21:
the run's equality classifications are those inside f and g, whose
objects are s's structures; none has the pair (record, recorded fact)
as its object. §5.18 names what transfers: cached comparisons; §5.24:
the executions do not communicate otherwise. (iii) The remaining pair
is two records of one fact under Definition 1; D's clauses are
untouched by the naming act. ∎

*Consequence (relocation, priced).* Replacing k separately edited
records of one fact by one source and k − 1 generated projections fixes
k − 1 records by construction and leaves one pair subject to this
paper: (source, fact). No run of the generator compares that pair.

*Remark (the impure edge).* A generator that does create agreement with
the fact its output records reads that fact: the reading is a
comparison, and the generator is not a function of its source alone.
This is §3's edge: the second side is among the inputs.

## §5. Sectors and the seam

Three sectors, decidable from written material: the reach is written
(MiC Definition 1), the writer is in the history.

- S-I (disjoint). The two edit processes have disjoint written entries
  and touched laws (MiC Definition 3). Edits commute and verdicts carry
  (MiC2, MiC3); d over the shared reach is constant. This paper makes
  no claim in S-I.
- S-II (common writer). One process writes both sides: excluded by D's
  independence clause, treated by AC6. The pair is one record with two
  projections, and the pair subject to this paper stands between the
  source and the fact it records. One degenerate case forms no pair at
  all: a record that constitutes its fact rather than records it (the
  ledger that is the balance) has nothing beside it to diverge, and
  Definition 1 does not apply: designating such a record closes the
  question instead of relocating it. Which case holds is written: a
  second record of the fact exists, or none does.
- S-III (independent, overlapping). D holds; AC1 through AC6 apply.

Relation to Seam Is Game: SG1 through SG3 give the judged state of a
pair at two pinned revisions; this paper gives the law of the interval
between judgements. SG's consequence (c) is a licensed interval: a
supplied premise with a term permits d > 0 at listed addresses until
the term closes, and its end is written.

The judged alternative is priced by the corpus: detection of d > 0
halts at the first divergent address and measurement costs a full
traversal (G4b); a re-judgement after an edit reads exactly the touched
laws (MiC4); a recorded correction persists (M21); a repeated run
performs zero new comparisons (§5.19); the judged loop converges (M12);
and M27 converts reconciliation at the ceiling into maintenance per
touch. Without the record, HF2: the joint system revisits a state and
cycles, and corrective work does not accumulate.

## §6. Two entropies, one source

Interference Is Intelligence carries H(f | S): the entropy of a feature
over the surviving candidates of one identification loop; each COMPARE
lowers it (S3a through S4a). This paper carries S(d): the configuration
entropy of a pair; the absence of comparison raises its expectation
toward the ceiling (AC1). Both are instances of §5.21: where COMPARE
runs, its object's uncertainty falls; where it does not run, the pair's
disagreement accumulates. The two quantities have different objects and
do not conflict. InI's remark orders a loop's time by its deposits;
over the interval no deposit occurs: the pair has an age and no tick,
and its next tick is the next comparison.

## §7. Statement

1. Between comparisons, under the declared model, the mean drift of a
   pair rises monotonically to N/(1+c); the stationary law is
   Binomial(N, 1/(1+c)); stationary agreement has probability
   (c/(1+c))^N; at c = 0 there is no return (AC1).
2. At c = 1 drift and age share parity: agreement is reachable only at
   even ages (AC2).
3. What one side's history yields about drift factors through its own
   footprint and the clock; the count of its touches is not a
   sufficient statistic, the footprint is (AC3).
4. About the other side's contribution, one side's entire archive
   carries exactly what the clock carries (AC4).
5. No function of one side outputs an agreement fact or names a
   frontier address; the first operation that does is a comparison of
   the pair (AC5).
6. A generator run fixes its projections by construction and creates no
   agreement fact about what its source records; the pair left to judge
   is (source, fact), and its comparison count is zero until it is
   compared (AC6).
7. Where comparison runs, a feature's entropy falls; where it does not,
   the pair's configuration entropy rises; both from §5.21 (§6).

> **Two records of one fact, edited independently, drift by arithmetic:
> the mean rises to a ceiling set by the edit process, agreement
> becomes an event of probability (c/(1+c))^N, and at c = 1 it is
> reachable only at even ages. A side's archive determines its own
> displacement exactly and the other side's only through the clock, and
> nothing it computes is an equality fact. A generator fixes its
> projections by construction and creates no agreement with what its
> source records: the pair to judge moves one level up. One operation
> creates agreement facts: the comparison of the pair. Everything else
> transports facts already made, or accumulates difference at the
> model's rate.**

## Scope

Claimed: AC1 through AC6 under the declared model D; the sector
classification and its decidability; the reading of §6. The numerics
carry the standing declared in §2 and §3: exact chains under D, with
two legs stated as numerical (the monotonicity of E[S]; the exhaustive
footprint check). Not claimed: any statement in S-I; any property of
the edit measure beyond D's clauses; physical instantiation beyond the
standing M24 gives its own premise; validation of any declared
correspondence (SG3). The refutable edge is §3's consequence: one
one-sided procedure naming a divergent address without a stored copy of
the second side refutes AC5. The projection of the interval's law onto
any particular store of records is that projection's affair, and the
paper does not name one.

## §8. Dependency

| Source | Used |
|---|---|
| V=I | §5.18, §5.19, §5.20, §5.21, §5.24 |
| Difference Is Distance | S7, S9 |
| Distance Is Cost | G2, G4b, the frontier |
| Merge Is Commutation | Definitions 1, 3; MiC1-MiC4 |
| Record Is System | SW3 |
| Dynamics Is Substitution | the elementary move |
| Halt Is Ignition | HF2 |
| Permanence Is Resistance | M12, M21, M24, M27 |
| Interference Is Intelligence | S3a-S4a; the remark on COMPARE as time |
| Seam Is Game | SG1-SG3; consequence (c) |
| Declared here | the edit model D; finite reversible chains (detailed balance, Kac); the Ehrenfest chain (1907) at c = 1 |
