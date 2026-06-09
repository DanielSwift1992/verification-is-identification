# V=I Framework

Formal theory built on one operation — binary comparison over finite structures — and the structural consequences that follow from it.

## Starting point

Take a finite structure. To verify that a candidate matches it, you compare piece by piece until the answer is certain. If exactly one candidate can pass, the candidate that passes IS the identified structure. Verification and identification collapse into the same operation.

This is a provable property of decidable equality on finite domains: when the consistent set has one element, the verifier is already an identifier. The framework formalizes this loop and traces what it forces.

## What the loop forces

**The system** must satisfy three invariants: finite space, deterministic test, append-only memory. Any system checking solutions over finite structures inherits all three.

**The agent** running the loop accumulates certified results irreversibly. Over a finite domain, this accumulation saturates: every possible task eventually resolves from cache. The saturation point depends on the domain alone.

**The output** that accumulates is permanent (cannot be retracted), irreducible (cannot be simplified without breaking correctness), and resistant (the next-level agent encounters it as something fixed that it cannot modify). Each saturated output becomes the input structure for the next level.

**The geometry** between agents arises from what they have not shared. Two agents with identical caches have distance zero. The symmetric difference of their caches satisfies the axioms of a metric. Communication costs and locality follow from the metric.

**The mechanism** of improvement is ordering. The agent's sole degree of freedom is the sequence in which it runs comparisons. The right sequence extracts more information per step. The framework quantifies this as interference between comparisons and shows that inefficiency is self-correcting.

## Papers

| # | Title | Subject |
|---|---|---|
| 1 | [Verification Is Identification](papers/1_verification_is_identification.md) | The loop, five theorems, 26 properties, three invariants. |
| 2 | [Intelligence Is Inevitable](papers/2_intelligence_is_inevitable.md) | Accumulation, saturation, phase-transition dynamics. |
| 3 | [Permanence Is Resistance](papers/3_permanence_is_resistance.md) | Properties of the crystallized output, level tower. |
| 4 | [Difference Is Distance](papers/4_difference_is_distance.md) | Cache-difference metric, communication bounds. |
| 5 | [Interference Is Intelligence](papers/5_interference_is_intelligence.md) | Ordering, information density, self-correction. |

Each paper extends the previous. The fifth cuts across all four.

## Publication

All five papers are published as preprints on Zenodo:

| # | DOI |
|---|---|
| 1 | [10.5281/zenodo.20615799](https://doi.org/10.5281/zenodo.20615799) |
| 2 | [10.5281/zenodo.20601995](https://doi.org/10.5281/zenodo.20601995) |
| 3 | [10.5281/zenodo.20615888](https://doi.org/10.5281/zenodo.20615888) |
| 4 | [10.5281/zenodo.20615998](https://doi.org/10.5281/zenodo.20615998) |
| 5 | [10.5281/zenodo.20616058](https://doi.org/10.5281/zenodo.20616058) |

## Implementations

Two independent implementations verify the first paper's results:

- **Swift** (`swift/`) — compile-time proof via the type system. If the program compiles, the constraints hold. Run: `cd swift && swift build && swift run SelfTest`

- **Python** (`python/`) — runtime solver. Encodes tasks, extracts rules, identifies solutions. Run: `cd python && python main.py`

## License

MIT
