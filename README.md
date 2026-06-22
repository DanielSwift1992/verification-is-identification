# V=I Framework

Formal theory built on one operation — binary comparison over finite structures — and the structural consequences that follow from it.

📖 **[Read the documentation →](https://danielswift1992.github.io/verification-is-identification/documentation/verificationisidentification)** — every protocol and every paper, browsable.

## Starting point

Take a finite structure. To verify that a candidate matches it, you compare piece by piece until the answer is certain. If exactly one candidate can pass, the candidate that passes IS the identified structure. Verification and identification collapse into the same operation.

This is a provable property of decidable equality on finite domains: when the consistent set has one element, the verifier is already an identifier. The framework formalizes this loop and traces what it forces.

## What the loop forces

**The system** must satisfy three invariants: finite space, deterministic test, append-only memory. Any system checking solutions over finite structures inherits all three.

**The agent** running the loop accumulates certified results irreversibly. Over a finite domain, this accumulation saturates: every possible task eventually resolves from cache. The saturation point depends on the domain alone.

**The output** that accumulates is permanent (cannot be retracted), irreducible (cannot be simplified without breaking correctness), and resistant (the next-level agent encounters it as something fixed that it cannot modify). Each saturated output becomes the input structure for the next level.

**The geometry** between agents arises from the difference in what they have witnessed. Two agents with identical caches have distance zero. The symmetric difference of their caches satisfies the axioms of a metric. Communication costs and locality follow from the metric.

**The mechanism** of improvement is ordering. The agent's sole degree of freedom is the sequence in which it runs comparisons. The right sequence extracts more information per step. The framework quantifies this as interference between comparisons and shows that inefficiency is self-correcting.

## This repository

A Swift package: the framework written as pure types, where **a green build is the proof**. A claim is a protocol, its proof is that the protocol compiles, and nothing runs. The construction law is enforced on every build by a plugin.

```swift
import VerificationIsIdentification
```

Build and run the proofs:

```sh
swift build    # the type checker verifies the lattice; LawCheck enforces the construction law
swift test     # the worked physics demos — ice's residual entropy, hydrogen's spectrum, a certified scheduler
```

## Documentation

The full theory — every protocol and every paper, woven by the dependency lattice — renders as a browsable DocC site, generated from this package and published with GitHub Pages:

- **[VerificationIsIdentification](https://danielswift1992.github.io/verification-is-identification/documentation/verificationisidentification)** — the framework: the protocols and the papers.
- **[Playground](https://danielswift1992.github.io/verification-is-identification/documentation/playground)** — the framework applied: the physics demos and a working solver.

## License

MIT
