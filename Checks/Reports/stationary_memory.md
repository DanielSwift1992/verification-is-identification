# Stationary retention and prepared growth

## A restriction stronger than finite recurrence

Let U preserve a probability measure μ on the entire state space Ω. If a
measurable real V satisfies V(Ux)≥V(x) almost surely, then V(Ux)=V(x)
almost surely, without requiring invertibility, finite Ω or integrability of V.
For each rational r, monotonicity nests {V(Ux)≤r} inside {V(x)≤r}.
Stationarity gives equal probabilities. Every strict increase crosses some
rational threshold, so the countable union of these null differences is null.
Measure preservation extends the conclusion to all forward steps on one
full-measure set. This is an almost-sure conclusion, not a claim at null states.

For a fixed countable fact vocabulary, apply the result to each measurable
membership indicator of a retaining cache. Every fact's insertion has zero
probability, and their countable union has zero probability. Thus a cache
that never drops facts also gains none almost surely under this stationary
whole measure. Infinite cardinality is not used as a progress measure.
Fresh facts need stable identities. Truth stability alone is not retention.

## Quantitative finite bound

Put μ'=U_*μ and TV(μ,μ')=sup_A|μ(A)-μ'(A)|. For fixed 0≤V≤1,
|E_μ[V(Ux)-V(x)]|≤TV(μ,μ'). The layer-cake expression for the expectation
integrates event-probability differences, each bounded by TV.
If V does not decrease on the prepared support, then
P_μ(V(Ux)-V(x)≥ε)≤TV(μ,μ')/ε. Without that monotonicity, gains and losses
can cancel. The normalization of V matters; this is not a universal bound
on bits learned, training loss, physical entropy production or energy.

## Closed finite construction

The whole consists of a four-bit retained source and an internal cursor
0…4: 80 states. U advances the cursor cyclically and keeps
the source unchanged. The decoded accessible cache is the source prefix
ending at the cursor. Its length names stable source positions. Decreasing
the cursor modulo five is the inverse. Access is part of the declared model,
not a claim that a physical reader has no implementation costs.

With a uniform source and cursor prepared at zero:

| Cursor | Whole entropy, bits | I(source; accessible cache), bits |
|---|---|---|
| 0 | 4 | 0.0 |
| 1 | 4 | 1.0 |
| 2 | 4 | 2.0 |
| 3 | 4 | 3.0 |
| 4 | 4 | 4.0 |
| 0 | 4 | 0.0 |

The whole entropy stays constant, but its distribution is not stationary:
the supported cursor value changes. The cache grows until wrap, then loses
access while the full source survives. Under the stationary uniform measure
on all 80 states, the mean cache length is constant: four growing phases
are balanced by one reset phase. Stationarity permits such fluctuations.

For a uniform source and cursor uniform on 0…3, one step increases V=cursor/4
by 1/4 on every prepared state. TV(μ,U_*μ)=1/4, so the bound is sharp.
Whole entropy is unchanged and accessible source information rises by one
bit. The next ensemble includes the reset phase, so this preparation does
not justify indefinite monotone growth.

## An infinite closed model can grow indefinitely

Take Ω=A^N×Z: an immutable infinite source tape x and an internal integer
cursor k. U(x,k)=(x,k+1) is bijective. C(x,k) contains (i,x_i) for
0≤i<max(k,0), so every record is finite and C grows by inclusion everywhere.
From k=0 it adds one source position each step. With a product tape law,
the ensemble at time t has cursor δ_t, so the whole distribution changes.
All source coordinates and the cursor remain inside Ω.

There is no U-invariant probability measure on this whole: its cursor
marginal would have equal mass at every integer, which cannot sum to one.
The product tape measure times counting measure is invariant but has
infinite total mass. Thus the stationary-probability premise fails.
This model assumes an infinite tape and unbounded cursor, not a finite
physical implementation. The growing cache expresses expanding access to
an existing internal source. It is not an inference of an unknown physical
law or a creation of information outside the whole.

Checks: 10935 finite rank models,
69 stationary transition/prior pairs,
29952 retaining cache models,
320 complete reversible ring states and
278 finite projections of an unbounded clock.
The infinite assertions have proofs above, not exhaustive finite verification.
Pure Swift exposes one resident source field into a cache pair and rewinds
it, preserving all fields. It does not encode stationary probability or
ensure that an arbitrary Pair is a nonempty physical tape.

Source: [Solomyak, Proposition 1.11](https://u.math.biu.ac.il/~solomyb/TEACH/20/ET/Lec1.pdf).
The stationary monotonicity theorem is established mathematics. This audit
applies it to VI's retention assumptions and separates preparation from
closure and entropy conservation.
