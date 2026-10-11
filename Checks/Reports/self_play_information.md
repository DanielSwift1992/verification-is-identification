# What self-play can add inside a closed whole

## Synthetic labels do not certify an unmeasured law

First-input observation 0 leaves actual laws (0,0) and (0,1) compatible.
Choosing (0,0) as the generator and appending its synthetic second label 0
makes the synthetic training set uniquely identify (0,0). This happens in
both possible actual worlds, including (0,1), where that second label is false.
The correct evidence-based version set still contains both laws.

For generated history G=F(B,R), I(Θ;G|B)≤I(Θ;R|B).
Here B contains prior accessible evidence and R contains all additional
program/seed inputs. If Θ and R are conditionally independent given B,
the extra information about Θ is zero. Independence only before conditioning
is insufficient: B and a masked seed can jointly decode the unknown bit.

A poser can still teach its privately drawn synthetic target to a solver.
An independent one-bit draw carries one bit about that draw and zero about
an unrelated unknown target. Which object is being learned matters.

## New access is possible without anything entering the whole

A 2048-state permutation contains two law bits,
the old record, seed, output, readiness, a generator program and a mode.
Generating from the old record and independent seed adds zero conditional
information about the unknown second bit. Reading that internal law bit adds
one bit to the local output. Both operations are reversible and preserve
whole entropy. The next tick reverses the record, so the reading window matters.

## Computation can improve without new evidence

The known task is parity of 3 retained input bits,
requested 4 times. Both machines use only reversible
controlled bit flips, prepared output bits, an accumulator and an internal clock.

| Policy | Gate/clock ticks before ready | Final accumulator | Final outputs |
|---|---|---|---|
| Compute, copy and uncompute for every request | 28 | 0 | Four exact parity bits |
| Compute once, copy to every output, uncompute once | 10 | 0 | Four exact parity bits |

Both reach the same data-register state. Program mode and clock also belong
to the whole, which has 10240 states and an explicit inverse.
Joint entropy stays 3 bits throughout. The outputs
are determined by the retained inputs, so add no information conditional on
those inputs. They make the answer directly readable with less repeated work.
Precomputation, copying and cleanup are all counted. The clock reset after
the readout window is outside both compared prefixes and is explicit in the
whole permutation. This is a reversible reuse construction, not a neural
training benchmark, physical energy bound or claim of globally optimal circuitry.
