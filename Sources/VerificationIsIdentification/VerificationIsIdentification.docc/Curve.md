# The curve

The saturation law, measured: the largest fully proved universe today is 6400 states, in 241 seconds, on a laptop.

## Overview

![The saturation curve: build seconds against universe size, grouped bars on a log scale, one bar per emitter generation, the proof frontier at 6400.](curve)

### The problem

"The build is the run" is a promise with a price: the build must enumerate and prove every state the system can reach, so the cost of one green build grows with the size of the world. If that cost grows faster than the world, the paradigm stops at toy sizes. This is the oldest wall in formal verification — the state-space explosion — and any claim to scale is a claim about this curve's shape.

The first measurement said the danger was real: with flat generated bodies, doubling the universe multiplied the proof by up to five. Near N², thousands of states already cost minutes.

### The solution, one instrument at a time

Each bar generation on the chart is one instrument from the theory, applied to the package's own generators and re-measured:

| Line | The instrument | What it moved |
| --- | --- | --- |
| flat bodies | none: a body of N statements folds into a Pair chain N deep, and every reader re-walks that depth | the starting law, near N² |
| folded into slices | past twenty-four leaves the emitter nests slices of sixteen, so chain depth falls to the logarithm | the exponent: N^2.3 to N^1.7 |
| sliced and sharded | generated declarations write in files of ~120 and render calls in functions of 200, so the type checker works shards in parallel | the constant, about three times |
| the proof layer | the same instruments, measured at the frontier | 6400 states in 241 seconds |

Each regrouping is a fold over `Pair` sums, so counts, labels, and rendered pages stay byte-identical: 471 pages re-rendered with zero diff after every instrument. The representation never changed — only the shape of its statement.

### Reproduce it

`swift run Tools curve 400 800 1600 3200` runs the whole method: it checks HEAD out into a disposable worktree, generates a universe of each size, times the build that proves it, and prints the growth law. The universe generator takes the size as one argument, so any point on the chart reproduces in one command.

### The frontier

At 6400 states the proof layer passes and the full site pipeline does not: the compiler's own frontend aborts (signal 4) while emitting modules of that size, and the failing job moves between runs. The wall standing today is the toolchain's, not the notation's, and the next instruments are known: splitting the universe across modules, and a reproducer for the frontend abort.

### Where the numbers live

The chart is drawn by the package's own vector engine from stated measurements, each with its provenance, and re-drawn by `swift run VectorDemo curve`. The neighbors this axis belongs to — model checking and its forty years of state-space walls — are on <doc:Neighbors>.
