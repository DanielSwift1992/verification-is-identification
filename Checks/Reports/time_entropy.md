# Time, entropy and an extra forgetting step

Let a fixed reading partition a finite complete-state space K into cells M_a
of size w_a. Let U be a permutation. All logarithms here use base two.
For a distribution mu put p_a=mu(M_a) and bar_mu(x)=p_a/w_a inside M_a.
These are probability descriptions of one declared whole, not an external
source choosing the laws or adding randomness to its actual evolution.

## An exact entropy ledger

H(bar_mu)=H(p)+sum_a p_a log2(w_a).
D(mu||bar_mu)=H(bar_mu)-H(mu)>=0.
Permutation evolution preserves H(mu), so changes in H(bar_mu) equal changes
in this within-cell divergence. It measures structure lost by uniformizing
the cells; it is not automatically heat or a physical entropy production.
If mu starts uniform within every occupied cell, H(bar_mu_t)>=H(bar_mu_0).
This lower bound relative to the prepared start does not imply monotonicity
between arbitrary subsequent times. Average log cell size is also a different
quantity: its difference from H(bar_mu) is the macro-outcome entropy H(p).

## Forward and inverse cell counts

N_ab=|M_a intersect U^(-1)(M_b)| counts both forward transitions a to b
and inverse transitions b to a. Under separate uniform cell preparations,
P_U(b|a)/P_inverse(a|b)=w_b/w_a whenever N_ab>0.
Thus the logarithm of that probability ratio equals the log-volume change.
No sign of time or entropy growth is selected by the identity. For a general
U, the inverse experiment is not the same forward process started in b.
The macro measure w_a/|K| is stationary. Applying the same counting argument
to any power of U is valid; it does not require a macro Markov assumption.

## A whole with an internal clock

K contains x in {0,1,2,3} and phase c in {0,1}. U swaps x=0 with x=1,
leaves x=2,3 unchanged and flips c. U is its own inverse on all eight states.
The reading retains phase and reports small for x=0, large for x=1,2,3.
Initially c=0 and x is uniform over the large cell. The clock phases are
internal, cyclic and observable in the model. They do not identify an absolute
cycle count or by themselves supply a thermodynamic arrow or permanent record.

| Phase | Whole H | Coarse H | Mean log cell size | Iterated-uniformization H |
| --- | --- | --- | --- | --- |
| 0 | 1.584962500721 | 1.584962500721 | 1.584962500721 | 1.584962500721 |
| 1 | 1.584962500721 | 1.974937501202 | 1.056641667147 | 1.974937501202 |
| 0 | 1.584962500721 | 1.584962500721 | 1.584962500721 | 1.996953118181 |

On the first tick coarse entropy rises while mean log cell size falls.
On the second tick the exact whole returns, and coarse entropy falls back.
This is a small non-thermodynamic countermodel to an unconditional inference
from closure and reversible evolution to monotone coarse entropy.

## When the arrow was added by the description

Exact observation at t is Pi U_*^t mu_0. Replacing the distribution by a
uniform one inside each cell after every tick instead gives
(Pi U_*)^t mu_0. Each permutation preserves entropy and each Pi increases
or preserves it, so the latter sequence has non-decreasing entropy.
It is a different sequence. After two ticks the actual probability of the
small cell is zero, while the repeatedly uniformized model predicts 2/9.
The original coarse reading lost distinctions needed to update itself:
in the large cell, x=1 and x=2 have different next readings. This is VI's
execution-closure boundary, now applied to an entropy calculation.

Pi is an inference approximation here. If physical mixing implements it,
that mixing mechanism, its preparation and residual must belong to the whole;
they cannot be silently added to U. A useful approximate macro law requires
a measured or proved error bound and regime of validity.

There is a precise positive repair. Split the large cell into x=1 and
x in {2,3}, retaining the phase. The resulting six-class reading determines
its own next value, and its coarse entropy stays log2(3) in this experiment.
The current and next old readings identify exactly these classes, as checked
pairwise. This is a sufficient encoding, not an asserted free measurement.
In general, a deterministic autonomous finite image of a permutation is a
permutation (VI VC20). Its successive fiber sizes are equal, so both coarse
entropy and cell-volume entropy are constant. The audit verifies this on all
143 autonomous partitions in its finite enumeration.

## Keeping every event still does not force monotone entropy

To impose literal retention, use the whole space of all nonempty finite valid
histories h=(w_0,...,w_t), where w_(i+1)=U(w_i). The actual update appends
U(w_t); removing the last entry recovers the prior history. This map is
injective but not onto the singleton histories. The whole has unbounded
capacity. No history recurs, and its length increases on every step.

At each length there are exactly eight histories, in bijection with their
last states because U is a permutation. A reading that reports length, phase
and small/large therefore still has cells of size one or three. Prepare the
same three equiprobable one-entry histories. Whole Shannon entropy stays
log2(3), and coarse entropy still alternates between 1.584963 and 1.974938
bits. Every actual event remains in the whole while the chosen reading's
entropy decreases on alternate steps. This follows for every length from
the formula; 56 history states in seven layers
were also checked, including recovery of every preceding prefix.

Thus irreversible growth of a retained historical order is stronger than
finite recurrence permits but still does not entail monotone coarse entropy.
The extra record has an explicit unbounded-capacity premise. It is not
implemented by the finite eight-state machine or by free outside storage.

## Checks and prior art

All 395 permutation/partition models on
one to four labeled states, 2519 cell pairs and
13071 rational-prior transports were checked.
Probabilities, cell counts and the two-step disagreement are exact Fractions;
entropy and log identities use tolerance 1e-12. All eight clock states and
the inverse are checked. The three missing-premise examples are a nonuniform
initial cell, a noninjective transition and using U instead of its inverse.
General identities have the elementary proofs in VI M38-M40; finite counts
do not prove a physical second law or a cosmological initial condition.

The entropy distinctions and the difference between a bound from the initial
time and genuine monotonicity are established prior art:
[Goldstein, Lebowitz, Tumulka and Zanghi, sections 1 and 8](https://arxiv.org/pdf/1903.11870).
The coarse quantity is the finite one-partition form of
[Safranek, Aguirre and Deutsch's observational entropy](https://arxiv.org/pdf/1905.03841),
Theorem 3 and equation 22. This audit contributes a small complete countermodel
and its VI execution-scope linkage; no priority for those entropy notions is claimed.
