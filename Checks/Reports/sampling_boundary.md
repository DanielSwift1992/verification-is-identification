# Sampling a countable closure

A countably infinite class set has no uniform probability distribution.
It has proper full-support distributions, for example p_i=2^(-i), i≥1.
For IID draws, P(class i absent after n draws)=(1-p_i)^n→0. The countable
union of never-visited events has probability zero. Every class is eventually
visited almost surely, while every finite prefix omits infinitely many classes.
Each fixed finite target set A has E[T_A]≤Σ_(i∈A)1/p_i<∞. This is not a
uniform deadline, a computable stopping certificate or a proof of learning
correctness. With an effective enumeration and finite norm bands, ordered
enumeration also visits every class, but is not the unique possible schedule.

## Same exponential rate, different boundary behavior

Let n_p(s)=ceil(2^s/s^p), s≥1. All four examples have γ=ln2.
At λ=γ, s^(-p)≤n_p(s)2^(-s)<s^(-p)+2^(-s).
Multiplying by s^k proves that the kth raw moment numerator converges
exactly when p>k+1. This comparison is a proof for all s. Finite audits do
not decide convergence by looking at a large cutoff.

| p | Z at γ | Mean as λ↓γ | Variance as λ↓γ |
|---|---|---|---|
| 0 | Infinite | Infinite | Infinite |
| 2 | Finite | Infinite | Infinite |
| 3 | Finite | Finite | Infinite |
| 4 | Finite | Finite | Finite |

For p=4, exact rational partial sums with analytic tail bounds enclose:
Z in [1.500066467083156, 1.5000664707509879], mean in [1.6677247310078476, 1.6677250492762787], variance in [1.5905519063691167, 1.590593351515197].
Only the displayed endpoints are rounded to floating point.
These are abstract finite-band count sequences. They refute conclusions
from γ alone, without claiming every sequence comes from a particular VI grammar.

For finite γ=limsup log(n(s))/s, λ>γ gives convergence and all norm moments,
λ<γ gives divergence, and λ=γ needs the actual density. On the open domain,
ψ=ln Z has -ψ'=mean and ψ''=variance. ψ is a log-partition function, not
directly thermodynamic free energy. A physical temperature or heat capacity
requires a physical implementation and the appropriate parameter factors.
The Gibbs law maximizes entropy among finite-entropy competitors with its
same finite mean, by D(q||p)=λE_q[s]+lnZ-H(q)≥0. This does not assert existence
for every requested mean or identify a deterministic enumeration with λ→0.

## Waiting time is not norm variance

Two classes of norms 1 and 2, with exp(-λ)=2^(-k), have rare-class probability
1/(2^k+1). As k goes 1,2,4,8, mean wait goes 3,5,17,257, while norm variance
decreases toward zero. Sampling delay and the ensemble's variance differ.

## IID windows inside one finite whole

For autonomous finite Ω with deterministic U and reading E, a length-n
observation tuple is a function of the initial whole state. Thus
H(Y_1,…,Y_n)≤H(Ω_0). If the readings are IID with nonzero entropy h,
nh≤H(Ω_0)≤log2|Ω|. With m positive-probability symbols, their support also
requires m^n≤|supp Ω_0|. An infinite nondegenerate IID stream therefore is
not supplied by a deterministic finite closed whole.
This exact-independence bound does not assess the practical quality of a
pseudorandom generator or exclude approximate independence for specified tests.

A positive bounded construction has an internal length-L tape and clock.
Each tick rotates the tape and advances the clock cyclically. Both inverses
are explicit. Prepare the tape from p^L and clock at zero: the first L reads
are IID, the next repeats the first. Whole entropy is L H(p), preserved.
The tuple is an analytical observation map, not an extra physical recorder.
A retained transcript would also need storage inside Ω. The input product
preparation is an assumption, not generated independent randomness.

Closure itself does not forbid an infinite IID process. On A^Z with product
measure p^Z, the two-sided shift is a bijective measure-preserving map and
coordinate-zero readings are IID. This standard infinite-state construction
has all its coordinates inside the whole. It is not a finite device or a
derived physical implementation. No finite audit certifies that infinite space.

Checks: 3072 exact critical-term comparisons,
30 exhaustive finite projected missing-class identities,
810 finite entropy/partition identities and
622 closed states across 12 tape models.
The Swift witness projects three cyclic readings and derives the repeated
fourth reading. It does not encode probabilities or prove an infinite theorem.

Sources: [Fithian, exponential families](https://www.stat.berkeley.edu/~wfithian/courses/stat210a/exponential-families.html),
differential identities on the parameter-space interior;
[MIT, radius of convergence](https://ocw.mit.edu/ans7870/18/18.013a/textbook/HTML/chapter30/section04.html).
For the infinite construction, see [Solomyak, Example 1.5](https://u.math.biu.ac.il/~solomyb/TEACH/20/ET/Lec1.pdf).
The elementary coverage and comparison proofs are written above. These
standard probability and convergence facts are not claimed as VI inventions.
