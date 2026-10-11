# Distinctions required by the experimental route

Exact deterministic verdicts; noiseless, nondestructive binary tests; known finite tables and positive priors.

For the complete transcript T and target Z=q(X), H(T)=H(Z)+H(T|Z).
The extra term counts distinctions inside answer classes. It is not a lower bound on final accessible memory.

| Experiment | Target entropy, bits | Mean questions for this partition | Extra transcript information, bits | Transcript partition |
|---|---|---|---|---|
| adaptive | 1.500000 | 3/2 | 0.000000 | {{0,1}, {2}, {3}} |
| membership | 0.543564 | 35/8 | 2.456436 | {{0}, {1}, {2}, {3}, {4}, {5}, {6}, {7}} |
| direct | 0.543564 | 1 | 0.000000 | {{0,1,2,3,4,5,6}, {7}} |
| tradeoff | 0.970951 | 8/5 | 0.550978 | {{0,2}, {1,4}, {3}} |
| tradeoff | 0.970951 | 8/5 | 0.550978 | {{0,3}, {1,4}, {2}} |
| tradeoff | 0.970951 | 9/5 | 0.400000 | {{0,2,3}, {1}, {4}} |

## Adaptive zero-excess experiment

Four sources A₁, A₂, B, C have target answers A, A, B, C.
Test u=(0,0,1,1) first. A zero answers A; after a one, use v=(0,1,0,1) to distinguish B and C.
Although v distinguishes A₁ from A₂ globally, the controller never asks it in that branch.
Every target class therefore has exactly one complete transcript.
Requiring every vocabulary test to factor through the target globally would incorrectly reject this experiment.

## A real cost/disclosure tradeoff

Five uniform sources 0,…,4 have target (0,1,0,0,1). Four tests are available:
u=(0,1,0,1,1), name₄=(0,0,0,0,1), name₁=(0,1,0,0,0), v=(0,1,1,0,1).
Ask u first and v only after a one: mean 8/5, splitting the three-source answer class, excess 0.550978 bits.
Ask name₄ first and name₁ only after a zero: mean 9/5, splitting the two-source answer class, excess 0.4 bits.
Separate leaves with the same answer do not merge their complete transcripts.
Every available root test splits a target class, so zero excess is impossible.
The exact optimizer finds both costs on the Pareto frontier; the fastest and least-disclosing policies differ.
There is also no single coarsest attainable transcript partition: any correct common coarsening of
the fast partition {{0,2},{1,4},{3}} and slow partition {{0,2,3},{1},{4}} is the unattainable target partition.

## Scope of the certificate

The optimizer records every leaf partition attainable by trees that stop when the target becomes fixed,
with the least rational expected query count for that partition. Uninformative queries can be removed.
Queries after a fixed verdict only refine the transcript and increase cost, so cannot improve this frontier.
Policies execute using only question indexes, readings and terminal answers. Full source tables are synthesis premises.
Entropy comparisons use tolerance 1e-12. The zero-excess criterion is exact equality of partitions.
This is a restricted experiment model, not a general lower bound for randomized, noisy or destructive experiments.
