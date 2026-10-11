# A narrower support can have a higher posterior entropy

Prior over A, B, C: 9/10, 1/20, 1/20. The noiseless question asks whether the source is not A.

| Reading | Probability | Remaining sources | Posterior entropy, bits | KL gain, bits |
|---|---|---|---|---|
| 0 | 9/10 | A | -0.000000 | 0.152003 |
| 1 | 1/10 | B, C | 1.000000 | 3.321928 |

Prior entropy: **0.568996** bits. Mean posterior entropy: **0.100000** bits.
Mutual information: **0.468996** bits, below one bit despite the rare branch's larger KL gain.
A **12-state** permutation includes source, memory and readiness phase.
Its joint entropy is **0.568996** bits before and **0.568996** after recording.
The next step reverses the recording. Preparation and a finite readout window are explicit.

# The same uncertainty permits different experimental costs

| Eight equiprobable sources | Worst questions | Mean questions |
|---|---|---|
| Identify source, testing one of the first seven names at a time | 7 | 35/8 |
| Identify source, reading its three binary coordinates | 3 | 3 |
| Ask whether source is the eighth, with only the seven name tests | 7 | 35/8 |
| Ask whether source is the eighth, with that question directly available | 1 | 1 |

Identity entropy is **3** bits. The eighth-source verdict entropy is **0.543564** bits.
With only the seven name tests, every successful verdict transcript also identifies the full source.
A yes to any name test identifies that source; seven negative readings identify the eighth.
Thus a complete transcript carries 3 bits about the source even when the final answer reports only the verdict.
All questions in this comparison are noiseless and nondestructive. The admissible vocabulary changes, not the prior.
These are optimal finite decision-tree costs, not a physical time or heat estimate.
