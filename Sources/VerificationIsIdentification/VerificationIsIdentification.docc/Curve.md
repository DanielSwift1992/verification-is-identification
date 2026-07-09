# The curve

One build proves a universe of 6400 states in 241 seconds on a laptop. This page measures how that cost grows with the universe, and what moved it.

## Overview

![The saturation curve: build seconds against universe size, grouped bars on a log scale, one bar per emitter generation, the proof frontier at 6400.](curve)

### The problem

The build proves every state the system states, so build time grows with the number of states. If it grows faster than the number of states, the notation stops working past toy systems. Formal verification has met this obstacle for forty years under the name state-space explosion, and the shape of this curve decides whether the notation scales.

The first measurement showed near-quadratic growth: with flat generated bodies, doubling the universe multiplied build time by up to five, and thousands of states already cost minutes.

### What moved the curve

Each series on the chart is one change to the code generators. Each change applies a known reduction technique, and each was measured before and after:

| Series | The change | What it moved |
| --- | --- | --- |
| flat bodies | none: a body of N statements folds into a Pair chain N deep, and every reader re-walks that depth | the starting law, near N² |
| folded into slices | past twenty-four leaves the emitter nests slices of sixteen, so chain depth falls to the logarithm | the exponent: N^2.3 to N^1.7 |
| sliced and sharded | generated declarations write in files of ~120 and render calls in functions of 200, so the type checker works shards in parallel | the constant, about three times |
| the proof layer | the same changes, measured at the frontier | 6400 states in 241 seconds |

Every regrouping preserves every reading: counts and labels are fold sums over `Pair`, and the 471 rendered pages came back with zero diff after each change. The statements regrouped; what they state did not change.

### Reproduce it

`swift run Tools curve 400 800 1600 3200` checks HEAD out into a disposable worktree, generates a universe of each size, times the build that proves it, and prints the growth factor and exponent per step. The universe generator takes the size as one argument, so any point on the chart reproduces in one command.

### The frontier

At 6400 states the proof layer passes and the full site pipeline does not: the compiler frontend aborts (signal 4) while emitting modules of that size. The same files compile in isolation and abort in the full pipeline, and the failing job moves between runs, so the limit sits in the compiler, not in the notation. Two next steps are known: splitting the universe across modules, and a standalone reproducer for the frontend abort.

### Provenance

The measurements are stated in `CurveChart.swift`, each with the run that produced it, and `swift run VectorDemo curve` redraws the figure from them. <doc:Neighbors> places this axis in its literature: model checking and the state-space explosion.
